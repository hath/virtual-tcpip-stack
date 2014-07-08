#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Packet/Verification/Generic/generic_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Packet::Ip;
use Packet::Icmp;
use Packet::Generic;

my $x = Packet::Ip->new();
my $y = Packet::Ip->new();
$y->set_src_ip("192.168.18.21");
$y->set_msg("Hello World");
my $message = $y->encode();
print ("message: $message \n");
$y->set_src_ip("hhhhhhh");
$y->dump();
$y->decode($message);
$y->dump();

my $a = Packet::Icmp->new();
$a->dump();
if ($a->packet_in_error()) {
   print ("packet in err\n");
} else {
   print ("packet OK\n");
}
   
my $h = Packet::Generic->new();
$h->dump();
