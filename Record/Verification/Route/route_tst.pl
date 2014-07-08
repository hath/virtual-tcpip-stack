#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/Route/route_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Record::Route;

my $x = Record::Route->new();
$x->set_interface('eth0');
$x->set_gateway('192.168.0.1');
$x->dump();
my $y = $x->get_interface();
print ($y, "\n");
$y = $x->get_gateway();
print ($y, "\n");
