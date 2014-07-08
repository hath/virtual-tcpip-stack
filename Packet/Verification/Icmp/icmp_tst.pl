#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Packet/Verification/Icmp/icmp_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Packet::Ip;
use Packet::Icmp;

my $x = Packet::Ip->new();
my $y = Packet::Ip->new();
$y->set_src_ip("192.168.18.21");
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
   
