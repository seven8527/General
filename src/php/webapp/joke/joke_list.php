

  <?
   	// echo "<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";
    $url=$_GET['url'];  
	var_dump($url);

    $html = file_get_contents($url);  

	$html=preg_replace("/[\t\n\r<>]+/","",$html);  

	//<a href="/jokehtml/冷笑话/2015080823324321.htm" target="_blank">内有各种冷,搞笑小冰箱</a>
	//<li><b><a href="/jokehtml/冷笑话/2014042000020662.htm" target="_blank">冷的笑意弥漫</a></b><span>浏览：31097次</span><i>2014-4-20</i></li>
	//<li><b><a href="/jokehtml/冷笑话/2015080623211465.htm" target="_blank">爆冷的真爱</a></b><span>浏览：4816次</span><i>2015-8-6</i></li>
	//<li><b><a href="/jokehtml/冷笑话/2015080823324321.htm" target="_blank">内有各种冷,搞笑小冰箱</a></b><span>浏览：7次</span><i>2015-8-8</i></li>


	preg_match('/div class="list_title"ul(.*?)\/ul\/div/is',$html,$re);

	// var_dump($re[1]);

	// $preg ='/target="_blank">([^<>]+)<\/a><\/b><span>(.*?)<\/span><i>(.*?)<\/i><\/li>/';//正则</p.*>
	$preg ='/liba href="(.*?)"target="_blank"(.*?)\/a\/bspan(.*?)\/spani(.*?)\/i\/li/';//正则</p.*>
	preg_match_all($preg,$re[1],$num); 
	
	$final_result = array();
	// var_dump($num);

	for ($i=0; $i <count($num[1]) ; $i++) { 
		$retens =  array('url'=>str_replace($url, 'http://www.jokeji.cn', $url.$num[1][$i]),'content'=>$num[2][$i],'span'=>$num[3][$i],'time'=>$num[4][$i]);		
		array_push($final_result, $retens);
	}
	// var_dump($num);
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