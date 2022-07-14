<?php

$limit = 2000;

$external_ip = "103.173.155.236";
$skip = [$external_ip, "199.241.138.81"];

$serverip=$external_ip;
exec("netstat -ntu|awk '{print $5}'|cut -d: -f1 -s|sort|uniq -c|sort -nk1 -r",$out);
foreach($out as $item){
	$item = trim($item);
	if($item != ""){
		$temp = explode(" ",$item);
		if(isset($temp[1])){
			$count = (int)$temp[0];
			if($count > $limit and !in_array(trim($temp[1]),$skip)){
				exec("sudo route add ".trim($temp[1])." reject");
				exec("sudo route add ".trim($temp[1])." reject");
				
				$curl = curl_init();
					curl_setopt_array($curl, array(
						CURLOPT_RETURNTRANSFER => 1,
						CURLOPT_URL => "https://script.google.com/macros/s/AKfycbwZhTQpvZsADMJDUAxy_7Pjeky6N9mVZnZQPeL5qLPzFNTil5Hz57VJKD27dMI-b8H0/exec?serverip=".$serverip."&blockip=".trim($temp[1])."&count=".$count."",
						CURLOPT_USERAGENT => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0',
						CURLOPT_SSL_VERIFYPEER => false
					));

				$resp = curl_exec($curl);
			}
		}
	}
	
}
