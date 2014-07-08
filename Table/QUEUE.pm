package Table::QUEUE;
#================================================================--
# File Name    : Table/QUEUE.pm
#
# Purpose      : table of queues
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$| = 1;
use strict;
use warnings;

use lib '../';
use Collection::Queue;

my %table;

sub enqueue {
   my $pkg = shift @_;
   my $q = shift @_;
   my $l = shift @_;
   
   if (!defined($q) || (!defined($l))) {
      die(Exc::Exception->new(name => "Table::QUEUE->enqueue"));
   }

   if (!exists($table{$q})) {
      $table{$q} = Collection::Queue->new();
   } 

   $table{$q}->enqueue($l);
}

sub dequeue {
   my $pkg = shift @_;
   my $q = shift @_;

   if (!defined($q)) {
      die(Exc::Exception->new(name => "Table::QUEUE->dequeue"));
   }

   if (exists($table{$q})) {
      return $table{$q}->dequeue();
   } else {
      return undef;
   }
}

sub get_siz {
   my $pkg = shift @_;
   my $q = shift @_;

   if (!defined($q)) {
      die(Exc::Exception->new(name => "Table::QUEUE->get_siz"));
   }

   if (exists($table{$q})) {
      return $table{$q}->get_siz();
   } else {
      return undef;
   }
}

1;
