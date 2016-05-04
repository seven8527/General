package com.zhicheng.collegeorange.utils.photoalbum;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.TextView;
import android.widget.Toast;

import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.database.ViewpointDBHelper;
import com.zhicheng.collegeorange.main.ActivityShare;
import com.zhicheng.collegeorange.model.Photo;
import com.zhicheng.collegeorange.utils.ImagePagerActivity;
import com.zhicheng.collegeorange.utils.NativeImageLoader;
import com.zhicheng.collegeorange.utils.NativeImageLoader.NativeImageCallBack;
import com.zhicheng.collegeorange.view.MyImageView;
import com.zhicheng.collegeorange.view.MyImageView.OnMeasureListener;



public class PhotoAlbumActivity extends Activity {

	private Button number;
	private Button preview;
	private Button albumName;
	
	private GridView mPhotoGridView;
	private PhotoAdapter photoAdapter;

	private ArrayList<String> mSelectedPath = new ArrayList<String>();
	private ArrayList<Photo> mAllPhoto = new ArrayList<Photo>();
	private final static int REQUEST_CODE = 100;
	private String currFolder;
	
	private int width;
    private boolean isShare;
    private int shareNum;
    private DisplayMetrics dm;
    private int CAMERA = 100;
    private int maxLength = 9;
    private String okBtnText = "";
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.ex_activity_gallery);

		initTitle();
		initView();
		initData();
	}

	private void initTitle() {
		findViewById(R.id.title_back).setOnClickListener(
			new Button.OnClickListener() {
				@Override
				public void onClick(View arg0) {
					finish();
				}
			});
		TextView view = (TextView) findViewById(R.id.title_middle1);
		view.setText("相册");
		
		preview = (Button) findViewById(R.id.title_right_button);
		preview.setVisibility(View.VISIBLE);
		preview.setText("预览");
		preview.setEnabled(false);
		preview.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				if(mSelectedPath.size()>0){
					Intent intent = new Intent(PhotoAlbumActivity.this, ImagePagerActivity.class);
					intent.putExtra("imageList", mSelectedPath);
					intent.putExtra("sd_pic", true);
					intent.putExtra("position", 0);
					intent.putExtra(ImagePagerActivity.SHOW_DICATOR, false);
					startActivity(intent);
				}
			}
		});
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		mSelectList.clear();
	}

	private void initView() {
		number = (Button) findViewById(R.id.number);
		mPhotoGridView = (GridView) findViewById(R.id.gridview_photos);
		albumName = (Button) findViewById(R.id.cancel_button);
		albumName.setOnClickListener(onClickListener);
		mPhotoGridView.setOnItemClickListener(onItemClickListener);
		number.setOnClickListener(onClickListener);
		findViewById(R.id.ok_button).setOnClickListener(onClickListener);
		currFolder = "所有图片";
	}
	
	private void initData() {
		dm = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(dm);
		width = dm.widthPixels;
		Intent intent = getIntent();
		isShare = getIntent().getBooleanExtra("share", false);
		shareNum = getIntent().getIntExtra("shareNum", -1);
		maxLength = intent.getIntExtra("maxLength", maxLength);
		
		if(intent.getStringExtra("ok_text") != null){
			okBtnText = intent.getStringExtra("ok_text");
			((Button)findViewById(R.id.ok_button)).setText(okBtnText);
		}
		
		
		if (shareNum > 0) {
			number.setVisibility(View.VISIBLE);
			number.setText((mSelectedPath.size() + shareNum) + "/" + maxLength);
		}
		
		mAllPhoto = ViewpointDBHelper.GetInstance(PhotoAlbumActivity.this).getAllPhoto(PhotoAlbumActivity.this);
		if(mAllPhoto != null && mAllPhoto.size()>0){
			photoAdapter = new PhotoAdapter(PhotoAlbumActivity.this, mAllPhoto,mPhotoGridView);
			mPhotoGridView.setAdapter(photoAdapter);
		}
	}
	
	private OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			ArrayList<String> strings = new ArrayList<String>();
			for(Photo photo : mAllPhoto){
				strings.add(photo.getmPath());
			}
			Intent intent = new Intent(PhotoAlbumActivity.this, ImagePagerActivity.class);
			intent.putExtra("imageList", strings);
			intent.putExtra("sd_pic", true);
			intent.putExtra("position", position);
			intent.putExtra(ImagePagerActivity.SHOW_DICATOR, false);
			startActivity(intent);
		}
	};
	
	private OnClickListener onClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			Intent intent = new Intent();
			switch (v.getId()) {
			case R.id.cancel_button:
				intent.setClass(PhotoAlbumActivity.this, PhotoFolderActivity.class);
				intent.putExtra("curr_folder", currFolder);
				startActivityForResult(intent, REQUEST_CODE);
				break;
			case R.id.ok_button:
			case R.id.number:
				if(mSelectedPath==null||mSelectedPath.isEmpty()){
					Toast.makeText(PhotoAlbumActivity.this, "请选择图片", Toast.LENGTH_SHORT).show();
					return;
				}
				if(isShare){
					intent.setClass(PhotoAlbumActivity.this, ActivityShare.class);
					intent.putStringArrayListExtra("pic", mSelectedPath);
					if(shareNum >= 0){
						intent.putExtra("share", true);
						setResult(RESULT_OK, intent);
					}else{
						startActivity(intent);
					}
					
				}else{
					intent.putStringArrayListExtra("pic", mSelectedPath);
					setResult(RESULT_OK, intent);
				}
				finish();
				break;
			default:
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
				ArrayList<Photo> mfolderPhoto = null;
				if (data != null) {
					mfolderPhoto = (ArrayList<Photo>) data.getSerializableExtra("folderPhoto");
				}
				if (mfolderPhoto == null) {
					return;
				}
				mSelectList.clear();
				mSelectMap.clear();
				mSelectedPath.clear();
				number.setVisibility(View.GONE);
				preview.setEnabled(false);
				if(mAllPhoto.size()==mfolderPhoto.size()){
					currFolder = "所有图片";
					albumName.setText("所有图片");
				}else{
					currFolder = mfolderPhoto.get(0).getmFolder();
					albumName.setText(mfolderPhoto.get(0).getmFolder());
				}
				mAllPhoto = mfolderPhoto;
				photoAdapter = new PhotoAdapter(PhotoAlbumActivity.this, mAllPhoto,mPhotoGridView);
				mPhotoGridView.setAdapter(photoAdapter);
				return;
			}
		}if (requestCode == CAMERA) {
 			if (resultCode == RESULT_OK) {
 				Log.e("", "获取图片成功，path="+picFileFullName);
 				mSelectedPath.clear();
 				mSelectedPath.add(picFileFullName);
 				Intent intent = new Intent();
 				intent.setClass(PhotoAlbumActivity.this, ActivityShare.class);
				intent.putStringArrayListExtra("pic", mSelectedPath);
				startActivity(intent);
 			} else if (resultCode == RESULT_CANCELED) {
 				// 用户取消了图像捕获
 			} else {
 				// 图像捕获失败，提示用户
 				Log.e("", "拍照失败");
 			}
 		}
		

	}

	private HashMap<Integer, Boolean> mSelectMap = new HashMap<Integer, Boolean>();
	private ArrayList<String> mSelectList = new ArrayList<String>();
	class PhotoAdapter extends BaseAdapter {
		
		private Point mPoint = new Point(0, 0);//用来封装ImageView的宽和高的对象
		
		Context context;
		private ArrayList<Photo> photos;
		private LayoutInflater inflater;
		private GridView mGridView;

		public PhotoAdapter(Context context, ArrayList<Photo> photos,GridView mGridView) {
			this.context = context;
			this.photos = photos;
			this.mGridView = mGridView;
			inflater = LayoutInflater.from(context);
		}

		@Override
		public int getCount() {
			return photos.size();
		}

		@Override
		public Object getItem(int position) {
			return photos.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(final int position, View convertView, ViewGroup parent) {
		    final ViewHolder viewHolder;
			if (convertView == null) {
				viewHolder = new ViewHolder();
				convertView = (View) inflater.inflate(R.layout.grid_child_item, null);
				viewHolder.mImageView = (MyImageView) convertView.findViewById(R.id.child_image);
				viewHolder.mCheckBox = (CheckBox) convertView.findViewById(R.id.child_checkbox);
				
				convertView.setTag(viewHolder);
			}  else {
				viewHolder = (ViewHolder) convertView.getTag();
			}	
			final Photo photo = photos.get(position);
			
			viewHolder.mImageView.setOnMeasureListener(new OnMeasureListener() {
				
				@Override
				public void onMeasureSize(int width, int height) {
					mPoint.set(width, height);
				}
			});
			
			viewHolder.mCheckBox.setVisibility(View.VISIBLE);
			viewHolder.mImageView.setTag(photo.getmPath());
			viewHolder.mCheckBox.setOnCheckedChangeListener(new OnCheckedChangeListener() {
				
				@Override
				public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
					int num = shareNum;
					if (num < 0){
						num = 0;
					}
					if(mSelectedPath.size()+num>=maxLength){
						viewHolder.mCheckBox.setButtonDrawable(R.drawable.friends_sends_pictures_select_icon_unselected);
						mSelectMap.put(position, false);
						String poStr = "" + position;
						
						if(isChecked ){							
						}else{
							mSelectList.remove(poStr);
						}
						
					}else if(mSelectedPath.size()+num<maxLength &&mSelectedPath.size()+num>=1){
						viewHolder.mCheckBox.setButtonDrawable(R.drawable.friends_sends_pictures_select_icon_selected);
						mSelectMap.put(position, isChecked);
						
						String poStr = "" + position;
						if(isChecked ){							
							mSelectList.remove(poStr);
							mSelectList.add(poStr);		
						}else{
							mSelectList.remove(poStr);
						}
					}else if(mSelectedPath.size()+num<=maxLength){
						viewHolder.mCheckBox.setButtonDrawable(R.drawable.pictures_select_icon);
						mSelectMap.put(position, isChecked);
						
						String poStr = "" + position;
						if(isChecked ){							
							mSelectList.remove(poStr);
							mSelectList.add(poStr);		
						}else{
							mSelectList.remove(poStr);
						}
					}
					mSelectedPath.clear();
					for (Map.Entry<Integer, Boolean> m : mSelectMap.entrySet()) {
						if(m.getValue()){
							//mSelectedPath.add(mAllPhoto.get(m.getKey()).getmPath());
							viewHolder.mCheckBox.setButtonDrawable(R.drawable.friends_sends_pictures_select_icon_selected);
						}else{
							viewHolder.mCheckBox.setButtonDrawable(R.drawable.friends_sends_pictures_select_icon_unselected);
						}
					}
					
					if(mSelectList != null && mSelectList.size() > 0){
						for(int i = 0; i < mSelectList.size() ; i++){
							try {
								int imgPosi = Integer.parseInt(mSelectList.get(i));
								mSelectedPath.add(mAllPhoto.get(imgPosi).getmPath());
							} catch (NumberFormatException e) {
								e.printStackTrace();
							}
						}						
					}
					
					if(mSelectedPath.size()>0){
						preview.setEnabled(true);
						number.setVisibility(View.VISIBLE);
						number.setText((mSelectedPath.size()+num)+"/"+maxLength);
					}else{
						number.setVisibility(View.GONE);
					}
					notifyDataSetChanged();
				}
			});
			LayoutParams lp=viewHolder.mImageView.getLayoutParams();
			lp.height = lp.width = width/3 - 5;     
			viewHolder.mImageView.setLayoutParams(lp);
			viewHolder.mImageView.setScaleType(ScaleType.CENTER_CROP);
			if(mSelectMap.get(position) != null){
				if(mSelectMap.get(position)){
					viewHolder.mCheckBox.setButtonDrawable(R.drawable.friends_sends_pictures_select_icon_selected);
				}else{
					viewHolder.mCheckBox.setButtonDrawable(R.drawable.friends_sends_pictures_select_icon_unselected);
				}
			}else{
				 viewHolder.mCheckBox.setButtonDrawable(R.drawable.friends_sends_pictures_select_icon_unselected);
			}
			
			//利用NativeImageLoader类加载本地图片
			Bitmap bitmap = NativeImageLoader.getInstance().loadNativeImage(photo.getmPath(), mPoint, new NativeImageCallBack() {
				
				@Override
				public void onImageLoader(Bitmap bitmap, String path) {
					ImageView mImageView = (ImageView) mGridView.findViewWithTag(path);
					if(bitmap != null && mImageView != null){
						mImageView.setImageBitmap(bitmap);
					}
				}
			});
			
			if(bitmap != null){
				viewHolder.mImageView.setImageBitmap(bitmap);
			}else{
				viewHolder.mImageView.setImageResource(R.drawable.friends_sends_pictures_no);
			}
			return convertView;
		}
		
		class ViewHolder {
			public MyImageView mImageView;                
			public CheckBox mCheckBox;
		}

	}
	private static String picFileFullName;
    public void takePicture(){
    	String state = Environment.getExternalStorageState();  
        if (state.equals(Environment.MEDIA_MOUNTED)) {  
            Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE); 
            File outDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);  
            if (!outDir.exists()) {  
            	outDir.mkdirs();  
            }  
            File outFile =  new File(outDir, System.currentTimeMillis() + ".jpg");  
            picFileFullName = outFile.getAbsolutePath();
            intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(outFile));  
            intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1);  
            startActivityForResult(intent, CAMERA);  
        } else{
        	Log.e("", "请确认已经插入SD卡");
        }
    }

}
