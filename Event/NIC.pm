package Event::NIC;
#================================================================--
# File Name    : Event/NIC.pm
#
# Purpose      : nic event
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use lib '../../';
use AnyEvent;
use AnyEvent::Socket;
use Packet::Generic;
use Packet::Ethernet;
use Packet::Ip;
use Handler::ETHERNET;
use Table::NIC;
use Table::QUEUE;

sub start {
   my $self = shift @_;
   my $iface = shift @_;

   if (!defined($iface)) {
      die(Exc::Exception->new(name => "Event::NIC->start"));
   }

   my $line;
   my $num;

   my $nic_event = AnyEvent->timer (
      after => 1,
      interval => 0.01,
      cb => sub {
         my $fh = Table::NIC->get_fh($iface);
         if (!defined($fh)) {
            return;
         }
         $num = sysread($fh, $line, 200);
         if (defined($num) && ($num != 0)) {
            Table::NIC->enqueue_packet_fragment($iface, $line);
         }

         my $pk = Table::NIC->dequeue_packet($iface);
         my $gen = Packet::Generic->new();
         $gen->set_interface($iface);
         $gen->set_msg($pk);

         if (defined($pk)) {
            if (Table::NIC->get_type($iface) eq 'ethernet') {
               Table::QUEUE->enqueue('ethernet', $gen->encode());
               Table::QUEUE->enqueue('task', Handler::ETHERNET->get_process_ref());
            }
            if (Table::NIC->get_type($iface) eq 'point2point') {
               my $temp=($gen->get_msg());
               my $generic_packet = Packet::Generic->new();
               $generic_packet->decode($temp);
               Table::QUEUE->enqueue('ip', $generic_packet->encode());
               Table::QUEUE->enqueue('task', Handler::IP->get_process_ref());
            }
         }

         my $seg = Table::NIC->dequeue_packet_fragment($iface);
         if (defined($seg)) {
            syswrite($fh, $seg);
         }
      }
   );

   bless($nic_event, $self);
   return $nic_event;
}

1;
