package Event::BOOT;
#================================================================--
# File Name    : Event/BOOT.pm
#
# Purpose      : boot event
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
use Table::NIC;

sub start {
   my $self = shift @_;
   my $sig_ptr = shift @_;

   my $boot_event = AnyEvent->timer(
      after => 1,
      interval => 1,
      cb => sub {
         my @key = Table::NIC->get_keys();
         my $soc_open = 1;
         foreach my $k (@key) {
            my $fh = Table::NIC->get_fh($k);
            if (!($fh =~ m/^GL*/)) {
               $soc_open = 0;
            }
         }
         if ($soc_open) {
            $$sig_ptr->send;
         }
      }
   );

   bless($boot_event, $self);
   return $boot_event;
}

1;
