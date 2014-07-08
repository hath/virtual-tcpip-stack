# Makefile to drive cew testing of Perl modules
# P Walsh Feb 2012

# Targets
#   bats --- make batch tester from tb.cew
#   clean
#   submit
#   cover --- test coverage
#   tidy --- indent code in .pl, .pm  and .cew files

# directory where scripts are located and temp files
SD=../../../Cew
CUT=../../Line.pm

# code beautifier 
INDENT=perltidy -i=3

bats: tb.pl
	perl tb.pl

cover: tb.pl
	perl -MDevel::Cover tb.pl
	cover -select $(CUT) -report text > $(CUT).cover
	rm -r cover_db
	
tb.pl: tb.cew
	rm -f $(SD)/tmp/tb.num
	rm -f ./tb.pl
	awk -f $(SD)/bin/addLineNums.awk tb.cew > $(SD)/tmp/tb.num
	m4 -I $(SD)/bin $(SD)/tmp/tb.num  | $(INDENT) > tb.pl

clean:
	rm -f  $(SD)/tmp/* tb.pl *.cover $(CUT).tdy *.tdy

tidy:
	 $(INDENT) $(CUT) *.pl *.cew

submit:
	echo "submit not set up"
