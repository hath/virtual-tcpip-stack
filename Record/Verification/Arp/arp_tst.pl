#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/Arp/arp_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Record::Arp;

my $x = Record::Arp->new();
$x->set_mac('23');
$x->dump();
my $y = $x->get_mac();
print ("max addr: $y \n");
