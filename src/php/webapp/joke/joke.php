  <?
   	// echo "<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";
    $url='http://www.jokeji.cn/Keyword.htm';  
    $html = file_get_contents($url);  

	$html=preg_replace("/[\t\n\r]+/","",$html);  

	//<a href="([^<>]+)" target="_self" class="user_14">(.*?)</a>
	$preg ='/<a href="([^<>]+)" target="_self" class="user_14">(.*?)<\/a>/';//正则</p.*>
	preg_match_all($preg,$html,$num); 
	
	$final_result = array();

	for ($i=0; $i <count($num[1]) ; $i++) { 
		$retens =  array('url'=>$url.$num[1][$i],'content'=>$num[2][$i]);		
		array_push($final_result, $retens);
	}
	// var_dump($final_result);
	$jarr = array('data'=>$final_result);
	$jarr =json_encode(url_encode($jarr));
	echo urldecode($jarr);


function encode_json($str) {  
    return urldecode(json_encode(url_encode($str)));      
}  
  
/** 
 *  
 */  
function url_encode($str) {  
    if(is_array($str)) {  
        foreach($str as $key=>$value) {  
            $str[urlencode($key)] = url_encode($value);  
        }  
    } else {  
        $str = urlencode($str);  
    }  
      
    return $str;  
} 
    ?>  