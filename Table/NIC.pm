package Table::NIC;
#================================================================--
# File Name    : Table/NIC.pm
#
# Purpose      : table of Nic records
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
use Record::Nic;
use Exc::Exception;

my %table;

sub get_keys {

   return keys(%table);
}

sub set {
   my $pkg = shift @_;
   my $nic_name = shift @_;
   my $type = shift @_;
   my $ip = shift @_;
   my $mac = shift @_;

   if (!defined($nic_name) || (!defined($type)) || (!defined($ip)) || (!defined($mac))) {
      die(Exc::Exception->new(name => "Table::NIC->set_type"));
   }

   if (!exists($table{$nic_name})) {
      $table{$nic_name} = Record::Nic->new();
   }

   $table{$nic_name}->set_type($type);
   $table{$nic_name}->set_ip($ip);
   $table{$nic_name}->set_mac($mac);
}

sub set_type {
   my $pkg = shift @_;
   my $nic_name = shift @_;
   my $t = shift @_;

   if (!defined($nic_name) || (!defined($t))) {
      die(Exc::Exception->new(name => "Table::NIC->set_type"));
   }

   if (!exists($table{$nic_name})) {
      $table{$nic_name} = Record::Nic->new();
   } 

   $table{$nic_name}->set_type($t);
}

sub set_ip {
   my $pkg = shift @_;
   my $nic_name = shift @_;
   my $ip = shift @_;

   if (!defined($nic_name) || (!defined($ip))) {
      die(Exc::Exception->new(name => "Table::NIC->set_ip"));
   }

   if (!exists($table{$nic_name})) {
      $table{$nic_name} = Record::Nic->new();
   }

   $table{$nic_name}->set_ip($ip);
}

sub set_mac {
   my $pkg = shift @_;
   my $nic_name = shift @_;
   my $m = shift @_;

   if (!defined($nic_name) || (!defined($m))) {
      die(Exc::Exception->new(name => "Table::NIC->set_mac"));
   }

   if (!exists($table{$nic_name})) {
      $table{$nic_name} = Record::Nic->new();
   }

   $table{$nic_name}->set_mac($m);
}


sub set_fh {
   my $pkg = shift @_;
   my $nic_name = shift @_;
   my $fh = shift @_;
   
   if (!defined($nic_name) || (!defined($fh))) {
      die(Exc::Exception->new(name => "Table::NIC->set_fh"));
   }

   if (!exists($table{$nic_name})) {
      $table{$nic_name} = Record::Nic->new();
   } 

   $table{$nic_name}->set_fh($fh);
}

sub get_type {
   my $pkg = shift @_;
   my $nic_name = shift @_;

   if (!defined($nic_name)) {
      die(Exc::Exception->new(name => "Table::NIC->get_type"));
   }

   if (exists($table{$nic_name})) {
      return $table{$nic_name}->get_type();
   } else {
      return undef;
   } 
}

sub get_fh {
   my $pkg = shift @_;
   my $nic_name = shift @_;

   if (!defined($nic_name)) {
      die(Exc::Exception->new(name => "Table::NIC->get_fh"));
   }

   if (exists($table{$nic_name})) {
      return $table{$nic_name}->get_fh();
   } else {
      return undef;
   } 
}

sub get_ip {
   my $pkg = shift @_;
   my $nic_name = shift @_;

   if (!defined($nic_name)) {
      die(Exc::Exception->new(name => "Table::NIC->get_ip"));
   }

   if (exists($table{$nic_name})) {
      return $table{$nic_name}->get_ip();
   } else {
      return undef;
   }
}

sub get_mac {
   my $pkg = shift @_;
   my $nic_name = shift @_;

   if (!defined($nic_name)) {
      die(Exc::Exception->new(name => "Table::NIC->get_mac"));
   }

   if (exists($table{$nic_name})) {
      return $table{$nic_name}->get_mac();
   } else {
      return undef;
   }
}

sub dequeue_packet_fragment {
   my $pkg = shift @_;
   my $nic_name = shift @_;

   if (!defined($nic_name)) {
      die(Exc::Exception->new(name => "Table::NIC->dequeue_packet_fragment"));
   }

   if (exists($table{$nic_name})) {
      return $table{$nic_name}->dequeue_packet_fragment();
   } else {
      return undef;
   } 
}

sub dequeue_packet {
   my $pkg = shift @_;
   my $nic_name = shift @_;

   if (!defined($nic_name)) {
      die(Exc::Exception->new(name => "Table::NIC->dequeue_packet"));
   }

   if (exists($table{$nic_name})) {
      return $table{$nic_name}->dequeue_packet();
   } else {
      return undef;
   } 
}

sub enqueue_packet {
   my $pkg = shift @_;
   my $nic_name = shift @_;
   my $p = shift @_;

   if (!defined($nic_name) || (!defined($p))) {
      die(Exc::Exception->new(name => "Table::NIC->enqueue_packet"));
   }

   if (!exists($table{$nic_name})) {
      $table{$nic_name} = Record::Nic->new();
   } 

   $table{$nic_name}->enqueue_packet($p);
}

sub enqueue_packet_fragment {
   my $pkg = shift @_;
   my $nic_name = shift @_;
   my $f = shift @_;

   if (!defined($nic_name) || (!defined($f))) {
      die(Exc::Exception->new(name => "Table::NIC->enqueue_packet_fragment"));
   }

   if (!exists($table{$nic_name})) {
      $table{$nic_name} = Record::Nic->new();
   } 

   $table{$nic_name}->enqueue_packet_fragment($f);
}

sub dump {
   my $self = shift @_;

   my $key;

   foreach $key (keys(%table)) {
      print ("Name: $key \n");
      $table{$key}->dump();
      print ("\n");
   } 
}


1;
