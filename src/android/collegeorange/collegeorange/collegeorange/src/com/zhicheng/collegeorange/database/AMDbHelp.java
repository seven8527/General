package com.zhicheng.collegeorange.database;

import android.content.Context;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import com.zhicheng.collegeorange.main.SharedHelper;


public class AMDbHelp  extends SQLiteOpenHelper{


	private static final String DATABASE_NAME = "viewpoint.db";// 数据库的名称

	private static final int DATABASE_VERSION = 1;// 数据库版本

	/**
	 * 默认构造函数
	 */
	public AMDbHelp(Context context) {
		super(context, SharedHelper.getShareHelper(context).getString(SharedHelper.USER_NAME, "") + DATABASE_NAME, null, DATABASE_VERSION);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		StringBuilder sqlViewpointTemp = new StringBuilder();
		sqlViewpointTemp.append("CREATE TABLE If NOT EXISTS ");
		sqlViewpointTemp.append(ViewpointDBHelper.VIEWPOINT_TABLE_NAME);
		sqlViewpointTemp.append(" (");
		sqlViewpointTemp.append("_id integer not null primary key,");
		sqlViewpointTemp.append("author varchar(1024),");
		sqlViewpointTemp.append("page_url varchar(1024),");
		sqlViewpointTemp.append("brief varchar(1024),");
		sqlViewpointTemp.append("create_time varchar(1024),");
		sqlViewpointTemp.append("pic_url varchar(1024),");
		sqlViewpointTemp.append("title varchar(1024),");
		sqlViewpointTemp.append("vid varchar(1024),");
		sqlViewpointTemp.append("zan_count varchar(1024),");
		sqlViewpointTemp.append("rowse_count varchar(1024),");
		sqlViewpointTemp.append("comment_count varchar(1024) default '0'");
		sqlViewpointTemp.append(" );");
		
		//创建上传列表表
		String sqlUpload = sqlViewpointTemp.toString();
		sqlViewpointTemp = null;
		db.execSQL(sqlUpload);
		
		StringBuilder sqlShareTemp = new StringBuilder();
		sqlShareTemp.append("CREATE TABLE If NOT EXISTS ");
		sqlShareTemp.append(ViewpointDBHelper.SHARE_TABLE_NAME);
		sqlShareTemp.append(" (");
		sqlShareTemp.append("_id integer not null primary key,");
		sqlShareTemp.append("phone varchar(1024),");
		sqlShareTemp.append("vid varchar(1024),");
		sqlShareTemp.append("content varchar(1024),");
		sqlShareTemp.append("create_time varchar(1024),");
		sqlShareTemp.append("pic_url varchar(1024),");
		sqlShareTemp.append("position varchar(1024)");
		sqlShareTemp.append(" );");
		
		//创建上传列表表
		String sqlShare = sqlShareTemp.toString();
		sqlShareTemp = null;
		db.execSQL(sqlShare);

		creatCircleTable(db);
		
		StringBuilder sqlUserCircleTemp = new StringBuilder();
		sqlUserCircleTemp.append("CREATE TABLE If NOT EXISTS ");
		sqlUserCircleTemp.append(ViewpointDBHelper.FRIEND_USER_CIRCLE_TABLE_NAME);
		sqlUserCircleTemp.append(" (");
//		sqlUserCircleTemp.append("_id integer not null primary key,");
//		sqlUserCircleTemp.append("sid varchar(1024),");
		sqlUserCircleTemp.append("phone_num varchar(1024) not null primary key,");
		sqlUserCircleTemp.append("lickname varchar(1024),");
		sqlUserCircleTemp.append("icon varchar(1024),");
		sqlUserCircleTemp.append("gender text");
		sqlUserCircleTemp.append(" );");
		
		//创建上传列表表
		String sqlUserCircle = sqlUserCircleTemp.toString();
		sqlUserCircleTemp = null;
		db.execSQL(sqlUserCircle);
		
		
		StringBuilder sqlCircleMessageTemp = new StringBuilder();
		sqlCircleMessageTemp.append("CREATE TABLE If NOT EXISTS ");
		sqlCircleMessageTemp.append(ViewpointDBHelper.FRIEND_CIRCLE_MESSAGE_TABLE_NAME);
		sqlCircleMessageTemp.append(" (");
		sqlCircleMessageTemp.append("_id integer not null primary key,");
		sqlCircleMessageTemp.append("sid text not null,");
		sqlCircleMessageTemp.append("msgType text not null,");
		sqlCircleMessageTemp.append("fromUser text not null,");
		sqlCircleMessageTemp.append("author text not null,");
		sqlCircleMessageTemp.append("nickName text,");
		sqlCircleMessageTemp.append("avatar text,");
		sqlCircleMessageTemp.append("mark text,");
		sqlCircleMessageTemp.append("isNew integer default 1,");
		sqlCircleMessageTemp.append("time text,");
		sqlCircleMessageTemp.append("context text,");
		sqlCircleMessageTemp.append("image text");
		sqlCircleMessageTemp.append(" );");
		
		//创建上传列表表
		String sqlCircleMessage = sqlCircleMessageTemp.toString();
		sqlCircleMessageTemp = null;
		db.execSQL(sqlCircleMessage);
	
	
		//创建话题评论表
		creatCircleReview(db);
		
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		
	}
	
