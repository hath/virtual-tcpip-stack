#!/usr/bin/perl
#================================================================--
# Project      : Virtual internet TCP/IP stack base system
#
# File Name    : base.pl
#
# Purpose      : main routine of the base implementation
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;

use strict;
use warnings;

use lib './';
use AnyEvent;
use Table::QUEUE;
use Table::NIC;
use System::GRUB;
use System::HOST;
use Event::STDIN;
use Event::NIC;
use Event::BOOT;
use Event::IDLE;
use Handler::STDOUT;
use Exc::Exception;
use Try::Tiny;

my $z_event;
my $y_event;
my $stdin_event;
my $boot_event;
my @nic_event;
my $idle_event;
my $generic_packet=Packet::Generic->new();
my $nexttask;

sub leaveScript {
   $generic_packet->set_msg("quit");
   Table::QUEUE->enqueue('stdout', $generic_packet->encode());
   Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
}

$SIG{INT} = sub {leaveScript();};

do {
   try {

      System::HOST->set_trace(1);

      System::GRUB->boot();
      
      #begin boot loop ++++++++

         $y_event = AnyEvent->condvar;

         $boot_event = Event::BOOT->start(\$y_event);

         $y_event->recv;
         $boot_event = undef;

      #end boot loop ++++++++

      #begin implicit while (1) event loop ++++++++

         $z_event = AnyEvent->condvar;

         $stdin_event = Event::STDIN->start();
      
         my @key = Table::NIC->get_keys();
         foreach (my $i = 0; $i <= $#key; $i++) {
            $nic_event[$i] = Event::NIC->start($key[$i]);
         }

         $idle_event = Event::IDLE->start();
               
         $z_event->recv;

      #end implicit while (1) event loop ++++++++
   }

   catch {
      my $cew_e = $_;
      if (ref($cew_e) ~~ "Exc::Exception") {
         my $exc_name = $cew_e->get_name();
         print("FATAL ERROR: $exc_name \n");
      } else {
         die("ref($cew_e)");
      }
   }
}
