package Packet::Generic;
#================================================================--
# File Name    : Packet/Generic.pm
#
# Purpose      : implements Generic packet ADT
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

my $PCHAR = chr(0xd9);

my $src_port = ' ';
my $dest_port = ' ';
my $src_ip = ' ';
my $dest_ip = ' ';
my $src_mac = ' ';
my $dest_mac = ' ';
my $interface = ' ';
my $msg = ' ';
my $previous_handler = ' ';

sub  new {
   my $class = shift @_;
   my $name = shift @_;

   my $self = {src_port => $src_port,
      dest_port => $dest_port,
      src_ip => $src_ip,
      dest_ip => $dest_ip,
      src_mac => $src_mac,
      dest_mac => $dest_mac,
      interface => $interface,
      msg => $msg,
      previous_handler => $previous_handler
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
   my $s = shift @_;
 
   $self->{interface} = $s;

   return;
}

sub get_src_ip {
   my $self = shift @_;
   
   return $self->{src_ip};
}

sub set_src_ip {
   my $self = shift @_;
   my $s = shift @_;
 
   $self->{src_ip} = $s;

   return;
}

sub get_dest_ip {
   my $self = shift @_;

   return $self->{dest_ip};
}

sub set_dest_ip {
   my $self = shift @_;
   my $d = shift @_;
 
   $self->{dest_ip} = $d;

   return;
}

sub set_src_mac {
   my $self = shift @_;
   my $sm = shift @_;
 
   $self->{src_mac} = $sm;

   return;
}

sub get_src_mac {
   my $self = shift @_;

   return $self->{src_mac};
}

sub set_dest_mac {
   my $self = shift @_;
   my $dm = shift @_;
 
   $self->{dest_mac} = $dm;

   return;
}

sub get_dest_mac {
   my $self = shift @_;

   return $self->{dest_mac};
}

sub set_src_port {
   my $self = shift @_;
   my $sp = shift @_;
 
   $self->{src_port} = $sp;

   return;
}

sub get_src_port {
   my $self = shift @_;

   return $self->{src_port};
}

sub set_dest_port {
   my $self = shift @_;
   my $dp = shift @_;
 
   $self->{dest_port} = $dp;

   return;
}

sub get_dest_port {
   my $self = shift @_;

   return $self->{dest_port};
}

sub set_previous_handler {
   my $self = shift @_;
   my $ph = shift @_;
 
   $self->{previous_handler} = $ph;

   return;
}

sub get_previous_handler {
   my $self = shift @_;

   return $self->{previous_handler};
}

sub set_msg {
   my $self = shift @_;
   my $m = shift @_;
 
   $self->{msg} = $m;

   return;
}

sub get_msg {
   my $self = shift @_;

   return $self->{msg};
}

sub encode {
   my $self = shift @_;

   my @m;

   $m[0] = $self->{src_port};
   $m[1] = $self->{dest_port};
   $m[2] = $self->{src_ip};
   $m[3] = $self->{dest_ip};
   $m[4] = $self->{src_mac};
   $m[5] = $self->{dest_mac};
   $m[6] = $self->{interface};
   $m[7] = $self->{msg};
   $m[8] = $self->{previous_handler};

   return join($PCHAR, @m);
}

sub decode {
   my $self = shift @_;
   my $pkt = shift @_;

   my @m = split($PCHAR, $pkt);

   $self->{src_port} = $m[0];
   $self->{dest_port} = $m[1];
   $self->{src_ip} = $m[2];
   $self->{dest_ip} = $m[3];
   $self->{src_mac} = $m[4];
   $self->{dest_mac} = $m[5];
   $self->{interface} = $m[6];
   $self->{msg} = $m[7];
   $self->{previous_handler} = $m[8];

   return;
}

sub dump {
   my $self = shift @_;

   print ("SRC PORT: $self->{src_port} \n");
   print ("DEST PORT: $self->{dest_port} \n");
   print ("SRC IP: $self->{src_ip} \n");
   print ("DEST IP: $self->{dest_ip} \n");
   print ("SRC MAC: $self->{src_mac} \n");
   print ("DEST MAC: $self->{dest_mac} \n");
   print ("INTERFACE: $self->{interface} \n");
   print ("MSG: $self->{msg} \n");
   print ("PREVIOUS HANDLER: $self->{previous_handler} \n");

   return;
}

1;