	private void creatCircleTable(SQLiteDatabase db){
		
		StringBuilder sqlViewpointCircleTemp = new StringBuilder();
		sqlViewpointCircleTemp.append("CREATE TABLE If NOT EXISTS ");
		sqlViewpointCircleTemp.append(ViewpointDBHelper.FRIEND_CIRCLE_TABLE_NAME);
		sqlViewpointCircleTemp.append(" (");
		sqlViewpointCircleTemp.append("_id integer,");
		sqlViewpointCircleTemp.append("sid varchar(1024),");
		sqlViewpointCircleTemp.append("phone_num varchar(1024),");
		sqlViewpointCircleTemp.append("content varchar(1024),");
		sqlViewpointCircleTemp.append("create_time varchar(1024),");
		sqlViewpointCircleTemp.append("pic_url varchar(1024),");
		sqlViewpointCircleTemp.append("position varchar(1024),");
		sqlViewpointCircleTemp.append("commentCount integer,");
		sqlViewpointCircleTemp.append("zanCount integer,");
		sqlViewpointCircleTemp.append("voice varchar(1024),");
		
		sqlViewpointCircleTemp.append("url varchar(1024),");
		sqlViewpointCircleTemp.append("title varchar(1024),");
		sqlViewpointCircleTemp.append("brief varchar(1024),");
		sqlViewpointCircleTemp.append("image varchar(1024),");
		sqlViewpointCircleTemp.append("isZan BOOLEAN default 0,");
		sqlViewpointCircleTemp.append("imageWidth integer default 0,");
		sqlViewpointCircleTemp.append("imageHeight integer default 0,");
		sqlViewpointCircleTemp.append("video varchar(1024),");
		sqlViewpointCircleTemp.append("videoWidth integer default 0,");
		sqlViewpointCircleTemp.append("videoHeight integer default 0,");
		
		sqlViewpointCircleTemp.append("primary key (phone_num,sid)");
		sqlViewpointCircleTemp.append(" );");
		
		//创建话题表
		String sqlViewpointCircle = sqlViewpointCircleTemp.toString();
		sqlViewpointCircleTemp = null;
		db.execSQL(sqlViewpointCircle);
	}
	
