#!/usr/bin/env perl
#   /usr/bin/env can be used as no option needed for perl
# /opt/local/bin/perl for Mac, /usr/local/bin/perl for CentOS
use strict;

#ARGV[0] Target TS File
#ARGV[1] Output Filename
#ARGV[2] Video Size (Ex. 480x360 960x720)
#ARGV[3] Log file name (optional)

# my $ffpreset = "/var/www/html/epgrec/libx264-hq-ts.ffpreset";
my $cmd = "/usr/local/bin/ffmpeg";
my $log = 1;
my $ffpreset = "/home/www/epgrec/libx264.ffpreset";

my $br; #Audio BitRate
my $logfile = "$0.log";
if ($ARGV[3]) {
    $logfile = $ARGV[3];
}

if ($log) {
    if (-e $logfile) {
	rename $logfile, $logfile.".old";
    }
    open(OF, "> $logfile");
    print OF "$0 $ARGV[0] $ARGV[1] $ARGV[2] $ARGV[3]\n";
    &printdate;
}

my $pass1cmd = "$cmd -i $ARGV[0] 2>&1 |";
print OF "Running $pass1cmd ...\n" if ($log);
open(my $res, $pass1cmd);

my ($vstr, $vid, $astr, $aid); #save StreamID
# New algorithm search both video and audio stream at the sametime

# For detecting virtual subchannels in a TS file.
my ($ekey, $progNum, $meta, $svname, $NHK, $NHKsubCh, $found);
$found = 0;
print OF "\n****** ffmpeg pass1 starting... *****\n" if ($log);
foreach(<$res>){
    print OF $_ if ($log);
    next if ($found); # Already found unprocessing lines

    if (/^\s*Program\s+(\d+)/) {
	$progNum=$1;
	$meta = $NHK = $NHKsubCh = 0; # rest channel info.
	print OF "*** Prog=$progNum ***\n" if ($log);
	if (($vstr ne "") && ($astr ne "")) {
	    print OF "*** Video & Audio stream found before program changing... exiting... ***\n\n" if ($log);
	    $found++;
	    print OF "*** Unprocessed lines.... ***\n";
	}
    } elsif (/^\s*Metadata:/) {
	$meta = 1; next;
	print OF "\n*** Meta" if ($log);
    } elsif ($meta && /^\s*service_name\s*:\s*([^\s]+)/) {
	$svname=$1;
	if ($svname =~ /\?NHK\?[^\?]+\?(\d)/) {
	    $NHK = 1; # general
	    $NHKsubCh = $1;
	} elsif ($svname =~ /\?NHKE\?[^\?]+\?l(\d)/) {
	    $NHK = 2; # E tele.
	    $NHKsubCh = $1;
	}
	print OF "*** svname=$svname NHK=$NHK NHKsubCh=$NHKsubCh ***\n" if ($log);
    } else {
	my $tid; my $tstr;
	if($_ =~ /Stream\s+\#(\d+):(\d+)\[.+mpeg2video/) {
		if ($vstr eq "" || $2 < $vid) {
			$tid = $2;
			$tstr = "$1:$2";
			if ($NHK && $NHKsubCh != 1) {
			    print OF "\n*** stream #$tstr found: not ch1 NHK.. skipped ***\n" if ($log);
			} else {
			    $vid = $tid; $vstr = $tstr;
			    print OF "*** Found vstr=$vstr ***\n\n" if ($log);
			}
		}
	} elsif($_ =~ /\#(\d+):(\d+)\[.+Audio:/){
	    if ($2 == ($vid + 1)) {
		$tid = $2;
		$tstr = "$1:$2";
		if ($NHK && $NHKsubCh != 1) {
		    print OF "*** Audio stream #$tstr found: not ch1 NHK.. skipped\n" if ($log);
		} else {
		    $aid = $tid; $astr = $tstr;
		    print OF "*** Found astr=$astr and exiting.. ***\n\n" if ($log);
		    $found++;
		    print OF "*** Unprocessed lines.... ***\n";
		}
	    } elsif ($astr eq "" || $2 < $aid) {
		$tid = $2;
		$tstr = "$1:$2";
		if ($NHK && $NHKsubCh != 1) {
		    print OF "*** Audio stream #$tstr found: not ch1 NHK.. skipped ***\n" if ($log);
		} else {
		    $aid = $tid; $astr = $tstr;
		    print OF "*** Found astr=$astr and continue.. ***\n" if ($log);
		}
	    }
	}
    }
}
close($res);

# Print result
print OF "\n****** ffmpeg pass1 finished. *****\n" if ($log);
print OF "*** Found: vstr=$vstr astr=$astr br=$br\n\n" if ($log);
print "vstr=$vstr astr=$astr br=$br\n";

my $cmdstr;
my $loglevel="verbose"; # most verbose
#my $loglevel="info";
#my $loglevel="warning";

#Encode
# $cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -f mp4 -vcodec libx264 -fpre $ffpreset -r 30000/1001 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -map 0:0 -map 0:2 -threads 0 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -f mp4 -vcodec libx264 -fpre $ffpreset -r 30000/1001  -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -ac 2 -map $vstr -map $astr -threads 0 $ARGV[1]";
$cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -f mp4 -vcodec libx264 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -ac 2 -map $vstr -map $astr -threads 0 $ARGV[1]";

# no loging
# $cmdstr = "$cmd -i $ARGV[0] -y -f mp4 -vcodec libx264 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -ac 2 -map $vstr -map $astr -threads 0 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -map $vstr -map $astr -threads 0 $ARGV[1]";

# $cmdstr = "$cmd -i $ARGV[0] -y -aspect 16:9 -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -y -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]";

if ($log) {
	&printdate;
	print OF "$cmdstr\n";
}

open(my $res, "$cmdstr 2>&1 |");
my @crlines;
foreach $_ (<$res>) {
   if ($log) {
	# formatting ^r terminated lines.
	if(m/\r/) {
	    @crlines=split(/\r/);
	    my $prev = "";
	    my $prnext = 0;
	    my $lastPrMin = "";
	    foreach my $ln (@crlines) {
		my $doprint = 0;
		next if ($ln =~ /^\s+$/);
		if ($ln !~ /^frame/) {
		    print OF "$prev\n";
		    $doprint = $prnext = 1;
		} elsif ($ln =~ /(\d+):(\d+):(\d+).(\d+)/) {
		    if ($2 ne $lastPrMin) {
			$doprint = 1;
			$lastPrMin = $2;
		    }
		} elsif ($prnext) {
		    $doprint++; $prnext = 0;
		}

		if ($doprint) {
		    print OF "$ln\n";
		}
		$prev = $ln;
	    }
	}
    }
}

if ($log) {
	&printdate;
	close(OF);
}
close($res);

1;

sub printdate {
	my @dayofw = ('Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat');
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$year += 1900;
	$mon += 1;
#	print OF "**Now** $year/$mon/$mday ($youbi[$wday]) $hour:$min:$sec(s)\n";
	printf(OF "**Now** %d/%02d/%02d (%s) %d:%02d:%02d ****\n", 
		$year, $mon, $mday,  $dayofw[$wday],
		$hour, $min, $sec);
}
