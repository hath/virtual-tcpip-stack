package Handler::STDOUT;
#================================================================--
# File Name    : Handler/STDOUT.pm
#
# Purpose      : implements stdout handler
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
use System::HOST;

my $process_ref = sub {
   my $pkg = shift @_;
   
   my $generic_packet = Packet::Generic->new();

   if (Table::QUEUE->get_siz('stdout')) {
      my $raw = Table::QUEUE->dequeue('stdout');
      $generic_packet->decode($raw);
      print $generic_packet->get_msg();
   }
   return;
};

sub get_process_ref {
   my $pkg = shift @_;

   return ($process_ref);
}

1;
