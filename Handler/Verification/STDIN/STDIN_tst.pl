#!/usr/bin/perl
######################################################
# Peter Walsh
# File: Handler/Verification/STDIN/STDIN_tst.pl
# Module test driver
######################################################

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Table::QUEUE;
use System::HOST;
use Handler::STDOUT;
use Handler::STDIN;
use Packet::Generic;

System::HOST->set_name("Interactive Tester");
my $p = Packet::Generic->new();
$p->set_msg('help');
Table::QUEUE->enqueue('stdin', $p->encode());
Table::QUEUE->enqueue('task', Handler::STDIN->get_process_ref());
my $x = Table::QUEUE->dequeue('task');
$x->();

#dequeue from STDOUT and process
Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
$x = Table::QUEUE->dequeue('task');
$x->();
