#!/usr/local/bin/perl
use strict;

#ARGV[0] Target TS File
#ARGV[1] Output Filename
#ARGV[2] Video Size (Ex. 480x360 960x720)

# my $ffpreset = "/var/www/html/epgrec/libx264-hq-ts.ffpreset";
my $cmd = "/usr/local/bin/ffmpeg";
my $log = 1;
my $ffpreset = "/home/www/epgrec/libx264.ffpreset";

my $br; #Audio BitRate

if ($log) {
	open(OF, "> $0.log");
	print OF "$^T $0 $ARGV[0] $ARGV[1] $ARGV[2]\n";
	&printdate;
}
open(my $res, "$cmd -i $ARGV[0] 2>&1 |");

my ($vstr, $astr); #save StreamID
foreach(<$res>){
    print OF $_ if ($log);
    #Get Video StreamID
    if($_ =~ /\#([0-9\:]+)\[.+mpeg2video/ && $vstr eq ""){
	$vstr = $1;
    }
    #Get Audio StreamID
    elsif($_ =~ /\#([0-9\:]+)\[.+Audio.+, ([0-9]+) kb\/s/){
	if($2 > $br){
	    $astr = $1;
	    $br = $2;
	}
    }
}
close($res);
print OF "vstr=$vstr astr=$astr br=$br\n" if ($log);

my $cmdstr;
#my $loglevel="verbose"; # most verbose
#my $loglevel="info";
my $loglevel="warning";

#Encode
# $cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -f mp4 -vcodec libx264 -fpre $ffpreset -r 30000/1001 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -map 0:0 -map 0:2 -threads 0 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -f mp4 -vcodec libx264 -fpre $ffpreset -r 30000/1001  -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -ac 2 -map $vstr -map $astr -threads 0 $ARGV[1]";
$cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -f mp4 -vcodec libx264 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -ac 2 -map $vstr -map $astr -threads 0 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -v $loglevel -y -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -map $vstr -map $astr -threads 0 $ARGV[1]";

# $cmdstr = "$cmd -i $ARGV[0] -y -aspect 16:9 -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -y -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]";

if ($log) {
	&printdate;
	print OF "$cmdstr\n";
}
open(my $res, "$cmdstr 2>&1 |");
if ($log) {
	print OF <$res>;
	&printdate;
	close(OF);
} else {
	<$res>;
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
