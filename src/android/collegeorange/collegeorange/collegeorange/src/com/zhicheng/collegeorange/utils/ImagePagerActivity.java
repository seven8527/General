package com.zhicheng.collegeorange.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import uk.co.senab.photoview.PhotoView;
import uk.co.senab.photoview.PhotoViewAttacher.OnPhotoTapListener;
import android.app.Activity;
import android.app.Dialog;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Parcelable;
import android.provider.MediaStore;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.animation.AnimationSet;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingProgressListener;
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener;
import com.nostra13.universalimageloader.utils.MemoryCacheUtils;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.database.ViewpointDBHelper;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.model.Share;
import com.zhicheng.collegeorange.view.HackyViewPager;

public class ImagePagerActivity extends Activity {

	private static final String STATE_POSITION = "STATE_POSITION";
	public static final String SHOW_DICATOR = "SHOW_DICATOR";

	DisplayImageOptions options;
	HackyViewPager pager;
	View title;
	private String mMessageType = "user_image";
	protected ImageLoader imageLoader = ImageLoader.getInstance();

	private boolean isSDPicPreview;
	private RelativeLayout bottomLayout;
	private TextView shareContent;
	private CheckBox imageCheck;
	private Share share;
	private boolean isShare;
	private boolean isDelete;
	private HashMap<String, String> mapContent = null;

