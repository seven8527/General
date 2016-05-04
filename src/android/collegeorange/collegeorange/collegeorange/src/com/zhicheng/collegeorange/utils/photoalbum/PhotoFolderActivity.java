package com.zhicheng.collegeorange.utils.photoalbum;

import java.util.ArrayList;
import java.util.TreeSet;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.database.AbsListViewBaseActivity;
import com.zhicheng.collegeorange.database.ViewpointDBHelper;
import com.zhicheng.collegeorange.model.Photo;


public class PhotoFolderActivity extends AbsListViewBaseActivity {

	private ListView listView;
	private Button mFolderBtn;
	
	private PhotoAdapter photoAdapter;
	private DisplayImageOptions options;
	
	private String currFolder;
	
	private ArrayList<Photo> mAllPhoto = new ArrayList<Photo>();
	private ArrayList<ArrayList<Photo>> mFolderPhotos = new ArrayList<ArrayList<Photo>>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_photo_folder);

		initView();
		initData();
	}

	private void initView() {
		mFolderBtn = (Button) findViewById(R.id.all_photo);
		listView = (ListView) findViewById(R.id.listView);
		listView.setOnItemClickListener(onItemClickListener);
		mFolderBtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
	}

	private void initData() {
		currFolder = getIntent().getStringExtra("curr_folder");
		options = new DisplayImageOptions.Builder().showImageOnFail(R.drawable.image_failed).cacheInMemory(true).cacheOnDisk(true).considerExifParams(true).build();
		mAllPhoto = ViewpointDBHelper.GetInstance(PhotoFolderActivity.this).getAllPhoto(PhotoFolderActivity.this);
		TreeSet<String> mFolders = ViewpointDBHelper.GetInstance(PhotoFolderActivity.this).getPhotoFolders(PhotoFolderActivity.this);
		if(mFolders != null && mFolders.size()>0){
			mFolderPhotos = folderSort(mFolders, mAllPhoto);
			photoAdapter = new PhotoAdapter(PhotoFolderActivity.this, mFolderPhotos);
			listView.setAdapter(photoAdapter);
			mFolderBtn.setText(currFolder);
		}
	}
	
	/**
	 * 对所有的图片进行按文件夹分类
	 */
	private ArrayList<ArrayList<Photo>> folderSort(TreeSet<String> folders,ArrayList<Photo> photos){
		mFolderPhotos.add(photos);
		for(String string : folders){
			ArrayList<Photo> folderNamePhotos = new ArrayList<Photo>();
			for(Photo photo : photos){
				if(string.equals(photo.getmFolder())){
					folderNamePhotos.add(photo);
				}
			}
			mFolderPhotos.add(folderNamePhotos);
		}
		return mFolderPhotos;
	}
	
	private OnItemClickListener onItemClickListener = new OnItemClickListener() {
	
		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
			ArrayList<Photo> mfolderPhoto = (ArrayList<Photo>) photoAdapter.getItem(position);
			Intent mIntent = new Intent();
			mIntent.putExtra("folderPhoto", mfolderPhoto);
			setResult(RESULT_OK, mIntent);
			finish();
		}
	};

	class PhotoAdapter extends BaseAdapter {
		Context context;
		private ArrayList<ArrayList<Photo>> photos;
		private LayoutInflater inflater;

		public PhotoAdapter(Context context, ArrayList<ArrayList<Photo>> photos) {
			this.context = context;
			this.photos = photos;
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
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder holder = null;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = (View) inflater.inflate(R.layout.activity_photo_foler_item, null);
				holder.photo = (ImageView) convertView.findViewById(R.id.photo_item_img);
				holder.choose = (ImageView) convertView.findViewById(R.id.choose);
				holder.foterName = (TextView) convertView.findViewById(R.id.photo_foter_name);
				holder.photoNumber = (TextView) convertView.findViewById(R.id.photo_number);
				
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}

			ArrayList<Photo> photo = photos.get(position);
			String mPath = photo.get(0).getmPath();
			if (mPath != null && !mPath.startsWith("http://") && (mPath.contains("sdcard") || mPath.contains("storage"))) {
				mPath = "file://" + mPath;// 图片地址：file:///storage/sdcard0/DCIM/Camera/IMG_20140810_191512.jpg
			}
			imageLoader.displayImage(mPath, holder.photo, options, new SimpleImageLoadingListener());
			if(0==position){
				holder.foterName.setText("所有图片");
				if(currFolder.equals("所有图片")){
					holder.choose.setVisibility(View.VISIBLE);
				}else{
					holder.choose.setVisibility(View.GONE);
				}
			}else{
				holder.foterName.setText(photo.get(0).getmFolder());
				if(currFolder.equals(photo.get(0).getmFolder())){
					holder.choose.setVisibility(View.VISIBLE);
				}else{
					holder.choose.setVisibility(View.GONE);
				}
			}
			holder.photoNumber.setText(String.valueOf(photo.size()));
			return convertView;
		}

		class ViewHolder {
			public ImageView photo;
			public TextView foterName;
			public TextView photoNumber;
			public ImageView choose;
			
		}

	}

	@Override
	protected void closeInputMethod() {
		// TODO Auto-generated method stub
		
	}

}
