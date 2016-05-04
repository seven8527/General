<?php
echo "<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";
// example of how to use basic selector to retrieve HTML contents
include('simple_html_dom.php');
    
// get DOM from URL or file
$html = file_get_html('http://mil.firefox.news.cn/');

foreach($html->find('div.left') as $e) 
{
	foreach ($e->find('p') as  $x) {
		  echo $x->outertext . '<br>';
	}
  foreach ($e->find('img') as  $x) {
		  echo $x->src . '<br>';
	}

}
    ?> 