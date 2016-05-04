<?php

include('simple_html_dom.php');
    
 $url = 'http://i.firefoxchina.cn/';
 // $url = $_GET['url'];
// get DOM from URL or file
$html = file_get_html($url);


$content = array();

// foreach($html->find('div[class=main-mod main-news mod-delay-resource] div[class=tab-detail] div[class=news-mod news-hot] div div ul li[class=hot-img-one] div a[class=news-img-wrapper] img') as $e) 
$index = 1;
foreach($html->find('div[class=tab-detail] div[class=news-mod news-hot] div[class=hot-mod hot-top] div[class=hot-left] ul li[class=hot-img-one] div a[class=news-img-wrapper] img[class=img-load-delay]' ) as $e) 
{

			$item=array();
			if ($index == 1) {
				$item=array('url' =>'http://domestic.firefox.163.com/' ,'title'=>'国内频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508140848270.jpg');
			}
			else if ($index == 2) {
				$item=array('url' =>'http://world.firefox.163.com/','title'=>'国际频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/8/201508140842320.jpg');
			}
			else if ($index == 3){
				$item=array('url' =>'http://mil.firefox.news.cn/','title'=>'军事频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/8/201508140916380.jpg');
			}
			else if ($index == 4) {
				$item=array('url' =>'http://legal.firefox.news.cn/','title'=>'法制频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508140842310.jpg');
			}
			else if ($index == 5) {
				$item=array('url' =>'http://photo.firefox.news.cn/','title'=>'图片频道', 'img_url'=>'http://www.xinhuanet.com/photo/titlepic/12812/128128160_1439511574490_title0h.jpg');
			}
			else if ($index == 6) {
				$item=array('url' =>'http://shehui.firefox.163.com/','title'=>'社会频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508140845210.jpg');
			}
			else if ($index == 7) {
				$item=array('url' =>'http://ent.firefox.news.cn/','title'=>'八卦频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/5/201508140859360.jpg');
			}
			else if ($index == 8) {
				$item=array('url' =>'http://sports.firefox.163.com/','title'=>'体育频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/5/201508140826030.jpg');
			}
			else if ($index == 9) {
				$item= array('url' =>'http://tech.firefox.163.com/','title'=>'科技频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/8/201508140920060.jpg');
			}
			else if ($index == 10) {
				$item= array('url' =>'http://money.firefox.163.com/','title'=>'财经频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508121709180.jpg');
			}
			else
			{
				$item=array('url' =>'http://domestic.firefox.163.com/' ,'title'=>'国内频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508140848270.jpg');
			}
			$item['img_url'] = $e->{'data-url'} ;
			array_push($content, $item);
			$index =$index + 1;

}
	array_push($content, array('url' =>'http://auto.firefox.news.cn/','title'=>'汽车频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/5/201508141002520.jpg'));
	$arrayData = array('data' => $content);
	// print_r($arrayNews);
	echo json_encode($arrayData);


	// $arrayNews = array();
	// array_push($arrayNews,  array('url' =>'http://domestic.firefox.163.com/' ,'title'=>'国内频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508140848270.jpg')); 
	// array_push($arrayNews, array('url' =>'http://world.firefox.163.com/','title'=>'国际频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/8/201508140842320.jpg'));
	// array_push($arrayNews, array('url' =>'http://mil.firefox.news.cn/','title'=>'军事频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/8/201508140916380.jpg'));
	// array_push($arrayNews, array('url' =>'http://legal.firefox.news.cn/','title'=>'法制频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508140842310.jpg'));
	// array_push($arrayNews,  array('url' =>'http://photo.firefox.news.cn/','title'=>'图片频道', 'img_url'=>'http://www.xinhuanet.com/photo/titlepic/12812/128128160_1439511574490_title0h.jpg'));
	// array_push($arrayNews,  array('url' =>'http://shehui.firefox.163.com/','title'=>'社会频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508140845210.jpg'));
	// array_push($arrayNews, array('url' =>'http://ent.firefox.news.cn/','title'=>'八卦频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/5/201508140859360.jpg'));
	// array_push($arrayNews,  array('url' =>'http://sports.firefox.163.com/','title'=>'体育频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/5/201508140826030.jpg'));
	// array_push($arrayNews, array('url' =>'http://tech.firefox.163.com/','title'=>'科技频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/8/201508140920060.jpg'));
	// array_push($arrayNews, array('url' =>'http://money.firefox.163.com/','title'=>'财经频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/4/201508121709180.jpg'));
	// //array_push($arrayNews, array('url' =>'http://firefox.vogue.com.cn/','title'=>'时尚频道', 'img_url'=>'http://upload.trends.com.cn/2015/0814/1439518508687.jpg'));
	// array_push($arrayNews, array('url' =>'http://auto.firefox.news.cn/','title'=>'汽车频道', 'img_url'=>'http://img.firefoxchina.cn/2015/08/5/201508141002520.jpg'));

	// $arrayData = array('data' => $arrayNews);
	// // print_r($arrayNews);
	// echo json_encode($arrayData);


?>