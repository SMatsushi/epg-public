#! /bin/sh

for ts in `ls *.ts`
do
#	echo $ts
	dest=`basename $ts ".mp4_tmp.ts"`.mp4
#	echo $dest
	cmd="ffmpeg -y -async 1000 -vsync 1 -r 15.0 -i $ts $dest"
	echo $cmd
	$cmd
	echo "mv $ts ts.done"
	mv $ts ts.done
done

# ffmpeg -y -async 1000 -vsync 1 -r 15.0  -i ts.sav/GR27_20150210080000_20150210081700_連続テレビ小説　マッサン（１１０）「万事休す」【解】【字】【デ】.mp4_tmp.ts t15.mp4
# ffmpeg -y -async 1000 -r 15.0 -i GR27_20150210080000_20150210081700_連続テレビ 小説　マッサン（１１０）「万事休す」【解】【字】【デ】.mp4_tmp.ts GR27_20150210080000_20150210081700_連続テレビ小説　マッサン（１１０）「万事休す」【解】【字】【デ】.mp4

# not works for one seg
#   ffmpeg -y -async 1000 -vsync 1 -r 15.0  -i GR27_20150210080000_20150210081700_連続テレビ小説　マッサン（１１０）「万事休す」【解】【字】【デ】.mp4_tmp.ts -map 0:11 -map 0:12 t15.mp4
