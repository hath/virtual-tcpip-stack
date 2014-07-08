package Collection::Line;
#================================================================--
# File Name    : Collection/Line.pm
#
# Purpose      : implements wired line framing and queueing 
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#=========================================================

$|=1;
use strict;
use warnings;

use lib '../../';
use Exc::Exception;

my $END = chr(0xc0);
my $ESC = chr(0xdb);

my $inbuff='';
my $outbuff='';

sub  new {
   my $class = shift @_;
   my %params = @_;

   my $self = {maxbuff => 1000,
               inbuff => $inbuff,
               outbuff => $outbuff};

   if (defined($params{maxbuff})) {
      $self->{maxbuff} = $params{maxbuff};
   }
                
   bless ($self, $class);
   return $self;
}

sub dequeue_packet {
   my $self = shift @_;

   if ($self->{inbuff} =~ m/$ESC[^$ESC$END]*$END/) {
      $self->{inbuff} =~ s/$ESC[^$ESC$END]*$END//;
      $self->{inbuff} = $'; # remove any garbage before the pkt
      my $hold=$&;
      $hold =~ s/$END//g;
      $hold =~ s/$ESC//g;
      return $hold;
   } else {
      return undef;
   }
}

sub enqueue_packet {
   my $self = shift @_;
   my $msg = shift @_;

   if ((length($self->{outbuff}) + length($msg) + 2) > ($self->{maxbuff})) {
      die(Exc::Exception->new(name => "fullbuff"));
   }

   # assume msg contains only ascii characters 
   # (ie no need to ESC any characters in msg)
   $self->{outbuff} = $self->{outbuff} . $ESC . $msg . $END;
   return;
}

sub enqueue_packet_fragment {
   my $self = shift @_;
   my $chunk = shift @_;

   if ((length($self->{inbuff}) + length($chunk)) > ($self->{maxbuff})) {
      die(Exc::Exception->new(name => "fullbuff"));
   }
   $self->{inbuff} = $self->{inbuff} . $chunk;
   return;
}

sub dequeue_packet_fragment {
   my $self = shift @_;
   my $siz = shift @_;

   if (!defined($siz)) {
      $siz=10;
   }

   my $len = length($self->{outbuff});
   if ($len == 0) {
      return undef;
   } else {
      if ($len < $siz) {
         $siz = $len;
      }
      $self->{outbuff} =~ s/.{$siz,$siz}//;

      return $&;
   }
}

sub get_outbuff_size {
   my $self = shift @_;

   return length($self->{outbuff});
}

sub get_inbuff_size {
   my $self = shift @_;

   return length($self->{inbuff});
}

sub dump {
   my $self = shift @_;

   print "INBUFF->$self->{inbuff}<-\n";
   print "OUTBUFF->$self->{outbuff}<-\n";

   return;
}

1;
