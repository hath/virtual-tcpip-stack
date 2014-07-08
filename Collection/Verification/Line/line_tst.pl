#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Collection/Verification/line_tst.pl
# Module test driver
# Marius' test case
######################################################

use lib '../../../';
use Collection::Line;

my $END=chr(0xc0);
my $ESC=chr(0xdb);

# maxbuff of 36 should throw an exception for this script
$x = Collection::Line->new((maxbuff => 37));

$x->enqueue_packet_fragment($ESC . 'xxxxxxxxxx' . $END);
$x->enqueue_packet_fragment('yyyyyyyyyy' . $END);
$x->enqueue_packet_fragment($ESC . 'zzzzzzzzzz' . $END);
$pk = $x->dequeue_packet;
print ("PACKET ", $pk , "\n");
$pk = $x->dequeue_packet;
print ("PACKET ", $pk , "\n");



