package Table::ROUTE;
#================================================================--
# File Name    : Table/ROUTE.pm
#
# Purpose      : table of  Route records
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
use Record::Route;
use Exc::Exception;

my %table;

sub set_route {
   my $pkg = shift @_;
   my $net = shift @_;
   my $gateway = shift @_;
   my $interface = shift @_;

   printf("Set: $net $gateway $interface\n");

   if (!defined($net) || !defined($gateway) || !defined($interface)) {
      die(Exc::Exception->new(name => "Table::ROUTE->set_route"));
   }

   if (!exists($table{$net})) {
      $table{$net} = Record::Route->new();
   }

   $table{$net}->set_interface($interface);
   $table{$net}->set_gateway($gateway);
}

sub get_route {
   my $pkg = shift @_;
   my $ip = shift @_;
   if (!defined($ip)) {
      die(Exc::Exception->new(name => "Table::ROUTE->get_route"));
   }

   my $key;
   my $max = 0;
   my $match = undef;

   foreach $key (keys(%table)) {
      if ($ip =~ m/$key/) {
         if (length($&) > $max) {
            $match = $key;
            $max = length($&);
         }
      }
   }
   if (defined($match)) {
      return ($table{$match}->get_interface(), $table{$match}->get_gateway());
   } elsif (exists($table{'0.0.0.0'})) {
      return ($table{'0.0.0.0'}->get_interface(), $table{'0.0.0.0'}->get_gateway());
   } else {
      return (undef, undef);
   }
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Net: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}

1;
