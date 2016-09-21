<?php

require_once('./db.php');
require_once('./Response.php');

	$user = $_POST['username'];
	$pwd = $_POST['password'];
	if (empty($user)) {
		echo Response::result(401, '用户名为空', array());
	}
	else if(empty($pwd)){
		echo Response::result(402, '密码不能为空', array());
	}
	else
	{
		$conn = DB::getInstance()->connect();
		$select_sql = "SELECT * FROM `userinfo` WHERE name='{$user}'";
		$result = mysql_query($select_sql);
		if (mysql_num_rows($result)) {
		 	echo Response::result(403, '用户名已存在', array());
		}else{
			// INSERT INTO table_name (列1, 列2,...) VALUES (值1, 值2,....)
			$insert_sql = "INSERT INTO `userinfo` (name, password) VALUES ('{$user}', '{$pwd}')";
			$inser_result = mysql_query($insert_sql);
			if ($inser_result) {
				echo Response::result(200, '注册成功', array());	
			}
			else
			{
				echo Response::result(404, '创建用户失败,服务器异常', array());
			}
					
				
		}
	}

?>