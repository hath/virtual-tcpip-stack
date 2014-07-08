#!/usr/bin/perl
#================================================================--
# File Name    : hubSniffer.pl
#
# Purpose      : Implement the Virtual Hub Sniffer for csci 460
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;
use strict;
use warnings;

use AnyEvent;
use AnyEvent::Socket;
use lib '../';
use Collection::Line;

my $total_packets_received=0;
my $max_captured=20;
my $portNo=0;
my $socket_port;
my @words;
my $inline;
my $command;
my $msg;
my @stdin_fifo;
my @stdout_fifo;
my @task_fifo;
my @captured_fifo;
my $num;
my $line;

my $process_stdout_ref;
my $process_stdin_ref;
my $z_event;
my $a_event;
my $s_event;
my $t_event;
my $e_event;
my $interface=Collection::Line->new();

sub prompt {
   push(@stdout_fifo, "Sniff[$portNo]> ");
   push(@task_fifo, $process_stdout_ref);
}

sub leaveScript {
   print ("Good Bye\n");
   exit;
}

$SIG{INT} = sub {leaveScript();};


$process_stdout_ref = sub {
   while (@stdout_fifo != 0) {
      print(shift(@stdout_fifo));
   }
};

$process_stdin_ref = sub {
   $inline= shift(@stdin_fifo);
   $inline = $inline . " no_command_entered";
   @words= split(' ', $inline);
   $command=shift(@words);
   if ($command eq "h") {
      push(@stdout_fifo, "help: (h)elp (o)pen/sniff [port] (d)ump captured (t)otal number received (q)uit \n");
      push(@task_fifo, $process_stdout_ref);
      prompt();
   } elsif ($command eq "o") {
      $portNo=shift(@words);
      tcp_connect '192.168.18.21',  $portNo, sub {
         $socket_port = shift;
         if (!defined $socket_port) {
            push(@stdout_fifo, "ERROR: cant open socket\n");
            push(@task_fifo, $process_stdout_ref);
            prompt(); # needed in the call back because it may be called "later"
         }
      };
      prompt();
   } elsif ($command eq "d") {
      while (@captured_fifo != 0) {
         push(@stdout_fifo, shift(@captured_fifo));
      }
      push(@task_fifo, $process_stdout_ref);
      prompt();
   } elsif ($command eq "t") {
      push(@stdout_fifo, "TOTAL NUMBER OF PACKETS RECEIVED: $total_packets_received \n");
      push(@task_fifo, $process_stdout_ref);
      prompt();
   } elsif ($command eq "q") { 
      leaveScript();
   } else {
      push(@stdout_fifo, "invalid command: $command enter h for help\n");
      push(@task_fifo, $process_stdout_ref);
      prompt();
   }
}; 

print "Sniff[$portNo]> ";

#begin implicit while (1) event loop ++++++++
$z_event = AnyEvent->condvar;

$a_event = AnyEvent->io (
   fh => \*STDIN,
   poll => "r",
   cb => sub {
      $line = <>;
      push(@stdin_fifo, $line);
      push(@task_fifo, $process_stdin_ref);
   }
);

$s_event = AnyEvent->timer (
   after => 1,
   interval => 0.02,
   cb => sub {
      if (defined($socket_port)) {
         my $num=sysread($socket_port, $line, 200);
         if (defined($num)) {
            $interface->enqueue_packet_fragment($line);
         }
      }
   }
);

$t_event = AnyEvent->timer (
   after => 2,
   interval => 0.02,
   cb => sub {
      $line=$interface->dequeue_packet();
      if (defined($line) != 0) {
         $total_packets_received++;
         push(@captured_fifo, $line . "\n");
         if ($#captured_fifo > $max_captured) {
            shift(@captured_fifo);
         }
      }
   }
);


$e_event= AnyEvent->idle(
   cb => sub {
      if (@task_fifo !=0) {
         my $sr = shift(@task_fifo);
         $sr->();
      }
   }
);
               
#end implicit while (1) event loop ++++++++
$z_event->recv;

