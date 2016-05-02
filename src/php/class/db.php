<?php
	
class DB{
	
	static private $_instance;
	static private $_connet;
	 private $db_config = array(
		'host'=>'localhost',
		'usr'=> 'root',
		'pwd'=> 'Alex_owen0',
		'db_name'=> 'persion',
	);
	
	private function __construct()
	{
		
	}
	
	static public function getInstance()
	{
		if(!(self::$_instance instanceof self))
		{
			self::$_instance = new self();
		}
		return self::$_instance;
	}
	
	public function connect()
	{
		if(!self::$_connet)
		{
			self::$_connet = mysql_connect($this->db_config['host'], $this->db_config['usr'], $this->db_config['pwd'])or die('数据库连接失败'.mysql_error);
			mysql_select_db($this->db_config['db_name'], self::$_connet) or die('选择数据库出错'.mysql_error);
			mysql_query('set names UTF8',self::$_connet)or die('设置字符集错误：'.mysql_error()); ;	
		}

		return self::$_connet;
	}
}


?>