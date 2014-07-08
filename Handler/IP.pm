package Handler::IP;
#================================================================--
# File Name    : Handler/IP.pm
#
# Purpose      : implements ip packet handler
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
use Packet::Ip;
use Packet::Icmp;
use Packet::Ethernet;
use Table::QUEUE;
use Table::NIC;
use System::HOST;
use Handler::ICMP;
use Handler::ETHERNET;

my $process_ref = sub {
   my $pkg = shift @_;
   
   my $trace = System::HOST->get_trace();
   if  ($trace) {
      print ("In IP\n");
   }

   my $generic_packet = Packet::Generic->new();

   if (Table::QUEUE->get_siz('ip')) {
      my $raw = Table::QUEUE->dequeue('ip');
      $generic_packet->decode($raw);
      my $ph = $generic_packet->get_previous_handler();
      $generic_packet->set_previous_handler("IP");

      my $ip_packet = Packet::Ip->new();
      my $icmp_packet = Packet::Icmp->new();

      if (($ph eq "ETHERNET")||($ph eq "IP")) {
         printf("En route\n");
         $ip_packet->decode($generic_packet->get_msg());
         my $i;
         my $g;
         ($i, $g) = Table::ROUTE->get_route($ip_packet->get_dest_ip());
         if (defined($i) && ($i ne 'lo') && ($i ne 'p2p0') && ($i ne 'p2p1')) {
            printf("Via Ethernet\n");
            $generic_packet->set_interface($i);
            $generic_packet->set_previous_handler("IP");
            $generic_packet->dump();
            printf("\n");
            Table::QUEUE->enqueue('ethernet', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
         } elsif (defined($i) && ($i =~ /p2p/)){
            printf("Via P2P\n");
            $generic_packet->set_interface($i);
            $generic_packet->set_previous_handler("IP");
            $generic_packet->dump();
            printf("\n");
            Table::NIC->enqueue_packet($i, $generic_packet->encode());
         } else {
            printf("And There\n");
            $ip_packet->decode($generic_packet->get_msg());
            $generic_packet->set_src_ip($ip_packet->get_src_ip());         
            $generic_packet->set_dest_ip($ip_packet->get_dest_ip());   
            if ($ip_packet->get_proto() eq 'ICMP') {
               $icmp_packet->decode($ip_packet->get_msg());
               $generic_packet->set_msg($icmp_packet->encode());
               $generic_packet->dump();
               printf("\n");
               Table::QUEUE->enqueue('icmp', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::ICMP->get_process_ref());
            }
         }
      } elsif ($ph eq 'ICMP') {
         printf("Starting Out\n");
         my $i;
         my $g;
         ($i, $g) = Table::ROUTE->get_route($generic_packet->get_dest_ip());
         if (defined($i) && ($i ne 'lo') && ($i ne 'p2p0') && ($i ne 'p2p1')) {
            printf("Via Ethernet\n");
            $ip_packet->set_msg($generic_packet->get_msg());
            $ip_packet->set_src_ip(Table::NIC->get_ip($i));
            $ip_packet->set_dest_ip($generic_packet->get_dest_ip());
            $ip_packet->set_proto('ICMP');
            
            $generic_packet->set_interface($i);
            $generic_packet->set_msg($ip_packet->encode());
            $generic_packet->dump();
            printf("\n");

            Table::QUEUE->enqueue('ethernet', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
         } elsif (defined($i) && ($i =~ /p2p/)){
            printf("Via P2P\n");
            $ip_packet->set_msg($generic_packet->get_msg());
            $ip_packet->set_src_ip(Table::NIC->get_ip($i));
            $ip_packet->set_dest_ip($generic_packet->get_dest_ip());
            $ip_packet->set_proto('ICMP'); 

            $generic_packet->set_interface($i);
            $generic_packet->set_msg($ip_packet->encode());  
            $generic_packet->dump();
            printf("\n");
 
            Table::NIC->enqueue_packet($i, $generic_packet->encode());
         } else {
            # for localhost
            $generic_packet->set_src_ip($generic_packet->get_dest_ip());
            Table::QUEUE->enqueue('icmp', $generic_packet->encode());
            Table::QUEUE->enqueue('task', Handler::ICMP->get_process_ref());
         }
      } 
   }

   if  ($trace) {
      print ("Out IP\n");
   }

   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
