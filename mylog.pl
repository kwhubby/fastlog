#!/usr/bin/perl -w

# a fast log entry program.  inspired by DL3CB's FLE.
#
# 2-clause BSD license.

# Copyright 2014 Chris Ruvolo (KC2SYK). All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
# 	this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
# 	this list of conditions and the following disclaimer in the
# 	documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY CHRIS RUVOLO ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL CHRIS RUVOLO OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of Chris Ruvolo.

use strict;
use utf8;
use feature 'unicode_strings';

use Text::ParseWords;
use DateTime;
use Clone 'clone';

binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");
use POSIX qw(strftime);

my $dt;
my $odate = strftime("%m-%d-%Y", gmtime);
my $time = strftime("%H%M", gmtime);
my $band = undef;
my $mode = "SSB";
my @bands = ("630m", "160m", "80m", "60m", "40m", "30m", "20m", "17m", "15m", "12m", "10m", "6m", "4m", "2m", "70cm");
my @modes = ("SSB", "CW", "RTTY", "PSK31", "AM", "PHONE", "DATA");
my @qsos;
my $quiet = 1;
my $freq;
my $name = undef;
my $comment;

my $i = 0;
while ($i <= $#ARGV) {
	if ($ARGV[$i] =~ /-q|--quiet/) {
		shift;
		$quiet = 1;
	}
	if ($ARGV[$i] =~ /-v|--verbose/) {
		shift;
		$quiet = undef;
	}
	$i++;
}

