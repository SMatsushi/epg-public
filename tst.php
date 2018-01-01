<?php
    $hankaku="hello world!\"'\\~() [],.!?;:&&<>\n";
    $result=mb_convert_kana($hankaku, 'R', 'UTF-8');
    print_r($hankaku . "が" . $result);
    $result=mb_convert_kana($hankaku, 'S', 'UTF-8');
    print_r($hankaku . "が" . $result);
    $han = array('"', "'", '`', "\\", '(', ')', '/', ' ', '[', ']', ',', '.', '!', '?', ':', ';', '&', '<', '>');
    $zen = array('”', "’", '｀', "＼", '（', '）', '／', '　', '［', '］', '，', '．', '！', '？', '：', '；', '＆', '＜', '＞');
    $result=str_replace($han, $zen, $hankaku);
    print_r($hankaku . "が" . $result);
?>
