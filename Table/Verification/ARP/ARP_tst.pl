#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/ARP/ARP_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Try::Tiny;
use Exc::Exception;
use Table::ARP;

do {
   try {

      Table::ARP->set_mac('192.168.6.1', '2');
      Table::ARP->set_mac('192.168.6.2', '3');

      my $mac = Table::ARP->get_mac('192.168.6.1');
      print ("MAC of .6.1 $mac\n");

      $mac = Table::ARP->get_mac('192.168.6.2');
      print ("MAC of .6.2 $mac\n");

      $mac = Table::ARP->get_mac('192.168.6.3');
      if (!defined($mac)) {
         print ("MAC of .6.3 UNDEF\n");
      }

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

