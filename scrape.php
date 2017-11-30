<?php

ini_set('memory_limit','16M');
set_time_limit(800);
class scrape {
var $conn="";
function scrapeWebsite($offset){
	include 'simple_html_dom.php';
$host="localhost";
$username="root";
$password="BrookePorter1281";
$db="domains";
$this->conn=new mysqli($host,$username,$password,$db);
echo $offset;
$sql="select * from domains where scraped is NULL LIMIT $offset,100";

$result=$this->conn->query($sql);

if($result->num_rows > 0){
	
	while($row=$result->fetch_assoc()){
		$sqlUpdate="update domains set scraped=true WHERE id=" .$row['id'];
                $this->conn->query($sqlUpdate);

		echo $row['domainname'];
		$html=$this->getHTML("http://www." . $row['domainname']);
		if(strlen($html)<10){
			$sqlUpdate="update domains set html='$html',haswebsite=false,filter='BLANK RETURNED',scraped=true WHERE id=" .$row['id'];
			$this->conn->query($sqlUpdate);
			continue;	
		}
		if($this->containsWord($html,"The resource you are looking for has been removed")){
		 	$sqlUpdate="update domains set html='$html',haswebsite=false,filter='REMOVED',scraped=true WHERE id=" .$row['id'];
                        $this->conn->query($sqlUpdate);
                        continue;
		}
		$find=$this->runFilters($html);
		if($find !=false){
			$sqlUpdate="update domains set html='$html',haswebsite=false,filter='$find',scraped=true WHERE id=" .$row['id'];
		}else{
			$sqlUpdate="update domains set html='$html',haswebsite=true,filter='$find',scraped=true WHERE id=" .$row['id'];
		}
		
		
		$this->conn->query($sqlUpdate);
	}
}



mysqli_close($this->conn);
}


function getHTML($domain){
	$ch = curl_init();
	curl_setopt($ch,CURLOPT_URL,$domain);
	curl_setopt($ch,CURLOPT_FOLLOWLOCATION,true);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT ,30);
	curl_setopt($ch, CURLOPT_TIMEOUT, 30); 
	curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
	curl_setopt($ch,CURLOPT_SSL_VERIFYHOST, false); 
	curl_setopt($ch,CURLOPT_SSL_VERIFYPEER, false);  
	curl_setopt($ch,CURLOPT_USERAGENT,'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13');
	$result=curl_exec($ch);
	curl_close($ch);

	return $result;
}
function containsWord($str, $word)
{
    return !!preg_match('#\\b' . preg_quote($word, '#') . '\\b#i', $str);
}
function runFilters($html){
	$htmlDom=new simple_html_dom();

	$htmlDom->load($html);

	$filtersSQL="select * from filters";
	$result=$this->conn->query($filtersSQL);
	while($row=$result->fetch_assoc()){
		$items=$htmlDom->find($row['selector']);
		foreach($items as $find){
			switch ($row['attr']){
				case "text":
					
					if($this->containsWord($find->innertext,$row['regex'])){
					
					return $row['name'];
			
					}
				break;

				case "src":
					if($this->containsWord($find->src,$row['regex'])){
					
					return $row['name'];
			
					}
				break;
			}
			
		}
	}
	return false;
}
}
echo $argv[1];
$a=new scrape();
$a->scrapeWebsite($argv[1]);
?>
