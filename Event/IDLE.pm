package Event::IDLE;
#================================================================--
# File Name    : Event/IDLE.pm
#
# Purpose      : idle event (execute tasks)
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
use Table::QUEUE;

sub start {
   my $self = shift @_;

   my $idle_event = AnyEvent->idle(
      cb => sub {
         if (Table::QUEUE->get_siz('task')) {
            my $nexttask = Table::QUEUE->dequeue('task');
            $nexttask->();
         }
      }
   );

   bless($idle_event, $self);
   return $idle_event;
}

1;
