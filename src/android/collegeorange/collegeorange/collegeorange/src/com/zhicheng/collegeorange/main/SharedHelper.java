package com.zhicheng.collegeorange.main;

import java.util.Set;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * SharedPreferences存储工具类 
 * @author zy
 * 
 */
public class SharedHelper {
	static SharedHelper sh= null;
	public SharedPreferences sp = null;
	public SharedPreferences.Editor edit = null;
	
	public static final String WHICH_ME = "which_me";//我注册，登陆，注销，3个状态，0，1，2
	public static final String LANGUAGE = "language";//0是中文，1是英语

	public static final String USER_SESSION_ID = "user_session_id";
	public static final String USER_NAME = "userName";
	public static final String USER_ICON = "avatar";
	public static final String USER_PHONE = "userPhone";
	public static final String USER_PASSWORD = "userPassword";
	public static final String USER_NICKNAME = "userNickName";
	
	public static final String USER_GENDER = "userGender";
	public static final String USER_CITY = "userCity";
	public static final String USER_SCHOOL = "userSchool";
	public static final String USER_Hobbies = "userHobbies";
	public static final String USER_REGISTE_TIME = "userRegisteTime";
	
	public static final String USER_SIGNATION = "userSignation";
	public static final String USER_Age = "userAge";
	public static final String USER_FRIENDS_COUNT = "user_friends_count";
//	public static final String USER_NEWS_COUNT = "user_news_count";
	
	public static final String USER_DIALOG = "user_dialog";
	public static final String RECORD_COUNT = "record_count";
	public static final String ACCORDING_TELEPHONE_NUMBER = "according_telephone_number";
	public static final String GROUP_KEY_NOTIFICATION = "key_notification";
	public static final String GROUP_KEY_SHOW_OTHER_NAME = "key_show_other_name";
//	public static final String GROUP_NEWS = "group_news_";
	public static final String NEW_VIEWPOINT = "new_viewPoint";
	public static final String NEW_VIEWPOINT_NUMBER = "new_viewPoint_number";
	
	public static final String WATCH_CONNECT_STATUS = "watch_connect_status";
	
	public static final String SYS_GETMESSAGE = "syncCode";
	
	public static final String HAS_CICLE_VIEWPOINT = "has_new_cicle_viewpoint";
	
	public static final String SETTING_TIME_ZONE = "setting_time_zone";
	
	public static final String SETTING_CAMERA_ID = "setting_camera_id";	
	
	/**启动动画或图片名称*/
	public static final String START_UP_PNG = "start_up_png";
	public static final String USER_LEVEL = "user_level";
	public static final String USER_GROWTH = "user_growth";
	public static final String SIGN_IN = "sign_in";
	public static final String UP_DAYS = "up_days";
	public static final String UP_POINTS = "up_points";
	public static final String SIGN_DATE = "sign_date";

	private SharedHelper(Context c) {
		if(sp==null){
			sp = c.getSharedPreferences("launcher", 4);
		}
		if(edit==null){
			edit = sp.edit();
		}
		
	}
	
	public static SharedHelper getShareHelper(Context c) {
		if(sh==null){
			sh = new SharedHelper(c); 
		}
		return sh;
	}

	public void putString(String key, String value) {
		edit.putString(key, value);
		edit.commit();
	}

	public String getString(String key,String def) {
		return sp.getString(key, def);
	}
	
	public void putSet(String key,Set<String> set) {
		edit.putStringSet(key, set);
		edit.commit();
	}
	
	public Set<String> getSet(String key,Set<String> set){
		return sp.getStringSet(key, set);
	}

	public void putInt(String key, int value) {
		edit.putInt(key, value);
		edit.commit();
	}

	public int getInt(String key, int def) {
		return sp.getInt(key, def);
	}
	
	public long getLong(String key, long def) {
		return sp.getLong(key, def);
	}
	
	public void putLong(String key, long l) {
		edit.putLong(key, l);
		edit.commit();
	}
	
	public void putBoolean(String key, boolean value) {
		edit.putBoolean(key, value);
		edit.commit();
	}

	public boolean getBoolean(String key, boolean def) {
		return sp.getBoolean(key, def);
	}
}
