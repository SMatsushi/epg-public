#!/bin/sh

# サムネールを取る時間をFORMER_TIME+αだけずらします
# お好きな時間だけずらしてください

OUTPUT_LOG=${OUTPUT}.log

offset=`expr ${FORMER} + 2`

# This may run first. Do not overwrite and clear log file just in case. Normaly log is created and written once.
echo "FORMER=${FORMER} offset=\`expr \${FORMER} + 2\`"  >> ${OUTPUT_LOG}
echo "Running: ${FFMPEG} -i ${OUTPUT} -r 1 -s 160x90 -ss ${offset} -vframes 1 -f image2 ${THUMB}" >> ${OUTPUT_LOG}
${FFMPEG} -i ${OUTPUT} -r 1 -s 160x90 -ss ${offset} -vframes 1 -f image2 ${THUMB} >> ${OUTPUT_LOG} 2>&1
