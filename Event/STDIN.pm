package Event::STDIN;
#================================================================--
# File Name    : Event/STDIN.pm
#
# Purpose      : stdin event
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
use Table::QUEUE;
use Handler::STDIN;

sub start {
   my $self = shift @_;

   my $generic_packet = Packet::Generic->new();
   my $stdin_event = AnyEvent->io (
      fh => \*STDIN,
      poll => "r",
      cb => sub {
         my $line = <>;
         $generic_packet->set_msg("$line");
         Table::QUEUE->enqueue('stdin', $generic_packet->encode());
         Table::QUEUE->enqueue('task', Handler::STDIN->get_process_ref());
      }
   );

   bless($stdin_event, $self);
   return $stdin_event;
}

1;
