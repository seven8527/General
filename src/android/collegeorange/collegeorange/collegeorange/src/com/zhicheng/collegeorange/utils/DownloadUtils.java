package com.zhicheng.collegeorange.utils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.HashMap;

import org.apache.http.conn.ConnectTimeoutException;

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;

import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.model.Circle;


public class DownloadUtils {
	public static String TAG = "DownloadUtils";
	
	public static String DOWNLOAN_VIDEO_SUCCESS = "downloan_video_success";
	public static String DOWNLOAN_VIDEO_FAIL = "downloan_video_fail";
	
	public static String DOWNLOAN_VOICE_SUCCESS = "downloan_voice_success";
	public static String DOWNLOAN_VOICE_FAIL = "downloan_voice_fail";
	
	public static String load_circle_Path = "/sdcard/.Tfire/point/";
	
	public static String load_chat_video_Path = "/sdcard/.Tfire/chat/";
	
	public static HashMap<String, Integer> downloadMap = new HashMap<String, Integer>();
	
	public static boolean isDownLoadAble(String fileName){
	
		if(downloadMap.get(fileName) != null && downloadMap.get(fileName) != 0){
			int state = downloadMap.get(fileName);
			if(state == 0 || state == -1){
				return true;
			}else{
				return false;	
			}			
		}
		
		return true;
	}
	
	
	public static void downloadCircleVoice(Context context, Circle circle) {
		if (TextUtils.isEmpty(circle.getmVoice())) {
			sendVoiceBroadcast(context, false, circle.getmVoice());
			return;
		}
		
		String savePath = load_circle_Path + circle.getmVoice();
		File ff = new File(savePath);
		if(ff != null && ff.exists()){
			Log.i(TAG, "文件已经存在！：" + savePath);
			sendVoiceBroadcast(context, true, circle.getmVoice());
			return;
		}
		
		if(!isDownLoadAble(circle.getmVoice())){
			Log.i("testTag", "正在下载中" + circle.getmVoice());
			sendVoiceBroadcast(context, false, circle.getmVoice());
			return;
		}
		downloadMap.put(circle.getmVoice(), 1);
		try {
			String urlStr = circle.getmVoice();
			String session = SharedHelper.getShareHelper(context).getString(SharedHelper.USER_SESSION_ID, "");
			urlStr = URLEncoder.encode(urlStr, "utf-8").replaceAll("\\+", "%20");
			urlStr = urlStr.replaceAll("%3A", ":").replaceAll("%2F", "/");
			
			URL url = new URL(Utils.REMOTE_SERVER_URL_FOR_SHARE_DOWNLOAD_VOICE +circle.getmPhoneNum()
					+"&session="+ session + "&fid=" + urlStr);
			URLConnection connection = url.openConnection();
			connection.connect();
			String contentType = "";
			try {
				if (connection != null && connection.getHeaderFields() != null && connection.getHeaderFields().containsKey("Content-Type")) {
					contentType = connection.getHeaderField("Content-Type");
					if (contentType.startsWith("text/plain")) {
						Log.e("logo", "doLoadVoice no this url:" + url);
						downloadMap.put(circle.getmVoice(), -1);
						sendVoiceBroadcast(context, false, circle.getmVoice());
						return;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			InputStream input = new BufferedInputStream(url.openStream());
			File file = new File(load_circle_Path);
			if (!file.exists())
				file.mkdirs();
			
			OutputStream output = new FileOutputStream(savePath);
			byte data[] = new byte[1024];
			int count;
			while ((count = input.read(data)) != -1) {
				output.write(data, 0, count);
			}
			output.flush();
			output.close();
			input.close();
			downloadMap.remove(circle.getmVoice());
			
			sendVoiceBroadcast(context, true, circle.getmVoice());
			return ;
			
		} catch (ConnectTimeoutException e) {
			e.printStackTrace();
			downloadMap.put(circle.getmVoice(), -1);
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
			downloadMap.put(circle.getmVoice(), -1);
		} catch (ConnectException e) {
			e.printStackTrace();
			downloadMap.put(circle.getmVoice(), -1);
		} catch (Exception e) {
			e.printStackTrace();
			downloadMap.put(circle.getmVoice(), -1);
		}
		
		sendVoiceBroadcast(context, false, circle.getmVoice());
	}
	
	private static void sendVideoBroadcast(Context context, boolean isSuccess, String filename){
		Intent intent = new Intent(isSuccess ? DOWNLOAN_VIDEO_SUCCESS : DOWNLOAN_VIDEO_FAIL);
		intent.putExtra("filename", filename);
		LocalBroadcastManager.getInstance(context).sendBroadcast(intent);		
	}
	
	private static void sendVoiceBroadcast(Context context, boolean isSuccess, String filename){
		Intent intent = new Intent(isSuccess ? DOWNLOAN_VOICE_SUCCESS : DOWNLOAN_VOICE_FAIL);
		intent.putExtra("filename", filename);
		LocalBroadcastManager.getInstance(context).sendBroadcast(intent);		
	}
	
}
