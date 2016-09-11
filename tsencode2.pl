#!/usr/local/bin/perl
use strict;

#ARGV[0] Target TS File
#ARGV[1] Output Filename
#ARGV[2] Video Size (Ex. 480x360 960x720)

# my $ffpreset = "/var/www/html/epgrec/libx264-hq-ts.ffpreset";
my $cmd = "/usr/local/bin/ffmpeg";
my $ffpreset = "/home/www/epgrec/libx264.ffpreset";

my $br; #Audio BitRate

open(OF, ">$ARGV[1].log");
print OF "$^T $0 $ARGV[0] $ARGV[1] $ARGV[2]\n";
open(my $res, "$cmd -i $ARGV[0] 2>&1 |");

#my @lines;
#@lines = split(/\n/,$str);

my ($vstr, $astr); #save StreamID
foreach(<$res>){
    print OF $_;
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
print OF "vstr=$vstr astr=$astr\n";

my $cmdstr;
#Encode
# $cmdstr = "$cmd -i $ARGV[0] -v -y -f mp4 -vcodec libx264 -fpre $ffpreset -r 30000/1001 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -map 0:0 -map 0:2 -threads 0 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -v verbose -y -f mp4 -vcodec libx264 -fpre $ffpreset -r 30000/1001  -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -ac 2 -map $vstr -map $astr -threads 0 $ARGV[1]";
$cmdstr = "$cmd -i $ARGV[0] -v verbose -y -f mp4 -vcodec libx264 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -ac 2 -map $vstr -map $astr -threads 0 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -v verbose -y -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -map $vstr -map $astr -threads 0 $ARGV[1]";

# $cmdstr = "$cmd -i $ARGV[0] -y -aspect 16:9 -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]";
# $cmdstr = "$cmd -i $ARGV[0] -y -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]";

print OF "$cmdstr\n";
open(my $res, "$cmdstr 2>&1 |");
print OF <$res>;
close($res);

close(OF);

1;
