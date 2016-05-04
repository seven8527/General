package com.zhicheng.collegeorange.main;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.view.inputmethod.InputMethodManager;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.database.ViewpointDBHelper;
import com.zhicheng.collegeorange.model.Circle;
import com.zhicheng.collegeorange.profile.LoginActivity;
import com.zhicheng.collegeorange.utils.BitmapUtil;
import com.zhicheng.collegeorange.utils.CompleteActionPlusActivity;
import com.zhicheng.collegeorange.utils.DateUtil;
import com.zhicheng.collegeorange.utils.FileUtils;
import com.zhicheng.collegeorange.utils.ImagePagerActivity;
import com.zhicheng.collegeorange.utils.StringUtil;
import com.zhicheng.collegeorange.utils.ToastUtil;
import com.zhicheng.collegeorange.utils.photoalbum.PhotoAlbumActivity;
import com.zhicheng.collegeorange.view.MyGridView;
import com.zhicheng.collegeorange.view.RandomUtils;


public class ActivityShare extends Activity {
	
	public static final String EXTRA_SHARE_TYPE = "EXTRA_SHARE_TYPE";
	public static final String EXTRA_VIDEO_PATH = "EXTRA_VIDEO_PATH";
	public static final int SHARE_TYPE_NORMAL = 0;
	public static final int SHARE_TYPE_VDIEO = 1;
	
	//最大话题字数
	public static final int MAX_SHARE = 1000;
	private TextView preview;
	private EditText editText;
	private MyGridView gridView;
	private TextView locationView;
	private ScrollView scrollView;
	private InputMethodManager imm;
	private String mLocation = "";
	private final static int REQUEST_CODE = 100;
	private final static int REQUEST_PREVIEW_CODE = 101;
	private final static int REQUEST_LOCATION_CODE = 102;
	private static final int CAMERA = 103;
	private AddImageAdapter imageAdapter;
	private ArrayList<HashMap<String, String>> mData = new ArrayList<HashMap<String, String>>();
	protected ImageLoader imageLoader = ImageLoader.getInstance();
	private DisplayImageOptions options;
	SharedHelper helper;
	private View rl_layout;
	private View view_layout;
	//private ImageButton videoThumbImage;
	//private View video_layout;
	
	private int shareType = SHARE_TYPE_NORMAL;
	
	private String videoPath = "";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		final int temp = SharedHelper.getShareHelper(this).getInt(SharedHelper.WHICH_ME, 0);
		if (temp == 0){			
			sendBroadcast(new Intent("CANCEL_NOTIFICTION"));
			Intent intent = new Intent(this,LoginActivity.class);
			startActivity(intent);
			finish();
    	}
		
		setContentView(R.layout.activity_share);
		helper = SharedHelper.getShareHelper(ActivityShare.this);
		imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		initTitle();
		initView();
		
		//if (TextUtils.isEmpty(helper.getString("avatar", ""))) {
			getUser();
		//}
		//initData();
		
