package com.zhicheng.collegeorange.database;


import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

import org.apache.http.HttpResponse;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.provider.MediaStore;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;

import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.model.Circle;
import com.zhicheng.collegeorange.model.Photo;
import com.zhicheng.collegeorange.model.Review;
import com.zhicheng.collegeorange.model.Share;


/**
 * 数据库相关 主要是 增删改查的功能。
 */
public class ViewpointDBHelper extends AMDbHelp{

	Context context;
	
	public ViewpointDBHelper(Context context) {
		super(context);
		this.context = context;
		initData(context);
	}

	public final static String TAG = ViewpointDBHelper.class.getSimpleName();

	public static ViewpointDBHelper instance;// 单例模式 实例

	//private static SQLiteDatabase mDatabase;

	//private static AMDbHelp mDbHelper;

	public final static String VIEWPOINT_ACTION_DB_INSERT = "viewpoint_action_db_insert";

	public final static String VIEWPOINT_CIRCLE_MESSAGE_ACTION_DB_INSERT = "viewpoint_circle_message_action_db_insert";

	public final static String VIEWPOINT_TABLE_NAME = "viewpoint_table_name";// 观点表名称

	public final static String SHARE_TABLE_NAME = "share_table_name";// 分享表名称

	public final static String FRIEND_CIRCLE_TABLE_NAME = "friend_circle";// 朋友圈表名称
	
	public final static String CIRCLE_REVIEW_TABLE = "circle_review";//话题评论和赞

	public final static String FRIEND_USER_CIRCLE_TABLE_NAME = "friend_user_circle";// 朋友圈用户资料表名称

	public final static String FRIEND_CIRCLE_MESSAGE_TABLE_NAME = "friend_circle_message";// 朋友圈消息表名

	// 朋友圈消息表名
	private static String MESSAGE_TABLES[] = new String[] { "_id", "sid", "msgType", "fromUser", "author", "nickName", "avatar", "mark", "isNew", "time",
			"context", "image" };

	// 观点表  官方话题
	private static String VIEWPOINT_TABLES[] = new String[] { "_id", "author", "page_url", "brief", "create_time", "pic_url", "title", "vid", "zan_count",
			"rowse_count", "comment_count" };

	// 分享表
	private static String SHARE_TABLES[] = new String[] { "_id", "phone", "vid", "content", "create_time", "pic_url", "position" ,"voice","url","title","brief","image" };

	// 朋友圈观点表
	private static String FRIEND_CIRCLE_TABLES[] = new String[] { "_id", "sid", "phone_num", "content", "create_time", "pic_url", "position","commentCount","zanCount",
																	"voice","url","title","brief","image", "isZan" , "imageWidth", "imageHeight",
																	"video", "videoWidth", "videoHeight" };
	// 话题评论 赞
	private static String CIRCLE_REVIEW_TABLES[] = new String[] { "_id", "circleUser", "circleTime", "type", "friendName",
																	"nickName", "content", "location", "time", "avatar" , "commentTo" };
	
	
	// 朋友圈观点用户表
	// private static String FRIEND_USER_CIRCLE_TABLES[] = new String[] { "_id",
	// "sid", "phone_num", "lickname", "icon"};
	private static String FRIEND_USER_CIRCLE_TABLES[] = new String[] { "phone_num", "lickname", "icon", "gender"};

	// 系统图片数据库表
	private final static String[] MEDIA_IMAGE_PROJECTION = new String[] { MediaStore.Images.Media._ID, MediaStore.Images.Media.DATA,
			MediaStore.Images.Media.BUCKET_DISPLAY_NAME, MediaStore.Images.Media.DATE_TAKEN };

	// 系统图片文件夹表
	private final static String[] BUCKET_DISPLAY_NAME = new String[] { MediaStore.Images.Media._ID, MediaStore.Images.Media.BUCKET_DISPLAY_NAME };

	public static ViewpointDBHelper GetInstance(Context context) {
		if (instance == null) {
			instance = new ViewpointDBHelper(context);
		}
		return instance;
	}	
	
	
	

