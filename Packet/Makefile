# Makefile to drive cew testing of Perl modules
# P Walsh Feb 2012

# Targets
#   bats --- make batch tester 
#   clean
#   tidy --- indent code in .pl, .pm  and .cew files

# directory where scripts are located and temp files
SD=../../../Cew
CUT=../../Arp.pm

# code beautifier 
INDENT=perltidy -i=3

# class names
CLASS= Arp Icmp Ip Udp Ethernet Generic

bats: 
	for m in $(CLASS); do \
		( cd Verification/$$m; $(MAKE) bats; ) \
	done

clean: 
	for m in $(CLASS); do \
		( cd Verification/$$m; $(MAKE) clean; ) \
	done

tidy: 
	for m in $(CLASS); do \
		( cd Verification/$$m; $(MAKE) tidy; ) \
	done
