package System::GRUB;
#================================================================--
# File Name    : System/GRUB.pm
#
# Purpose      : manages boot-loader information
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
use AnyEvent;
use AnyEvent::Socket;
use System::HOST;
use Table::NIC;
use Table::QUEUE;
use Table::ARP;
use Table::ROUTE;
use Handler::STDOUT;
use Packet::Generic;
use Device::SerialPort;

my $generic_packet = Packet::Generic->new();

sub serial_configure {
   my $nic = shift;

   my $sp;
   my $fh;
   my $config = '/tmp/pw_serial_config.txt';
   if (! -e $config) {
      $sp = Device::SerialPort->new("/dev/ttyUSB0", 1, '/tmp/pwlock')  || die "Panic Panic\nCant Open Seriel Port\nCRASH\n";
      #$sp->baudrate(9600);
      $sp->baudrate(115200);
      $sp->parity("none");
      $sp->handshake("none");
      $sp->databits(8);
      $sp->stopbits(1);
      $sp->read_char_time(0);
      $sp->read_const_time(1);
      $sp->save($config);
      $sp->close();
      undef $sp;
   }

   $sp = tie (*FH, 'Device::SerialPort', $config) || die "Panic Panic\nCan't Tie Serial Port File Handle\nCRASH\n";
   $fh = \*FH;

   Table::NIC->set_fh($nic, $fh);
   my $tab_fh = Table::NIC->get_fh($nic);
   print("$nic bound to FH: $tab_fh \n");
   #syswrite($fh, "hello device");
}

sub socket_configure {
   my $nic = shift;
   my $host = shift;
   my $port = shift;

   tcp_connect $host, $port, sub {
      my $fh = shift;

      if (!defined $fh) {
         print ("Panic Panic \nCant Open Interface\nCRASH\n");
         die(Exc::Exception->new(name => "Grub->boot"));
      }

      Table::NIC->set_fh($nic, $fh);

      my $tab_fh = Table::NIC->get_fh($nic);
      print("$nic bound to FH: $tab_fh \n");
   };

   () #return nothing;
}

