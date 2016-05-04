<?php
//echo "<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";
// example of how to use basic selector to retrieve HTML contents
include('simple_html_dom.php');
    
// get DOM from URL or file
// $html = file_get_html('http://mil.firefox.news.cn/');
    
 //$url = 'http://world.firefox.163.com/';
 $url = $_GET['url'];
// get DOM from URL or file
$html = file_get_html($url);
// $Root_url = 'http://mil.firefox.news.cn/';
$arrayName = array();

// var_dump($html);
foreach($html->find('a.list_box') as $e) 
{
	$img='';
	$h1;
	$p;
	$div;

	$href = $e->href ;
	
	foreach($e->find('img') as  $ex) {
		// echo $ex->plaintext . '<br>';
		
		  $img = $ex->src ;
	}
	if(is_null($img))
	{
//		$img='';
	}
	  // echo $e->plaintext . '<br>';
	foreach ($e->find('h1') as  $ex) {
		  // echo $ex->outertext . '<br>';
		$h1 = $ex->plaintext;
	}
  foreach ($e->find('p') as  $ex) {
		  // echo $ex->outertext . '<br>';
  		$p = $ex->plaintext;
	}
  foreach ($e->find('div') as  $ex) {
		  // echo $ex->outertext . '<br>';
  		$div = $ex->plaintext;
	}

	$arrayTmp  = array('img' => $img, 'title'=>$h1 , 'time' =>$p, 'content' => $div , 'url'=>$href);
	array_push($arrayName, $arrayTmp);
	

}
$nextpage;
foreach($html->find('a.next') as $e) 
	{

		  $nextpage = $e->href ;
	
	}
// var_dump($arrayName);

$arrayReturn  = array('data' => $arrayName, 'next'=> $nextpage, 'total'=> count($arrayName), 'stat'=>'0');
echo json_encode($arrayReturn);
?> 