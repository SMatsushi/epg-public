#!/bin/sh -f

IN=$1
if [ $2 ]
then
	OUT=$2
else
	OUT=`basename $1 .ts`.mp4
fi
echo $0 $IN $OUT

# ffmpeg -y -i "$IN" -f mp4 -vcodec libx264 -vpre /home/www/epgrec/libx264.ffpreset -r 30000/1001 -aspect 16:9 -s 1440x1080 -bufsize 20000k -maxrate 25000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -map 0.0 -map 0.1 "$OUT"
#ffmpeg -y -i "$IN" -f mp4 -vcodec libx264 -fpre /home/www/epgrec/libx264.ffpreset -r 30000/1001 -aspect 16:9 -s 1440x1080 -bufsize 20000k -maxrate 25000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -map 0.0 -map 0.1 "$OUT"
# ffmpeg -y -i "$IN" -f mp4 -vcodec libx264 -fpre /home/www/epgrec/libx264.ffpreset -r 30000/1001 -aspect 16:9 -s 1440x1080 -bufsize 20000k -maxrate 25000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -threads 4 "$OUT"
ffmpeg -y -i "$IN" -vsync 1 -s 480x360 -threads 4 "$OUT"
