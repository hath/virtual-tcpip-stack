#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Record/Verification/Nic/nic_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Record::Nic;

my $x = Record::Nic->new();
$x->set_type('ethernet');
$x->set_ip('192.168.6.23');
$x->set_mac('607');
$x->enqueue_packet("Peter");
$x->dump();

my $y = Record::Nic->new();
$y->set_type('point2point');
$y->set_ip('192.168.6.24');
$y->set_mac('608');
$y->enqueue_packet("paul");
$y->dump();
