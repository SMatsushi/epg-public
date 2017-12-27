#!/bin/env perl

opendir(DIR, "./");
foreach (readdir(DIR)) {
    next if /\.[^\.]+$/;
    next if /^\./;
#    printf("'%s'\n", $_);

    $cmd = "./do-reenc.sh $_";
    printf("'%s'\n", $cmd);
    system($cmd);
}


