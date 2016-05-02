<?php

class Response
{
	
	/*
	* 根据方式输出相应格式 
	* param intger 相应码
	* param string 消息
	* param array  内容
	*/
	public static function result($code, $message='', $data=array())
	{
		//$type = isset($_GET['format'])?$_GET['format']:'';
		$type = $_GET['format']
		if(!$type)
		{
			//var_dump($type);
			$type = $_POST['format'];
		}
		if($type == 'json')
		{
			return self::json($code, $message, $data);
		}
		elseif($type == 'xml')
		{
			return self::xml($code, $message, $data);
		}
		elseif($type == 'array')
		{
			var_dump($data);
		}
		else{
			
			return self::json($code, $message, $data);
		}
	}
	/*
	* 输出json 格式 相应
	* param intger 相应码
	* param string 消息
	* param array  内容
	*/
	public static function json($code, $message='', $data=array())
	{
		
		if(!is_numeric($code))
		{
			return '';
		}
		$result = array(
			'code'=>$code,
			'message' => $message,
			'data' => $data,
		);
		//var_dump($result);
		return json_encode($result);
	}
	/*
	* 输出xml 格式 相应
	* param intger 相应码
	* param string 消息
	* param array  内容
	*/
	public static function xml($code, $message='', $data=array())
	{
		if(!is_numeric($code))
		{
			return '';
		}
		$result = array(
			'code'=>$code,
			'message' => $message,
			'data' => $data,
		);
		header("Content-Type:text/xml");
		$xml = "<?xml version='1.0' encoding= 'UTF-8'?>\n";
		$xml .= "<root>\n";
		$xml .= self::makeItem($result);		
		$xml .="</root>";
		
		return $xml;
	}
	
	public static function makeItem($data)
	{
		$xml ='';
		foreach( $data as $key => $value)
		{
			if(is_numeric($key))
			{
				$attr = " id='{$key}'";
				$key = "item";
			}
			
			$xml .= "<{$key}{$attr}>";
			$xml .= is_array($value)? self::makeItem($value):$value;
			$xml .= "</{$key}>\n";
		}
		return $xml;
	}
}
?>