	public synchronized void updateCommentCount(Context context, String id, String phoneNum, int length1,int length2) {
		long index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String whereClause = FRIEND_CIRCLE_TABLES[1] + "=? and " + FRIEND_CIRCLE_TABLES[2] + "=?";
			String[] whereArgs = { id, phoneNum };
			int commentCount = 0;
			int zanCount = 0;
			Cursor cursor = mDatabase.query(FRIEND_CIRCLE_TABLE_NAME, new String[] { FRIEND_CIRCLE_TABLES[7],FRIEND_CIRCLE_TABLES[8] }, whereClause, whereArgs, null, null, null);
			if (cursor != null) {
				cursor.moveToFirst();
				commentCount = cursor.getInt(0);
				zanCount = cursor.getInt(1);
				cursor.close();
			}
			if (commentCount != length1 || zanCount != length2) {
				ContentValues values = new ContentValues();
				values.put(FRIEND_CIRCLE_TABLES[7], length1);
				values.put(FRIEND_CIRCLE_TABLES[8], length2);
				index = mDatabase.update(FRIEND_CIRCLE_TABLE_NAME, values, whereClause, whereArgs);
			}
		} catch (Exception e) {
			Log.v(TAG, "insert viewPoint info fail");
		} finally {
			this.close();
		}
		if (index > 0) {
			sendBroadcast(context,false,phoneNum);
		}
	}
	
	public synchronized void updateZanState(Context context, String id, String phoneNum, boolean zanState) {
		long index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String whereClause = FRIEND_CIRCLE_TABLES[1] + "=? and " + FRIEND_CIRCLE_TABLES[2] + "=?";
			String[] whereArgs = { id, phoneNum };
			boolean hasZan = false; 
		
			Cursor cursor = mDatabase.query(FRIEND_CIRCLE_TABLE_NAME, new String[] { FRIEND_CIRCLE_TABLES[14] }, whereClause, whereArgs, null, null, null);
			if (cursor != null) {
				cursor.moveToFirst();
				int hasZanIndex = cursor.getColumnIndex(FRIEND_CIRCLE_TABLES[14]);
				hasZan =  cursor.getInt(hasZanIndex) != 0 ? true : false;				
				cursor.close();
			}
			if (zanState != hasZan) {
				ContentValues values = new ContentValues();
				values.put(FRIEND_CIRCLE_TABLES[14], zanState);
				index = mDatabase.update(FRIEND_CIRCLE_TABLE_NAME, values, whereClause, whereArgs);
			}
		} catch (Exception e) {
			Log.v(TAG, "update zan state viewPoint info fail");
		} finally {
			this.close();
		}
	}
	
	private void sendBroadcast(Context context,boolean value,String userName) {
		sendBroadcast(context, value, userName,false);
	}
	
	private void sendBroadcast(Context context,boolean value,String userName, boolean is2Top) {
		Intent intent = new Intent(VIEWPOINT_ACTION_DB_INSERT);
		intent.putExtra("isGetRemote", value);
		intent.putExtra("userName", userName);
		intent.putExtra("is2ListTop", is2Top);
		LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
	}	

	public synchronized Circle getCircle(Context context, String id, String phoneNum) {
		Circle circle = null;
		Cursor cursor = null;
		try {
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = "a.phone_num =" + phoneNum + " and b.phone_num=" + phoneNum + " and a.sid = " + id;
			String sql = "select a.sid, a.phone_num, a.content, a.create_time,a.pic_url,a.position,a.voice,a.video,b.lickname,b.icon,a.url,a.title,a.brief,a.image,a.imageWidth,a.imageHeight,a.videoWidth,a.videoHeight "
					+ "from friend_circle as a, friend_user_circle as b where " + where;
			cursor = mDatabase.rawQuery(sql, null);
			cursor.moveToFirst();
			int sidIndex = cursor.getColumnIndex("sid");
			int phone_numIndex = cursor.getColumnIndex("phone_num");
			int contentIndex = cursor.getColumnIndex("content");
			int create_timeIndex = cursor.getColumnIndex("create_time");
			int pic_urlIndex = cursor.getColumnIndex("pic_url");
			int positionIndex = cursor.getColumnIndex("position");
			int voiceIndex = cursor.getColumnIndex("voice");
			int videoIndex = cursor.getColumnIndex("video");
			int licknameIndex = cursor.getColumnIndex("lickname");
			int iconIndex = cursor.getColumnIndex("icon");
//			/"url","title","brief","image"
			int urlIndex = cursor.getColumnIndex("url");
			int titleIndex = cursor.getColumnIndex("title");
			int briefIndex = cursor.getColumnIndex("brief");
			int imageIndex = cursor.getColumnIndex("image");
			int imageWidhtIndex = cursor.getColumnIndex("imageWidth");
			int imageHeightIndex = cursor.getColumnIndex("imageHeight");
			int videoWidhtIndex = cursor.getColumnIndex("videoWidth");
			int videoHeightIndex = cursor.getColumnIndex("videoHeight");
			
			circle = new Circle();
			circle.setmId(cursor.getString(sidIndex));
			circle.setmPhoneNum(cursor.getString(phone_numIndex));
			circle.setmContent(cursor.getString(contentIndex));
			circle.setmTime(cursor.getString(create_timeIndex));
			
			circle.setmUrl(cursor.getString(urlIndex));
			circle.setmTitle(cursor.getString(titleIndex));
			circle.setmBrief(cursor.getString(briefIndex));
			circle.setmImage(cursor.getString(imageIndex));
			
			String[] path = cursor.getString(pic_urlIndex).split(";");
			ArrayList<String> strings = new ArrayList<String>();
			for (String string : path) {
				if (!TextUtils.isEmpty(string)) {
					strings.add(string);
				}
			}
			circle.setmPicPaths(strings);
			circle.setmPosition(cursor.getString(positionIndex));
			circle.setmVoice(cursor.getString(voiceIndex));
			circle.setmVideo(cursor.getString(videoIndex));
			circle.setmLickName(cursor.getString(licknameIndex));
			circle.setmIcon(cursor.getString(iconIndex));
			circle.setImageWidth(cursor.getInt(imageWidhtIndex));
			circle.setImageHeight(cursor.getInt(imageHeightIndex));
			
			circle.setVideoWidth(cursor.getInt(videoWidhtIndex));
			circle.setVideoHeight(cursor.getInt(videoHeightIndex));
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}

		return circle;
	}

	private void sendCircleMessage(Context context) {
		Intent intent = new Intent(VIEWPOINT_CIRCLE_MESSAGE_ACTION_DB_INSERT);
		LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
	}

	public synchronized boolean deleteCircleMessage(Context context, int _id) {
		int index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			index = mDatabase.delete(FRIEND_CIRCLE_MESSAGE_TABLE_NAME, MESSAGE_TABLES[0] + " = " + _id, null);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return index > 0;
	}

	public synchronized boolean deleteCircleMessageAll(Context context) {
		int index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			index = mDatabase.delete(FRIEND_CIRCLE_MESSAGE_TABLE_NAME, null, null);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return index > 0;
	}
	
	public synchronized boolean deleteCircleMessages(Context context,String username,String circleId) {
		int index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String zselection = MESSAGE_TABLES[1] + "=? and " + MESSAGE_TABLES[4]+ "=?"  ;
			
			String[] zselectionArgs = new String[] { circleId , username };
			index = mDatabase.delete(FRIEND_CIRCLE_MESSAGE_TABLE_NAME, zselection, zselectionArgs);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return index > 0;
	}
	
	
	public synchronized boolean setReadCircleMessage(Context context) {
		int index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			ContentValues cv = new ContentValues();
			cv.put(MESSAGE_TABLES[8], 0);
			index = mDatabase.update(FRIEND_CIRCLE_MESSAGE_TABLE_NAME, cv, MESSAGE_TABLES[8] + " = 1", null);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return true;
	}

	public synchronized boolean insertUserCircleInfo(Context context, Circle circle) {
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			ContentValues cv = new ContentValues();
			cv.put(FRIEND_USER_CIRCLE_TABLES[0], circle.getmPhoneNum());
			cv.put(FRIEND_USER_CIRCLE_TABLES[1], circle.getmLickName());
			cv.put(FRIEND_USER_CIRCLE_TABLES[2], circle.getmIcon());
			cv.put(FRIEND_USER_CIRCLE_TABLES[3], circle.getmGender());
			// mDatabase.insert(FRIEND_USER_CIRCLE_TABLE_NAME, null, cv);
			mDatabase.replace(FRIEND_USER_CIRCLE_TABLE_NAME, null, cv);
		} catch (Exception e) {
			Log.v(TAG, "insert viewPoint info fail");
			return false;
		} finally {
			this.close();
		}
		Log.v(TAG, "insert viewPoint info success");
		return true;
	}

	public synchronized Circle getUserCircleInfo(Context context, String phoneNum) {
		Cursor cursor = null;
		try {
			String[] whereValue = { phoneNum };
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String where = FRIEND_USER_CIRCLE_TABLES[0] + "=?";
			cursor = mDatabase.query(FRIEND_USER_CIRCLE_TABLE_NAME, null, where, whereValue, null, null, null);

			int num = cursor.getCount();
			Log.d(TAG, "mDatabase num:" + num);
			cursor.moveToFirst();

			if (num > 0) {
				Circle circle = new Circle();
				// circle.setmId(Integer.parseInt(cursor.getString(1)));
				circle.setmPhoneNum(cursor.getString(0));
				circle.setmLickName(cursor.getString(1));
				circle.setmIcon(cursor.getString(2));
				circle.setmGender(cursor.getString(3));
				return circle;
			} else {
				return null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
	}

	public synchronized boolean queryUserCircleById(Context context, String phoneNum) {
		Cursor cursor = null;
		try {
			String[] whereValue = { phoneNum };
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = FRIEND_USER_CIRCLE_TABLES[0] + "=?";
			cursor = mDatabase.query(FRIEND_USER_CIRCLE_TABLE_NAME, null, where, whereValue, null, null, null);

			int num = cursor.getCount();
			cursor.moveToFirst();

			if (num > 0) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
	}
	
	/**
	 * 删除临时数据后插入新数据
	 * @param context
	 * @param phoneNum
	 * @param id
	 * @param circle
	 * @param flg
	 * @return
	 */
	public synchronized boolean insertSendSuccessCircle(Context context, String phoneNum, String id,Circle circle ,boolean flg){
		deleteCircleForPhoneID(context,phoneNum,id);
		return insertCircleInfo(context, circle, flg, true, true);
	}

	public synchronized boolean insertCircleInfo(Context context, Circle circle) {
		return insertCircleInfo(context, circle, false);
	}

	public synchronized boolean insertCircleInfo(Context context, Circle circle, boolean flg){
		return insertCircleInfo( context,  circle,  flg, true);
	}
	
	public synchronized boolean insertCircleInfo(Context context, Circle circle, boolean flg,boolean isGetRemote){
		return insertCircleInfo( context,  circle,  flg, isGetRemote, false);
	}
	
	
	/**
	 *  插入一条朋友圈信息
	 * @param context
	 * @param circle
	 * @param flg  是否发送广播
	 * @param isGetRemote 是否拉取新数据
	 * @param is2Top 是否需要跳转到列表顶端
	 * @return
	 */
	public synchronized boolean insertCircleInfo(Context context, Circle circle, boolean flg,boolean isGetRemote,boolean is2Top) {
		StringBuffer stringBuffer = new StringBuffer();
		if (circle.getmPicPaths() != null && circle.getmPicPaths().size() > 0) {
			for (int i = 0; i < circle.getmPicPaths().size(); i++) {
				if (i != circle.getmPicPaths().size() - 1) {
					stringBuffer.append(circle.getmPicPaths().get(i) + ";");
				} else {
					stringBuffer.append(circle.getmPicPaths().get(i));
				}
			}
		}
		long index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			ContentValues cv = new ContentValues();
			cv.put(FRIEND_CIRCLE_TABLES[1], circle.getmId());
			cv.put(FRIEND_CIRCLE_TABLES[2], circle.getmPhoneNum());
			cv.put(FRIEND_CIRCLE_TABLES[3],circle.getmContent());
			cv.put(FRIEND_CIRCLE_TABLES[4], circle.getmTime());
			cv.put(FRIEND_CIRCLE_TABLES[5], stringBuffer.toString());
			cv.put(FRIEND_CIRCLE_TABLES[6], circle.getmPosition());
			cv.put(FRIEND_CIRCLE_TABLES[7], circle.getCommentCount());
			cv.put(FRIEND_CIRCLE_TABLES[8], circle.getZanCount());
			cv.put(FRIEND_CIRCLE_TABLES[9], circle.getmVoice());
			cv.put(FRIEND_CIRCLE_TABLES[10], circle.getmUrl());
			cv.put(FRIEND_CIRCLE_TABLES[11], circle.getmTitle());
			cv.put(FRIEND_CIRCLE_TABLES[12], circle.getmBrief());
			cv.put(FRIEND_CIRCLE_TABLES[13], circle.getmImage());
			
			cv.put(FRIEND_CIRCLE_TABLES[14], circle.hasZan);
			cv.put(FRIEND_CIRCLE_TABLES[15], circle.getImageWidth());
			cv.put(FRIEND_CIRCLE_TABLES[16], circle.getImageHeight());
			cv.put(FRIEND_CIRCLE_TABLES[17], circle.getmVideo());
			cv.put(FRIEND_CIRCLE_TABLES[18], circle.getVideoWidth());
			cv.put(FRIEND_CIRCLE_TABLES[19], circle.getVideoHeight());
			
			index = mDatabase.insert(FRIEND_CIRCLE_TABLE_NAME, null, cv);
		} catch (Exception e) {
			e.printStackTrace();
			Log.v(TAG, "insert viewPoint info fail");
			return false;
		} finally {
			this.close();
		}
		if (index > 0) {
			Log.v(TAG, "insert viewPoint info success");
			if (flg) {				
				sendBroadcast(context,isGetRemote,circle.getmPhoneNum(),is2Top);
			}
		} else {
			Log.e(TAG, "insert viewPoint info fail");
		}
		return index > 0;
	}
	
	public synchronized ArrayList<Circle> queryFailedCircles(Context context) {
		ArrayList<Circle> arrayList = new ArrayList<Circle>();
		Cursor cursor = null;
		try {
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = "length(a.sid)=20";
			String sql = "select a.sid, a.phone_num, a.content, a.create_time,a.pic_url,a.position,a.voice,a.video,a.url,a.title,a.brief,a.image,a.isZan,a.imageWidth,a.imageHeight,a.videoWidth,a.videoHeight "
					+ "from friend_circle as a where " + where;
			cursor = mDatabase.rawQuery(sql, null);
			cursor.moveToFirst();
			while (!cursor.isAfterLast()) {
				int sidIndex = cursor.getColumnIndex("sid");
				int phone_numIndex = cursor.getColumnIndex("phone_num");
				int contentIndex = cursor.getColumnIndex("content");
				int create_timeIndex = cursor.getColumnIndex("create_time");
				int pic_urlIndex = cursor.getColumnIndex("pic_url");
				int positionIndex = cursor.getColumnIndex("position");
				int voiceIndex = cursor.getColumnIndex("voice");
				int videoIndex = cursor.getColumnIndex("video");
				int urlIndex = cursor.getColumnIndex("url");
				int titleIndex = cursor.getColumnIndex("title");
				int briefIndex = cursor.getColumnIndex("brief");
				int imageIndex = cursor.getColumnIndex("image");
				
				int hasZanIndex = cursor.getColumnIndex("isZan");
				int imageWidhtIndex = cursor.getColumnIndex("imageWidth");
				int imageHeightIndex = cursor.getColumnIndex("imageHeight");
				
				int videoWidhtIndex = cursor.getColumnIndex("videoWidth");
				int videoHeightIndex = cursor.getColumnIndex("videoHeight");
				
				Circle circle = new Circle();
				circle.setmId(cursor.getString(sidIndex));
				circle.setmPhoneNum(cursor.getString(phone_numIndex));
				circle.setmContent(cursor.getString(contentIndex));
				circle.setmTime(cursor.getString(create_timeIndex));
				circle.setmUrl(cursor.getString(urlIndex));
				circle.setmTitle(cursor.getString(titleIndex));
				circle.setmBrief(cursor.getString(briefIndex));
				circle.setmImage(cursor.getString(imageIndex));
				
				String[] path = cursor.getString(pic_urlIndex).split(";");
				ArrayList<String> strings = new ArrayList<String>();
				for (String string : path) {
					if (!TextUtils.isEmpty(string)) {
						strings.add(string);
					}
				}
				circle.setmPicPaths(strings);
				circle.setmPosition(cursor.getString(positionIndex));
				circle.setmVoice(cursor.getString(voiceIndex));
				circle.hasZan = cursor.getInt(hasZanIndex) != 0 ? true : false;
				circle.setImageWidth(cursor.getInt(imageWidhtIndex));
				circle.setImageHeight(cursor.getInt(imageHeightIndex));
				
				circle.setmVideo(cursor.getString(videoIndex));
				circle.setVideoWidth(cursor.getInt(videoWidhtIndex));
				circle.setVideoHeight(cursor.getInt(videoHeightIndex));
				
				arrayList.add(circle);
				cursor.moveToNext();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
		return arrayList;
	}
	
	public boolean insertCircleInfo(Context context, ArrayList<Circle> circles){
		return insertCircleInfo(context, circles,false);
	}

	public synchronized boolean insertCircleInfo(Context context, ArrayList<Circle> circles,boolean flg) {
		long index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			mDatabase.beginTransaction();
			for (int i = 0; i < circles.size(); i++) {
				Circle circle = circles.get(i);
				StringBuffer stringBuffer = new StringBuffer();
				if (circle.getmPicPaths() != null && circle.getmPicPaths().size() > 0) {
					for (int j = 0; j < circle.getmPicPaths().size(); j++) {
						if (j != circle.getmPicPaths().size() - 1) {
							stringBuffer.append(circle.getmPicPaths().get(j) + ";");
						} else {
							stringBuffer.append(circle.getmPicPaths().get(j));
						}
					}
				}
				ContentValues cv = new ContentValues();
				cv.put(FRIEND_CIRCLE_TABLES[1], circle.getmId());
				cv.put(FRIEND_CIRCLE_TABLES[2], circle.getmPhoneNum());
				cv.put(FRIEND_CIRCLE_TABLES[3], circle.getmContent());
				cv.put(FRIEND_CIRCLE_TABLES[4], circle.getmTime());
				cv.put(FRIEND_CIRCLE_TABLES[5], stringBuffer.toString());
				cv.put(FRIEND_CIRCLE_TABLES[6], circle.getmPosition());
				cv.put(FRIEND_CIRCLE_TABLES[7], circle.getCommentCount());
				cv.put(FRIEND_CIRCLE_TABLES[8], circle.getZanCount());
				cv.put(FRIEND_CIRCLE_TABLES[9], circle.getmVoice());
				//"url","title","brief","image"
				cv.put(FRIEND_CIRCLE_TABLES[10], circle.getmUrl());
				cv.put(FRIEND_CIRCLE_TABLES[11], circle.getmTitle());
				cv.put(FRIEND_CIRCLE_TABLES[12], circle.getmBrief());
				cv.put(FRIEND_CIRCLE_TABLES[13], circle.getmImage());
				cv.put(FRIEND_CIRCLE_TABLES[14], circle.hasZan);
				cv.put(FRIEND_CIRCLE_TABLES[15], circle.getImageWidth());
				cv.put(FRIEND_CIRCLE_TABLES[16], circle.getImageHeight());
				cv.put(FRIEND_CIRCLE_TABLES[17], circle.getmVideo());
				cv.put(FRIEND_CIRCLE_TABLES[18], circle.getVideoWidth());
				cv.put(FRIEND_CIRCLE_TABLES[19], circle.getVideoHeight());
				index = mDatabase.insert(FRIEND_CIRCLE_TABLE_NAME, null, cv);
				
				if (circle.getmLickName()!=null && circle.getmIcon()!=null) {
					cv = new ContentValues();
					cv.put(FRIEND_USER_CIRCLE_TABLES[0], circle.getmPhoneNum());
					cv.put(FRIEND_USER_CIRCLE_TABLES[1], circle.getmLickName());
					cv.put(FRIEND_USER_CIRCLE_TABLES[2], circle.getmIcon());
					cv.put(FRIEND_USER_CIRCLE_TABLES[3], circle.getmGender());
					mDatabase.replace(FRIEND_USER_CIRCLE_TABLE_NAME, null, cv);
				}
				
				if(circle.getZanList() != null && circle.getZanList().size() > 0){
					if(addCircleReviews(mDatabase, circle.getZanList())){
						Log.i("testTag", "点赞数据添加成功");
					}else{
						Log.e("testTag", "点赞数据添加失败");
					}
				}
				
				if(circle.getCommentList() != null && circle.getCommentList().size() > 0){
					if( addCircleReviews( mDatabase, circle.getCommentList() ) ){
						Log.i("testTag", "评论数据添加成功");
					}else{
						Log.e("testTag", "评论数据添加失败");
					}
				}
			}
			mDatabase.setTransactionSuccessful();
			mDatabase.endTransaction();
		} catch (Exception e) {
			Log.v(TAG, "insert insertCircleInfo info fail");
			return false;
		} finally {
			this.close();
		}
		if (index > 0) {
			Log.v(TAG, "insert insertCircleInfo info success");
			if (flg) {
				sendBroadcast(context,true,"");
			}
		} else {
			Log.e(TAG, "insert insertCircleInfo info fail");
		}
		return index > 0;
	}
	
	public synchronized boolean deleteCircleForPhoneID(Context context, String phoneNum, String id) {
		long index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String where = FRIEND_CIRCLE_TABLES[1] + "=? and " + FRIEND_CIRCLE_TABLES[2] + "=?";
			String[] whereValue = { id, phoneNum };
			index = mDatabase.delete(FRIEND_CIRCLE_TABLE_NAME, where, whereValue);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			this.close();
		}
		return index > 0;
	}

	/**
	 * 查询朋友圈列表
	 * 
	 * @param context
	 * @see [类、类#方法、类#成员]
	 */
	public synchronized ArrayList<Circle> getAllCircle(Context context) {
		ArrayList<Circle> arrayList = new ArrayList<Circle>();
		Cursor cursor = null;
		try {
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			cursor = mDatabase.query(FRIEND_CIRCLE_TABLE_NAME, null, null, null, null, null, null);
			int num = cursor.getCount();
			cursor.moveToFirst();

			if (num > 0) {
				for (int i = 0; i < num; i++) {
					Circle mCircle = new Circle();
					mCircle.setmPhoneNum(cursor.getString(2));
					mCircle.setmId(cursor.getString(1));
					if (cursor.getString(3) != null && !cursor.getString(3).equals("")) {
						mCircle.setmContent(cursor.getString(3));
					}

					mCircle.setmTime(cursor.getString(4));
					if (cursor.getString(5) != null && !cursor.getString(5).equals("")) {
						String[] path = cursor.getString(5).split(";");
						ArrayList<String> strings = new ArrayList<String>();
						for (String string : path) {
							if (!TextUtils.isEmpty(string)) {
								strings.add(string);
							}
						}
						mCircle.setmPicPaths(strings);
					}
					if (cursor.getString(6) != null && !cursor.getString(6).equals("")) {
						mCircle.setmPosition(cursor.getString(6));
					}
					arrayList.add(mCircle);
					cursor.moveToNext();
				}
			}
		} catch (Exception e) {
			return null;
		} finally {
			if (cursor != null) {
				cursor.close();
			}
			this.close();
		}
		return arrayList;
	}

	public synchronized ArrayList<Circle> getCirclesByPage1(Context context, String page) {
		ArrayList<Circle> arrayList = new ArrayList<Circle>();
		Cursor cursor = null;
		try {
			String[] whereValue = { page };
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = FRIEND_CIRCLE_TABLES[7] + "=?";
			cursor = mDatabase.query(FRIEND_CIRCLE_TABLE_NAME, null, where, whereValue, null, null, null);

			int num = cursor.getCount();
			cursor.moveToFirst();

			if (num > 0) {
				for (int i = 0; i < num; i++) {
					Circle mCircle = new Circle();
					mCircle.setmPhoneNum(cursor.getString(2));
					mCircle.setmId(cursor.getString(1));
					if (cursor.getString(3) != null && !cursor.getString(3).equals("")) {
						mCircle.setmContent(cursor.getString(3));
					}

					mCircle.setmTime(cursor.getString(4));
					if (cursor.getString(5) != null && !cursor.getString(5).equals("")) {
						String[] path = cursor.getString(5).split(";");
						ArrayList<String> strings = new ArrayList<String>();
						for (String string : path) {
							if (!TextUtils.isEmpty(string)) {
								strings.add(string);
							}
						}
						mCircle.setmPicPaths(strings);
					}
					if (cursor.getString(6) != null && !cursor.getString(6).equals("")) {
						mCircle.setmPosition(cursor.getString(6));
					}
					arrayList.add(mCircle);
					cursor.moveToNext();
				}
			} else {
				return null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
		return arrayList;
	}

	public synchronized ArrayList<Circle> getCirclesByPage2(Context context, String limit) {
		ArrayList<Circle> arrayList = new ArrayList<Circle>();
		Cursor cursor = null;
		try {
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String orderBy = " create_time desc";
			String where = "a.phone_num = b.phone_num ";
			String sql = "select a.sid, a.phone_num, a.content, a.create_time,a.pic_url,a.position,a.commentCount,a.zanCount,a.voice,a.video,a.isZan,a.imageWidth,a.imageHeight,a.videoWidth,a.videoHeight,b.lickname,b.icon,b.gender,a.url,a.title,a.brief,a.image "
					+ "from friend_circle as a, friend_user_circle as b where " + where + " order by " + orderBy + " limit " + limit;
			cursor = mDatabase.rawQuery(sql, null);
			cursor.moveToFirst();
			while (!cursor.isAfterLast()) {
				int sidIndex = cursor.getColumnIndex("sid");
				int phone_numIndex = cursor.getColumnIndex("phone_num");
				int contentIndex = cursor.getColumnIndex("content");
				int create_timeIndex = cursor.getColumnIndex("create_time");
				int pic_urlIndex = cursor.getColumnIndex("pic_url");
				int positionIndex = cursor.getColumnIndex("position");
				int voiceIndex = cursor.getColumnIndex("voice");
				
				int licknameIndex = cursor.getColumnIndex("lickname");
				int iconIndex = cursor.getColumnIndex("icon");
				int genderIndex = cursor.getColumnIndex("gender");
				int commentCountIndex = cursor.getColumnIndex("commentCount");
				int zanCountIndex = cursor.getColumnIndex("zanCount");
				int urlIndex = cursor.getColumnIndex("url");
				int titleIndex = cursor.getColumnIndex("title");
				int briefIndex = cursor.getColumnIndex("brief");
				int imageIndex = cursor.getColumnIndex("image");
				int hasZanIndex = cursor.getColumnIndex("isZan");
				int imageWidhtIndex = cursor.getColumnIndex("imageWidth");
				int imageHeightIndex = cursor.getColumnIndex("imageHeight");
				
				int videoIndex = cursor.getColumnIndex("video");
				int videoWidhtIndex = cursor.getColumnIndex("videoWidth");
				int videoHeightIndex = cursor.getColumnIndex("videoHeight");
				
				Circle circle = new Circle();
				
				String phoneNum = cursor.getString(phone_numIndex);
				String nickName = cursor.getString(licknameIndex);
				String gender = cursor.getString(genderIndex);
				circle.setmId(cursor.getString(sidIndex));
				circle.setmPhoneNum(phoneNum);
				circle.setmGender(gender);
				circle.setmLickName(nickName);
					
				circle.setmContent(cursor.getString(contentIndex));
				circle.setmTime(cursor.getString(create_timeIndex));
				circle.setmUrl(cursor.getString(urlIndex));
				circle.setmTitle(cursor.getString(titleIndex));
				circle.setmBrief(cursor.getString(briefIndex));
				circle.setmImage(cursor.getString(imageIndex));
				circle.hasZan = cursor.getInt(hasZanIndex) != 0 ? true : false;
				circle.setImageWidth(cursor.getInt(imageWidhtIndex));
				circle.setImageHeight(cursor.getInt(imageHeightIndex));
				
				circle.setmVideo(cursor.getString(videoIndex));
				circle.setVideoWidth(cursor.getInt(videoWidhtIndex));
				circle.setVideoHeight(cursor.getInt(videoHeightIndex));
				
				String[] path = cursor.getString(pic_urlIndex).split(";");
				ArrayList<String> strings = new ArrayList<String>();
				for (String string : path) {
					if (!TextUtils.isEmpty(string)) {
						strings.add(string);
					}
				}
				circle.setmPicPaths(strings);
				circle.setmPosition(cursor.getString(positionIndex));
				circle.setmVoice(cursor.getString(voiceIndex));				
				circle.setmIcon(cursor.getString(iconIndex));
				circle.setZanCount(cursor.getInt(zanCountIndex));
				circle.setCommentCount(cursor.getInt(commentCountIndex));				
				arrayList.add(circle);
				cursor.moveToNext();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
		ArrayList<Circle> failedCircles = queryFailedCircles(context);
		if(failedCircles!=null&&failedCircles.size()>0){
			while(arrayList!=null&&arrayList.size()>0){
				Circle cir = arrayList.get(arrayList.size()-1);
				if(failedCircles.contains(cir)){
					arrayList.remove(cir);
				}else {
					break;
				}
			}
		}
		return arrayList;
	}
	
	public void loadCirclesReview(Context context ,List<Circle> circles){
		for(Circle circle : circles){
			List<Review> zanDatas = getReviewsByType(context, circle.getmPhoneNum(), circle.getmTime(), Review.TYPE_ZAN);
			circle.setZanList(zanDatas);
			List<Review> comments = getReviewsByType(context, circle.getmPhoneNum(), circle.getmTime(), Review.TYPE_COMMENT);
			circle.setCommentList(comments);
		}		
	}
		
	
	public synchronized ArrayList<Circle> getMyCircles(Context context,String myName) {
		ArrayList<Circle> arrayList = new ArrayList<Circle>();
		Cursor cursor = null;
		try {
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String orderBy = " create_time desc";
			String where = "a.phone_num = b.phone_num and a.phone_num = " + myName;
			String sql = "select a.sid, a.phone_num, a.content, a.create_time,a.pic_url,a.position,a.commentCount,a.zanCount,a.voice,a.video,a.isZan,a.imageWidth,a.imageHeight,a.videoWidth,a.videoHeight,b.lickname,b.icon,b.gender,a.url,a.title,a.brief,a.image "
					+ "from friend_circle as a, friend_user_circle as b where " + where + " order by " + orderBy;
			cursor = mDatabase.rawQuery(sql, null);
			cursor.moveToFirst();
			while (!cursor.isAfterLast()) {
				int sidIndex = cursor.getColumnIndex("sid");
				int phone_numIndex = cursor.getColumnIndex("phone_num");
				int contentIndex = cursor.getColumnIndex("content");
				int create_timeIndex = cursor.getColumnIndex("create_time");
				int pic_urlIndex = cursor.getColumnIndex("pic_url");
				int positionIndex = cursor.getColumnIndex("position");
				int voiceIndex = cursor.getColumnIndex("voice");
				int licknameIndex = cursor.getColumnIndex("lickname");
				int iconIndex = cursor.getColumnIndex("icon");
				int genderIndex = cursor.getColumnIndex("gender");
				int commentCountIndex = cursor.getColumnIndex("commentCount");
				int zanCountIndex = cursor.getColumnIndex("zanCount");
				int urlIndex = cursor.getColumnIndex("url");
				int titleIndex = cursor.getColumnIndex("title");
				int briefIndex = cursor.getColumnIndex("brief");
				int imageIndex = cursor.getColumnIndex("image");
				int hasZanIndex = cursor.getColumnIndex("isZan");
				int imageWidhtIndex = cursor.getColumnIndex("imageWidth");
				int imageHeightIndex = cursor.getColumnIndex("imageHeight");
				
				int videoIndex = cursor.getColumnIndex("video");
				int videoWidhtIndex = cursor.getColumnIndex("videoWidth");
				int videoHeightIndex = cursor.getColumnIndex("videoHeight");
				
				Circle circle = new Circle();
				circle.setmId(cursor.getString(sidIndex));
				circle.setmPhoneNum(cursor.getString(phone_numIndex));
				circle.setmGender(cursor.getString(genderIndex));
				circle.setmContent(cursor.getString(contentIndex));
				circle.setmTime(cursor.getString(create_timeIndex));
				circle.setmUrl(cursor.getString(urlIndex));
				circle.setmTitle(cursor.getString(titleIndex));
				circle.setmBrief(cursor.getString(briefIndex));
				circle.setmImage(cursor.getString(imageIndex));
				circle.hasZan = cursor.getInt(hasZanIndex) != 0 ? true : false;
				circle.setImageWidth(cursor.getInt(imageWidhtIndex));
				circle.setImageHeight(cursor.getInt(imageHeightIndex));
				
				circle.setmVideo(cursor.getString(videoIndex));
				circle.setVideoWidth(cursor.getInt(videoWidhtIndex));
				circle.setVideoHeight(cursor.getInt(videoHeightIndex));
				
				String[] path = cursor.getString(pic_urlIndex).split(";");
				ArrayList<String> strings = new ArrayList<String>();
				for (String string : path) {
					if (!TextUtils.isEmpty(string)) {
						strings.add(string);
					}
				}
				circle.setmPicPaths(strings);
				circle.setmPosition(cursor.getString(positionIndex));
				circle.setmVoice(cursor.getString(voiceIndex));
				circle.setmLickName(cursor.getString(licknameIndex));
				circle.setmIcon(cursor.getString(iconIndex));
				circle.setZanCount(cursor.getInt(zanCountIndex));
				circle.setCommentCount(cursor.getInt(commentCountIndex));
				arrayList.add(circle);
				cursor.moveToNext();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
		return arrayList;
	}

	/**
	 * 根据手机号和ID确认数据库是否存在所需查询的朋友圈信息
	 * 
	 * @param context
	 * @param phoneNum
	 * @param id
	 * @return
	 */
	public synchronized boolean queryCircleById(Context context, String phoneNum, String id,int commentCount,int zanCount) {
		long num = 0;
		SQLiteDatabase mDatabase = this.getReadableDatabase();
		try {
			String[] whereValue = { id, phoneNum };
			//this.initialize(context, false);
			
			String where = FRIEND_CIRCLE_TABLES[1] + "=? and " + FRIEND_CIRCLE_TABLES[2] + "=?";
			mDatabase.beginTransaction();
//			cursor = mDatabase.query(FRIEND_CIRCLE_TABLE_NAME, null, where, whereValue, null, null, null);
			ContentValues values = new ContentValues();
			values.put(FRIEND_CIRCLE_TABLES[7], commentCount);
			values.put(FRIEND_CIRCLE_TABLES[8], zanCount);
			num = mDatabase.update(FRIEND_CIRCLE_TABLE_NAME, values, where, whereValue);
			
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			mDatabase.setTransactionSuccessful();
			mDatabase.endTransaction();
			this.close();
		}
		if (num > 0) {
			
			return true;
		} else {
			return false;
		}
	}
	
//	public synchronized Circle queryCircleBySid(Context context, String phoneNum, String id) {
//		long num = 0;
//		Circle circle = null;
//		Cursor cursor = null;
//		try {
//			String[] whereValue = { id, phoneNum };
//			this.initialize(context, false);
//			String where = FRIEND_CIRCLE_TABLES[1] + "=? and " + FRIEND_CIRCLE_TABLES[2] + "=?";
//			cursor = mDatabase.query(FRIEND_CIRCLE_TABLE_NAME, null, where, whereValue, null, null, null);
//			cursor.moveToFirst();
//			if (!cursor.isAfterLast()) {
//				int sidIndex = cursor.getColumnIndex("sid");
//				int phone_numIndex = cursor.getColumnIndex("phone_num");
//				int contentIndex = cursor.getColumnIndex("content");
//				int create_timeIndex = cursor.getColumnIndex("create_time");
//				int pic_urlIndex = cursor.getColumnIndex("pic_url");
//				int positionIndex = cursor.getColumnIndex("position");
//				int voiceIndex = cursor.getColumnIndex("voice");
//				int licknameIndex = cursor.getColumnIndex("lickname");
//				int iconIndex = cursor.getColumnIndex("icon");
//				int commentCountIndex = cursor.getColumnIndex("commentCount");
//				int zanCountIndex = cursor.getColumnIndex("zanCount");
//				circle = new Circle();
//				circle.setmId(cursor.getString(sidIndex));
//				circle.setmPhoneNum(cursor.getString(phone_numIndex));
//				circle.setmContent(cursor.getString(contentIndex));
//				circle.setmTime(cursor.getString(create_timeIndex));
//				String[] path = cursor.getString(pic_urlIndex).split(";");
//				ArrayList<String> strings = new ArrayList<String>();
//				for (String string : path) {
//					if (!TextUtils.isEmpty(string)) {
//						strings.add(string);
//					}
//				}
//				circle.setmPicPaths(strings);
//				circle.setmPosition(cursor.getString(positionIndex));
//				circle.setmVoice(cursor.getString(voiceIndex));
//				circle.setmLickName(cursor.getString(licknameIndex));
//				circle.setmIcon(cursor.getString(iconIndex));
//				circle.setZanCount(cursor.getInt(zanCountIndex));
//				circle.setCommentCount(cursor.getInt(commentCountIndex));
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}  finally {
//			if (null != cursor) {
//				cursor.close();
//			}
//			this.close();
//		}
//		return circle;
//	}
	
	private String getMinTime(ArrayList<Circle> circles) {
		long returnTime = 0;
		for (Circle circle : circles) {
			if (!TextUtils.isEmpty(circle.getmTime())) {
				long time = Long.valueOf(circle.getmTime());
				if (time <= returnTime || returnTime == 0) {
					returnTime = time;
				}
			}
		}
		return returnTime + "";
	}
	
	private String getMaxTime(ArrayList<Circle> circles) {
		long returnTime = 0;
		for (Circle circle : circles) {
			if (!TextUtils.isEmpty(circle.getmTime())) {
				long time = Long.valueOf(circle.getmTime());
				if (time >= returnTime) {
					returnTime = time;
				}
			}
		}
		return returnTime + "";
	}
	
	/**
	 * 清空评论和点赞数据表
	 * 
	 * @return 成功返回true 失败返回false
	 * @see [类、类#方法、类#成员]
	 */
	public synchronized boolean clearReviews() {
		try {
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			mDatabase.delete(CIRCLE_REVIEW_TABLE, null, null);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return true;
	}
	
	/**
	 * 清空朋友圈数据表
	 * 
	 * @return 成功返回true 失败返回false
	 * @see [类、类#方法、类#成员]
	 */
	public synchronized boolean clearCircles() {
		try {
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			mDatabase.delete(FRIEND_CIRCLE_TABLE_NAME, "length(sid)!=20", null);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return true;
	}
	
	/**
	 * 根据手机号和ID确认数据库是否存在所需查询的朋友圈信息
	 * 
	 * @param context
	 * @param phoneNum
	 * @param id
	 * @return
	 */
	public synchronized ArrayList<Circle> queryCircleById(Context context,ArrayList<Circle> circles,String lastTime,String phoneNum) {
		ArrayList<Circle> noCircles = new ArrayList<Circle>();
		SQLiteDatabase mDatabase = this.getReadableDatabase();
		try {
			//this.initialize(context, false);
			mDatabase.beginTransaction();
//				Cursor cursor = null;
//				String orderBy = " create_time desc";
//				String where = "a.phone_num = b.phone_num and a.create_time > "+;
//				String sql = "select a.sid, a.phone_num, a.content, a.create_time,a.pic_url,a.position,a.commentCount,a.zanCount,a.voice,b.lickname,b.icon "
//						+ "from friend_circle as a, friend_user_circle as b where " + where;
//				cursor = mDatabase.rawQuery(sql, null);
			{
				String where = "create_time>=" + getMinTime(circles);
				if (!TextUtils.isEmpty(lastTime)) {
					where += " and create_time<" + lastTime;
				}
				if (!TextUtils.isEmpty(phoneNum)) {
					where += " and phone_num=" + phoneNum;
				}

				String sql = "select sid, phone_num, create_time from friend_circle where " + where+" order by create_time desc ";
				Cursor cursor = mDatabase.rawQuery(sql, null);
				cursor.moveToFirst();
				while (!cursor.isAfterLast()) {
					int sidIndex = cursor.getColumnIndex("sid");
					int phone_numIndex = cursor.getColumnIndex("phone_num");
					int timeIndex = cursor.getColumnIndex("create_time");
					Circle circle = new Circle();
					circle.setmId(cursor.getString(sidIndex));
					circle.setmPhoneNum(cursor.getString(phone_numIndex));
					circle.setmTime(cursor.getString(timeIndex));
					boolean canDelete = true;
					for (Circle forCircle : circles) {
						if (forCircle.getmId().equals(circle.getmId())
								&& forCircle.getmPhoneNum().equals(circle.getmPhoneNum()) 
								&& forCircle.getmTime().equals(circle.getmTime()) ) {
							canDelete = false;
							break;
						}
					}
					if (canDelete && circle.getmId().length() != 20) {
						where = FRIEND_CIRCLE_TABLES[1] + "='" + circle.getmId() + "' and " + FRIEND_CIRCLE_TABLES[2] + "= '" + circle.getmPhoneNum() + "'";
						mDatabase.delete(FRIEND_CIRCLE_TABLE_NAME, where, null);
					}
					cursor.moveToNext();
				}
				cursor.close();
			}
			
			for (int i = 0; i < circles.size(); i++) {
				Circle circle = circles.get(i);
				String[] whereValue = { circle.getmId(), circle.getmPhoneNum() };
				String where = FRIEND_CIRCLE_TABLES[1] + "=? and " + FRIEND_CIRCLE_TABLES[2] + "=?";
				ContentValues values = new ContentValues();
				values.put(FRIEND_CIRCLE_TABLES[7], circle.getCommentCount());
				values.put(FRIEND_CIRCLE_TABLES[8], circle.getZanCount());
//				circle.needProfile = queryUserCircleById(context, circle.getmPhoneNum());
				
				String[] whereValueUser = { circle.getmPhoneNum() };
				String whereCaseUser = FRIEND_USER_CIRCLE_TABLES[0] + "=?";
				circle.needProfile = true;
				Cursor cursor = mDatabase.query(FRIEND_USER_CIRCLE_TABLE_NAME, null, whereCaseUser, whereValueUser, null, null, null);
				circle.needProfile = true;
				
				cursor.moveToFirst();				
				while (!cursor.isAfterLast()) {
					int genderIndex = cursor.getColumnIndex(FRIEND_USER_CIRCLE_TABLES[3]);
					String gender = cursor.getString(genderIndex);
					if(!TextUtils.isEmpty(gender)){
						circle.needProfile = false;	
					}
					break;
				}
				
				cursor.close();
				long num = mDatabase.update(FRIEND_CIRCLE_TABLE_NAME, values, where, whereValue);
				if (num == 0 || circle.needProfile) {
					noCircles.add(circle);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				mDatabase.setTransactionSuccessful();
				mDatabase.endTransaction();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
			this.close();
		}
		return noCircles;
	}

	/**
	 * 插入一条分享信息
	 * 
	 * @param context
	 * @param share
	 * @return
	 */
	public synchronized boolean insertShareInfo(Context context, Share share) {
		StringBuffer stringBuffer = new StringBuffer();
		if (share.getmPicPaths().size() > 0) {
			for (int i = 0; i < share.getmPicPaths().size(); i++) {
				if (i != share.getmPicPaths().size() - 1) {
					stringBuffer.append(share.getmPicPaths().get(i) + ";");
				} else {
					stringBuffer.append(share.getmPicPaths().get(i));
				}
			}
		}
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			ContentValues cv = new ContentValues();
			cv.put(SHARE_TABLES[1], share.getmPhoneNum());
			cv.put(SHARE_TABLES[2], share.getmId());
			cv.put(SHARE_TABLES[3], share.getmContent());
			cv.put(SHARE_TABLES[4], share.getmTime());
			cv.put(SHARE_TABLES[5], stringBuffer.toString());
			cv.put(SHARE_TABLES[6], share.getmPosition());
			mDatabase.insert(SHARE_TABLE_NAME, null, cv);
		} catch (Exception e) {
			Log.v(TAG, "insert viewPoint info fail");
			return false;
		} finally {
			this.close();
		}
		Log.v(TAG, "insert viewPoint info success");
		return true;
	}

	/**
	 * 根据用户手机号码获取用户分享列表
	 * 
	 * @param context
	 * @param phoneNum
	 * @return
	 */
	public synchronized ArrayList<Share> getShareList(Context context, String phoneNum) {
		ArrayList<Share> arrayList = new ArrayList<Share>();
		Cursor cursor = null;
		try {
			String[] whereValue = { phoneNum };
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = SHARE_TABLES[1] + "=?";
			cursor = mDatabase.query(SHARE_TABLE_NAME, null, where, whereValue, null, null, null);

			int num = cursor.getCount();
			Log.d(TAG, "mDatabase num:" + num);
			cursor.moveToFirst();

			if (num > 0) {
				for (int i = 0; i < num; i++) {
					Share mShare = new Share();
					mShare.setmSqlId(cursor.getString(0));
					mShare.setmPhoneNum(cursor.getString(1));
					mShare.setmId(cursor.getString(2));
					if (cursor.getString(3) != null && !cursor.getString(3).equals("")) {
						mShare.setmContent(cursor.getString(3));
					}

					mShare.setmTime(cursor.getString(4));
					if (cursor.getString(5) != null && !cursor.getString(5).equals("")) {
						String[] path = cursor.getString(5).split(";");
						ArrayList<String> strings = new ArrayList<String>();
						for (String string : path) {
							strings.add(string);
						}
						mShare.setmPicPaths(strings);
					}
					if (cursor.getString(6) != null && !cursor.getString(6).equals("")) {
						mShare.setmPosition(cursor.getString(6));
					}
					arrayList.add(mShare);
					cursor.moveToNext();
				}
			} else {
				return null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
		return arrayList;
	}
	
	
	public synchronized ArrayList<Share> getShareList1(Context context, String phoneNum) {
		ArrayList<Share> arrayList = new ArrayList<Share>();
		Cursor cursor = null;
		try {
			String[] whereValue = { phoneNum };
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = SHARE_TABLES[1] + "=?";
			cursor = mDatabase.query(SHARE_TABLE_NAME, null, where, whereValue, null, null, SHARE_TABLES[4] +" desc");
			int num = cursor.getCount();
			cursor.moveToFirst();
			if (num > 0) {
				for (int i = 0; i < num; i++) {
					Share mShare = new Share();
					mShare.setmSqlId(cursor.getString(0));
					mShare.setmPhoneNum(cursor.getString(1));
					mShare.setmId(cursor.getString(2));
					if (cursor.getString(3) != null && !cursor.getString(3).equals("")) {
						mShare.setmContent(cursor.getString(3));
					}

					mShare.setmTime(cursor.getString(4));
					if (cursor.getString(5) != null && !cursor.getString(5).equals("")) {
						String[] path = cursor.getString(5).split(";");
						ArrayList<String> strings = new ArrayList<String>();
						for (String string : path) {
							strings.add(string);
						}
						mShare.setmPicPaths(strings);
					}
					if (cursor.getString(6) != null && !cursor.getString(6).equals("")) {
						mShare.setmPosition(cursor.getString(6));
					}
					arrayList.add(mShare);
					cursor.moveToNext();
				}
			} else {
				return null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
		return arrayList;
	}

	/**
	 * 根据数据库生成ID删除分享信息
	 * 
	 * @param context
	 * @param vid
	 * @return
	 */
	public synchronized boolean deleteShareInfo(Context context, String vid) {
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String where = SHARE_TABLES[0] + "=?";
			String[] whereValue = { vid };
			mDatabase.delete(SHARE_TABLE_NAME, where, whereValue);
		}

		catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return true;
	}

	public synchronized boolean deleteCircle(Context context, String sid, String phoneNum, boolean sendBroadcast) {
		long index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String where = FRIEND_CIRCLE_TABLES[1] + "='" + sid + "' and " + FRIEND_CIRCLE_TABLES[2] + "= '" + phoneNum + "'";
			index = mDatabase.delete(FRIEND_CIRCLE_TABLE_NAME, where, null);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		if (sendBroadcast && index > 0) {
			sendBroadcast(context,true,phoneNum);
		}
		return true;
	}

	/**
	 * 根据手机号码和ID删除分享信息
	 * 
	 * @param context
	 * @param phoneNum
	 * @param id
	 * @return
	 */
	public synchronized boolean deleteShareInfoForPhoneID(Context context, String phoneNum, String id) {
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String where = SHARE_TABLES[1] + "=? and " + SHARE_TABLES[2] + "=?";
			String[] whereValue = { phoneNum, id };
			mDatabase.delete(SHARE_TABLE_NAME, where, whereValue);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		Log.d(TAG, "deleteSearchHistory is sucess!");
		return true;
	}

	/**
	 * 根据手机号和ID确认数据库是否存在所需查询的分享信息
	 * 
	 * @param context
	 * @param phoneNum
	 * @param id
	 * @return
	 */
	public synchronized boolean queryShareById(Context context, String phoneNum, String id) {
		Cursor cursor = null;
		try {
			String[] whereValue = { phoneNum, id };
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = SHARE_TABLES[1] + "=? and " + SHARE_TABLES[2] + "=?";
			cursor = mDatabase.query(SHARE_TABLE_NAME, null, where, whereValue, null, null, "_id asc");

			int num = cursor.getCount();
			Log.d(TAG, "mDatabase num:" + num);
			cursor.moveToFirst();

			if (num > 0) {
				return true;
			} else {
				return false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
	}
	
	/**
	 * 获取话题记录中最新的几张图片资源
	 * @param context
	 * @param phoneNum
	 * @param max
	 * @return
	 */
	public synchronized List<String> queryLastImageinCircles(String phoneNum, int  max) {
		Cursor cursor = null;
		try {
			String[] whereValue = { phoneNum};
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			
			String where = FRIEND_CIRCLE_TABLES[2] + "=?";
			
			cursor = mDatabase.query(FRIEND_CIRCLE_TABLE_NAME, null, where, whereValue, null, null, "create_time desc");

			int num = cursor.getCount();
			Log.d(TAG, "mDatabase num:" + num);
			ArrayList<String> images  = new ArrayList<String>();
			
			cursor.moveToFirst();
			while (!cursor.isAfterLast()) {
				
				int pic_urlIndex = cursor.getColumnIndex("pic_url");
				
				String[] path = cursor.getString(pic_urlIndex).split(";");
				for (String string : path) {
					if (!TextUtils.isEmpty(string)) {
						images.add(string);
					}
				}
				
				if(images.size() > max){
					break;
				}			
				cursor.moveToNext();
			}

			return images;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
	}

	/**
	 * 根据ID确认数据库是否存在所需查询的观点信息
	 * 
	 * @param context
	 * @param phoneNum
	 * @param id
	 * @return
	 */
	public synchronized boolean queryViewPointById(Context context, String vid) {
		Cursor cursor = null;
		try {
			String[] whereValue = { vid };
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String where = VIEWPOINT_TABLES[7] + "=?";
			cursor = mDatabase.query(VIEWPOINT_TABLE_NAME, null, where, whereValue, null, null, "_id asc");

			int num = cursor.getCount();
			Log.d(TAG, "mDatabase num:" + num);
			cursor.moveToFirst();

			if (num > 0) {
				return true;
			} else {
				return false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
	}	
	
	/**
	 * 获取系统数据库所有的图片
	 * 
	 * @param context
	 * @return
	 */
	public synchronized ArrayList<Photo> getAllPhoto(Context context) {
		ArrayList<Photo> arrayList = new ArrayList<Photo>();
		Cursor cursor = null;
		try {
			cursor = context.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, MEDIA_IMAGE_PROJECTION, null, null,
					MediaStore.Images.Media.DATE_TAKEN + " DESC");
			int num = cursor.getCount();
			cursor.moveToFirst();
			if (num > 0) {
				for (int i = 0; i < num; i++) {
					Photo photo = new Photo();
					photo.setmId(cursor.getInt(0));
					photo.setmPath(cursor.getString(1));
					photo.setmFolder(cursor.getString(2));
					photo.setmTakenDate(cursor.getString(3));
					arrayList.add(photo);
					cursor.moveToNext();
				}
			}
		} catch (Exception e) {
			return null;
		} finally {
			if (cursor != null) {
				cursor.close();
			}
		}
		return arrayList;
	}
	
	public synchronized void deletePhoto(Context context,String name){
		int i = context.getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, MediaStore.Images.Media.DATA+"=?",new String[]{name} );
	}

	/**
	 * 根据ID删除观点信息
	 * 
	 * @param context
	 * @param vid
	 * @return
	 * @see [类、类#方法、类#成员]
	 */
	public synchronized boolean deleteUserInfo(Context context, String vid) {
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String where = VIEWPOINT_TABLES[7] + "=?";
			String[] whereValue = { vid };
			mDatabase.delete(VIEWPOINT_TABLE_NAME, where, whereValue);
		}

		catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return true;
	}

	/**
	 * 获取系统数据库所有的图片文件夹
	 * 
	 * @param context
	 * @return
	 */
	public synchronized TreeSet<String> getPhotoFolders(Context context) {
		TreeSet<String> set = new TreeSet<String>();
		Cursor cursor = null;
		try {
			//this.initialize(context, false);
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			cursor = context.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, BUCKET_DISPLAY_NAME, null, null,
					MediaStore.Images.Media.DATE_TAKEN + " DESC");
			int num = cursor.getCount();
			cursor.moveToFirst();

			if (num > 0) {
				for (int i = 0; i < num; i++) {
					String folder = cursor.getString(1);
					set.add(folder);
					cursor.moveToNext();
				}
			}
		} catch (Exception e) {
			return null;
		} finally {
			if (cursor != null) {
				cursor.close();
			}
			this.close();
		}
		return set;
	}

	/**
	 * 清空观点数据表
	 * 
	 * @param context
	 * @return 成功返回true 失败返回false
	 * @see [类、类#方法、类#成员]
	 */
	public synchronized boolean clearViewPoint(Context context) {
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			mDatabase.delete(VIEWPOINT_TABLE_NAME, null, null);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return true;
	}

	/*private void initialize(Context context, boolean writable) {
		if (mDatabase != null) {
			if (mDatabase.isOpen()) {
				mDatabase.endTransaction();
				mDatabase.close();
			}
			mDatabase = null;
		}

		if (mDbHelper != null) {
			mDbHelper.close();
			mDbHelper = null;
		}

		if (writable) {
			mDbHelper = new AMDbHelp(context);
			mDatabase = mDbHelper.getWritableDatabase();
		} else {
			mDbHelper = new AMDbHelp(context);
			mDatabase = mDbHelper.getReadableDatabase();
		}
		SharedHelper sharedHelper = SharedHelper.getShareHelper(context);
		String userName = sharedHelper.getString(SharedHelper.USER_NAME, "");
		if (!TextUtils.isEmpty(userName)) {
			ContentValues cv = new ContentValues();
			cv.put(FRIEND_USER_CIRCLE_TABLES[0], userName);
			cv.put(FRIEND_USER_CIRCLE_TABLES[1], sharedHelper.getString(SharedHelper.USER_NICKNAME, ""));
			cv.put(FRIEND_USER_CIRCLE_TABLES[2], sharedHelper.getString("avatar", ""));
			cv.put(FRIEND_USER_CIRCLE_TABLES[3], sharedHelper.getString("userGender", "F"));
			mDatabase.replace(FRIEND_USER_CIRCLE_TABLE_NAME, null, cv);
		}
	}*/
	
	private void initData(Context context) {
		try{
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			
			SharedHelper sharedHelper = SharedHelper.getShareHelper(context);
			String userName = sharedHelper.getString(SharedHelper.USER_NAME, "");
			if (!TextUtils.isEmpty(userName)) {
				ContentValues cv = new ContentValues();
				cv.put(FRIEND_USER_CIRCLE_TABLES[0], userName);
				cv.put(FRIEND_USER_CIRCLE_TABLES[1], sharedHelper.getString(SharedHelper.USER_NICKNAME, ""));
				cv.put(FRIEND_USER_CIRCLE_TABLES[2], sharedHelper.getString("avatar", ""));
				cv.put(FRIEND_USER_CIRCLE_TABLES[3], sharedHelper.getString("userGender", "F"));
				mDatabase.replace(FRIEND_USER_CIRCLE_TABLE_NAME, null, cv);
			}
			
		} catch (Exception e) {
			Log.v(TAG, "insert addCircleZanComment info fail");
		} finally {
			this.close();
		}
	}

	
	public synchronized boolean deleteCircleReviews(Context context, Circle circle){
		
		return false;
	}
	
	public synchronized boolean addCircleZanComment(Context context,String circleUser, String circleTime , List<Review> zanDatas, List<Review> comments){
		long index = 0;
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			mDatabase.beginTransaction();
			
			String selection = "circleUser=? and circleTime =? ";
			String[] values = new String[]{ circleUser, 
					circleTime} ;
			index = mDatabase.delete(CIRCLE_REVIEW_TABLE, selection, values);
			
			if(addCircleReviews(mDatabase, zanDatas)){
				index++;
			}
			
			if(addCircleReviews(mDatabase, comments)){
				index++;
			}
			mDatabase.setTransactionSuccessful();
			mDatabase.endTransaction();
		} catch (Exception e) {
			Log.v(TAG, "insert addCircleZanComment info fail");
			return false;
		} finally {
			this.close();
		}
		if (index > 0) {
			Log.v(TAG, "insert addCircleZanComment info success");			
		} else {
			Log.e(TAG, "insert addCircleZanComment info fail");
		}
		return index > 0;
	}
	
	private synchronized boolean addCircleReviews(SQLiteDatabase mDatabase, List<Review> reviews){
		long index = -1;
		try{
			for (int i = 0; i < reviews.size(); i++) {
				Review review = reviews.get(i);
				
				ContentValues cv = new ContentValues();
				cv.put(CIRCLE_REVIEW_TABLES[0], review.getId());
				cv.put(CIRCLE_REVIEW_TABLES[1], review.getCircleUser());
				cv.put(CIRCLE_REVIEW_TABLES[2], review.getCircleTime());
				cv.put(CIRCLE_REVIEW_TABLES[3], review.getType());
				cv.put(CIRCLE_REVIEW_TABLES[4], review.getFriendName());
				cv.put(CIRCLE_REVIEW_TABLES[5], review.getNickName());
				cv.put(CIRCLE_REVIEW_TABLES[6], review.getContent());
				cv.put(CIRCLE_REVIEW_TABLES[7], review.getLocation());
				cv.put(CIRCLE_REVIEW_TABLES[8], review.getTime());
				cv.put(CIRCLE_REVIEW_TABLES[9], review.getAvatar());				
				cv.put(CIRCLE_REVIEW_TABLES[10], review.getCommentTo());
				
				index = mDatabase.insert(CIRCLE_REVIEW_TABLE, null, cv);		
			}
			
		} catch (Exception e) {
			Log.v(TAG, "insert circle_review info fail");
			return false;
		} 
		
		if (index > 0) {
			Log.v(TAG, "insert circle_review info success");			
		} else {
			Log.e(TAG, "insert circle_review info fail");
		}
		
		return index > 0;
	}
	
	public synchronized ArrayList<Review> getReviewsByType(Context context,String circleUser, String circleTime, int type){
		ArrayList<Review> arrayList = new ArrayList<Review>();
		Cursor cursor = null;
		try {
			//this.initialize(context, false);			
			SQLiteDatabase mDatabase = this.getReadableDatabase();
			String orderBy = " time asc";
			String selection = "circleUser =? and circleTime =? and type =?";
			String[] values = new String[]{circleUser, circleTime ,	""+type } ;
			
			cursor = mDatabase.query(CIRCLE_REVIEW_TABLE, null, selection, values, null,null, orderBy, null);
			//int num = cursor.getCount();
			cursor.moveToFirst();

			/*"_id", "circleUser", "circleTime", "type", "friendName",
			"nickName", "content", "location", "time", "avatar" */
			while (!cursor.isAfterLast()) {
				Review review = new Review();
				review.setId(cursor.getString(0));
				review.setCircleUser(cursor.getString(1));
				review.setCircleTime(cursor.getString(2));
				review.setType(cursor.getInt(3));
				review.setFriendName(cursor.getString(4));
				review.setNickName(cursor.getString(5));
				review.setContent(cursor.getString(6));
				review.setLocation(cursor.getString(7));
				review.setTime(cursor.getString(8));
				review.setAvatar(cursor.getString(9));				
				review.setCommentTo(cursor.getString(10));
				
				arrayList.add(review);
				cursor.moveToNext();
			}
			
	/*		if (num > 0) {
				for (int i = 0; i < num; i++) {
					Review review = new Review();
					
					review.setCircleUser(cursor.getString(1));
					review.setCircleTime(cursor.getString(2));
					review.setType(cursor.getInt(3));
					review.setFriendName(cursor.getString(4));
					review.setNickName(cursor.getString(5));
					review.setContent(cursor.getString(6));
					review.setLocation(cursor.getString(7));
					review.setTime(cursor.getString(8));
					review.setAvatar(cursor.getString(9));				
					review.setCommentTo(cursor.getString(10));
					
					arrayList.add(review);
					cursor.moveToNext();
				}
			}*/
			
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			if (null != cursor) {
				cursor.close();
			}
			this.close();
		}
		return arrayList;		
	}
	
	public synchronized boolean addCircleReview(Context context,Review review){
		long index = -1;
		try{
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			ContentValues cv = new ContentValues();
			cv.put(CIRCLE_REVIEW_TABLES[0], review.getId());
			cv.put(CIRCLE_REVIEW_TABLES[1], review.getCircleUser());
			cv.put(CIRCLE_REVIEW_TABLES[2], review.getCircleTime());
			cv.put(CIRCLE_REVIEW_TABLES[3], review.getType());
			cv.put(CIRCLE_REVIEW_TABLES[4], review.getFriendName());
			cv.put(CIRCLE_REVIEW_TABLES[5], review.getNickName());
			cv.put(CIRCLE_REVIEW_TABLES[6], review.getContent());
			cv.put(CIRCLE_REVIEW_TABLES[7], review.getLocation());
			cv.put(CIRCLE_REVIEW_TABLES[8], review.getTime());
			cv.put(CIRCLE_REVIEW_TABLES[9], review.getAvatar());
			cv.put(CIRCLE_REVIEW_TABLES[10], review.getCommentTo());
			
			index = mDatabase.insert(CIRCLE_REVIEW_TABLE, null, cv);
			
		} catch (Exception e) {
			Log.v(TAG, "insert circle_review info fail");
			return false;
		} finally {
			this.close();
		} 
		
		if (index > 0) {
			Log.v(TAG, "insert circle_review info success");			
		} else {
			Log.e(TAG, "insert circle_review info fail");
		}
		
		return index > 0;
	}

	public synchronized boolean deleteCircleReview(Context context,Review review){
		int index = 0;
		try {
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			//this.initialize(context, true);
			String selection = "circleTime =? and type =? and friendName=? and time=?";
			String[] values = new String[]{review.getCircleTime(), review.getType() + "" ,
											review.getFriendName() , review.getTime() } ;
			index = mDatabase.delete(CIRCLE_REVIEW_TABLE, selection, values);
		} catch (Exception e) {
			return false;
		} finally {
			this.close();
		}
		return index > 0;
	}
	
	public synchronized boolean hasZan(Context context, Review review) {
		try {
			//this.initialize(context, true);
			SQLiteDatabase mDatabase = this.getWritableDatabase();
			String selection = "circleTime =? and type =? and friendName=? and circleUser=?";
			String[] values = new String[]{review.getCircleTime(), review.getType() + "" ,
											review.getFriendName() , review.getCircleUser() } ;
		
			Cursor cursor = mDatabase.query(CIRCLE_REVIEW_TABLE, new String[] { CIRCLE_REVIEW_TABLES[5] }, selection, values, null, null, null);
			if (cursor != null) {
				if(cursor.getCount()>0){
					cursor.close();
					return true;
				}else {
					cursor.close();
					return false;
				}
				
			}else {
				return false;
			}
		} catch (Exception e) {
			Log.v(TAG, "update zan state viewPoint info fail");
			return false;
		} finally {
			this.close();
		}
	}
	
}
