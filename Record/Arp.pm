package Record::Arp;
#================================================================--
# File Name    : Record/Arp.pm
#
# Purpose      : implements Route record
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
use Exc::Exception;

my $mac = ' ';

sub  new {
   my $class = shift @_;

   my $self = {mac => $mac
   };
                
   bless ($self, $class);
   return $self;
}

sub get_mac {
   my $self = shift @_;
   
   return $self->{mac};
}

sub set_mac {
   my $self = shift @_;
   my $m = shift @_;
 
   $self->{mac} = $m;
   return;
}

sub dump {
   my $self = shift @_;

   print ("Mac: $self->{mac} \n");
   return;
}

1;
