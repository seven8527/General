  <?
//   	echo "<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";

    // $url='http://sports.firefox.163.com/';  
    $url=$_GET['url'];
    $html = file_get_contents($url);  

	$html=preg_replace("/[\t\n\r]+/","",$html);  

	//<a class="list_box first" href="([[^<>]]+)" target="_blank"><img src="(.*?)"><h1 class="category_title">(.*?)</h1><p>(.*?)</p><div>(.*?)</div></a>
	$preg ='/<a class="list_box.*?" href="([^<>]+)" target="_blank"><img src="(.*?)"><h1 class="category_title">(.*?)<\/h1><p>(.*?)<\/p><div>(.*?)<\/div><\/a>/';//正则</p.*>
	preg_match_all($preg,$html,$num); 
	
	// var_dump($num);

	$final_result = array();

	for ($i=0; $i <count($num[1]) ; $i++) { 
		$retens =  array('url'=>$url.$num[1][$i],'image_url'=>$num[2][$i],'title'=>$num[3][$i],'time'=>$num[4][$i],'content'=>$num[5][$i]);		
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