while (<>) {
	chomp;
#	my @array1 = split(' ',$VAR1);
my $call = undef;
my $sentrst = undef;
my $myrst = undef;
my $state = undef;
my $qth = undef;
 $name = undef;
	my @array1 = parse_line(' ', 1, $_);
	if (/^\s*date\s+(\d{4}-\d{2}-\d{2})/i) {
		$odate= $1;
		print STDERR "date set: $odate\n" unless defined($quiet);
	} elsif (/^\s*band\s+(\d+c?m?)/i) {
		my $tmp = $1;
		$tmp =~ s/(\d+)$/$1m/;
		if (grep { /$tmp/i } @bands) {
			$band = $tmp;
			print STDERR "band set: $band\n" unless defined ($quiet);
		};
	} elsif (/^\s*mode\s+(\w+)/i) {
		my $tmp = $1;
		if (grep { /$tmp/i } @modes) {
			$mode = $tmp;
			print STDERR "mode set: $mode\n" unless defined($quiet);
		}
	} elsif (/\s*(delete|drop|error)/i) {
		my ($date, $time, $call, $band, $mode, $sentrst, $myrst, $comment) =
			split(/\|/, pop(@qsos));
		print STDERR "deleted qso: $odate$time $call $band $mode\n"
			unless defined($quiet);
	}
	else {
	foreach (@array1) {
		print STDERR "word: '$_' \n" unless defined ($quiet);
		if (/(^\d{1,2})\/(\d{1,2})\/(\d\d\d\d)/i) {
	  	#$odate= $1;
	    #print STDERR "date set: $date\n" unless defined($quiet);
	     $dt = DateTime->new(
        year       => $3,
        month      => $1,
        day        => $2,
        time_zone  => 'America/Los_Angeles'
    	);
	    #$datetim=$date->parse_datetime($TIMESTART);
	    #$dt->set_time_zone("America/Los_Angeles");
	    #$dt->set_time_zone("UTC");
	    print STDERR $dt unless defined ($quiet);
	  }
	  elsif (/^(\d{1,2}):(\d\d)(pm|am)/i) {
	  	my $hr = $1;
	  	if ($hr == 12) {
	  		$hr=0;
	  	}
	  	if ($3 eq "pm") {
	  	$hr+=12;
	  	}
	    $dt->set(
	     hour    =>  $hr,
	     minute  =>  $2
	    );
	    print STDERR "time $dt \n" unless defined ($quiet);
	  }
	  elsif (/^(\d{1,2})(pm|am)/i) {
	  	my $hr = $1;
	  	if ($hr == 12) {
	  		$hr=0;
	  	}
	  	if ($2 eq "pm") {
	  	$hr+=12;
	  	}
	    $dt->set(
	     hour    =>  $hr
	    );
	    print STDERR "time $dt \n" unless defined ($quiet);
	  }
	  elsif (/(\d{4,})/i) {
	  	$freq = $1 / 1000;
	  	print STDERR "Frequency $freq" unless defined($quiet);
	  	if ($freq >= 1.8 && $freq <= 2) { $band = "160m";} 
	  	elsif ($freq >= 3.5 && $freq <= 4) { $band = "80m";}
	  	elsif ($freq >= 5 && $freq < 6) { $band = "60m";}
	  	elsif ($freq >= 7 && $freq <= 7.3) { $band = "40m";}
	  	elsif ($freq >= 10.1 && $freq <= 10.15) { $band = "30m";}
	  	elsif ($freq >= 14 && $freq <= 14.35) { $band = "20m";}
	  	elsif ($freq >= 18 && $freq <= 18.2) { $band = "17m";}
	  	elsif ($freq >= 21 && $freq <= 21.5) { $band = "15m";}
	  	elsif ($freq >= 24.8 && $freq <= 25) { $band = "12m";}
	  	elsif ($freq >= 28 && $freq <= 30) { $band = "10m";}
	  	elsif ($freq >= 50 && $freq <= 54) { $band = "6m";}
	  	elsif ($freq >= 144 && $freq <= 148) { $band = "2m";}
	  }
	  #elsif (/^"(.*?)"$/) {
	  elsif (/^"([^"]+)"$/) {
	  	$name = $1;
	  	print STDERR "name is $name \n" unless defined ($quiet);
	  }
	  elsif (/^'([^']+)'$/) {
	  	$qth = $1;
	  	print STDERR "qth is $qth \n" unless defined ($quiet);
	  }
	   elsif (/^c"([^"]+)"$/) {
	  	$comment = $1;
	  	print STDERR "comment is $comment \n" unless defined ($quiet);
	  }
	  elsif (/^([A-Z]{2})$/) {
	  	$state = $1;
	  	print STDERR "state is $state \n" unless defined ($quiet);
	  }
	  elsif (/(\w{3,}.*)/) {  #need to include stroke signs!
	  	$call = $1;
	  	print STDERR "call: $call\n" unless defined ($quiet);
	  }
	  elsif (/^(\d\d)$/) {
	  	if (!defined $sentrst) {
	  		$sentrst = $1;
	  		print STDERR "sent RST $sentrst \n" unless defined ($quiet);
	  	}
	  	else {
	  		$myrst = $1;
	  		print STDERR "rec RST $myrst \n" unless defined ($quiet);
	  	}
	  }
	}
	 #elsif (/^(\d{0,4})?\s*(\w{3,})\s*(\d{2,3})?\s*(@\d{2,3})?\s*(#.*)?$/) {
		# 51 dl4mcf 579 @559 #good contact
		# 1: 51
		# 2: dl4mcf
		# 3: 579
		# 4: @559
		# 5: #good contact
		#my $timefrag = $1;
		#my $call = $2;
		#my $sentrst = $3;
		#my $myrst = $4;
		#my $comment = $5;

		if (!defined($band)) {
			print STDERR "error: band must be set.\n";
			next;
		}
		if (!defined($mode)) {
			print STDERR "error: mode must be set.\n";
			next;
		}
		if (!defined($call) || $call eq "") {
			print STDERR "error: call must be set.\n";
			next;
		}
		if (! ($call =~ /^\s*(\d?[a-z]{1,2}[0-9Øø]{1,4}[a-z]{1,4})\s*$/i)) {
			print STDERR "error: invalid callsign: $call \n";
			
		}
		$call =~ s/[Øø]/0/g;

		#$time = substr($time,0,4-length($timefrag)) . $timefrag;
		if (uc($mode) eq "SSB") {
			$sentrst = "59" unless defined $sentrst;
		} else {
			$sentrst = "599" unless defined $sentrst;
		}
		$myrst = "" unless defined $myrst;
		$comment = "" unless defined $comment;
		$name = "" unless defined $name;
		$state = "" unless defined $state;
		$qth = "" unless defined $qth;
		$myrst =~ s/^@//;
		$comment =~ s/^#//;
		my $datetime = clone($dt);
		$datetime->set_time_zone("UTC");
		print STDERR "qso: $dt $call $band $mode $sentrst $myrst $state $qth $comment $name\n";
		push(@qsos, join('|', $datetime->format_cldr('yyyyMMDD'), $datetime->format_cldr('HHmm'), $call, $band, $mode, $sentrst, $myrst, $state, $qth, $comment, $name));
	}
}

# output as adif
print "Log file transcribed by fastlog. https://github.com/cruvolo/fastlog\n";
print "<ADIF_VER:4>1.00\n<EOH>\n";
foreach(@qsos) {
	#print "$_\n";
	my ($date, $time, $call, $band, $mode, $sentrst, $myrst, $state, $qth, $comment, $name) =
		split/\|/;
	#$odate=~ s/-//g;
	print "<QSO_DATE:8>", uc($date), " <TIME_ON:4>", uc($time), "<CALL:",
		length(uc($call)), ">", uc($call), " <BAND:",
		length(uc($band)), ">", uc($band), " <FREQ:",
		length(uc($freq)), ">", uc($freq), " <STATE:",
		length(uc($freq)), ">", uc($state), " <MODE:",
		length(uc($mode)), ">", uc($mode), " <RST_SENT:",
		length($sentrst), ">", $sentrst,
		(length($myrst)==0)?"":(" <RST_RCVD:".length($myrst).">".$myrst),
		" <name:", length(uc($name)), ">", uc($name),
		(length($comment)==0)?"":(" <COMMENT:".length($comment).">".$comment),
		(length($qth)==0)?"":(" <COMMENT:".length($qth).">".$qth),
		"\n<EOR>\n";
}

