<?php

class Response
{
	/*
	* 返回json 格式数据
	* param string $code  状态码
	* param string $message 状态消息
	* param   $data 数据
	*/
	public static function json($code, $message, $data)
	{
		if(!$code)
		{			
			return '';
		}
		$result = array(
			'code'=>$code,
			'message' => $message,
			'data' => $data
		);
		return json_encode($result);
	}
	
	
	
}
?>