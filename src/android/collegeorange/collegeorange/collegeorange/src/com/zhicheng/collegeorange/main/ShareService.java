package com.zhicheng.collegeorange.main;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import org.apache.http.HttpResponse;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.zhicheng.collegeorange.UploadUtil;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.database.ViewpointDBHelper;
import com.zhicheng.collegeorange.model.Circle;



public class ShareService extends Service {
	private ViewpointDBHelper dbHelper;
	private String myName;
	private String mySession;
	private static String ACTION_SHARE_VIEW_POINT = "ACTION_SHARE_VIEW_POINT";
	private BroadcastReceiver mShareReceiver = new BroadcastReceiver() {

		@SuppressLint("SdCardPath")
		@Override
		public void onReceive(Context context, Intent intent) {
			String act = intent.getAction();
			if (TextUtils.isEmpty(myName)) {
				Toast.makeText(context, "用户已经注销登录,分享失败", Toast.LENGTH_LONG).show();
				return;
			}
			if (ACTION_SHARE_VIEW_POINT.equals(act)) {

			}
		}
	};

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	@Override
	public void onCreate() {
		super.onCreate();
		myName = SharedHelper.getShareHelper(this).getString(SharedHelper.USER_NAME, "");
		mySession = SharedHelper.getShareHelper(this).getString(SharedHelper.USER_SESSION_ID, "");
		
		dbHelper = ViewpointDBHelper.GetInstance(this);
		IntentFilter ifi = new IntentFilter();
		ifi.addAction(ACTION_SHARE_VIEW_POINT);
		LocalBroadcastManager.getInstance(this).registerReceiver(mShareReceiver, ifi);
	}

	@Override
	public void onDestroy() {
		if (mShareReceiver != null) {
			LocalBroadcastManager.getInstance(this).unregisterReceiver(mShareReceiver);
		}
		super.onDestroy();
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		try {
		Circle circle = (Circle) intent.getSerializableExtra("circle");
		if (circle != null) {
			sendShareThread(circle);
		}
		
		} catch (Exception e) {
			 e.printStackTrace();
		}
		return super.onStartCommand(intent, flags, startId);
	}
	
	public static HashMap<String, Integer> sendingMap = new HashMap<String, Integer>();
	
	/**
	 * 获取话题的发送状态
	 * @param id 话题ID
	 * @return  -1 发送失败； 0   发送中； 1 发送成功；
	 */
	public static int getSendingState(String id){
		if(sendingMap.get(id) != null){
			return sendingMap.get(id);
		}else{
			return 0;			
		}
	}
	
	public static void updateSendingState(String id, int state){
		if(sendingMap.get(id) != null){
			if(state == 1){
				sendingMap.put(id, state);		
				sendingMap.remove(id);
			}else{
				sendingMap.put(id, state);				
			}
		}else{
			sendingMap.put(id, state);			
		}
	}
	
