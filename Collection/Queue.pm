package Collection::Queue;
#================================================================--
# File Name    : Collection/Queue.pm
#
# Purpose      : implements queue ADT
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;


sub  new {
   my $class = shift @_;
   my $name = shift @_;

   my $self = {queue => [ ]
   };
                
   bless ($self, $class);

   return $self;
}

sub enqueue {
   my $self = shift @_;
   my $l = shift @_;
   
   push (@{$self->{queue}}, $l);

   return;
}

sub dequeue {
   my $self = shift @_;

   return shift(@{$self->{queue}});
}
   
sub get_siz {
   my $self = shift @_;

   return ($#{$self->{queue}} + 1 );
}

1;
