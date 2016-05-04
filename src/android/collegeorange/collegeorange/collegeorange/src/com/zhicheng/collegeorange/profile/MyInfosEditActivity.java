package com.zhicheng.collegeorange.profile;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.MediaStore.Images.Thumbnails;
import android.provider.MediaStore.Video.VideoColumns;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.display.RoundedBitmapDisplayer;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.soundcloud.android.crop.Crop;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.UploadUtil;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.utils.MD5;
import com.zhicheng.collegeorange.utils.ShowDialog;


public class MyInfosEditActivity extends Activity implements OnClickListener {
	private TextView nikname_text,signature_text,sex_text,age_text,city_text,hobby_text,mSaveBtn;
    private Context mContext; 
    private SharedHelper sharedHelper;
    private String mGenderStr = "F";
//    private PopupWindow mPop;
    private ImageView mAvatar;
    float mImageLong = 0;
    private DisplayImageOptions optionsIcon;
    private LinearLayout bg_layout;
    public static final String BITMAP_NAME = "logo_image";
    private JSONObject userJsonObject;
    
    ActionPopupWindow mCompleteActionPlusActivity = null;
    
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.my_info_editor_activity);
		optionsIcon = new DisplayImageOptions.Builder()
		.showImageOnLoading(R.drawable.user_logo)
		.showImageForEmptyUri(R.drawable.user_logo)
		.showImageOnFail(R.drawable.user_logo).cacheInMemory(true)
		.cacheOnDisk(true).considerExifParams(true)
		.resetViewBeforeLoading(true)
		.displayer(new RoundedBitmapDisplayer(120)).build();
		
		mContext = this;
		sharedHelper = SharedHelper.getShareHelper(this);
		mImageLong = getResources().getDimensionPixelOffset(R.dimen.me_logo);
		initTitle();
		initView();
		initData();
		
		checkCameraImage(savedInstanceState);
	}

	private void initTitle() {
		findViewById(R.id.back).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (userJsonObject != null)
					setResult(RESULT_OK, new Intent().putExtra("userInfo", userJsonObject.toString()));
				finish();
			}
		});
	}
	
	@Override
	public void onBackPressed() {
		if (userJsonObject != null)
			setResult(RESULT_OK, new Intent().putExtra("userInfo", userJsonObject.toString()));
		finish();
	}

	private void initView() {
		nikname_text = (TextView)findViewById(R.id.nikname_text);
		signature_text = (TextView)findViewById(R.id.signature_text);
		sex_text = (TextView)findViewById(R.id.sex_text);
		age_text = (TextView)findViewById(R.id.age_text);
		city_text = (TextView)findViewById(R.id.city_text);
		hobby_text = (TextView)findViewById(R.id.hobby_text);
		mAvatar = (ImageView)findViewById(R.id.avatar);
		bg_layout = (LinearLayout)findViewById(R.id.bg_layout);
		findViewById(R.id.avatar_layout).setOnClickListener(this);
		findViewById(R.id.nikename_layout).setOnClickListener(this);
		findViewById(R.id.signature_layout).setOnClickListener(this);
		findViewById(R.id.sex_layout).setOnClickListener(this);
		findViewById(R.id.age_layout).setOnClickListener(this);
		findViewById(R.id.city_layout).setOnClickListener(this);
		findViewById(R.id.hobby_layout).setOnClickListener(this);
		mSaveBtn = (TextView)findViewById(R.id.save_bnt);
		mSaveBtn.setVisibility(View.INVISIBLE);
		mSaveBtn.setText("保存");
		mSaveBtn.setOnClickListener(this);
		
//		View view = LayoutInflater.from(this).inflate(R.layout.pop_logo_layout, null);
//		view.findViewById(R.id.album).setOnClickListener(this);
//		view.findViewById(R.id.camera).setOnClickListener(this);
//		view.findViewById(R.id.local).setOnClickListener(this);
//		mPop = new PopupWindow(view, LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT, false);
//		mPop.setBackgroundDrawable(new BitmapDrawable());
//		mPop.setOutsideTouchable(true);
//		mPop.setFocusable(true);
	}

	private void initData() {
		String pic = sharedHelper.getString("avatar", "");
		String uId = sharedHelper.getString(SharedHelper.USER_NAME, "");
		String session = sharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
		
		if(!TextUtils.isEmpty(pic)){
			String iconUrl = Utils.DOWNLOAD_PIC  + uId + "&session=" + session + "&fid=" + pic + "&size=small";
			ImageLoader.getInstance().displayImage(iconUrl, mAvatar, optionsIcon,imageLoadingListener);
		}
		
		signature_text.setText(sharedHelper.getString(SharedHelper.USER_SIGNATION, ""));
		nikname_text.setText(sharedHelper.getString(SharedHelper.USER_NICKNAME, ""));
		city_text.setText(sharedHelper.getString(SharedHelper.USER_SCHOOL, ""));
		mGenderStr = sharedHelper.getString(SharedHelper.USER_GENDER, "");
		if ("F".equals(mGenderStr)) {
			sex_text.setText("女");
		} else{
			sex_text.setText("男");
		}
		hobby_text.setText(sharedHelper.getString(SharedHelper.USER_Hobbies, ""));
		age_text.setText(sharedHelper.getString(SharedHelper.USER_Age, ""));
		getUserInfo();
	}
	
	ImageLoadingListener imageLoadingListener = new ImageLoadingListener() {
		@Override
		public void onLoadingStarted(String arg0, View arg1) {
		}
		@Override
		public void onLoadingFailed(String arg0, View arg1, FailReason arg2) {
		}
		@Override
		public void onLoadingComplete(String arg0, View arg1, Bitmap bmp) {
			if(bmp != null){
//				try {
//					bg_layout.setBackgroundDrawable(Utils.BoxBlurFilter(bmp));
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
			}
		}
		@Override
		public void onLoadingCancelled(String arg0, View arg1) {
		}
	};

	private boolean isUpdateInfo = false;
	
	@Override
	public void onClick(View v) {
		Intent intent = new Intent();
		switch (v.getId()) {
		case R.id.avatar_layout:
//			if (mPop.isShowing()) {
//				mPop.dismiss();
//			} else {
//				mPop.showAsDropDown(v, (int) mImageLong, -(int) (mImageLong / 2));
//			}
			View bg2 = findViewById(R.id.layout2);
			bg2.setVisibility(View.VISIBLE);
			Animation anim = new AlphaAnimation(0.0f, 1.0f);
			anim.setDuration(500);
			anim.setFillAfter(true);
			bg2.setAnimation(anim);

			try {
				List<String> name = new ArrayList<String>();
				name.add("拍照");
				name.add("相册");
				//name.add("本地头像");
				mCompleteActionPlusActivity = new ActionPopupWindow(MyInfosEditActivity.this, name, onInvateClickListener, "",mHandler);
				mCompleteActionPlusActivity.setAnimationStyle(R.style.AnimBottom);
				mCompleteActionPlusActivity.showAtLocation(bg_layout,Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); // 设置layout在PopupWindow中显示的位置
			} catch (Exception e) {
				e.printStackTrace();
			}
			ScaleAnimation myAnimation_Scale = new ScaleAnimation(1.0f, 0.9f, 1.0f, 0.9f,   
		             Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,  0.5f);   
			myAnimation_Scale.setDuration(500);
			myAnimation_Scale.setFillAfter(true);
			bg_layout.startAnimation(myAnimation_Scale);
			break;
		case R.id.nikename_layout:
			intent.setClass(mContext, GroupNameDialogActivity.class);
			String name = nikname_text.getText().toString();
			intent.putExtra(GroupNameDialogActivity.type, GroupNameDialogActivity.nickName);
			intent.putExtra(GroupNameDialogActivity.text_content, name);
			startActivityForResult(intent, 101);
			break;
		case R.id.signature_layout:
			intent.setClass(mContext, GroupNameDialogActivity.class);
			String text = signature_text.getText().toString();
			intent.putExtra(GroupNameDialogActivity.type, GroupNameDialogActivity.signature);
			intent.putExtra(GroupNameDialogActivity.text_content, text);
			startActivityForResult(intent, 101);
			break;
		case R.id.sex_layout:
			intent.setClass(mContext, GroupNameDialogActivity.class);
			intent.putExtra("gender", mGenderStr);
			intent.putExtra("title", "Gender");
			startActivityForResult(intent, 0);
			break;
		case R.id.age_layout:
			intent.setClass(mContext, GroupNameDialogActivity.class);
			text = age_text.getText().toString();
			intent.putExtra(GroupNameDialogActivity.type, GroupNameDialogActivity.age);
			intent.putExtra(GroupNameDialogActivity.text_content, text);
			startActivityForResult(intent, 101);
			break;
		case R.id.city_layout:
			intent.setClass(mContext, GroupNameDialogActivity.class);
			text = city_text.getText().toString();
			intent.putExtra(GroupNameDialogActivity.type, GroupNameDialogActivity.city);
			intent.putExtra(GroupNameDialogActivity.text_content, text);
			startActivityForResult(intent, 101);
			break;
		case R.id.hobby_layout:
			intent.setClass(mContext, GroupNameDialogActivity.class);
			text = hobby_text.getText().toString();
			intent.putExtra(GroupNameDialogActivity.type, GroupNameDialogActivity.hobbies);
			intent.putExtra(GroupNameDialogActivity.text_content, text);
			startActivityForResult(intent, 101);
			break;
		case R.id.save_bnt: 
		ShowDialog.showProgressDialog(mContext, "正在提交资料，请等待！", true);		
		JSONObject obj = getUpdateInfo();
		String avatar =  sharedHelper.getString(SharedHelper.USER_ICON, "");;
			try {
				obj.put("Avatar", avatar);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		submitInfos(obj,false);
		break;
		default:
			break;
		}
	}
	
	private JSONObject getUpdateInfo(){
		JSONObject obj = new JSONObject();
		try {
			//obj.put("Avatar", "");
			obj.put("Nickname", nikname_text.getText());
			obj.put("Signature", signature_text.getText());
			obj.put("Age", age_text.getText());
			obj.put("Hobbies", hobby_text.getText());
			//obj.put("Location", city_text.getText());
			obj.put("Gender", mGenderStr);
			obj.put("School", city_text.getText());
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}
	
	private OnClickListener onInvateClickListener = new OnClickListener() {
		@Override
		public void onClick(View arg0) {
			if(mCompleteActionPlusActivity != null){
				mCompleteActionPlusActivity.dismiss();
			}
			switch (arg0.getId()) {
			case R.id.exitBtn0:
				getPicFromCapture();
				break;
			case R.id.exitBtn1:
				getPicFromContent();
				break;
			case R.id.exitBtn2:
				//startActivityForResult(new Intent(mContext, LocalAvatarActivity.class), 990);
				break;
			}
		}
	};
	
	private void submitInfos(final JSONObject obj,final boolean isPic){
		new Thread(){
			@Override
			public void run() {
				try {
					String uid = sharedHelper.getString(SharedHelper.USER_NAME, "");
					String session = sharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
					
					HttpResponse response = Utils.getResponse(Utils.REMOTE_SERVER_URL 
							+ "/user/info?uid="+uid+"&session="+session,
							obj, 30000, 30000);
					
					int code = response.getStatusLine().getStatusCode();
					if (code != 200) {
						ShowDialog.closeProgressDialog();
						return;
					}
					String mHistoryList = EntityUtils.toString(response.getEntity());
					JSONObject jsonObj= new JSONObject(mHistoryList);
					
					int resultCode = -1;
					if(jsonObj.has("code")){
						resultCode = jsonObj.getInt("code");
					}else{
						mHandler.sendEmptyMessage(R.string.error_server);
						return ;
					}
					
					if (resultCode == 0) {
						userJsonObject = obj;
						saveUserData(userJsonObject);
						Intent intent = new Intent(Utils.USER_INFO_CHANGE);
						LocalBroadcastManager.getInstance(mContext).sendBroadcast(intent);
						mHandler.sendEmptyMessage(R.string.info_change_ok);
					} else {
						mHandler.sendEmptyMessage(R.string.error_server);
					}
				} catch (ConnectTimeoutException e) {
					mHandler.sendEmptyMessage(R.string.error_network);
					e.printStackTrace();
				} catch (SocketTimeoutException e) {
					mHandler.sendEmptyMessage(R.string.error_network);
					e.printStackTrace();
				} catch (ConnectException e) {
					mHandler.sendEmptyMessage(R.string.error_network);
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
					ShowDialog.closeProgressDialog();
				}
			};
		}.start();
	}
	
	public void saveUserData(JSONObject infoObject){
		
		try {
			SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
			
			if(infoObject.has("Nickname")){						
				shareHelper.putString(SharedHelper.USER_NICKNAME, infoObject.getString("Nickname"));
			}
			
			if(infoObject.has("Avatar")){						
				shareHelper.putString(SharedHelper.USER_ICON, infoObject.getString("Avatar"));
			}
			
			if(infoObject.has("Signature")){						
				shareHelper.putString(SharedHelper.USER_SIGNATION, infoObject.getString("Signature"));
			}
			
			if(infoObject.has("Gender")){						
				shareHelper.putString(SharedHelper.USER_GENDER, infoObject.getString("Gender"));
			}
			
			/*if(infoObject.has("")){						
				shareHelper.putString(SharedHelper.USER_NAME, infoObject.getString("School"));
			}*/
			
			if(infoObject.has("CreateTime")){						
				shareHelper.putString(SharedHelper.USER_REGISTE_TIME, infoObject.getString("CreateTime"));
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static final int refeshInfo = 1001;
	Handler mHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			ShowDialog.closeProgressDialog();
			switch (msg.what) {
			case refeshInfo:
				try {				
					String uId = sharedHelper.getString(SharedHelper.USER_NAME, "");
					String session = sharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
					
					JSONObject json = new JSONObject(msg.obj.toString());
					userJsonObject = json;
					String nickname = json.getString("Nickname");
					mGenderStr = json.getString("Gender");
					String explain = json.getString("Signature");
					String Avatar = json.getString("Avatar");
					//String age = json.getString("Age");
					//sharedHelper.putString(SharedHelper.USER_Age, age);
					nikname_text.setText(nickname);
					String sex = getString(R.string.male);
					if ("F".equals(mGenderStr)) {
						sex = getString(R.string.female);
					}
					sharedHelper.putString(SharedHelper.USER_GENDER, mGenderStr);
					
					sex_text.setText(sex);
					signature_text.setText(explain);
					//age_text.setText(age);
					if (!TextUtils.isEmpty(explain))
						sharedHelper.putString(SharedHelper.USER_SIGNATION, explain);
					if (!TextUtils.isEmpty(Avatar)) {
						sharedHelper.putString("avatar", Avatar);						
						String iconUrl = Utils.DOWNLOAD_PIC  + uId + "&session=" + session + "&fid=" + Avatar + "&size=small";
						ImageLoader.getInstance().displayImage(iconUrl, mAvatar, optionsIcon,imageLoadingListener);
					}else{
						mAvatar.setImageResource(R.drawable.user_logo);
						
						if ("F".equals(mGenderStr)) {
							mAvatar.setImageResource(R.drawable.nv_icon);
						} else {
							mAvatar.setImageResource(R.drawable.nan_icon);
						}
					}
					if (nickname != null) {
						sharedHelper.putString(SharedHelper.USER_NICKNAME, nickname);
					}
					if(explain != null){
						sharedHelper.putString(SharedHelper.USER_SIGNATION, explain);
					}
					
					//String hobbies = json.getString("Hobbies");
					//sharedHelper.putString(SharedHelper.USER_Hobbies, hobbies);
					//String city = json.getString("Location");
					//sharedHelper.putString(SharedHelper.USER_CITY, city);
					//hobby_text.setText(hobbies);
					//city_text.setText(city);
					if(json.has("School")){
						String school = json.getString("School");
						city_text.setText(school);
					}
					
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case R.string.error_server:
				Toast.makeText(mContext, R.string.error_server, Toast.LENGTH_SHORT).show();
				break;
			case R.string.error_network:
				Toast.makeText(mContext, R.string.error_network, Toast.LENGTH_SHORT).show();
				break;
			case 0:
				try {
					Bitmap bmp = Utils.getRoundCornerBitmap((Bitmap) msg.obj);
					mAvatar.setImageBitmap(bmp);
//					try {
//						bg_layout.setBackgroundDrawable(Utils.BoxBlurFilter(bmp));
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case R.string.info_change_ok:
				mSaveBtn.setVisibility(View.INVISIBLE);
				getUserInfo();
				break;
			case 101:
				goback();
				break;
			default:
				break;
			}
		};
	};
	
	private void goback() {
		ScaleAnimation myAnimation_Scale =new ScaleAnimation(0.9f, 1.0f, 0.9f, 1.0f,   
	             Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,  0.5f);   
		myAnimation_Scale.setDuration(500);
		myAnimation_Scale.setFillAfter(true);
		bg_layout.startAnimation(myAnimation_Scale);
		
		
		View bg2 = findViewById(R.id.layout2);
		bg2.setVisibility(View.GONE);
		Animation animation = new AlphaAnimation(1.0f, 0.0f);
		animation.setDuration(500);
		bg2.setAnimation(animation);
		if (mCompleteActionPlusActivity != null) {
			mCompleteActionPlusActivity.setAnimationStyle(R.style.AnimTop2);
		}
	}
	
	private void setBitmap(ImageView view, String filePath) {
		Matrix matrix = new Matrix();
		matrix.postRotate(readPicyureDegree(filePath));
		try {
			Bitmap b = Utils.decodCompressionBitmapFromFile(filePath, 1280, 720);
			saveBitmap(b);
			Message message = new Message();
			message.obj = b;
			message.what = 0;
			mHandler.sendMessage(message);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static int readPicyureDegree(String path) {
		int degree = 0;
		try {
			ExifInterface exifInterface = new ExifInterface(path);
			int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
			switch (orientation) {
			case ExifInterface.ORIENTATION_ROTATE_90:
				degree = 90;
				break;
			case ExifInterface.ORIENTATION_ROTATE_180:
				degree = 180;
				break;
			case ExifInterface.ORIENTATION_ROTATE_270:
				degree = 270;
				break;
			default:
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return degree;
	}
	
	private void saveBitmap(Bitmap b) {
		String path = this.getFilesDir().getAbsolutePath() + File.pathSeparator + BITMAP_NAME;
		if (saveBitmap2file(b, path)) {
			uploadAvatar(path);
		}
	}

	boolean saveBitmap2file(Bitmap bmp, String path) {
		CompressFormat format = Bitmap.CompressFormat.JPEG;
		int quality = 100;
		OutputStream stream = null;
		try {
			stream = new FileOutputStream(path);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bmp.compress(format, quality, stream);
	}
	
	private boolean uploadAvatar(final String tmpFileName) {
		int retryCount = 3;
		String err = null;
		String uId = sharedHelper.getString(SharedHelper.USER_NAME, "");
		String session = sharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
		//String newFileName = uId + System.currentTimeMillis() + ".jpg";
		String newFileName = null;//MD5.digestFileContent(tmpFileName);
		do {
			String url = Utils.REMOTE_SERVER_URL +  "/file/image?uid="+uId+"&session="+session;
			err = UploadUtil.uploadImage(url, tmpFileName);
			if(!TextUtils.isEmpty(err)){
				newFileName = err;
				break;
			}
		} while (--retryCount > 0);

		if (err == null) {
			return false;
		} else {
			try {
				JSONObject obj = new JSONObject();
				obj = getUpdateInfo();
				obj.put("Avatar", newFileName);
				submitInfos(obj,true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return true;
	}
	
	
	private void getUserInfo() {
		
		new Thread(new Runnable() {
			@Override
			public void run() {
    	SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
    	String myName = shareHelper.getString(SharedHelper.USER_NAME, "");
    	String mySession = shareHelper.getString(SharedHelper.USER_SESSION_ID, "");
		try {
			String url = Utils.REMOTE_SERVER_URL + "/user/info/"+myName+"?uid="+myName+"&session="+mySession;
			HttpGet httpGet = new HttpGet(url);
            HttpClient httpClient = new DefaultHttpClient();

            // 发送请求
            HttpResponse response = httpClient.execute(httpGet);
			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				mHandler.sendEmptyMessage(R.string.error_network);
				return;
			}
			String mHistoryList = EntityUtils.toString(response.getEntity());
			JSONObject jsonObj= new JSONObject(mHistoryList);
			
			int resultCode = -1;
			if(jsonObj.has("code")){
				resultCode = jsonObj.getInt("code");
			}
			
			if (resultCode == 0 && jsonObj.has("data")) {
				
				JSONObject jsonObject = jsonObj.getJSONObject("data");
				
				if(jsonObject.has("Profile")){
					JSONObject infoObject = jsonObject.getJSONObject("Profile");
					
					if(infoObject.has("Nickname")){						
						shareHelper.putString(SharedHelper.USER_NICKNAME, infoObject.getString("Nickname"));
					}
					
					if(infoObject.has("Avatar")){						
						shareHelper.putString(SharedHelper.USER_ICON, infoObject.getString("Avatar"));
					}
					
					if(infoObject.has("Signature")){						
						shareHelper.putString(SharedHelper.USER_SIGNATION, infoObject.getString("Signature"));
					}
					
					if(infoObject.has("Gender")){						
						shareHelper.putString(SharedHelper.USER_GENDER, infoObject.getString("Gender"));
					}
					
					if(infoObject.has("School")){						
						shareHelper.putString(SharedHelper.USER_SCHOOL, infoObject.getString("School"));
					}
					
					if(infoObject.has("CreateTime")){						
						shareHelper.putString(SharedHelper.USER_REGISTE_TIME, infoObject.getString("CreateTime"));
					}
						
					Message message = new Message();
					message.obj = infoObject;
					message.what = refeshInfo;
					mHandler.sendMessage(message);
					return ;
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
		mHandler.sendEmptyMessage(R.string.error_network);
			}
		}).start();
	}	
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode == RESULT_OK) {
			if (requestCode == 0) {
				mSaveBtn.setVisibility(View.VISIBLE);
				final String name = data.getStringExtra("name");
				final String title = data.getStringExtra("title");
				if (!TextUtils.isEmpty(name)){
					isUpdateInfo = true;
					mGenderStr = name;
					if (name.equals("F")){
						sex_text.setText(R.string.female);
					}else{
						sex_text.setText(R.string.male);
					}
				}
			} else if (requestCode == 990) {
				if (resultCode != RESULT_OK)
					return;
				final String fileName = data.getStringExtra("name");
				AssetManager am = getResources().getAssets();
				try {
					final InputStream is = am.open(fileName);
					ImageLoader.getInstance().displayImage("assets://" + fileName, mAvatar, optionsIcon,imageLoadingListener);
					ShowDialog.showProgressDialog(mContext, "正在上传，请稍等...", true);
					try {
						JSONObject obj = new JSONObject();
						obj = getUpdateInfo();
						//obj.put("userName", sharedHelper.getString(SharedHelper.USER_NAME, ""));
						obj.put("Avatar", fileName);
						submitInfos(obj,true);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (requestCode == 101) { 
				isUpdateInfo = true;
				mSaveBtn.setVisibility(View.VISIBLE);
				final String name = data.getStringExtra(GroupNameDialogActivity.type);
				final String str = data.getStringExtra(name);
				if (name.equals(GroupNameDialogActivity.nickName)){
					nikname_text.setText(str);
				}else if (name.equals(GroupNameDialogActivity.signature)){
					signature_text.setText(str);
				}else if (name.equals(GroupNameDialogActivity.age)){
					age_text.setText(str);
				}else if (name.equals(GroupNameDialogActivity.hobbies)){
					hobby_text.setText(str);
				}else if (name.equals(GroupNameDialogActivity.city)){
					city_text.setText(str);
				}
			}else if(requestCode == Crop.REQUEST_CROP){
				endofImageCrop01(data);		
			}else {
				if (requestCode == 1) {// 拍照
					File picture = new File(Environment.getExternalStorageDirectory() + "/temp.jpg");
//					startPhotoZoom(Uri.fromFile(picture));
					//startCropImage(Uri.fromFile(picture));
					Uri destination = Uri.fromFile(new File(getCacheDir(), "cropped"));
					Crop.of(Uri.fromFile(picture), destination).asSquare().start(this);
					
				} else if (requestCode == 2) {// 图库					
//					startPhotoZoom(data.getData());
//					startCropImage(data.getData());
					Uri destination = Uri.fromFile(new File(getCacheDir(), "cropped"));
					Crop.of(data.getData(), destination).asSquare().start(this);
				} else {					
//					endofImageCrop01(data);					
					//endofImageCrop02(data);
				}
			}

		}
	}
	
	
	@Override
	public void onSaveInstanceState(Bundle outState) {
		if(tempImage != null){
			outState.putParcelable("camera_Image", tempImage);
		}
		super.onSaveInstanceState(outState);		
	}
	
	private void checkCameraImage(Bundle savedInstanceState){
		if(savedInstanceState != null 
				&& savedInstanceState.getParcelable("camera_Image") != null){
			try {
				Uri imagePath = savedInstanceState.getParcelable("camera_Image");				
				startPhotoZoom(imagePath);
				//startCropImage(imagePath);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	
	public void startPhotoZoom(Uri uri) {
		Intent intent = new Intent("com.android.camera.action.CROP");
//		intent.setDataAndType(uri, "image/*");
//		intent.putExtra("crop", "false");
//		intent.putExtra("aspectX", 1);
//		intent.putExtra("aspectY", 1);
//		intent.putExtra("outputX", 300);
//		intent.putExtra("outputY", 300);
//		intent.putExtra("return-data", true);
//		startActivityForResult(intent, 3);
//		
//		 //裁剪图片意图  
//        Intent intent = new Intent("com.android.camera.action.CROP");    
        intent.setDataAndType(uri, "image/*");    
        intent.putExtra("crop", "true");  
        //裁剪框的比例，1：1  
        intent.putExtra("aspectX", 1);    
        intent.putExtra("aspectY", 1);  
        //裁剪后输出图片的尺寸大小  
        intent.putExtra("outputX", 400);     
        intent.putExtra("outputY", 400);  
        //图片格式  
        intent.putExtra("outputFormat", "JPEG");  
        intent.putExtra("noFaceDetection", true);  
        intent.putExtra("return-data", true);    
        intent.putExtra("scale", true);
        startActivityForResult(intent, 3); 
	}
	
	private void endofImageCrop01(Intent data){
		// 取得返回的Uri,基本上选择照片的时候返回的是以Uri形式，但是在拍照中有得机子呢Uri是空的，所以要特别注意
		final Uri mImageCaptureUri =Crop.getOutput(data);
		
		// 返回的Uri不为空时，那么图片信息数据都会在Uri中获得。如果为空，那么我们就进行下面的方式获取	
		
		final Bitmap image;
		final ProgressDialog dialog = new ProgressDialog(this);
		dialog.show();
		dialog.setCanceledOnTouchOutside(false);
		dialog.setMessage(getString(R.string.Uploading_Photos));
		
		
		
		image = BitmapFactory.decodeFile(mImageCaptureUri.getPath());
		try {
			Bitmap bmp = Utils.getRoundCornerBitmap(image);
			mAvatar.setImageBitmap(bmp);
//			try {
//				bg_layout.setBackgroundDrawable(Utils.BoxBlurFilter(bmp));
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// findViewById(R.id.image_Bg).setBackgroundColor(getResources().getColor(R.color.white));
		new Thread() {
			@Override
			public void run() {
				setBitmap(mAvatar, mImageCaptureUri.getPath());
				dialog.dismiss();
			}
		}.start();
		
//		if (mImageCaptureUri != null) {
//			try {
//				
//				Cursor cursor = this.getContentResolver().query(mImageCaptureUri, null, null, null, null);
//				if (cursor != null && cursor.moveToNext()) {
//					
//					int id = cursor.getInt(cursor.getColumnIndex(VideoColumns._ID));
//					final String filePath = cursor.getString(cursor.getColumnIndex(VideoColumns.DATA));
//					image = Thumbnails.getThumbnail(getContentResolver(), id, Thumbnails.MICRO_KIND, null);
//					
//					
//					try {
//						Bitmap bmp = Utils.getRoundCornerBitmap(image);
//						mAvatar.setImageBitmap(bmp);
////						try {
////							bg_layout.setBackgroundDrawable(Utils.BoxBlurFilter(bmp));
////						} catch (Exception e) {
////							e.printStackTrace();
////						}
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
//					// findViewById(R.id.image_Bg).setBackgroundColor(getResources().getColor(R.color.white));
//					new Thread() {
//						@Override
//						public void run() {
//							setBitmap(mAvatar, filePath);
//							dialog.dismiss();
//						}
//					}.start();
//					cursor.close();
//				}						
//				
//			} catch (Exception e) {
//				dialog.dismiss();
//				e.printStackTrace();
//			}
//		} else {
//			Bundle extras = data.getExtras();
//			if (extras != null) {
//				// 这里是有些拍照后的图片是直接存放到Bundle中的所以我们可以从这里面获取Bitmap图片
//				image = extras.getParcelable("data");
//				if (image != null) {
//					try {
//						Bitmap bmp = Utils.getRoundCornerBitmap(image);
//						mAvatar.setImageBitmap(bmp);
////						bg_layout.setBackgroundDrawable(Utils.BoxBlurFilter(bmp));
//					} catch (Exception e) {
//						e.printStackTrace();
//					}
////					findViewById(R.id.image_Bg).setBackgroundColor(getResources().getColor(R.color.white));
//					ShowDialog.showProgressDialog(mContext, "正在上传，请稍等...", true);
//					new Thread() {
//						@Override
//						public void run() {
//							saveBitmap(image);
//							dialog.dismiss();
//						}
//					}.start();
//				}
//			}
//		}
		
	}
	
	
	private String cropImageName = "";
	
	
	/*private void startCropImage(Uri uri) {
		cropImageName = Environment.getExternalStorageDirectory() + "/temp_"+System.currentTimeMillis()+".jpg";
        Intent intent = new Intent(this, CropImage.class);
        intent.setData(uri);
        intent.putExtra(CropImage.OUT_PATH, cropImageName);
        intent.putExtra(CropImage.SCALE, true);

        intent.putExtra(CropImage.ASPECT_X, 400);
        intent.putExtra(CropImage.ASPECT_Y, 400);
        intent.putExtra(CropImage.OUTPUT_X, 400);
        intent.putExtra(CropImage.OUTPUT_Y, 400);

        startActivityForResult(intent, 3);
    }
	
	
	private void endofImageCrop02(Intent data){
		String path = data.getStringExtra(CropImage.OUT_PATH);
        if (path == null) {
            return;
        } 
		
        final Bitmap image;
		final ProgressDialog dialog = new ProgressDialog(this);
		dialog.show();
		dialog.setCanceledOnTouchOutside(false);
		dialog.setMessage(getString(R.string.Uploading_Photos));
		
		try {
			final String filePath = path;
			image = BitmapFactory.decodeFile(filePath);		
			try {
				Bitmap bmp = Utils.getRoundCornerBitmap(image);
				mAvatar.setImageBitmap(bmp);
//				try {
//					bg_layout.setBackgroundDrawable(Utils.BoxBlurFilter(bmp));
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			ShowDialog.showProgressDialog(mContext, "正在上传，请稍等...", true);
			new Thread() {
				@Override
				public void run() {
					setBitmap(mAvatar, filePath);
					dialog.dismiss();
				}
			}.start();
		} catch (Exception e) {
			e.printStackTrace();
			dialog.dismiss();
		}
		
	}*/
	
	
	private Uri tempImage = null;
	
	private void getPicFromCapture() {
		try {
			// 拍照我们用Action为MediaStore.ACTION_IMAGE_CAPTURE，
			// 有些人使用其他的Action但我发现在有些机子中会出问题，所以优先选择这个
			Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
			intent.setAction(MediaStore.ACTION_IMAGE_CAPTURE);
			tempImage = Uri.fromFile(new File(Environment.getExternalStorageDirectory(), "temp.jpg"));
			intent.putExtra(MediaStore.EXTRA_OUTPUT, tempImage);
			startActivityForResult(intent, 1);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void getPicFromContent() {
		try {
			// 选择照片的时候也一样，我们用Action为Intent.ACTION_GET_CONTENT，
			// 有些人使用其他的Action但我发现在有些机子中会出问题，所以优先选择这个
			Intent intent = new Intent(Intent.ACTION_PICK);
			intent.setType("image/*");// 相片类型
			startActivityForResult(intent, 2);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
