#!/usr/bin/perl

#term.pl

# A linux serial terminal.
# Peter Walsh July 2011
# Prototype Code csci 460
# derived versions MUST use strict

$|=1;
#use strict;
#use warnings;


use AnyEvent;
use AnyEvent::Socket;
use lib '../';
use Collection::Line;
use Packet::Ethernet;
use Packet::Ip;
use Device::SerialPort;

my $line;
my $inline;
my $ch_count;
my $ch_string;
my $command;
my @words;
my @stdin_fifo;
my @stdout_fifo;
my @task_fifo;
my $sline = Collection::Line->new();
my $eth = Packet::Ethernet->new();
$eth->set_src_mac('45');
$eth->set_dest_mac('46');
my $ip = Packet::Ip->new();
my $iip = Packet::Ip->new();

sub prompt {
   push(@stdout_fifo, "term> ");
   push(@task_fifo, $process_stdout_ref);
}

sub leaveScript {
   if (defined($sp)) {
      $sp->close();
   }
   print ("Good Bye\n");
   exit;
}

$SIG{INT} = sub { leaveScript();};

my $sp = Device::SerialPort->new("/dev/ttyUSB0", 1, '/tmp/pwlock')  || die "Cant Open Seriel Port \n";

$sp->baudrate(9600);
$sp->parity("none");
$sp->handshake("none");
$sp->databits(8);
$sp->stopbits(1);
$sp->read_char_time(0);
$sp->read_const_time(1);


$process_stdout_ref = sub {while (@stdout_fifo != 0) {
                              print(shift(@stdout_fifo));
                           }
                      };

$process_stdin_ref = sub {$inline= shift(@stdin_fifo);
                          @words= split(' ', $inline);
                          $command=shift(@words);
                          if ($command eq "h") {
                             push(@stdout_fifo, "help: (h)elp (w)rite [message] (q)uit \n");
                             push(@task_fifo, $process_stdout_ref);
                             prompt();
                          } elsif ($command eq "w") {
                             $eth->set_msg(join(' ', @words));
                             $ip->set_msg($eth->encode());
                             $sline->enqueue_packet($ip->encode());
                             prompt();
                          } elsif ($command eq '') {
                             prompt();
                          } elsif ($command eq "q") { 
                             leaveScript();
                          } else {
                             push(@stdout_fifo, "invalid command: $command enter h for help\n");
                             push(@task_fifo, $process_stdout_ref);
                             prompt();

                          }
                     }; 

print "term> ";

#begin implicit while (1) event loop ++++++++
$z_event = AnyEvent->condvar;

$a_event = AnyEvent->io (fh => \*STDIN,
                   poll => "r",
                   cb => sub {$line = <>;
                              push(@stdin_fifo, $line);
                              push(@task_fifo, $process_stdin_ref);
                         });


$e_event= AnyEvent->idle(cb => sub {if (@task_fifo !=0) {;
                                 $sr = shift(@task_fifo);
                                 $sr->();
                              }
                         });
               
$f_event = AnyEvent->timer (after => 1,
                   interval => 0.02,
                   #cb => sub {($ch_count, $ch_str) = $sp->read(1);
                   cb => sub {($ch_count, $ch_str) = $sp->read(10);
                              if ($ch_count > 0) {
                                 $sline->enqueue_packet_fragment($ch_str);
                              }
                              my $pk = $sline->dequeue_packet();
                              if (defined($pk)) {
                                 $iip->decode($pk);
                                 $eth->decode($iip->get_msg());

                                 push(@stdout_fifo, $eth->get_msg());
                                 push(@task_fifo, $process_stdout_ref);

                                 push(@stdout_fifo, $eth->get_src_mac());
                                 push(@task_fifo, $process_stdout_ref);

                                 push(@stdout_fifo, $eth->get_dest_mac());
                                 push(@task_fifo, $process_stdout_ref);
                              }
                              my $frag = $sline->dequeue_packet_fragment(4);
                              if (defined($frag)) {
                                 $sp->write($frag);
                              }

                         });


#end implicit while (1) event loop ++++++++
$z_event->recv;

