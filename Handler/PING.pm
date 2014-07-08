package Handler::PING;
#================================================================--
# File Name    : Handler/PING.pm
#
# Purpose      : implements ping packet handler
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use lib '../';
use AnyEvent;
use Packet::Generic;
use Handler::ICMP;
use Table::QUEUE;
use Handler::STDOUT;
use Handler::STDIN;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In PING\n");
   }

   my $generic_packet = Packet::Generic->new();

   if (Table::QUEUE->get_siz('ping')) {
      my $raw = Table::QUEUE->dequeue('ping');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("PING");

      if ($ph eq "STDIN") {
         $generic_packet->set_msg(join(':',@{["ECHO", AnyEvent->time()]}));
         Table::QUEUE->enqueue('icmp', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::ICMP->get_process_ref());
      } else {
         # assume $ph eq "ICMP" 
         (my $ty, my $ts) = split(':', $generic_packet->get_msg());
         my $tme = AnyEvent->time() - $ts;
         $generic_packet->set_msg("Ping Reply " . $ty . " " . $tme . "(s) \n");
         Table::QUEUE->enqueue('stdout', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
         $generic_packet->set_msg(' '); # tidy up shell prompt
         Table::QUEUE->enqueue('stdin', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDIN->get_process_ref());
      }
   }

   if  ($trace) {
      print ("Out PING\n");
   }

   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
