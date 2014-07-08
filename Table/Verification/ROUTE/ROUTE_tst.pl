#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/Route/ROUTE_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Try::Tiny;
use Exc::Exception;
use Table::ROUTE;

do {
   try {

      Table::ROUTE->set_route('192.168.6.1', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('0.0.0.0', '192.168.6.100', 'eth0');
      Table::ROUTE->set_route('192.168.6', '0.0.0.0', 'eth0');


      my $i;
      my $g;
      ($i, $g) = Table::ROUTE->get_route('192.168.6.34');
      print("Interface $i Gateway $g \n");

   }

   catch {
      my $cew_e = $_;
      if (ref($cew_e) ~~ "Exc::Exception") {
         my $exc_name = $cew_e->get_name();
         print("FATAL ERROR: $exc_name \n");
      } else {
         die("ref($cew_e)");
      }
   }
}

