#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Table/Verification/NIC/NIC_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Try::Tiny;
use Table::NIC;

do {
   try {
      Table::NIC->set_type('eth0', 'ethernet');
      Table::NIC->set_ip('eth0', '192.168.6.0');
      Table::NIC->set_mac('eth0', '77');
      Table::NIC->enqueue_packet('eth0', 'Test Pe');

      Table::NIC->set_type('p2p1', 'point2point');
      Table::NIC->set_ip('p2p1', '192.168.6.1');
      Table::NIC->set_mac('p2p1', 'dc');
      Table::NIC->enqueue_packet('p2p1', 'Test Pa');
      Table::NIC->dump();

      Table::NIC->set('peter', 'ethernet', '192.168.1.3', '33');
      Table::NIC->dump();

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
