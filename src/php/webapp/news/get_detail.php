<?php
// echo "<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";
// example of how to use basic selector to retrieve HTML contents
include('simple_html_dom.php');
    
 $url = 'http://mil.firefox.news.cn/15/0812/08/7GKW53VHZEOMNR8T.html';
 $url = $_GET['url'];
// get DOM from URL or file
$html = file_get_html($url);


// $Root_url = 'http://mil.firefox.news.cn/';
$arrayName = array();

// var_dump($html);
//get title
foreach($html->find('div.article_title') as $e) 
{


	foreach($e->find('h1') as  $ex) {
		// echo $ex->plaintext . '<br>';
		  $arrayName['title'] = $ex->plaintext ;
	}
	  // echo $e->plaintext . '<br>';
	foreach ($e->find('p') as  $ex) {
		$arrayName['time'] = $ex->plaintext;
	}

}

// get content
$content= array();
//$image  = array();
foreach($html->find('div.article_content') as $e) 
{


	//foreach($e->find('p[!class]') as  $ex) {		
	//$content[] = $ex->plaintext ;
	//}
	// echo $e->plaintext . '<br>';
	//foreach ($e->find('img') as  $ex) {
	//	$image[] = $ex->src;
	//}
	for( $i = 0 ; $i< count($e->find('p[!class]')); $i++)
	{
		$item['text'] = $e->find('p[!class]',$i)->plaintext ;
		if(is_null($e->find('img',$i)->src))
			$item['image'] ='';
		else
		$item['image'] = $e->find('img',$i)->src ;
		array_push($content, $item);
	}

}

$nextpage;
foreach($html->find('p.article_pages') as $e) 
	{
		foreach($e->find('a') as $ex) 
		{
			// echo $ex->plaintext;
			if('下一页'=== $ex->plaintext)
				$nextpage = $ex->href ;
			if('上一页'=== $ex->plaintext)
				$nextpage = '' ;
		}


	
	}
// var_dump($arrayName);
$arrayName['stat'] =  '0';
if ( is_null($nextpage)) {
	$nextpage='';
}
$arrayName['netxpage'] =  $nextpage;
$arrayName['content'] =  $content;
//$arrayName['image'] =  $image;
// $arrayReturn  = array('data' => $arrayName, 'next'=> $nextpage, 'total'=> count($arrayName), 'stat'=>'0');
// var_dump($arrayName);
echo json_encode($arrayName);
?> 