	private void creatCircleReview(SQLiteDatabase db){
		
		StringBuilder sqlCircleReviewTemp = new StringBuilder();
		sqlCircleReviewTemp.append("CREATE TABLE If NOT EXISTS ");
		sqlCircleReviewTemp.append(ViewpointDBHelper.CIRCLE_REVIEW_TABLE);
		sqlCircleReviewTemp.append(" (");
		sqlCircleReviewTemp.append("_id text,");
		sqlCircleReviewTemp.append("circleUser varchar(1024),");
		sqlCircleReviewTemp.append("circleTime varchar(1024),");
		sqlCircleReviewTemp.append("type integer default 0,");
		sqlCircleReviewTemp.append("friendName varchar(1024),");
		sqlCircleReviewTemp.append("nickName varchar(1024),");
		sqlCircleReviewTemp.append("content varchar(1024),");
		sqlCircleReviewTemp.append("location varchar(1024),");
		sqlCircleReviewTemp.append("time varchar(1024),");
		sqlCircleReviewTemp.append("avatar varchar(1024),");
		sqlCircleReviewTemp.append("commentTo varchar(1024)");
		
		sqlCircleReviewTemp.append(" );");
		
		//创建话题评论赞表
		String sqlCircleReview = sqlCircleReviewTemp.toString();
		sqlCircleReviewTemp = null;
		db.execSQL(sqlCircleReview);
		
	}

	
	/**
	 * Upgrade tables. In this method, the sequence is:
	 * <b>
	 * <p>[1] Rename the specified table as a temporary table.
	 * <p>[2] Create a new table which name is the specified name.
	 * <p>[3] Insert data into the new created table, data from the temporary table.
	 * <p>[4] Drop the temporary table.
	 * </b>
	 *
	 * @param db The database.
	 * @param tableName The table name.
	 * @param columns The columns range, format is "ColA, ColB, ColC, ... ColN";
	 */
	protected void upgradeTables(SQLiteDatabase db, String tableName, String columns)
	{
	    try
	    {
	        db.beginTransaction();
	        // 1, Rename table.
	        String tempTableName = tableName + "_temp";
	        String sql = "ALTER TABLE " + tableName +" RENAME TO " + tempTableName;
	        db.execSQL(sql);
	        // 2, Create table.
	        creatTable(db,tableName);
	        // 3, Load data
	        sql =   "INSERT INTO " + tableName +  
	                " (" + columns + ") " +  
	                " SELECT " + columns + " FROM " + tempTableName;  
	  
	        db.execSQL( sql);
	        
	        // 4, Drop the temporary table.
	        db.execSQL( "DROP TABLE IF EXISTS " + tempTableName);

	        db.setTransactionSuccessful();
	        Log.i("testTag", "数据表更新成功  表名 ： " + tableName);
	    }
	    catch (SQLException e)
	    {
	    	Log.i("testTag", "数据表更新失败  " );
	        e.printStackTrace();
	    }
	    catch (Exception e)
	    {
	        e.printStackTrace();
	        Log.i("testTag", "数据表更新失败 " );
	    }
	    finally
	    {
	        db.endTransaction();
	    }
	}
	
	private void creatTable(SQLiteDatabase db,String tableName){
		
		if(ViewpointDBHelper.FRIEND_USER_CIRCLE_TABLE_NAME.equals(tableName)){
			StringBuilder sqlUserCircleTemp = new StringBuilder();
			sqlUserCircleTemp.append("CREATE TABLE If NOT EXISTS ");
			sqlUserCircleTemp.append(ViewpointDBHelper.FRIEND_USER_CIRCLE_TABLE_NAME);
			sqlUserCircleTemp.append(" (");
			sqlUserCircleTemp.append("phone_num varchar(1024) not null primary key,");
			sqlUserCircleTemp.append("lickname varchar(1024),");
			sqlUserCircleTemp.append("icon varchar(1024),");
			sqlUserCircleTemp.append("gender text");
			sqlUserCircleTemp.append(" );");
			
			//创建上传列表表
			String sqlUserCircle = sqlUserCircleTemp.toString();
			sqlUserCircleTemp = null;
			db.execSQL(sqlUserCircle);
		}
		
	}
	
}
