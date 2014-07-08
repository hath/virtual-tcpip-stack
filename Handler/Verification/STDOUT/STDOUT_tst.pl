#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Handler/Verification/STDOUT/STDOUT_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Table::QUEUE;
use Handler::STDOUT;
use Packet::Generic;

my $generic_packet = Packet::Generic->new();
my $g_packet = Packet::Generic->new();
$generic_packet->set_msg("Hello World\n");
$g_packet->set_msg("Peter Walsh\n");

Table::QUEUE->enqueue('stdout', $generic_packet->encode());
Table::QUEUE->enqueue('stdout', $g_packet->encode());
Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
my $x = Table::QUEUE->dequeue('task');
$x->();
