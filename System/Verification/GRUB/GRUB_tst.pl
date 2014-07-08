#!/usr/bin/perl
######################################################
# Peter Walsh
# File: System/Verification/GRUB/GRUB_tst.pl
# Module test driver
######################################################


$| = 1;

use strict;
use warnings;

use lib '../../../';

use System::GRUB;
use System::HOST;
use Table::NIC;
use Table::ARP;
use Table::ROUTE;

System::GRUB->boot();
print("HOST DUMP \n");
System::HOST->dump();
print("NIC DUMP \n");
Table::NIC->dump();
print("ARP DUMP \n");
Table::ARP->dump();
print("ROUTE DUMP \n");
Table::ROUTE->dump();




