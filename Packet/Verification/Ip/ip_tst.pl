#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Packet/Verification/Ip/ip_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Packet::Ip;

my $x = Packet::Ip->new();
my $y = Packet::Ip->new();
$y->set_src_ip("192.168.18.21");
my $message = $y->encode();
print ("message: $message \n");
$y->set_src_ip("hhhhhhh");
$y->dump();
$y->decode($message);
$y->dump();

