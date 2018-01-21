
<?php

function getHTML($domain){
	$ch = curl_init();
	curl_setopt($ch,CURLOPT_URL,$domain);
	curl_setopt($ch,CURLOPT_FOLLOWLOCATION,true);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT ,30);
	curl_setopt($ch, CURLOPT_TIMEOUT, 30); 
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    'Connection: Keep-Alive',
    'Keep-Alive: 300'
));
	curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
	curl_setopt($ch,CURLOPT_SSL_VERIFYHOST, false); 
	curl_setopt($ch,CURLOPT_SSL_VERIFYPEER, false);  
	curl_setopt($ch,CURLOPT_USERAGENT,'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13');
	$result=curl_exec($ch);
	curl_close($ch);

	return $result;
}

getHTML("http://www.valleyofatlanta.org");