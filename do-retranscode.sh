#!/bin/sh

SRC=$1
BASE=`basename $SRC`
DESTDIR=./video
BADDIR=./video/ts.bad
DEST="${DESTDIR}/${BASE}"
LOG="${BADDIR}/${BASE}.rtrsc.log"

echo conveting $SRC ($BASE) to $DEST with $LOG"

RECORDER=/usr/local/bin/recpt1
PERL=/usr/local/bin/perl
ENCPROG=/home/www/epgrec/tsencode5.pl
# ENCPROG=/home/www/epgrec/tsencode.pl
ENC2PROG=/home/www/epgrec/tsencode2.pl


    OUTPUT_TMP=${SRC}_tmp.ts
    OUTPUT_LOG=$LOG
    OUTPUT=$DEST
    
    # <-解像度は4:3で指定（理由は後述）

echo doing   $PERL $ENCPROG ${OUTPUT_TMP} ${OUTPUT} 640x360 ${OUTPUT_LOG}
exit 0
  
#    if [ -f ${OUTPUT} ]; then
    if [ -s ${OUTPUT} ]; then
        echo ${OUTPUT} exists and non-zero. Removing ${OUTPUT_TMP} >> ${OUTPUT_LOG}
        mv ${OUTPUT_LOG} video/ts.log
        rm ${OUTPUT_TMP}
     else
        echo ${OUTPUT} does not exist. Moving ${OUTPUT_TMP} to video/ts.bad >> ${OUTPUT_LOG}
        mv ${OUTPUT_LOG} ${OUTPUT_TMP} video/ts.bad

#    $PERL $ENC2PROG ${OUTPUT}_tmp.ts t3.mp4 640x360
#     echo mv ${OUTPUT}_tmp.ts video/ts.ok >> video/tsencode.log
#     mv ${OUTPUT}_tmp.ts video/ts.ok

# mode 2 example is as follows
#elif [ ${MODE} = 2 ]; then
#   $RECORDER $CHANNEL $DURATION ${OUTPUT}.tmp.ts --b25 --strip
#   ffmpeg -i ${OUTPUT}.tmp.ts ... 適当なオプション ${OUTPUT}
fi
