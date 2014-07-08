package Record::Nic;
#================================================================--
# File Name    : Record/Nic.pm
#
# Purpose      : implements Nic record
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
use Collection::Line;

my $type = ' ';
my $ip = ' ';
my $mac = ' ';
my $fh = ' ';

sub  new {
   my $class = shift @_;

   my $self = {type => $type,
      ip => $ip,
      mac => $mac,
      fh => $fh,
      line => Collection::Line->new()
   };
                
   bless ($self, $class);
   return $self;
}

sub get_ip {
   my $self = shift @_;

   return $self->{ip};
}

sub set_ip {
   my $self = shift @_;
   my $ip = shift @_;

   $self->{ip} = $ip;
   return;
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

sub get_type {
   my $self = shift @_;
   
   return $self->{type};
}

sub set_type {
   my $self = shift @_;
   my $t = shift @_;
 
   $self->{type} = $t;
   return;
}

sub get_fh {
   my $self = shift @_;

   return $self->{fh};
}

sub set_fh {
   my $self = shift @_;
   my $f = shift @_;
 
   $self->{fh} = $f;
   return;
}

sub dequeue_packet {
   my $self = shift @_;

   return $self->{line}->dequeue_packet();
}

sub dequeue_packet_fragment {
   my $self = shift @_;

   return ($self->{line})->dequeue_packet_fragment();
}

sub enqueue_packet {
   my $self = shift @_;
   my $p = shift @_;
 
   $self->{line}->enqueue_packet($p);
   return;
}

sub enqueue_packet_fragment {
   my $self = shift @_;
   my $f = shift @_;
 
   $self->{line}->enqueue_packet_fragment($f);
   return;
}

sub dump {
   my $self = shift @_;

   print ("Type: $self->{type} \n");
   print ("File Handle: $self->{fh} \n");
   print ("Ip: $self->{ip} \n");
   print ("Mac: $self->{mac} \n");
   print ("Line: \n");
   $self->{line}->dump();
   return;
}

1;
