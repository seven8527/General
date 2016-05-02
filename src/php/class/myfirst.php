<?php 

//echo '第一个php 程序';
require_once('./Response.php');


//define(DB_HOST,'localhost');
//define(DB_NAME, 'root');
//define(DB_PWD, 'Alex_owen0');
//define(DB_DBNAME, 'persion');
//define(DB_TABLENAME, 'persioninfo');

//创建连接
$conn = mysql_connect(DB_HOST,DB_NAME, DB_PWD)or die('数据库连接失败：'.mysql_error());

//选择数据库
mysql_select_db(DB_DBNAME, $conn) or die('选择数据库失败：'.mysql_error());
//设置字符集
mysql_query('set NAMES UTF8')or die('设置字符集错误：'.mysql_error()); 

//查询数据
$query = "select * from ".DB_TABLENAME;
$result = mysql_query($query, $conn)or die('查询出错：'.mysql_error());

//输出资源
//print_r(mysql_fetch_array($result, MYSQL_ASSOC));
//echo json_encode(mysql_fetch_array($result, MYSQL_ASSOC));

 //echo Response::json(200, '查询成功', mysql_fetch_array ($result, MYSQL_ASSOC));
 echo Response::result(200, '查询成功', mysql_fetch_array ($result, MYSQL_ASSOC));
//释放内存资源
mysql_free_result($result);
//关闭数据了连接
mysql_close($conn);




?>