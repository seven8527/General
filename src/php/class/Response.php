<?php

class Response
{
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