package Handler::PINGD;
#================================================================--
# File Name    : Handler/PINGD.pm
#
# Purpose      : handles the PINGD service
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

use Packet::Generic;
use Table::QUEUE;
use Handler::ICMP;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In PINGD\n");
   }
   
   my $generic_packet = Packet::Generic->new();

   if (Table::QUEUE->get_siz('pingd')) {
      my $raw = Table::QUEUE->dequeue('pingd');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("PINGD");

      if ($ph eq "ICMP") {
         #$generic_packet->dump();
         (my $ty, my $ts) = split(':', $generic_packet->get_msg());
         $generic_packet->set_msg(join(':', @{["ECHO_REPLY", $ts]}));
         $generic_packet->set_dest_ip($generic_packet->get_src_ip());
         Table::QUEUE->enqueue('icmp', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::ICMP->get_process_ref());
      } else {
         # should never get a non ICMP packet
      }
   }

   if  ($trace) {
      print ("Out PINGD\n");
   }

   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
