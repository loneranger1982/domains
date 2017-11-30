<?php
include 'simple_html_dom.php';
$host="localhost";
$username="root";
$password="BrookePorter1281";
$db="domains";
$conn=new mysqli($host,$username,$password,$db);

$sql="select * from domains where scraped is NULL LIMIT 100";

$result=$conn->query($sql);

if($result->num_rows > 0){

	while($row=$result->fetch_assoc()){
		
		$html=getHTML("http://www." . $row['domainname']);
		$find=runFilters($html);
		if($find !=false){
			$sqlUpdate="update domains set haswebsite=false,filter='$find',scraped=true WHERE id=" .$row['id'];
		}else{
			$sqlUpdate="update domains set haswebsite=true,filter='$find',scraped=true WHERE id=" .$row['id'];
		}
		
		
		$conn->query($sqlUpdate);
	}
}



mysqli_close($conn);

function getHTML($domain){
	$ch = curl_init();
	curl_setopt($ch,CURLOPT_URL,$domain);
	curl_setopt($ch,CURLOPT_FOLLOWLOCATION,true);
	curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
	curl_setopt($ch,CURLOPT_SSL_VERIFYHOST, false); 
	curl_setopt($ch,CURLOPT_SSL_VERIFYPEER, false);  
	curl_setopt($ch,CURLOPT_USERAGENT,'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13');
	$result=curl_exec($ch);
	curl_close($ch);

	return $result;
}

function runFilters($html){
	$htmlDom=new simple_html_dom();

	$htmlDom->load($html);

	$filtersSQL="select * from filters";
	$result=$conn->query($filtersSQL);
	while($row=$result->fetch)assoc()){
		$items=$html->find($row['selector'])
		foreach($items as $find){
			switch ($row['attr']){
				case "text":
					if($find->outertext == $row['regex']){
					return $row['name'];
			
					}
				break;

				case "src":
					if($find->src == $row['regex']){
					return $row['name'];
			
					}
				break;
			}
			
		}
	}
	return false;
}
?>