	private boolean isShowDicator = true;
	private boolean isDeleteImage = false;
	public String myName;
	private String mySession;
	//public static String cacheUrl_org = "";
	//public static Bitmap cacheBitmap = null;
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
/*
		switch (id) {
		case R.id.action_saveing:
			
			
			return true;
		case R.id.action_forwarding:
			if (imageList == null)
				return true;
			String mPath = imageList.get(pager.getCurrentItem());
			Intent intent = new Intent(ImagePagerActivity.this,
					ChooseGroupMembers.class);
			Bundle bundle = new Bundle();
			bundle.putString("forwarding", mPath);
			intent.putExtra("noUpLoad", true);
			intent.putExtra("uploadName", uploadName);
			intent.putExtra("msgType", mMessageType);
			intent.putExtras(bundle);
			startActivity(intent);
			return true;
		case android.R.id.home:
			finish();
			return true;
		default:
			break;
		}*/
		return super.onOptionsItemSelected(item);
	}

	private void save() {
		try {
			String mPath = imageList.get(pager.getCurrentItem());
			SimpleDateFormat timesdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String saveFileName = timesdf.format(new Date()).toString() + ".jpeg";// 获取
			
			File tmpFile = null;
			
			String path = "";
			if (mPath.contains(Environment.getExternalStorageDirectory()
					.getPath())
					|| mPath.contains("sdcard")
					|| mPath.contains("storage")) {
				String string = Utils.initPath(mPath);
				if (string != null && !string.equals("")) {
					saveFileName = getLocalFileName(string) + ".jpeg";
					tmpFile = new File(Environment.getExternalStorageDirectory() + "/Pictrue", myName + saveFileName);
						
					if(tmpFile != null && tmpFile.exists()){
						Toast.makeText(ImagePagerActivity.this, "文件已经存在！",
								Toast.LENGTH_LONG).show();
						return ;
					}
					
					copyfile(new File(string), tmpFile, true);
					Toast.makeText(ImagePagerActivity.this, "保存文件成功。",
							Toast.LENGTH_LONG).show();
				} else {
					Toast.makeText(ImagePagerActivity.this, "保存文件失败。",
							Toast.LENGTH_LONG).show();
				}
				ShowDialog.closeProgressDialog();
				return;
			}  else {
				path = Utils.DOWNLOAD_PIC  + phoneName + "&session=" + mySession + "&fid=" + mPath
						+ "&size=orig";
			}
			
			saveFileName = getLocalFileName(path) + ".jpeg";
			tmpFile = new File(Environment.getExternalStorageDirectory() + "/Pictrue", myName + saveFileName);
				
			if(tmpFile != null && tmpFile.exists()){
				Toast.makeText(ImagePagerActivity.this, "文件已经存在！",
						Toast.LENGTH_LONG).show();
				return ;
			}

			
			File fromFile = imageLoader.getDiskCache().get(path);
			if (fromFile == null) {
				Toast.makeText(ImagePagerActivity.this, "保存文件失败。",
						Toast.LENGTH_LONG).show();
				ShowDialog.closeProgressDialog();
				return;
			}
			copyfile(fromFile, tmpFile, true);
			Toast.makeText(ImagePagerActivity.this, "保存文件成功。",
					Toast.LENGTH_LONG).show();
		} catch (Exception e) {
			Toast.makeText(ImagePagerActivity.this, "保存文件失败。",
					Toast.LENGTH_LONG).show();
			e.printStackTrace();
		}
	}
	
	boolean[] checkList;
	ArrayList<String> imageList;
	String uploadName;
	private String phoneName;
	private TextView titleRight;
	ImagePagerAdapter pagerAdapter;
	//ImageView mIndicator;
	int screenWidth = 720;
	int indicatorbgWidth = 700;
	//LayoutParams params;
	float indicatorWidth = 0;
	//View indicatorLayout;
	AnimationSet _AnimationSet;

	private SharedHelper mSharedHelper;
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.ac_image_pager);
		
		mSharedHelper = SharedHelper.getShareHelper(this);
		myName = mSharedHelper.getString(SharedHelper.USER_NAME, "");
		mySession = mSharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
		
		forceShowOverflowMenu();
		_AnimationSet = new AnimationSet(true);
		// actionBar = getSupportActionBar();
		screenWidth = getWindowManager().getDefaultDisplay().getWidth();
		indicatorbgWidth = screenWidth - 2 * BitmapUtil.dipToPx(this, 20);
		title = findViewById(R.id.title);
		title.setVisibility(View.INVISIBLE);
		findViewById(R.id.up).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if(isDeleteImage){
					Intent intent = new Intent();
					intent.putStringArrayListExtra("pic", imageList);
					setResult(RESULT_OK, intent);
					finish();
				}else{
					finish();	
				}				
			};
		});
		titleRight = (TextView) findViewById(R.id.action_bar_subtitle);
		
		bottomLayout = (RelativeLayout) findViewById(R.id.image_bottom_layout);
		/*imageCheck = (CheckBox) findViewById(R.id.image_check);

		imageCheck.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			
			@Override
			public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
				int index = pager.getCurrentItem();
				if(checkList != null && index < checkList.length && index >= 0){
					checkList[index] = isChecked;
				}
			}
		});*/
		
		Bundle bundle = getIntent().getExtras();
		
		assert bundle != null;
		imageList = bundle.getStringArrayList("imageList");
		if(imageList == null || imageList.size() < 1){
			finish();
			return ;
		}
		int pagerPosition = bundle.getInt("position", 0);
		String msgType = bundle.getString("msgType");
		phoneName = bundle.getString("phone");

		isSDPicPreview = bundle.getBoolean("sd_pic");
		share = (Share) bundle.getSerializable("share");
		// isShareDedail = bundle.getBoolean("share_dedail", false);
		isShare = bundle.getBoolean("booshare", false);
		isDelete = bundle.getBoolean("boodelete", false);
		isShowDicator = bundle.getBoolean(SHOW_DICATOR, true);
		
		mapContent = (HashMap<String, String>) bundle
				.getSerializable("share_content");
		
		/*try {
			if(!TextUtils.isEmpty(bundle.getString("cacheUri"))){
				cacheUrl = bundle.getString("cacheUri");
				cacheBitmap = bundle.getParcelable("cacheBitmap");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		/*if(isShare){
			checkList = new boolean[imageList.size()];
			for(int i = 0 ; i < checkList.length ; i++){
				checkList[i] = true;
			}
		}
*/
		if (TextUtils.isEmpty(phoneName) && share != null) {
			phoneName = share.getmPhoneNum();
		}

		if (!TextUtils.isEmpty(msgType)) {
			mMessageType = msgType;
		}
		uploadName = bundle.getString("uploadName");
		if (savedInstanceState != null) {
			pagerPosition = savedInstanceState.getInt(STATE_POSITION);
		}
		total = imageList.size();

		shareContent = (TextView) findViewById(R.id.share_content);

		//mIndicator = (ImageView) findViewById(R.id.indicator);
		//params = (LayoutParams) mIndicator.getLayoutParams();
		indicatorWidth = (float) indicatorbgWidth / (float) total;
		//params.width = (int) indicatorWidth;
		
		mStart = pagerPosition;
		
		pIndicatorLayout = (RelativeLayout)findViewById(R.id.point_indicatorLayout);
	    pointLayout = (LinearLayout)findViewById(R.id.point_layout);		
		
		/*mIndicator.setLayoutParams(params);	
		ViewHelper.setX(mIndicator, pagerPosition * indicatorWidth);*/
		
		if (total == 1) {
			//findViewById(R.id.indicatorBg).setVisibility(View.INVISIBLE);
			//mIndicator.setVisibility(View.INVISIBLE);
			pIndicatorLayout.setVisibility(View.INVISIBLE);
		}

		options = new DisplayImageOptions.Builder()
				.showImageOnFail(R.drawable.image_failed).cacheInMemory(true)
				.cacheOnDisk(true).considerExifParams(true)
				.resetViewBeforeLoading(true).build();
		//indicatorLayout = findViewById(R.id.indicatorLayout);
		pager = (HackyViewPager) findViewById(R.id.view_pager);
		pager.setOffscreenPageLimit(3);
		pagerAdapter = new ImagePagerAdapter(imageList);
		pager.setAdapter(pagerAdapter);
		pager.setOnPageChangeListener(changeListener);
		pager.setCurrentItem(pagerPosition);
		
		
		if (savedInstanceState != null) {
			boolean isLocked = savedInstanceState.getBoolean(ISLOCKED_ARG,
					false);
			pager.setLocked(isLocked);
		}

		setContent();

		if (isShare) {		
			
			titleRight.setText("删除");
			titleRight.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					
					int position = pager.getCurrentItem();
					if (isDelete) {
						File file = new File(imageList.get(position));
						ViewpointDBHelper.GetInstance(ImagePagerActivity.this)
								.deletePhoto(ImagePagerActivity.this,
										file.getAbsolutePath());
						file.delete();
					}
					imageList.remove(position);
					isDeleteImage = true;
					if (imageList.size() == 0) {
						Intent intent = new Intent();
						intent.putStringArrayListExtra("pic", imageList);
						setResult(RESULT_OK, intent);
						finish();
					} else {
						// raGrop_indicator.removeViewAt(raGrop_indicator.getChildCount()-1);
						pagerAdapter = new ImagePagerAdapter(imageList);
						pager.setAdapter(pagerAdapter);
						total = imageList.size();
						if (position > 0) {
							position = position - 1;
							pager.setCurrentItem(position);
						} else if (position == 0) {
							position = 0;
							pager.setCurrentItem(0);
						}
						
						/*params = (LayoutParams) mIndicator.getLayoutParams();
						indicatorWidth = (float) indicatorbgWidth / (float) total;
						params.width = (int) indicatorWidth;
						mIndicator.setLayoutParams(params);
						ViewHelper.setX(mIndicator, indicatorWidth * pager.getCurrentItem());*/
						
						
					}
					
					if (total > 1) {
						/*findViewById(R.id.indicatorBg).setVisibility(
								View.VISIBLE);
						mIndicator.setVisibility(View.VISIBLE);*/
						pIndicatorLayout.setVisibility(View.VISIBLE);
						setIndicatorPoint(position, imageList.size() );
						
					} else {
						/*findViewById(R.id.indicatorBg).setVisibility(
								View.INVISIBLE);
						mIndicator.setVisibility(View.INVISIBLE);*/
						pIndicatorLayout.setVisibility(View.INVISIBLE);
					}
					
					//refreshIndicator();
									
				}
			});
		} else {
			
			//imageCheck.setVisibility(View.GONE);
			titleRight.setVisibility(View.INVISIBLE);
			titleRight.setText("保存");
			
			/*if (isSDPicPreview) {
				titleRight.setVisibility(View.INVISIBLE);
				return;
			}
			titleRight.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					save();
				}
			});*/
			
			
		}
		if(isShowDicator){
			setIndicatorPoint(pagerPosition, total);
			if (total > 1) {			
				/*indicatorLayout.setVisibility(View.VISIBLE);
				mIndicator.setVisibility(View.VISIBLE);*/
				pIndicatorLayout.setVisibility(View.VISIBLE);
				handler.removeMessages(0);
				handler.sendEmptyMessageDelayed(0, 1000);
			} else {
				/*indicatorLayout.setVisibility(View.INVISIBLE);
				mIndicator.setVisibility(View.INVISIBLE);*/
				pIndicatorLayout.setVisibility(View.INVISIBLE);
			}
		}else {			
			pIndicatorLayout.setVisibility(View.INVISIBLE);
		}
	}
	
	private void refreshIndicator(){
		
		/*params = (LayoutParams) mIndicator.getLayoutParams();
		indicatorWidth = (float) indicatorbgWidth / (float) total;
		params.width = (int) indicatorWidth;
		mIndicator.setLayoutParams(params);*/
		
		
		if(imageList.size() > 1){
			/*findViewById(R.id.indicatorBg).setVisibility(View.INVISIBLE);
			mIndicator.setVisibility(View.INVISIBLE);*/
			pIndicatorLayout.setVisibility(View.INVISIBLE);
		}else{
			int position = pager.getCurrentItem();			
			/*indicatorLayout.setVisibility(View.VISIBLE);
			mIndicator.setVisibility(View.VISIBLE);
			ViewPropertyAnimator.animate(mIndicator).setDuration(300).translationX(position * indicatorWidth).start();*/
			pIndicatorLayout.setVisibility(View.VISIBLE);
			selectIndicatorPoint(position);
			setContent();
			handler.removeMessages(0);
			handler.sendEmptyMessageDelayed(0, 2000);
			mStart = position;
		}		
	}
	
	private RelativeLayout pIndicatorLayout;
	private LinearLayout pointLayout;
	
	public void selectIndicatorPoint(int index){		
		int oldCount = pointLayout.getChildCount();
		for(int i = 0; i < oldCount ; i++){
			pointLayout.getChildAt(i).setSelected(index == i);
		}
		
	}
	
	public void setIndicatorPoint(int index, int count){
		
		int oldCount = pointLayout.getChildCount();
		if(oldCount > count){
			for(int i = oldCount - 1 ; i >= count; i-- ){
				pointLayout.removeViewAt(i);
			}
		}else if(oldCount < count){
			for(int i = 0; i < (count - oldCount) ; i++){
				addIndicatorPoint();
			}
		}
		selectIndicatorPoint(index);
	}
	
	private void addIndicatorPoint(){
		ImageView pointImg = new ImageView(this);
		int width = getResources().getDimensionPixelSize(R.dimen.point_dicator_width);
		int space = getResources().getDimensionPixelSize(R.dimen.point_dicator_space);
		LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(width, width);
		lp.leftMargin  = space;
		pointImg.setScaleType(ScaleType.FIT_XY);
		pointImg.setImageResource(R.drawable.dicator_point_selector);
		pointLayout.addView(pointImg, lp);
	}

	private void setContent() {
		if (share != null) {
			// if (share.getmContent() != null &&
			// !share.getmContent().equals("")) {
			// shareContent.setVisibility(View.VISIBLE);
			// shareContent.setText(share.getmContent());
			// } else {
			// shareContent.setVisibility(View.GONE);
			// }
			if (mapContent != null && !mapContent.isEmpty()) {
				try {
					/*shareContent.setVisibility(View.VISIBLE);
					String mPath = imageList.get(pager.getCurrentItem());
					SpannableString spannableString = FaceConversionUtil
							.getInstace().getExpressionString(
									ImagePagerActivity.this,
									mapContent.get(mPath));
					shareContent.setText(spannableString);*/
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				bottomLayout.setVisibility(View.GONE);
				shareContent.setVisibility(View.GONE);
			}
		} else {
			bottomLayout.setVisibility(View.GONE);
			shareContent.setVisibility(View.GONE);
		}
	}

	public RadioButton getCircleImageLayout(RadioButton rb0, int idnex) {
		RadioButton rb = new RadioButton(this);
		rb.setButtonDrawable(android.R.color.transparent);
		rb.setBackgroundResource(R.drawable.selector_indicator_new);
		rb.setLayoutParams(rb0.getLayoutParams());
		rb.setId(idnex);
		rb.setEnabled(false);
		rb.setClickable(false);
		return rb;
	}

	private void forceShowOverflowMenu() {
		try {
			ViewConfiguration config = ViewConfiguration.get(this);
			Field menuKeyField = ViewConfiguration.class
					.getDeclaredField("sHasPermanentMenuKey");
			if (menuKeyField != null) {
				menuKeyField.setAccessible(true);
				menuKeyField.setBoolean(config, false);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static final String ISLOCKED_ARG = "isLocked";
	int total = 0;
	private final static int DISPLAY_LINE = 1001;
	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case DISPLAY_LINE:
				try {
					//params.leftMargin = msg.arg1;
					//mIndicator.setLayoutParams(params);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case 0:
			/*	Animation anim = new AlphaAnimation(1.0f, 0.0f);
				anim.setDuration(100);
				anim.setAnimationListener(new AnimationListener() {
					
					@Override
					public void onAnimationStart(Animation animation) {
						
					}
					
					@Override
					public void onAnimationRepeat(Animation animation) {
						
					}
					
					@Override
					public void onAnimationEnd(Animation animation) {
						indicatorLayout.setVisibility(View.INVISIBLE);
						mIndicator.setVisibility(View.INVISIBLE);
						
						pIndicatorLayout.setVisibility(View.INVISIBLE);
					}
				});
				//indicatorLayout.startAnimation(anim);
				pIndicatorLayout.startAnimation(anim);*/
				
			/*	indicatorLayout.setVisibility(View.INVISIBLE);
				mIndicator.setVisibility(View.INVISIBLE);*/
				break;
			}

		};
	};

	private int mStart = 0;
	OnPageChangeListener changeListener = new OnPageChangeListener() {

		@Override
		public void onPageSelected(int arg0) {
			/*indicatorLayout.setVisibility(View.VISIBLE);
			mIndicator.setVisibility(View.VISIBLE);
			
			ViewPropertyAnimator.animate(mIndicator).setDuration(300).translationX(arg0 * indicatorWidth).start();*/
			if(isShowDicator){
				pIndicatorLayout.setVisibility(View.VISIBLE);
				selectIndicatorPoint(arg0);
				
				setContent();
				handler.removeMessages(0);
				handler.sendEmptyMessageDelayed(0,1000);
				mStart = arg0;
			}			
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {

		}

		@Override
		public void onPageScrollStateChanged(int arg0) {

		}
	};
	/*private  ShareUtils shareUtil;
	public  ShareUtils getShareUtils(Context context){
		if(shareUtil == null){
			shareUtil = new ShareUtils(ImagePagerActivity.this);
		}
		return shareUtil;
	}*/
		
	
	public class CustomDialog extends Dialog {

		public CustomDialog(Context context, int theme) {
			super(context, theme);
		}

		protected void onCreate(Bundle savedInstanceState) {
			super.onCreate(savedInstanceState);
			setContentView(R.layout.image_menu_layout);
			
			((TextView) findViewById(R.id.save_text)).setText("保存到手机");
			findViewById(R.id.save_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
				@Override
				public void onClick(View v) {					
					save();					
					dismiss();
				}
			});
			findViewById(R.id.share_item_layout).setVisibility(View.GONE);
			
			findViewById(R.id.forward_item_layout).setVisibility(View.GONE);
			
			findViewById(R.id.forward_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
				@Override
				public void onClick(View v) {	
					try {
						String uri = imageList.get(pager.getCurrentItem());
						
						if (!uri.startsWith("file://")) {
							if (!uri.startsWith("http://")
									&& (uri.contains("sdcard") || uri.contains("storage"))) {
								uri = "file://" + uri;
							} else {
								uri = Utils.DOWNLOAD_PIC  + phoneName + "&session=" + mySession + "&fid=" + uri
										+ "&size=orig";
							}
							
						}		
						
						/*String imagePath = null;
						File fl = imageLoader.getDiskCache().get(uri);
						if(fl != null){
							imagePath = fl.getPath();
							getShareUtils(ImagePagerActivity.this).sendImageShare(ShareUtils.TYPE_SHARE_WECHAT_FRIEND, imagePath, "");
						}else{
							ToastUtil.showToast(ImagePagerActivity.this, "未获取到图片资源！");
						}*/
						
						Bitmap bmp = getBitmapFromCache(uri);
						if(bmp != null && !bmp.isRecycled()){								
							//getShareUtils(ImagePagerActivity.this).sendBitmapShare(ShareUtils.TYPE_SHARE_WECHAT_FRIEND, bmp, "");
						}else{
							ToastUtil.showToast(ImagePagerActivity.this, "图片获取失败！");
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					dismiss();
				}
			});
			findViewById(R.id.share_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
				@Override
				public void onClick(View v) {	
					/*try {
						String uri = imageList.get(pager.getCurrentItem());
						
						if (!uri.startsWith("file://")) {
							if (!uri.startsWith("http://")
									&& (uri.contains("sdcard") || uri.contains("storage"))) {
								uri = "file://" + uri;
							} else if ("aaa".equals(mMessageType) || share != null) {
								uri = Utils.DOWNLOAD_PIC + phoneName + "&filename=" + uri
										+ "&mode=original";
							} else if (!uri.startsWith("http://")) {
								uri = Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD_IMAGE + uri
										+ "&mode=original";
							}
						}		
						
						String imagePath = null;
						File fl = imageLoader.getDiskCache().get(uri);
						if(fl != null){
							imagePath = fl.getPath();
							getShareUtils(ImagePagerActivity.this).sendImageShare(ShareUtils.TYPE_SHARE_WECHAT, imagePath, "");
						}else{
							ToastUtil.showToast(ImagePagerActivity.this, "未获取到图片资源！");
						}
						
						Bitmap bmp = getBitmapFromCache(uri);
						if(bmp != null && !bmp.isRecycled()){								
							//getShareUtils(ImagePagerActivity.this).sendBitmapShare(ShareUtils.TYPE_SHARE_WECHAT, bmp, "");
						}else{
							ToastUtil.showToast(ImagePagerActivity.this, "图片获取失败！");
						}
					} catch (Exception e) {
						e.printStackTrace();
					}*/
					dismiss();
				}
			});
		}
	}
	

	private class ImagePagerAdapter extends PagerAdapter {

		private ArrayList<String> images;
		private LayoutInflater inflater;

		ImagePagerAdapter(ArrayList<String> images) {
			this.images = images;
			inflater = getLayoutInflater();
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			container.removeView((View) object);
		}

		@Override
		public int getCount() {
			return images.size();
		}

		private void setTempImage(String uri,ImageView tempImage){

			try {
				String cacleUrl = uri;
				if (!uri.startsWith("file://")) {
					if (!uri.startsWith("http://")
							&& (uri.contains("sdcard") || uri.contains("storage"))) {
						cacleUrl = "file://" + uri;
					}  else {
						uri = Utils.DOWNLOAD_PIC  + phoneName + "&session=" + mySession + "&fid=" + uri
								+ "&size=small";
					}
					
				}						
						
				Bitmap  cacheBitmap = getBitmapFromCache(cacleUrl);
				if(	cacheBitmap != null && !cacheBitmap.isRecycled()){
					
					tempImage.setVisibility(View.VISIBLE);
					tempImage.setImageBitmap(cacheBitmap);	
					
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
		@Override
		public Object instantiateItem(ViewGroup view, int position) {
			View imageLayout = inflater.inflate(R.layout.item_pager_image,
					view, false);
			assert imageLayout != null;
			
			final ImageView tempImage = (ImageView)imageLayout.findViewById(R.id.temp_image);
			
			PhotoView imageView = (PhotoView) imageLayout
					.findViewById(R.id.image);
			final ProgressBar spinner = (ProgressBar) imageLayout
					.findViewById(R.id.loading);
			String uri = images.get(position);
			
			setTempImage(uri, tempImage);
			
			if (!uri.startsWith("file://")) {
				if (!uri.startsWith("http://")
						&& (uri.contains("sdcard") || uri.contains("storage"))) {
					uri = "file://" + uri;
				} else{
					uri = Utils.DOWNLOAD_PIC  + phoneName + "&session=" + mySession + "&fid=" + uri
							+ "&size=orig";
				}		
				
			}		
			
			imageLoader.displayImage(uri, imageView, options,
					new SimpleImageLoadingListener() {
						@Override
						public void onLoadingStarted(String imageUri, View view) {
							spinner.setVisibility(View.VISIBLE);
						}

						@Override
						public void onLoadingComplete(String imageUri,
								View view, Bitmap loadedImage) {
							//FadeInBitmapDisplayer.animate(view, 500);
							tempImage.setVisibility(View.GONE);
							spinner.setVisibility(View.GONE);
							/*if(loadedImage != null ){
								int imgW = loadedImage.getWidth();
								int imgH = loadedImage.getHeight();
								
								if((1.0f * imgH / imgW ) > 3){									
									try {									
										File imageFile = imageLoader.getDiskCache().get(imageUri);
										if(imageFile != null && imageFile.exists()){
											Log.i("testTag", "重新加载原图显示");
											((PhotoView)view).setImageURI(Uri.fromFile(imageFile));											
										}
									} catch (Exception e) {
										e.printStackTrace();
									}
								}								
							}*/
							
						}

						@Override
						public void onLoadingFailed(String imageUri, View view,
								FailReason failReason) {
							tempImage.setVisibility(View.GONE);
							spinner.setVisibility(View.GONE);
						}
					},
					
					new ImageLoadingProgressListener() {
						
						@Override
						public void onProgressUpdate(String arg0, View arg1, int arg2, int arg3) {
							
						}
					});

			imageView.setOnPhotoTapListener(new OnPhotoTapListener() {

				@Override
				public void onPhotoTap(View view, float x, float y) {
					
					if(isShare){
						if (title.getVisibility() == View.VISIBLE) {
							title.setVisibility(View.INVISIBLE);
						} else {
							title.setVisibility(View.VISIBLE);
						}
					}else{
						finish();
						overridePendingTransition(R.anim.fadeint,R.anim.fadeout); 
					}
					
				}
			});
			
			imageView.setOnLongClickListener(new OnLongClickListener() {
				
				@Override
				public boolean onLongClick(View v) {
					
					if(isShare){
						return false;	
					}else{
						CustomDialog dialog = new CustomDialog(ImagePagerActivity.this, R.style.tip_dialog);
						dialog.show();
						return true;
					}					
					
				}
			});
			
			imageLayout.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {

					if(isShare){
						if (title.getVisibility() == View.VISIBLE) {
							title.setVisibility(View.INVISIBLE);
						} else {
							title.setVisibility(View.VISIBLE);
						}
					}else{
						finish();
						overridePendingTransition(R.anim.fadeint,R.anim.fadeout); 
					}
					
				}
			});

			view.addView(imageLayout, 0);
			return imageLayout;
		}

		@Override
		public boolean isViewFromObject(View view, Object object) {
			return view == object;
		}

		@Override
		public void restoreState(Parcelable state, ClassLoader loader) {
		}

		@Override
		public Parcelable saveState() {
			return null;
		}
	}

	public void copyfile(final File fromFile, final File toFile,
			final Boolean rewrite) {
		ShowDialog.showProgressDialog(ImagePagerActivity.this, "正在保存...", true);
		new Thread() {
			@Override
			public void run() {
				super.run();
				if (!fromFile.exists()) {
					ShowDialog.closeProgressDialog();
					return;
				}
				if (!fromFile.canRead()) {
					ShowDialog.closeProgressDialog();
					return;
				}
				if (!toFile.getParentFile().exists()) {
					toFile.getParentFile().mkdirs();
				}
				if (toFile.exists() && rewrite) {
					toFile.delete();
				}

				try {
					java.io.FileInputStream fosfrom = new java.io.FileInputStream(
							fromFile);
					java.io.FileOutputStream fosto = new FileOutputStream(
							toFile);
					byte bt[] = new byte[1024];
					int c;
					while ((c = fosfrom.read(bt)) > 0) {

						fosto.write(bt, 0, c); // 将内容写到新文件当中
					}
					fosfrom.close();
					fosto.close();
					ShowDialog.closeProgressDialog();

					ContentValues localContentValues = new ContentValues();
					localContentValues.put("_data", toFile.getPath());
					localContentValues.put("description", "photo");
					localContentValues.put("mime_type", "image/jpeg");
					ContentResolver localContentResolver = getContentResolver();
					Uri localUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
					localContentResolver.insert(localUri, localContentValues);
					Intent intent = new Intent(
							Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
					Uri uri = Uri.fromFile(toFile);
					intent.setData(uri);
					sendBroadcast(intent);
					return;
				} catch (Exception ex) {
					ShowDialog.closeProgressDialog();
					Log.e("readfile", ex.getMessage());
					return;
				}

			}
		}.start();
	}

	@Override
	public void onBackPressed() {
		if (isShare) {
			Intent intent = new Intent();
			intent.putStringArrayListExtra("pic", imageList);
			setResult(RESULT_OK, intent);
		}
		super.onBackPressed();
	}	

	/*
	public static void setImageCacheInfo(ImageLoader imgloader , String cacheUrl, String origin_url){
		try {
			List<Bitmap> list = MemoryCacheUtils.findCachedBitmapsForImageUri(cacheUrl, imgloader.getMemoryCache());
			Log.i("testTag", "加载缓存图片===" + cacheUrl );
			Bitmap tempBitmap = null;
			if(list != null && list.size() > 0){
				Log.i("testTag", "加载缓存图片 === 加载成功" );
				tempBitmap = list.get(0);
				if(tempBitmap != null && !tempBitmap.isRecycled()){								
					cacheUrl_org = origin_url;
					cacheBitmap = tempBitmap;
				}
			}else{
				Log.i("testTag", "加载缓存图片 === 加载失败" );
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}*/
	
	public Bitmap getBitmapFromCache(String url){
		List<Bitmap> list = MemoryCacheUtils.findCachedBitmapsForImageUri(url, imageLoader.getMemoryCache());
		Log.i("testTag", "加载缓存图片===" + url );
		if(list != null && list.size() > 0){
			Log.i("testTag", "加载缓存图片 === 加载成功" );
			return list.get(0);
		}else{
			Log.i("testTag", "加载缓存图片 === 加载失败" );
		}
		return null;
	}
	
	public String getLocalFileName(String url){		
		return String.valueOf( url.hashCode());
	}
	
}