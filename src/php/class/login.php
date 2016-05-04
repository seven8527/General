<?php

require_once('./db.php');
require_once('./Response.php');

	//header("Content-type:text/html;charset=utf-8");
	$usr = $_POST["username"];
	$pwd = $_POST["password"];

	if ($usr) {
		echo Response::result(401, '用户名为空', array());
	}
	elseif ($pwd) {
		echo Response::result(402, '密码为空', array());
	}
	else
	{

		$conn = DB::getInstance()->connect();
		$sql = "select pwd from user where name = {$usr}";
		$result = mysql_query($sql, $conn);

		if ($result == false) {
			echo Response::result(403, $sql, array());
			exit();
		}

		while ($user = mysql_fetch_array($result)) {		 

			if ($user) {
				if ($user['pwd'] == $pwd) {
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