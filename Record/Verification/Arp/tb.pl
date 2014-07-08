#================================================================--
# File Name    : Record/Verification/Route/tb.cew
#
# Purpose      : unit testing
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Perl (Linux)
#
#================================================================--

$| = 1;
use strict;
use warnings;

use lib '../../../';
use Exc::Exception;
use Record::Arp;
use Try::Tiny;

my $cew_Test_Count  = 0;
my $cew_Error_Count = 0;

sub leaveScript {
   print("\n**********Summary**********\n");
   print( "Total number of test cases = ",          $cew_Test_Count,  "\n" );
   print( "Total number of test cases in error = ", $cew_Error_Count, "\n" );

   print("Bye\n");
   exit(0);
}

$SIG{INT} = sub { leaveScript(); };

my $x = Record::Arp->new();
$x->set_mac('23');

$cew_Test_Count = $cew_Test_Count + 1;
do {
   try {
      ;
      if ( !( ( $x->get_mac() ) ~~ ('23') ) ) {
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 36, "\n" );
         print( "Actual Value is ",   $x->get_mac(), " \n" );
         print( "Expected Value is ", '23',          "\n" );
      }
   }
   catch {
      my $cew_e = $_;
      if ( ref($cew_e) ~~ "Exc::Exception" ) {
         my $cew_exc_name = $cew_e->get_name();
         $cew_Error_Count = $cew_Error_Count + 1;
         print( "Test Case ERROR (Ncase) in script at line number ", 36, "\n" );
         print( "Unexpected Exception ", $cew_exc_name, " thrown \n" );
      }
   }
};

print("\n**********Summary**********\n");
print( "Total number of test cases = ",          $cew_Test_Count,  "\n" );
print( "Total number of test cases in error = ", $cew_Error_Count, "\n" );

