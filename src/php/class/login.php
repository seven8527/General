<?php

require_once('./db.php');
require_once('./Response.php');

	//header("Content-type:text/html;charset=utf-8");
	$usr = $_POST["username"];
	$pwd = $_POST["password"];

	if (empty($usr)) {
		echo Response::result(401, '用户名为空', array());
	}
	elseif (empty($pwd)) {
		echo Response::result(402, '密码为空', array());
	}
	else
	{

		$conn = DB::getInstance()->connect();
		$sql = "SELECT password FROM `userinfo` WHERE name='{$usr}'";
		$result = mysql_query($sql, $conn);
		//var_dump($sql);
		//var_dump($result);
		if (!mysql_num_rows($result)) {
			echo Response::result(403, '用户不存在', array());
			exit();
		}

		while ($user = mysql_fetch_array($result)) {		 

			if (!empty($user)) {
				if ($user['password'] == $pwd) {
					echo Response::result(200, '登陆成功', mysql_fetch_array($result));
				}
				else
				{
					echo Response::result(404, '密码错误', array());
				}				
			}
			else
			{
				echo Response::result(405, '用户不存在', array());
			}			
		}
	}
?>