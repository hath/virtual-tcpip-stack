package Record::Route;
#================================================================--
# File Name    : Record/Route.pm
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

my $interface = ' ';
my $gateway = ' ';

sub  new {
   my $class = shift @_;

   my $self = {interface => $interface,
      gateway => $gateway
   };
                
   bless ($self, $class);
   return $self;
}

sub get_interface {
   my $self = shift @_;
   
   return $self->{interface};
}

sub set_interface {
   my $self = shift @_;
   my $i = shift @_;
 
   $self->{interface} = $i;
   return;
}

sub get_gateway {
   my $self = shift @_;

   return $self->{gateway};
}

sub set_gateway {
   my $self = shift @_;
   my $g = shift @_;

   $self->{gateway} = $g;
   return;
}

sub dump {
   my $self = shift @_;

   print ("Interface: $self->{interface} \n");
   print ("Gateway: $self->{gateway} \n");
   return;
}

1;
