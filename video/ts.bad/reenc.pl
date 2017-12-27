#!/bin/env perl

opendir(DIR, "./");
foreach (readdir(DIR)) {
    next if /\.[^\.]+$/;
    next if /^\./;
    printf("'%s'\n", $_);
    if (/^(GR\d+)/) {
        ENV{CHANNEL}=$1;
    }

    ENV{MODE}="2";
    ENV{DURATION}="2";
}

