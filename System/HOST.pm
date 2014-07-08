package System::HOST;
#================================================================--
# File Name    : System/HOST.pm
#
# Purpose      : implements HOST ADT
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
use AnyEvent;
my $host_name = 'Vnet';
my $boot_time;
my $trace = 0;

sub set_trace {
   my $pkg = shift @_;
   my $v = shift @_;
   
   $trace = $v;

   return;
}

sub get_trace {
   my $pkg = shift @_;

   return $trace;
}

sub set_boot_time {
   my $pkg = shift @_;
   my $tme = shift @_;
   
   $boot_time = $tme;

   return;
}

sub get_boot_time {
   my $pkg = shift @_;

   return $boot_time;
}

sub set_name {
   my $pkg = shift @_;
   my $nme = shift @_;
   
   $host_name= $nme;

   return;
}

sub get_name {
   my $pkg = shift @_;

   return $host_name;
}

sub dump {
   my $self = shift @_;
   
   print ("HOST NAME: ", $host_name, "\n");
   print ("HOST BOOT TIME: ", $boot_time, "\n");

   return;
}

1;