		initShareData();
	}	
	
	private Bitmap compressImage(Bitmap image) {

		ByteArrayOutputStream baos = new ByteArrayOutputStream();         
	    image.compress(Bitmap.CompressFormat.JPEG, 50, baos);  
	    if( baos.toByteArray().length / 1024>1024) {//判断如果图片大于1M,进行压缩避免在生成图片（BitmapFactory.decodeStream）时溢出    
	        baos.reset();//重置baos即清空baos  
	        image.compress(Bitmap.CompressFormat.JPEG, 30, baos);//这里压缩50%，把压缩后的数据存放到baos中  
	    }  
	    ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());  
	    BitmapFactory.Options newOpts = new BitmapFactory.Options();  
	   
	    newOpts.inJustDecodeBounds = true;  
	    Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, newOpts);  
	    newOpts.inJustDecodeBounds = false;  
	    int w = newOpts.outWidth;  
	    int h = newOpts.outHeight;  
	
	    float hh = 800f;
	    float ww = 480f; 
	    //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可  
	    int be = 1;//be=1表示不缩放  
	    if (w > h && w > ww) {//如果宽度大的话根据宽度固定大小缩放  
	        be = (int) (newOpts.outWidth / ww);  
	    } else if (w < h && h > hh) {//如果高度高的话根据宽度固定大小缩放  
	        be = (int) (newOpts.outHeight / hh);  
	    }  
	    if (be <= 0)  
	        be = 1;  
	    newOpts.inSampleSize = be;//设置缩放比例  
 
	    isBm = new ByteArrayInputStream(baos.toByteArray());  
	    bitmap = BitmapFactory.decodeStream(isBm, null, newOpts);  
	    return bitmap;
	}
	
    private static int calculateInSampleSize(BitmapFactory.Options options,  
            int reqWidth, int reqHeight) {  
        // Raw height and width of image  
        final int height = options.outHeight;  
        final int width = options.outWidth;  
        int inSampleSize = 1;  
  
        if (height > reqHeight || width > reqWidth) {  
  
            // Calculate ratios of height and width to requested height and  
            // width  
            final int heightRatio = Math.round((float) height  
                    / (float) reqHeight);  
            final int widthRatio = Math.round((float) width / (float) reqWidth);  
  
            // Choose the smallest ratio as inSampleSize value, this will  
            // guarantee  
            // a final image with both dimensions larger than or equal to the  
            // requested height and width.  
            inSampleSize = heightRatio < widthRatio ? widthRatio : heightRatio;  
        }  
  
        return inSampleSize;  
    }  
	private void initTitle() {
		try {
			findViewById(R.id.title_back).setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					determineExit();
				}
			});

			TextView titleView = (TextView) findViewById(R.id.title_middle1);
			titleView.setText("分享");
		} catch (Exception e) {
			e.printStackTrace();
		}
		scrollView = (ScrollView)findViewById(R.id.share_edit_scroll);
		preview = (TextView) findViewById(R.id.title_right_textview);
		preview.setVisibility(View.VISIBLE);
		preview.setText("发表");
		preview.setEnabled(false);
		preview.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					
					String myName = helper.getString(SharedHelper.USER_NAME, "");
					String mTime = DateUtil.currentFormatDate();
					String id = RandomUtils.generateMixString(20);
					
					Circle circle = new Circle();
					circle.setmId(id);
					circle.setmPhoneNum(myName);
					circle.setmTime(mTime);

					circle.setmPosition(mLocation);
					circle.hasZan = false;
					
					if(shareType == SHARE_TYPE_NORMAL){
						
						if((mData == null || mData.isEmpty() || mData.size() < 2) && TextUtils.isEmpty(editText.getEditableText().toString().trim())){
							return;
						}
						
						if ( (mData == null || mData.isEmpty()) && TextUtils.isEmpty(editText.getEditableText().toString().trim())) {
							Toast.makeText(ActivityShare.this, "请选择图片", Toast.LENGTH_SHORT).show();
							return;
						}
						
						ArrayList<String> list = new ArrayList<String>();
						for (int i = 0; i < mData.size(); i++) {
							if (mData.get(i).get("pic") != null) {
								if (!TextUtils.isEmpty(mData.get(i).get("pic"))) {
									list.add(mData.get(i).get("pic"));
								}
							}
						}
						
						circle.setmPicPaths(list);
						
						if(list.size() == 1){						
							try {
								String fileName = list.get(0);
								final BitmapFactory.Options options = new BitmapFactory.Options();  
							    options.inJustDecodeBounds = true;  
							    BitmapFactory.decodeFile(fileName, options);  							    
							    // Calculate inSampleSize  
							    options.inSampleSize = calculateInSampleSize(options, 480, 800);  
							  
							    // Decode bitmap with inSampleSize set  
							    options.inJustDecodeBounds = false;  
								Bitmap bmp = BitmapFactory.decodeFile(fileName);
//								bmp =compressImage(bmp);

								int degree = getBitmapDegree(fileName);
								if(degree == 90 || degree == 270){
									circle.setImageWidth(bmp.getHeight());
									circle.setImageHeight(bmp.getWidth());
								}else{
									circle.setImageWidth(bmp.getWidth());
									circle.setImageHeight(bmp.getHeight());
								}
								
							} catch (Exception e) {
								e.printStackTrace();
								circle.setImageWidth(0);
								circle.setImageHeight(0);
							}
						}else{
							circle.setImageWidth(0);
							circle.setImageHeight(0);
						}
						
					}else if(shareType == SHARE_TYPE_VDIEO){
						/*if(TextUtils.isEmpty(videoPath)){
							return;
						}
						circle.setmVideo(videoPath);
						circle.setVideoWidth(MediaRecorderBase.VIDEO_WIDTH);
						circle.setVideoHeight(MediaRecorderBase.VIDEO_HEIGHT);*/
					}
					
					//circle.setmContent(EmojiconHandler.initEmoji(ActivityShare.this,editText.getEditableText().toString()));
					circle.setmContent(editText.getEditableText().toString());
					boolean isSuccess = ViewpointDBHelper.GetInstance(ActivityShare.this).insertCircleInfo(ActivityShare.this, circle, true, false, true);
					if(isSuccess){
						Intent service = new Intent();
						service.putExtra("circle", circle);
						service.setClass(ActivityShare.this, ShareService.class);
						startService(service);
						finish();	
					}else{
						ToastUtil.showToast(getApplicationContext(), "数据保存失败，请重试！");
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	private int getBitmapDegree(String path) {
	    int degree = 0;
	    try {
	        // 从指定路径下读取图片，并获取其EXIF信息
	        ExifInterface exifInterface = new ExifInterface(path);
	        // 获取图片的旋转信息
	        int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION,
	                ExifInterface.ORIENTATION_NORMAL);
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
	        }
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
	    return degree;
	}
	
	
	private void initView() {
		rl_layout = findViewById(R.id.rl_layout);
		view_layout = findViewById(R.id.view_layout);
		editText = (EditText) findViewById(R.id.input_content);
		gridView = (MyGridView) findViewById(R.id.gridView);
		locationView = (TextView) findViewById(R.id.location);
		
		editText.setFilters(new InputFilter[]{ new InputFilter.LengthFilter(MAX_SHARE)});
		editText.addTextChangedListener(textWatcher);
		findViewById(R.id.layout_location).setOnClickListener(onClickListener);
		//videoThumbImage.setOnClickListener(onClickListener);
		
		options = new DisplayImageOptions.Builder().showImageOnLoading(R.drawable.gray_bg).showImageForEmptyUri(R.drawable.gray_bg)
				.showImageOnFail(R.drawable.gray_bg).cacheInMemory(true).cacheOnDisk(true).considerExifParams(true).resetViewBeforeLoading(true).build();
		editText.setOnClickListener(onClickListener);
		editText.setOnFocusChangeListener(new View.OnFocusChangeListener() {
			
			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				// 				
				//findViewById(R.id.emoji_open_btn).setVisibility(hasFocus ? View.VISIBLE : View.GONE);
			}
		});
		//findViewById(R.id.layout_emoji).setVisibility(View.VISIBLE);
		
	}
	
	public void initShareData(){
		 // Get intent, action and MIME type  
        Intent intent = getIntent();  
        String action = intent.getAction();  
        String type = intent.getType();  
  
        if (Intent.ACTION_SEND.equals(action) && type != null) {
        	
            if ("text/plain".equals(type)) {            	
                handleSendText(intent);                 
            } else if (type.startsWith("image/")) {              	
                handleSendImage(intent);               
            }  
            
        } else if (Intent.ACTION_SEND_MULTIPLE.equals(action) && type != null) {  
            if (type.startsWith("image/")) {  
                handleSendMultipleImages(intent);   
            }  
        }  else {             
        	initData();        	
        }  
	}
	
	private void handleSendText(Intent intent){
		String sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);  
        String sharedTitle = intent.getStringExtra(Intent.EXTRA_TITLE);  
        if (sharedText != null) { 
        	
        	//video_layout.setVisibility(View.GONE);
			gridView.setVisibility(View.GONE);
			
			editText.setText(sharedText);
			
			preview.setEnabled(true);		
        }  
	}
	
	private void handleSendImage(Intent intent){
		 Uri imageUri = (Uri) intent.getParcelableExtra(Intent.EXTRA_STREAM);  
	     if (imageUri != null) { 
	    	 
	    	 	//video_layout.setVisibility(View.GONE);
				gridView.setVisibility(View.VISIBLE);
				
				ArrayList<String> mfolderPhoto = new ArrayList<String>();
				String imagePath = imageUri.getPath();
				if(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT){
					imagePath = FileUtils.getImageAbsolutePath(this, imageUri);
				}				
				mfolderPhoto.add(imagePath);
				preview.setEnabled(true);
				ArrayList<HashMap<String, String>> images = new ArrayList<HashMap<String, String>>();
				images.addAll(mData);
				for (int i = 0; i < images.size(); i++) {
					if (images.get(i).get("type") != null && images.get(i).get("type").equals("add")) {
						mData.remove(mData.get(i));
					}
				}

				for (String item : mfolderPhoto) {
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("pic", item);
					mData.add(map);
				}

				if (mData.size() < MAX_ImageCount) {
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("type", "add");
					mData.add(map);
				}

				imageAdapter = new AddImageAdapter(ActivityShare.this, mData);
				gridView.setAdapter(imageAdapter);   
	     }  
	}
	
	private void handleSendMultipleImages(Intent intent) {  
        ArrayList<Uri> imageUris = intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM);  
        if (imageUris != null) {  
        	//video_layout.setVisibility(View.GONE);
			gridView.setVisibility(View.VISIBLE);
			
			ArrayList<String> mfolderPhoto = new ArrayList<String>();
			
			for(int i = 0; i < MAX_ImageCount && i < imageUris.size() ;i++){
				mfolderPhoto.add(imageUris.get(i).getPath());
			}		
			
			preview.setEnabled(true);
			ArrayList<HashMap<String, String>> images = new ArrayList<HashMap<String, String>>();
			images.addAll(mData);
			for (int i = 0; i < images.size(); i++) {
				if (images.get(i).get("type") != null && images.get(i).get("type").equals("add")) {
					mData.remove(mData.get(i));
				}
			}

			for (String item : mfolderPhoto) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("pic", item);
				mData.add(map);
			}

			if (mData.size() < MAX_ImageCount) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("type", "add");
				mData.add(map);
			}

			imageAdapter = new AddImageAdapter(ActivityShare.this, mData);
			gridView.setAdapter(imageAdapter);   
        }  
    }  

	public static final int MAX_ImageCount = 9;
	
	private void initData() {		
		shareType = getIntent().getIntExtra(EXTRA_SHARE_TYPE, SHARE_TYPE_NORMAL);
		if(shareType == SHARE_TYPE_NORMAL){
			//video_layout.setVisibility(View.GONE);
			gridView.setVisibility(View.VISIBLE);
			ArrayList<String> mfolderPhoto = (ArrayList<String>) getIntent().getSerializableExtra("pic");
			if (mfolderPhoto == null) {
				if (TextUtils.isEmpty(editText.getEditableText().toString().trim())) {
					preview.setEnabled(false);
				}
				return;
			}

			preview.setEnabled(true);

			ArrayList<HashMap<String, String>> images = new ArrayList<HashMap<String, String>>();
			images.addAll(mData);
			for (int i = 0; i < images.size(); i++) {
				if (images.get(i).get("type") != null && images.get(i).get("type").equals("add")) {
					mData.remove(mData.get(i));
				}
			}

			for (String item : mfolderPhoto) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("pic", item);
				mData.add(map);
			}

			if (mData.size() < MAX_ImageCount) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("type", "add");
				mData.add(map);
			}

			imageAdapter = new AddImageAdapter(ActivityShare.this, mData);
			gridView.setAdapter(imageAdapter);
			
		}else if(shareType == SHARE_TYPE_VDIEO){
			//video_layout.setVisibility(View.VISIBLE);
			gridView.setVisibility(View.GONE);
			preview.setEnabled(true);
			preview.setTextColor(getResources().getColor(R.color.title_text_right));
			try {
				videoPath = getIntent().getStringExtra(EXTRA_VIDEO_PATH);		
				//videoThumbImage.setBackground(new BitmapDrawable(BitmapUtil.createVideoThumbnail(videoPath)));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			
		}
		
		
		
	}

	private OnClickListener onClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.layout_location:{
				Intent intent = new Intent();
				String str = locationView.getText().toString();
				if(!TextUtils.isEmpty(str)
						&& str.contains(".")){
					int index = str.indexOf(".");
					str = str.substring(index+1);
				}
				intent.putExtra("location", str);
				intent.setClass(ActivityShare.this, ActivityShareLocation.class);
				startActivityForResult(intent, REQUEST_LOCATION_CODE);
			}				
				break;
			case R.id.input_content:
			{
			}
				break;
		
			default:
				break;
			}

		}
	};

	private TextWatcher textWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			if(s.toString().trim().length() >= MAX_SHARE){
				Toast.makeText(ActivityShare.this, "文字长度已到最大！", Toast.LENGTH_SHORT).show();
			}
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {

		}

		@Override
		public void afterTextChanged(Editable s) {
			String input = String.valueOf(s);
			if ((TextUtils.isEmpty(input) || TextUtils.isEmpty(input.trim()))&& (null == mData || 2 > mData.size())) {
				//if(video_layout.getVisibility()==View.VISIBLE)return;
				preview.setEnabled(false);
				preview.setTextColor(getResources().getColor(R.color.transparent_white));
			} else {
				preview.setEnabled(true);
				preview.setTextColor(getResources().getColor(R.color.title_text_right));
			}
			
		}
	};
	
	@Override
	protected void onResume() {
		super.onResume();
		try {
			/*if (emojiLayout.isOpen()) {
				findViewById(R.id.emoji_open_btn).setBackgroundResource(R.drawable.chat_icon_smiles_pressed);
			} else {			
				findViewById(R.id.emoji_open_btn).setBackgroundResource(R.drawable.chat_icon_smiles);
			}*/
		} catch (Exception e) {
			e.printStackTrace();
		}
	};

	class AddImageAdapter extends BaseAdapter {

		Context context;
		private LayoutInflater inflater;
		private ArrayList<HashMap<String, String>> data;

		public AddImageAdapter(Context context, ArrayList<HashMap<String, String>> data) {
			this.context = context;
			this.data = data;
			inflater = LayoutInflater.from(context);
		}

		@Override
		public int getCount() {
			return data.size();
		}

		@Override
		public Object getItem(int position) {
			return data.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder holder = null;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = (View) inflater.inflate(R.layout.addfriends_pic_item, null);
				holder.image = (ImageView) convertView.findViewById(R.id.pic_imageview);

				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}

			Map map = data.get(position);
			final int mPosition = position;
			Object type = map.get("type");
			if (type != null && type.toString().equals("add")) {
				holder.image.setImageResource(R.drawable.add_btn_bg);
				holder.image.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View arg0) {
						Animation anim = new AlphaAnimation(0.0f, 1.0f);
						anim.setDuration(500);
						view_layout.setVisibility(View.VISIBLE);
						view_layout.setAnimation(anim);
						
						List<String> name = new ArrayList<String>();
						name.add("拍照");
						name.add("从手机相册选择");
						mCompleteActionPlusActivity = new CompleteActionPlusActivity(ActivityShare.this, name, onShareClickListener, null,mHandler);
						mCompleteActionPlusActivity.setAnimationStyle(R.style.AnimBottom);
						mCompleteActionPlusActivity.showAtLocation(ActivityShare.this.findViewById(R.id.share_layout), Gravity.BOTTOM
								| Gravity.CENTER_HORIZONTAL, 0, 0); // 设置layout在PopupWindow中显示的位置
						
						imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
						
						ScaleAnimation myAnimation_Scale = new ScaleAnimation(1.0f, 0.9f, 1.0f, 0.9f,   
					             Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,  0.5f);   
						myAnimation_Scale.setDuration(500);
						myAnimation_Scale.setFillAfter(true);
						rl_layout.startAnimation(myAnimation_Scale);
					}
				});
			} else {
				String imagePath = (String) map.get("pic");
				if (!imagePath.startsWith("file://")) {
					if (!imagePath.startsWith("http://") && (imagePath.contains("sdcard") || imagePath.contains("storage"))) {
						imagePath = "file://" + imagePath;
					} else if (!imagePath.startsWith("http://")) {
						imagePath = Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD_IMAGE + imagePath + "&mode=original";
					}
				}
				// imageLoader.displayImage(imagePath, holder.image);
				imageLoader.displayImage(imagePath, holder.image, options);
				holder.image.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View arg0) {
						try {
							if(data != null){
								ArrayList<String> strings = new ArrayList<String>();
								for (HashMap<String, String> hashMap : data) {
									if (hashMap.get("pic") != null) {
										strings.add(hashMap.get("pic"));
									}
								}
								if (strings != null && strings.size() > 0){
									Intent intent = new Intent(ActivityShare.this, ImagePagerActivity.class);
									intent.putExtra("imageList", strings);
									intent.putExtra("position", mPosition);
									intent.putExtra("booshare", true);
									intent.putExtra("sd_pic", true);
									startActivityForResult(intent, REQUEST_PREVIEW_CODE);
								}
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				});
			}
			return convertView;
		}

		class ViewHolder {
			public ImageView image;
		}
	}
	
	private Handler mHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 101:
				goback();
				break;
			}
		}
	};

	private void goback() {
		ScaleAnimation myAnimation_Scale =new ScaleAnimation(0.9f, 1.0f, 0.9f, 1.0f,   
	             Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,  0.5f);   
		myAnimation_Scale.setDuration(500);
		myAnimation_Scale.setFillAfter(true);
		rl_layout.startAnimation(myAnimation_Scale);
		
		
		view_layout.setVisibility(View.GONE);
		Animation animation = new AlphaAnimation(1.0f, 0.0f);
		animation.setDuration(500);
		view_layout.setAnimation(animation);
		if (mCompleteActionPlusActivity != null) {
			mCompleteActionPlusActivity.setAnimationStyle(R.style.AnimTop2);
		}
	}
	
	CompleteActionPlusActivity mCompleteActionPlusActivity = null;
	private OnClickListener onShareClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			mCompleteActionPlusActivity.dismiss();
			switch (v.getId()) {
			case R.id.exitBtn0:
				takePicture();
				break;
			case R.id.exitBtn1:
				Intent i = new Intent(ActivityShare.this, PhotoAlbumActivity.class);
				i.putExtra("share", true);
				i.putExtra("shareNum", mData.size() - 1);
				startActivityForResult(i, REQUEST_CODE);
				break;
			default:
				goback();
				break;
			}
		}
	};

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == REQUEST_CODE) {
			if (resultCode == RESULT_CANCELED) {
				return;
			} else if (resultCode == RESULT_OK) {
				ArrayList<String> mfolderPhoto = new ArrayList<String>();
				if (data != null) {
					mfolderPhoto = (ArrayList<String>) data.getSerializableExtra("pic");
					if (data.getBooleanExtra("share", false)) {
						/*for (HashMap<String, String> hashMap : mData) {
							if (hashMap.get("pic") != null) {
								mfolderPhoto.add(hashMap.get("pic"));
							}
						}
						mData.clear();*/
						
						for (int i = 0; i < mData.size(); i++) {
							if (mData.get(i).get("type") != null && mData.get(i).get("type").equals("add")) {
								mData.remove(mData.get(i));
							}
						}
						
						for (String item : mfolderPhoto) {
							HashMap<String, String> map = new HashMap<String, String>();
							map.put("pic", item);
							mData.add(map);
						}

						if (mData.size() < MAX_ImageCount && mData.size()!=0) {
							HashMap<String, String> map = new HashMap<String, String>();
							map.put("type", "add");
							mData.add(map);
						}

						imageAdapter = new AddImageAdapter(ActivityShare.this, mData);
						gridView.setAdapter(imageAdapter);
					} else {
						putPicInGrid(mfolderPhoto);
					}
					
					refreshBtn();
				}
				return;
			}
		} else if (requestCode == REQUEST_PREVIEW_CODE) {
			if (resultCode == RESULT_CANCELED) {
				return;
			} else if (resultCode == RESULT_OK) {
				if (data != null) {
					ArrayList<String> folderPhoto = (ArrayList<String>) data.getSerializableExtra("pic");
					if (folderPhoto == null || folderPhoto.isEmpty()) {
						mData.clear();
						HashMap<String, String> map = new HashMap<String, String>();
						map.put("type", "add");
						mData.add(map);
					}else{

						mData.clear();
						for (String item : folderPhoto) {
							HashMap<String, String> map = new HashMap<String, String>();
							map.put("pic", item);
							mData.add(map);
						}

//						if (mData.size() < 8&&mData.size()!=0) {
					    if (mData.size() < MAX_ImageCount) {
							HashMap<String, String> map = new HashMap<String, String>();
							map.put("type", "add");
							mData.add(map);
						}
					}

					imageAdapter = new AddImageAdapter(ActivityShare.this, mData);
					gridView.setAdapter(imageAdapter);
					
					refreshBtn();
				}
				return;
			}
		} else if (requestCode == REQUEST_LOCATION_CODE) {
			if (resultCode == RESULT_CANCELED) {
				return;
			} else if (resultCode == RESULT_OK) {
				if (data != null) {
					mLocation = data.getStringExtra("location");
				}
				if (!mLocation.equals("")) {
					locationView.setText(mLocation);
				}else{
					locationView.setText("");
				}
				return;
			}
		} else if (requestCode == CAMERA) {
			if (resultCode == RESULT_OK) {
				String path = picFileFullName.getPath();
				if (!TextUtils.isEmpty(path)) {
					ArrayList<String> folderPhoto = new ArrayList<String>();
					folderPhoto.add(path);
					putPicInGrid(folderPhoto);
				}
				refreshBtn();
				return;
			} else {
				// 图像捕获失败，提示用户
				Log.e("", "拍照失败");
			}
		}
	}
	
	private void refreshBtn(){
		try {
			String str = editText.getText().toString().trim();
			if((null == mData || 2 > mData.size()) && TextUtils.isEmpty(str)){
				preview.setTextColor(getResources().getColor(R.color.transparent_white));
			}else
				preview.setTextColor(getResources().getColor(R.color.title_text_right));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void putPicInGrid(ArrayList<String> folderPhoto) {
		ArrayList<String> mfolderPhoto = folderPhoto;
		try {
			if (mfolderPhoto == null || mfolderPhoto.size() <= 0) {
				if (TextUtils.isEmpty(editText.getText().toString().trim())) {
					preview.setEnabled(false);
				}
				return;
			}

			preview.setEnabled(true);

			ArrayList<HashMap<String, String>> images = new ArrayList<HashMap<String, String>>();
			images.addAll(mData);
			for (int i = 0; i < images.size(); i++) {
				if (images.get(i).get("type") != null && images.get(i).get("type").equals("add")) {
					mData.remove(mData.get(i));
				}
			}

			for (String item : mfolderPhoto) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("pic", item);
				mData.add(map);
			}

			if (mData.size() < MAX_ImageCount && mData.size()!=0) {
				HashMap<String, String> map = new HashMap<String, String>();
				map.put("type", "add");
				mData.add(map);
			}

			imageAdapter = new AddImageAdapter(ActivityShare.this, mData);
			gridView.setAdapter(imageAdapter);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private Uri picFileFullName;

	public void takePicture() {
		String state = Environment.getExternalStorageState();
		if (state.equals(Environment.MEDIA_MOUNTED)) {
			Intent i = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);// 相机捕捉图片的意图
			SimpleDateFormat timesdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String FileTime = timesdf.format(new Date()).toString() + ".jpeg";// 获取
			File file = new File(Environment.getExternalStorageDirectory() + "/TomoonPictrue", FileTime);
			file.getParentFile().mkdirs();
			picFileFullName = Uri.fromFile(file);
			i.putExtra(MediaStore.EXTRA_OUTPUT, picFileFullName);// 指定系统相机拍照保存在imageFileUri所指的位置
			startActivityForResult(i, CAMERA);
		} else {
			Log.e("", "请确认已经插入SD卡");
		}
	}

	private void determineExit(){
		
		if(checkEditInfo()){
			new AlertDialog.Builder(this)
			.setMessage("确定要退出编辑吗？")
			.setPositiveButton("确定", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialoginterface, int i) {
	                finish();
				}
			})
			.setNegativeButton("取消", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int whichButton) {
					// 取消按钮事件
				}
			}).show();
		}else{
			finish();
		}	
	}
	
	private boolean checkEditInfo(){
		String inputStr = editText.getEditableText().toString().trim();
		if(!TextUtils.isEmpty(inputStr)){
			return true;
		}
		
		if(!TextUtils.isEmpty(videoPath)){
			return true;
		}
		
		if (mData != null && mData.size() > 1) {
			return true;
		}		
		
		return false;
	}
	
	@Override
	public void onBackPressed() {
		determineExit();
	}
	
	
	private void getUser() {
		new Thread(new Runnable() {
			@Override
			public void run() {
				getUserInfo();
			}
		}).start();
	}

	private void getUserInfo() {
		try {
			JSONObject obj = new JSONObject();
			obj.put("userName",
					helper.getString(SharedHelper.USER_NAME, ""));
			//Log.e("response++++++++++++++", "start");
			HttpResponse response = Utils.getResponse(this,Utils.REMOTE_SERVER_URL,
					"getUserProfile", obj,  30000,	30000);
			//Log.e("response++++++++++++++", "end");
			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return;
			}
			int resultCode = Integer.valueOf(response
					.getHeaders(Utils.URL_KEY_RESULT_CODE)[0].getValue() + "");
			if (resultCode == 2002) {
			} else if (resultCode == 9990) {
			} else if (resultCode == 0) {
				String userInfo = EntityUtils.toString(response.getEntity());
				/*FileUtils.saveObjectToFile(ActivityShare.this, "userJson",
						userInfo);*/
				JSONObject json = new JSONObject(userInfo);
				String Nickname = json.getString("Nickname");
				String Avatar = json.getString("Avatar");
				if (!TextUtils.isEmpty(Nickname)) {
					helper
							.putString(SharedHelper.USER_NICKNAME, Nickname);
				}
				if (!TextUtils.isEmpty(Avatar)) {
					helper.putString("avatar", Avatar);
					imageLoader.displayImage(
							Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD + Avatar
									+ "&mode=original", new ImageView(this));
					// imageLoader.displayImage(Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD
					// + Avatar + "&mode=original", new ImageView(this),
					// options);
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
	}
}
