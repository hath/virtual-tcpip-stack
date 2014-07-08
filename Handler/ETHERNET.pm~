package Handler::ETHERNET;
#================================================================--
# File Name    : Handler/ETHERNET.pm
#
# Purpose      : implements ethernet packet handler
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;
use strict;
use warnings;

use lib '../';

use Packet::Generic;
use Packet::Ethernet;
use Packet::Ip;
use Table::QUEUE;
use Table::NIC;
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;

   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In ETHERNET\n");
   }

   my $generic_packet = Packet::Generic->new();
   my $ethernet_packet = Packet::Ethernet->new();
   my $ip_packet = Packet::Ip->new();

   if (Table::QUEUE->get_siz('ethernet')) {
      my $raw = Table::QUEUE->dequeue('ethernet');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("ETHERNET");

      if ($ph eq "IP") {
         #  add MAC addresses and send ethernet packet
         #  to appropriate NIC interface
         my $src_mac = Table::NIC->get_mac($generic_packet->get_interface());
         my $dest_mac = Table::ARP->get_mac($generic_packet->get_dest_ip());
         if(!defined($dest_mac)){
            my $i;
            my $g;
            ($i, $g) = Table::ROUTE->get_route('0.0.0.0');
            $dest_mac = Table::ARP->get_mac($g);
         }
         $ethernet_packet->set_src_mac($src_mac);
         $ethernet_packet->set_dest_mac($dest_mac);
         $ethernet_packet->set_proto('IP');
         $ethernet_packet->set_msg($generic_packet->get_msg());
         $ethernet_packet->dump();  
         Table::NIC->enqueue_packet('eth0', $ethernet_packet->encode());
         # note, enqueue an ethernet packet NOT a generic packet
         # and no need to schedule task as nic event covers that

      } else {
         # packet coming in from NIC of type ethernet
         # if packet for us then process

         $ethernet_packet->decode($generic_packet->get_msg());
         my $my_mac = Table::NIC->get_mac($generic_packet->get_interface());
         my $in_mac = $ethernet_packet->get_dest_mac();
         if ($in_mac eq $my_mac) {
            if ($ethernet_packet->get_proto() eq 'IP') {
               $ip_packet->decode($ethernet_packet->get_msg());
               $generic_packet->set_msg($ip_packet->encode());
               Table::QUEUE->enqueue('ip', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());
            } # else { print("In packet type broken \n");}
         } # else {print("In packet dropped dest mac $in_mac\n");}
      }

   }

   if  ($trace) {
      print ("Out ETHERNET\n");
   }
   return;   
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
