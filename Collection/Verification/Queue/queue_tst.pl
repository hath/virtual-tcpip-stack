#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Collection/Verification/Queue/queue_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Collection::Queue;

my $x = Collection::Queue->new();
my $y = Collection::Queue->new();

$x->enqueue("Hello");
$x->enqueue("world");

$y->enqueue("foo");
$y->enqueue("bar");
$y->enqueue("Demo3");

print ($x->get_siz(), "\n");
print ($y->get_siz(), "\n");

print ($x->dequeue(), "\n");
print ($y->dequeue(), "\n");
