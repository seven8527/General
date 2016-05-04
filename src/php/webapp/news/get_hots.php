<?php
// echo "<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";
// example of how to use basic selector to retrieve HTML contents
include('simple_html_dom.php');
    
 $url = 'http://www.firefoxchina.cn/';
 // $url = $_GET['url'];
// get DOM from URL or file
$html = file_get_html($url);

$arrayName = array();

// get content
$content= array();
$findme = 'vogue.com.cn';
$findmegq = 'gq.com.cn';
$findmeself = 'self.com.cn';
$findmegui = 'guide.cntraveler.com.cn';
$findmewww = 'www.adstyle.com.cn';


//$image  = array();
foreach($html->find('div[class=main-mod mod-middle]') as $e) 
{

	foreach($e->find('ul li a') as $ex) 
	{
		//$ex = $e->find('a')
		// var_dump($ex);
		$item['text'] = $ex->plaintext ;
		
		$item['url'] = $ex->href;
		$pos = strpos( $ex->href,   $findme);
		$pos1 = strpos( $ex->href,   $findmegq);
		$pos2 = strpos( $ex->href,   $findmeself);
		$pos3 = strpos( $ex->href,   $findmegui);
		$pos4 = strpos( $ex->href,   $findmewww);
		if (!$pos&&!$pos1&&!$pos2&&!$pos3&&!$pos4) {
			array_push($content, $item);
		}

		
	}

}


$arrayName['stat'] =  '0';

$arrayName['total'] =  count( $content);
$arrayName['content'] =  $content;

echo json_encode($arrayName);
$html->clear();
?> 