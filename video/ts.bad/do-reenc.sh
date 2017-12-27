#!/bin/sh
OUTPUT=$1
echo "CHANNEL : $CHANNEL"
echo "DURATION: $DURATION"
echo "OUTPUT  : $OUTPUT"
echo "TUNER : $TUNER"
echo "TYPE : $TYPE"
echo "MODE : $MODE"
echo "SID  : $SID"

RECORDER=/usr/local/bin/recpt1
PERL=/usr/local/bin/perl
ENCPROG=/home/www/epgrec/tsencode5.pl
# ENCPROG=/home/www/epgrec/tsencode.pl
ENC2PROG=/home/www/epgrec/tsencode2.pl

echo "RECORDER : $RECORDER"
echo "PERL : $PERL"
echo "ENCPROG: $ENCPROG"
# ENCPROG=/home/www/epgrec/tsencode.pl
echo "ENC2PROG : $ENC2PROG"

# exit 0

    OUTPUT_TMP=${OUTPUT};
    OUTPUT_LOG=${OUTPUT}.log;
#    $RECORDER --b25 --strip $CHANNEL $DURATION ${OUTPUT_TMP} >/dev/null
    # <-解像度は4:3で指定（理由は後述）
    $PERL $ENCPROG ${OUTPUT_TMP} ${OUTPUT}.mp4 640x360 ${OUTPUT_LOG}
#    if [ -f ${OUTPUT} ]; then
#    if [ -s ${OUTPUT} ]; then
#        echo ${OUTPUT} exists and non-zero. Removing ${OUTPUT_TMP} >> ${OUTPUT_LOG}
#        mv ${OUTPUT_LOG} video/ts.log
#        rm ${OUTPUT_TMP}
#     else
#        echo ${OUTPUT} does not exist. Moving ${OUTPUT_TMP} to video/ts.bad >> ${OUTPUT_LOG}
#        mv ${OUTPUT_LOG} ${OUTPUT_TMP} video/ts.bad
#     fi
#    $PERL $ENC2PROG ${OUTPUT}_tmp.ts t3.mp4 640x360
#     echo mv ${OUTPUT}_tmp.ts video/ts.ok >> video/tsencode.log
#     mv ${OUTPUT}_tmp.ts video/ts.ok

# mode 2 example is as follows
#elif [ ${MODE} = 2 ]; then
#   $RECORDER $CHANNEL $DURATION ${OUTPUT}.tmp.ts --b25 --strip
#   ffmpeg -i ${OUTPUT}.tmp.ts ... 適当なオプション ${OUTPUT}