	private void sendShareThread(final Circle circle) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				String id = circle.getmId();
				updateSendingState(id, 0);
				int code = sendShare(circle);
				if (code == 0) {
					updateSendingState(id, 1);
					Log.i("testTag", "---share viewpoint is ok---");
				} else {
					Log.e("testTag", "---share viewpoint is failed---");
					updateSendingState(id, -1);
					mHandler.sendEmptyMessage(1);
				}
			}
		}).start();
	}

	//private ArrayList<String> strings = new ArrayList<String>();// 上传成功的图片集合

	private String reSendId = "";
	
	private int sendShare(Circle circle1) {
		String id = circle1.getmId();
		String sendUser = circle1.getmPhoneNum();
		
		myName = SharedHelper.getShareHelper(this).getString(SharedHelper.USER_NAME, "");
		mySession = SharedHelper.getShareHelper(this).getString(SharedHelper.USER_SESSION_ID, "");
		
		try {
			JSONObject obj = new JSONObject();
			/*obj.put("userName", circle1.getmPhoneNum());
			if (!"null".equals(circle1.getmId()) && !"0".equals(circle1.getmId())) {
				obj.put("clientSid", circle1.getmId());
			}*/
			
			JSONArray jsonArray = new JSONArray();
			ArrayList<String> strings = new ArrayList<String>();
			ArrayList<String> points = circle1.getmPicPaths();
			int uploadImageSize = 0;
			if (points != null && !points.isEmpty()) {
				for (int i = 0; i < points.size(); i++) {
					String filePath = points.get(i);
					File file = new File(filePath);
					if (!file.exists()) {
						Log.e("tomoon", points.get(i) + " is not exists!!!");
						uploadImageSize++;
					} else {
						String uploadImageName = uploadSharePic( points.get(i));
						if(!TextUtils.isEmpty(uploadImageName)){
							strings.add(uploadImageName);
						}else{
							Log.e("ShareService", "图片发送失败！");
						}						
					}
				}
			}
			
			if (strings.size() > 0) {
				for (String string : strings) {
					jsonArray.put(string);
				}
			}
			obj.put("Images", jsonArray);
			
			
			if (!TextUtils.isEmpty(circle1.getmContent())) {
				obj.put("Content", circle1.getmContent());
			} else {
				obj.put("Content", "");
			}
			obj.put("Address", circle1.getmPosition());

			if (jsonArray.length() == 0 && TextUtils.isEmpty(circle1.getmContent()) 
					&& TextUtils.isEmpty(circle1.getmVoice()) 
					&& TextUtils.isEmpty(circle1.getmUrl())
					&& TextUtils.isEmpty(circle1.getmVideo())
					) {
				if (points.size() == 0 || points.size() == uploadImageSize) {
					boolean b = dbHelper.deleteCircleForPhoneID(ShareService.this, sendUser, id);
				}
				return -1;
			}
			if (points != null && points.size() != jsonArray.length()) {
				Log.e("tomoon", "image not ok!!!");
				if (points.size() == uploadImageSize) {
					//boolean b = dbHelper.deleteCircleForPhoneID(ShareService.this, sendUser, id);
				}
				return -1;
			}

			if (!TextUtils.isEmpty(circle1.getmVoice())) {
				String newFileName = myName + "_" + System.currentTimeMillis() + ".amr";
				String result = UploadUtil.uploadFile(this , circle1.getmVoice(), Utils.REMOTE_SERVER_URL_FOR_SHARE_UPLOAD_VOICE, newFileName, 0, false);
				if (result != null && result.equals("ok")) {
					obj.put("Voice ", newFileName);
				}else{
					//boolean b = dbHelper.deleteCircleForPhoneID(ShareService.this, sendUser, id);
					return -1;
				}
			}
			
			/*String videoPath = circle1.getmVideo();
			if (!TextUtils.isEmpty(videoPath)) {	
				
				
				
			} */

			
		//	\"url\": \"sddsaga\", \"image\": \"dfgfdsgfd\", \"brief\": \"\u4f60\u597d\", \"title\": \"\u54c8\u54c8\"
			/*if(!TextUtils.isEmpty(circle1.getmUrl())){
				obj.put("url", circle1.getmUrl());
				if(!TextUtils.isEmpty(circle1.getmTitle())){
					obj.put("title", circle1.getmTitle());
				}
				if(!TextUtils.isEmpty(circle1.getmImage())){
					obj.put("image", circle1.getmImage());
				}
				if(!TextUtils.isEmpty(circle1.getmBrief())){
					obj.put("brief", circle1.getmBrief());
				}
			}*/

			HttpResponse response = Utils.getResponse(Utils.REMOTE_SERVER_URL + "/topic?uid=" + myName + "&session=" + mySession  , obj, 30000, 30000);

			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				Log.e("logo", "sendShare code:"+code);
				return -1;
			}
			
			String mCommentViewpointList = EntityUtils.toString(response.getEntity());
			JSONObject jsonb = new JSONObject(mCommentViewpointList);
			if(jsonb.has("code")){
				int resultCode = jsonb.getInt("code");
				if (resultCode == 0) {
					if (jsonb.has("data")) {				
						
						dbHelper.deleteCircleForPhoneID(ShareService.this,circle1.getmPhoneNum(),id);						
						
						LocalBroadcastManager.getInstance(ShareService.this).sendBroadcast(new Intent("UPDATE_TAB"));
						mHandler.sendEmptyMessage(0);
						return 0;
					}
				}
				
			}
			
			
		} catch (ConnectTimeoutException e) {
			e.printStackTrace();
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	private Circle getCircleDetails(String sid, String userName) {
		try {
			JSONArray sidArray = new JSONArray();
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("userName", userName);
			jsonObj.put("sid", sid);
			sidArray.put(jsonObj);
			JSONObject obj = new JSONObject();
			obj.put("sidArray", sidArray);
			obj.put("timestamp", "");
			obj.put("shareCount", 0);
			HttpResponse response = Utils.getResponse(this,Utils.REMOTE_SERVER_URL, "getShareList", obj,  30000, 30000);

			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return null;
			}
			int resultCode = Integer.valueOf(response.getHeaders(Utils.URL_KEY_RESULT_CODE)[0].getValue() + "");
			if (resultCode == 3003) {
			} else if (resultCode == 9999) {
			} else if (resultCode == 0) {
				String mHistoryList = EntityUtils.toString(response.getEntity());

				ArrayList<Circle> mCircles = new ArrayList<Circle>();
				JSONArray jsonArray = new JSONArray(mHistoryList);
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject jsonObject = jsonArray.getJSONObject(i);
					Circle mCircle = new Circle();
					mCircle.setmId(jsonObject.getString("sid"));
					mCircle.setmPosition(jsonObject.getString("position"));
					mCircle.setmContent(jsonObject.getString("content"));
					mCircle.setmTime(jsonObject.getString("timestamp"));
					mCircle.setmPhoneNum(jsonObject.getString("userName"));
					String voice = jsonObject.getString("voice");
					mCircle.setmVoice(voice);
					
					String url = jsonObject.getString("url");
					if(!TextUtils.isEmpty(url)){
						mCircle.setmUrl(url);
						String title = jsonObject.getString("title");
						String brief = jsonObject.getString("brief");
						String iamge = jsonObject.getString("image");
						
						if(!TextUtils.isEmpty(brief)){
							mCircle.setmBrief(brief);
						}
						if(!TextUtils.isEmpty(iamge)){
							mCircle.setmImage(iamge);
						}
						if(!TextUtils.isEmpty(title))
						    mCircle.setmTitle(title);
					}
					
					
					if (!TextUtils.isEmpty(voice)) {
						Message message = new Message();
						message.obj = mCircle;
						message.what = 0;
						loadVoiceHandler.sendMessage(message);
					}

					mCircle.setCommentCount(jsonObject.getInt("commentCount"));
					
					if (jsonObject.has("imageWidth")) {
						mCircle.setImageWidth(jsonObject.getInt("imageWidth"));
					}
					
					if (jsonObject.has("imageHeight")) {
						mCircle.setImageHeight(jsonObject.getInt("imageHeight"));
					}
					
					if (jsonObject.has("video")) {
						mCircle.setmVideo(jsonObject.getString("video"));
					}
					
					if (jsonObject.has("v_width")) {
						try {
							mCircle.setVideoWidth(jsonObject.getInt("v_width"));
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					
					if (jsonObject.has("v_height")) {
						try {
							mCircle.setVideoHeight(jsonObject.getInt("v_height"));
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					
					if(jsonObject.has("zanUsers")){
						JSONArray array = jsonObject.getJSONArray("zanUsers");
						for(int k = 0 ; k < array.length() ;k++){
							String zanUserName = array.getString(k).toString();
							if(myName.equals(zanUserName)){
								mCircle.hasZan = true;
								break;
							}
						}
					}
					
					if (jsonObject.has("fileList")) {
						JSONArray array = jsonObject.getJSONArray("fileList");
						ArrayList<String> mPicNames = new ArrayList<String>();
						for (int j = 0; j < array.length(); j++) {
							if (!TextUtils.isEmpty(array.get(j).toString())) {
								mPicNames.add(array.get(j).toString());
							}
						}
						mCircle.setmPicPaths(mPicNames);
					}
					mCircles.add(mCircle);
				}
				if (!mCircles.isEmpty()) {
					return mCircles.get(0);
				}
			}
		} catch (ConnectTimeoutException e) {
			e.printStackTrace();
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private Handler loadVoiceHandler = new Handler() {
		public void handleMessage(Message msg) {
			final Circle circle = (Circle) msg.obj;
			new Thread() {
				public void run() {
					doLoadVoice(circle);
				};
			}.start();
		};
	};
	
	private Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
		switch (msg.what) {
		case 0:
			Toast.makeText(ShareService.this, "表达发送成功！", Toast.LENGTH_SHORT).show();
			break;
		case 1:
			//Toast.makeText(ShareService.this, "话题发送失败！", Toast.LENGTH_SHORT).show();
			break;

		default:
			break;
		}
		};
	};
	private String loadChatPath = "/sdcard/.Tfire/point/";

	private void doLoadVoice(Circle circle) {
		if (TextUtils.isEmpty(circle.getmVoice())) {
			return;
		}
		try {
			String urlStr = circle.getmVoice();
			urlStr = URLEncoder.encode(urlStr, "utf-8").replaceAll("\\+", "%20");
			urlStr = urlStr.replaceAll("%3A", ":").replaceAll("%2F", "/");
			URL url = new URL(Utils.REMOTE_SERVER_URL_FOR_SHARE_DOWNLOAD_VOICE + circle.getmPhoneNum() + "&filename=" + urlStr);
			URLConnection connection = url.openConnection();
			connection.connect();
			String contentType = "";
			if (connection != null && connection.getHeaderFields().containsKey("Content-Type")) {

				contentType = connection.getHeaderField("Content-Type");
				if (contentType.startsWith("text/plain")) {

					return;
				}
			}

			InputStream input = new BufferedInputStream(url.openStream());
			File file = new File(loadChatPath);
			if (!file.exists())
				file.mkdirs();
			String savePath = loadChatPath + circle.getmVoice();
			OutputStream output = new FileOutputStream(savePath);
			byte data[] = new byte[1024];
			int count;
			while ((count = input.read(data)) != -1) {
				output.write(data, 0, count);
			}
			output.flush();
			output.close();
			input.close();
		} catch (ConnectTimeoutException e) {
			e.printStackTrace();
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	};

	
	private String uploadSharePic(String mPicName) {
		int retryCount = 3;
		String err = null;
		String url = Utils.UPLOAD_PIC +myName+ "&session=" + mySession;
		do {
			//err = Utils.uploadFile(url, mPicName);
			
			err = UploadUtil.uploadImage(url, mPicName);
			if (!TextUtils.isEmpty(err)) {
				break;
			}
		} while (--retryCount > 0);

		return err;
	}
	
	
	
	public String initPath(String path) {
		File tmpFile = null;
		try {
			final BitmapFactory.Options options = new BitmapFactory.Options();
			options.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(path, options);
			int rawImgW = options.outWidth;
			int rawImgH = options.outHeight;
			float fv = 1.0f * rawImgH / rawImgW;
			if ((rawImgW <= 1280) && (rawImgH <= 720)) {
				return null;
			}else if(fv > 3){
				// 解决长条图形问题
				Log.i("testTag", "长条型图片》》》》》》》 不压缩 《《《《《《《《");
				return null;
			} else {
				SimpleDateFormat timesdf = new SimpleDateFormat("yyyyMMddHHmmss");
				String FileTime = timesdf.format(new Date()).toString() + ".jpeg";// 获取
				tmpFile = new File(Environment.getExternalStorageDirectory(), FileTime);
				try {
					tmpFile.createNewFile();
				} catch (Exception e) {
					e.printStackTrace();
					return null;
				}
				FileOutputStream output = null;
				try {
					output = new FileOutputStream(tmpFile);
				} catch (Exception e) {
					e.printStackTrace();
					return null;
				}
				Bitmap bm = Utils.decodCompressionBitmapFromFile(path, 1280, 720);
				if (bm == null) {
					try {
						output.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
					return null;
				}
				bm.compress(Bitmap.CompressFormat.JPEG, 100, output);
				try {
					output.flush();
				} catch (Exception e) {
					e.printStackTrace();
					return null;
				}
			}
			return tmpFile.getPath();
		} catch (Exception e) {
			e.printStackTrace();
			Log.e("bailu", "UploadPictureToService err");
		}
		return null;
	}

}
