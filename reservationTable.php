<?php
include_once('config.php');
include_once( INSTALL_PATH . '/DBRecord.class.php' );
include_once( INSTALL_PATH . '/Smarty/Smarty.class.php' );
include_once('reclib.php');

$logfile = INSTALL_PATH."/video/reservationTable.log";
$logWritten = 0;

try{
	$rvs = DBRecord::createRecords(RESERVE_TBL, "WHERE complete='0' ORDER BY starttime ASC" );
	$recd = DBRecord::createRecords(RESERVE_TBL, "WHERE complete='1' ORDER BY starttime ASC" );
	$spacecmd = "./recspace.pl ".count($recd)." ".count($rvs);
	
	$reservations = array();
	foreach( $rvs as $r ) {
		$cat = new DBRecord(CATEGORY_TBL, "id", $r->category_id );
		$arr = array();
		$arr['id'] = $r->id;
		$arr['type'] = $r->type;
		$arr['channel'] = $r->channel;
		$arr['starttime'] = $r->starttime;
		$arr['endtime'] = $r->endtime;
        if( time() > toTimestamp($r->endtime) ) {
             // 終わったはずの録画がまだ予約になっている
             $r->complete = 1;    // 終わったことにする
             $logfp = fopen($logfile, "a");
             fwrite($logfp, "録画ID".$r->id.":".$r->type.$r->channel.$r->title."を録画終了にした\n" );
             fwrite($logfp,"  理由) 現時刻: ".toDatetime(time())." > 録画終了予定時刻: ".$r->endtime."\n" );
             $logWritten++;
        }
		$arr['mode'] = $RECORD_MODE[$r->mode]['name'];
		$arr['title'] = $r->title;
		$arr['description'] = $r->description;
		$arr['cat'] = $cat->name_en;
		$arr['autorec'] = $r->autorec;
		
		array_push( $reservations, $arr );
	}
    if ($logWritten > 0) {
        fwrite($logfp, $logWritten." entries written");
        fclose($logfp);
    }
	
	$smarty = new Smarty();
	$smarty->assign("sitetitle","録画予約一覧");
	$smarty->assign("space", exec($spacecmd));
	$smarty->assign( "reservations", $reservations );
	$smarty->display("reservationTable.html");
}
catch( exception $e ) {
	exit( $e->getMessage() );
}
?>
