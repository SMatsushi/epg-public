#!/bin/sh

FILES=( \
    "video/BSBS3_1_20190224220000_20190224225000_プレミアムドラマ　盤上のアルファ〜約束の将棋〜（４）【終】「さらば友よ」【字】.mp4"
    "video/NG_1_20190224220000_20190224225000_プレミアムドラマ　盤上のアルファ〜約束の将棋〜（４）【終】「さらば友よ」【字】.mp4"
    "video/GR27_20190302080000_20190302082000_連続テレビ小説　まんぷく（１２７）「きれいごとは通りませんか」【解】【字】【デ】.mp4" )


for OUTPUT in "${FILES[@]}"; do
    if [ -s ${OUTPUT} ]; then
        echo ${OUTPUT} exists and non-zero.
        sz=`wc -c ${OUTPUT} | awk '{print int($1/1024)}'`
        if [ $sz -gt 4098 ]; then
            echo size=$sz KB is big enough.
        else
            echo size=$sz KB is NOT big enough.
        fi
     else
        echo ${OUTPUT} does not exist.
     fi
done