sub boot {
   my $pkg = shift @_;

   my $sel = -1;
   while (!($sel =~ m/^[0-8]/) || (length($sel) != 1))  {

      print ("\n\tBoot Menu\n\n");
      print ("Boot Host-Config Moon 0\n");
      print ("Boot Host-Config Star 1\n");
      print ("Boot Host-Config Sun (R) 2\n");
      print ("Boot Host-Config Tac 3\n");
      print ("Boot Host-Config Toe 4\n");
      print ("Boot Host-Config Tic (R) 5\n");
      print ("Boot Host-Config Earth 6\n");
      print ("Boot Host-Config Wind 7\n");
      print ("Boot Host-Config Fire (R) 8\n");

      print ("\nEnter Selection ");
      $sel = <>;
      chop($sel);
   }
   
   if ($sel == 0) {

      # little checking performed :(

      System::HOST->set_name("Moon");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.6.1', '601');
      socket_configure('eth0', '192.168.18.21', 6114);
      Table::ARP->set_mac('192.168.6.2', '602');
      Table::ARP->set_mac('192.168.6.3', '603');
      Table::ARP->set_mac('192.168.6.4', '604');
      Table::ROUTE->set_route('192.168.6.1', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.6', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '192.168.6.3', 'eth0');
   }

   if ($sel == 1) {

      # little checking performed :(

      System::HOST->set_name("Star");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);

      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.6.2', '602');
      socket_configure('eth0', '192.168.18.21', 6115);
      Table::ARP->set_mac('192.168.6.1', '601');
      Table::ARP->set_mac('192.168.6.3', '603');
      Table::ARP->set_mac('192.168.6.4', '604');
      Table::ROUTE->set_route('192.168.6.2', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.6', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '192.168.6.3', 'eth0');
   }

 if ($sel == 2) {

      # little checking performed :(

      System::HOST->set_name("Sun");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.6.3', '603');
      Table::NIC->set('p2p0', 'point2point', '10.0.0.1', '0');
      Table::NIC->set('p2p1', 'point2point', '10.0.2.1', '0');
      socket_configure('eth0', '192.168.18.21', 6116);
      socket_configure('p2p1', '192.168.18.21', 7022);
      serial_configure('p2p0');
      Table::ARP->set_mac('192.168.6.2', '602');
      Table::ARP->set_mac('192.168.6.1', '601');
      Table::ARP->set_mac('192.168.6.4', '604');
      Table::ROUTE->set_route('10.0.2', '0.0.0.0', 'p2p1');
      Table::ROUTE->set_route('10.0.1', '0.0.0.0', 'p2p0');
      Table::ROUTE->set_route('192.168.6', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('192.168.4', '10.0.2.2', 'p2p1');
      Table::ROUTE->set_route('192.168.5', '10.0.0.2', 'p2p0');
      Table::ROUTE->set_route('10.0.2.1', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('10.0.0.1', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.6.3', '0.0.0.0', 'lo');
   }

 if ($sel == 3) {

      # little checking performed :(

      System::HOST->set_name("Tac");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.5.1', '601');
      socket_configure('eth0', '192.168.18.21', 6118);
      Table::ARP->set_mac('192.168.5.2', '602');
      Table::ARP->set_mac('192.168.5.3', '603');
      Table::ARP->set_mac('192.168.5.4', '604');
      Table::ROUTE->set_route('192.168.5.1', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.5', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '192.168.5.3', 'eth0');
   }

 if ($sel == 4) {

      # little checking performed :(

      System::HOST->set_name("Toe");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);

      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.5.2', '602');
      socket_configure('eth0', '192.168.18.21', 6119);
      Table::ARP->set_mac('192.168.5.1', '601');
      Table::ARP->set_mac('192.168.5.3', '603');
      Table::ARP->set_mac('192.168.5.4', '604');
      Table::ROUTE->set_route('192.168.5.2', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.5', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '192.168.5.3', 'eth0');
   }

if ($sel == 5) {

      # little checking performed :(

      System::HOST->set_name("Tic");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.5.3', '603');
      Table::NIC->set('p2p0', 'point2point', '10.0.0.2', '0');
      socket_configure('eth0', '192.168.18.21', 6120);
      serial_configure('p2p0');
      Table::ARP->set_mac('192.168.5.2', '602');
      Table::ARP->set_mac('192.168.5.1', '601');
      Table::ARP->set_mac('192.168.5.4', '604');
      Table::ROUTE->set_route('192.168.5', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('10.0.0', '0.0.0.0', 'p2p0');
      Table::ROUTE->set_route('0.0.0.0', '10.0.0.1', 'p2p0');
      Table::ROUTE->set_route('10.0.0.2', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.5.3', '0.0.0.0', 'lo');
   }

   if ($sel == 6) {

      # little checking performed :(

      System::HOST->set_name("Earth");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.4.1', '601');
      socket_configure('eth0', '192.168.18.21', 6122);
      Table::ARP->set_mac('192.168.4.2', '602');
      Table::ARP->set_mac('192.168.4.3', '603');
      Table::ARP->set_mac('192.168.4.4', '604');
      Table::ROUTE->set_route('192.168.4.1', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.4', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '192.168.4.3', 'eth0');
   }

   if ($sel == 7) {

      # little checking performed :(

      System::HOST->set_name("Wind");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.4.2', '602');
      socket_configure('eth0', '192.168.18.21', 6123);
      Table::ARP->set_mac('192.168.4.1', '601');
      Table::ARP->set_mac('192.168.4.3', '603');
      Table::ARP->set_mac('192.168.4.4', '604');
      Table::ROUTE->set_route('192.168.4.2', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.4', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('0.0.0.0', '192.168.4.3', 'eth0');
   }

 if ($sel == 8) {

      # little checking performed :(

      System::HOST->set_name("Fire");
      print(System::HOST->get_name(), "\n");
      my $boot_time = AnyEvent->time();
      print ("Boot Time: ", $boot_time, "\n");
      System::HOST->set_boot_time($boot_time);
      #                           Type        Ip             Mac
      Table::NIC->set('eth0', 'ethernet', '192.168.4.3', '603');
      Table::NIC->set('p2p0', 'point2point', '10.0.2.2', '0');
      socket_configure('eth0', '192.168.18.21', 6124);
      socket_configure('p2p0', '192.168.18.21', 7023);
      Table::ARP->set_mac('192.168.4.2', '602');
      Table::ARP->set_mac('192.168.4.1', '601');
      Table::ARP->set_mac('192.168.4.4', '604');
      Table::ROUTE->set_route('192.168.4', '0.0.0.0', 'eth0');
      Table::ROUTE->set_route('10.0.2', '0.0.0.0', 'p2p0');
      Table::ROUTE->set_route('0.0.0.0', '10.0.2.1', 'p2p0');
      Table::ROUTE->set_route('10.0.2.2', '0.0.0.0', 'lo');
      Table::ROUTE->set_route('192.168.4.3', '0.0.0.0', 'lo');
   }

   $generic_packet->set_msg(System::HOST->get_name() . "> ");
   Table::QUEUE->enqueue('stdout', $generic_packet->encode());
   Table::QUEUE->enqueue('task', Handler::STDOUT->get_process_ref());
   return;
}

1;
