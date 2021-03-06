#!/usr/local/bin/perl

#// 首都圏用地上デジタルチャンネルマップ
#// 識別子 => チャンネル番号
%GR_CHANNEL_MAP = (
	"GR27" => "NHK総合",
	"GR26" => "NHK教育",
	"GR25" => "日テレ",
	"GR22" => "TBS",
	"GR21" => "フジ",
	"GR24" => "テレ朝",
	"GR23" => "テレ東",
	"GR20" => "MX TV",
	"GR18" => "テレ神",
	"GR30" => "千葉",
	"GR32" => "テレ玉",
	"GR28" => "放送大学",
);

$tpl = "index.tpl";

open(TPL, "$tpl") || die "Can not open template $tpl";

$cmd = "ls *.mp4 |";
open($res, $cmd);

foreach(<$res>){
    if(/^(GR\d+)_(\d+)_(\d+)_(.*)\.mp4$/) {
		$tsfile = $_;
		$chan = $1;
		$start = $2;
		$end = $3;
		$title = $4;
		printf("%s-%s, %10s: %s\n",
			&fmtdate($start, 0),
			&fmtdate($end, 1),
			$GR_CHANNEL_MAP{$chan} ? $GR_CHANNEL_MAP{$chan} : $chan,
			$title);
	}
}

1;

sub date2dow {
	($year, $month, $day) = @_;
#	printf("%s/%s/%s\n", $year, $month, $day);
	@weekarray = ('日','月','火','水','木','金','土');
	if ($month < 3){
		$year--;
		$month += 12;
	}
	$weeknum =
		($year+int($year/4)-int($year/100)+
		int($year/400)+int(($month*13+8)/5)+$day) % 7;
	@weekarray[$weeknum];
}

sub fmtdate {
	if ($_[0] =~ /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/) {
		if ($_[1]) {
			sprintf("%s:%s", $4,$5);
		} else {
			sprintf("%s/%s/%s(%s) %s:%s", $1,$2,$3,
				&date2dow($1,$2,$3),
				$4,$5);
		}
	} else {
		print("Error: Unknown date format: $_[0]\n");
	}
}

sub printdate {
	my @dayofw = ('Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat');
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$year += 1900;
	$mon += 1;
	printf("**Now** %d/%02d/%02d (%s) %d:%02d:%02d ****\n", 
		$year, $mon, $mday,  $dayofw[$wday],
		$hour, $min, $sec);
}
