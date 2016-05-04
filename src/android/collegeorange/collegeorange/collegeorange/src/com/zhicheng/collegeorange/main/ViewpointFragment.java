package com.zhicheng.collegeorange.main;

/**
 * 话题
 */

import java.io.File;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.BitmapDrawable;
import android.media.MediaPlayer;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.Editable;
import android.text.InputFilter;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.format.DateUtils;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.MeasureSpec;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.display.RoundedBitmapDisplayer;
import com.nostra13.universalimageloader.core.listener.PauseOnScrollListener;
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener;
import com.zhicheng.collegeorange.MainActivity;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.WebViewFragment;
import com.zhicheng.collegeorange.database.ViewpointDBHelper;
import com.zhicheng.collegeorange.model.Circle;
import com.zhicheng.collegeorange.model.Review;
import com.zhicheng.collegeorange.model.Topic;
import com.zhicheng.collegeorange.profile.LoginActivity;
import com.zhicheng.collegeorange.utils.CompleteActionPlusActivity;
import com.zhicheng.collegeorange.utils.DateUtil;
import com.zhicheng.collegeorange.utils.DeviceUtils;
import com.zhicheng.collegeorange.utils.DownloadUtils;
import com.zhicheng.collegeorange.utils.ImagePagerActivity;
import com.zhicheng.collegeorange.utils.MyProgressDialog;
import com.zhicheng.collegeorange.utils.ToastUtil;
import com.zhicheng.collegeorange.utils.photoalbum.PhotoAlbumActivity;
import com.zhicheng.collegeorange.view.MyPagerAdapter;

/**
 * Main page.
 */
public class ViewpointFragment extends Fragment implements View.OnClickListener{

    public static final String TAG = "ViewpointFragment";
    
    private Context mContext;
    private boolean isInitView = false;
	private ViewPointCircleAdapter circleAdapter;
	private SharedHelper sharedHelper;
	private ArrayList<Circle> mCircles = new ArrayList<Circle>();
	private ArrayList<String> mAllTextId = new ArrayList<String>();
	private ArrayList<String> mAllDownId = new ArrayList<String>();
	private ViewpointDBHelper dbHelper;
	private DisplayImageOptions options;
	private DisplayImageOptions optionsIcon;
	private DisplayImageOptions optionsTop;
	//private DisplayImageOptions optionsVideo;
	protected ImageLoader imageLoader = ImageLoader.getInstance();
	public static final String REFRESH_COMMENTS_NUM = "refresh_comment_num";
	private String myName;
	private String mySession;
	private String myNickName;
	public static final String REFRESH_ADAPTER = "REFRESH_ADAPTER";
	public static final String NOTIFY_ADAPTER = "NOTIFY_ADAPTER";
	private ImageView title_icon;
	private AnimationDrawable animaition = null;
	private String mMyIcon = null;
//	private ImageView btn_top = null;
	private int downloadVoiceCount = 0;
	private int downloadVideoCount = 0;
	// private CollectionDBHelper cHelper;

	private View loadingView;
	private int oneLineHeight = -1;
	private int itemW = -1;

//	private RoundRectImageView titleIamgeviewRoundrect;
	
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	private BroadcastReceiver mBroadcastReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			String act = intent.getAction();
			if (ViewpointDBHelper.VIEWPOINT_ACTION_DB_INSERT.equals(act)) {
				try {
					boolean isGetRemote = intent.getBooleanExtra("isGetRemote", true);
					boolean is2ListTop = intent.getBooleanExtra("is2ListTop", false);
					initDataFromDB(isGetRemote, is2ListTop);
				} catch (Exception e) {
					e.printStackTrace();
				}
				// String user = intent.getStringExtra("userName");
				return;
			} else if ("UPDATE_TAB".equals(act)) {
				try {
					refreshingList();
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (ViewpointDBHelper.VIEWPOINT_CIRCLE_MESSAGE_ACTION_DB_INSERT.equals(act)) {
				try {
					setHearderData();
				} catch (Exception e) {
					e.printStackTrace();
				}
				return;
			} else if (REFRESH_COMMENTS_NUM.equals(act)) {
				try {
					int comments = intent.getIntExtra("comments", 0);
					int praise = intent.getIntExtra("praise", 0);
					boolean hasZan = intent.getBooleanExtra("hasZan", false);
					String id = intent.getStringExtra("id");
					String userid = intent.getStringExtra("userid");
					if (!TextUtils.isEmpty(id) && !TextUtils.isEmpty(userid)) {
						boolean isRefresh = false;
						for (Circle item : mCircles) {
							if (id.equals(item.getmId()) && userid.equals(item.getmPhoneNum())) {
								if (item.getCommentCount() != comments || praise != item.getZanCount()) {
									isRefresh = true;
									item.hasZan = hasZan;
									item.setCommentCount(comments);
									item.setZanCount(praise);
								}
								break;
							}
						}

						if (isRefresh) {
							refreshList(false);
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}  else if (DownloadUtils.DOWNLOAN_VOICE_SUCCESS.equals(act)) {
				// 语音文件下载成功
				downloadVoiceCount--;
				if (downloadVoiceCount <= 0) {
					refreshList(false);
				}

			} else if (DownloadUtils.DOWNLOAN_VOICE_FAIL.equals(act)) {
				downloadVoiceCount--;
			} else if (MusicPlayerService.PLAY_COMPLETED.equals(act)) {
				try {
					if (animaition != null && animaition.isRunning()) {
						animaition.stop();
						animaition.selectDrawable(0);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				animaition = null;
				return;
			}else if (Utils.LOGIN_STATE_CHANGE.equals(act)){
				myName = sharedHelper.getString(SharedHelper.USER_NAME, "");
				mySession = sharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
			} 
		}
	};

	private void showLoadDialog() {
		if (isLoading)
			return;
		
		pullToRefreshView.showHeaderLoadingView();
	}

	private void closeLoading() {
		loadingView.setVisibility(View.GONE);
	}

	private boolean isToTop = false;

	private void refreshingList() {
		isToTop = true;
		showLoadDialog();
		new GetDatasTask().execute(0);
	}   
    
    public static ViewpointFragment newInstance(int sectionNumber) {
        ViewpointFragment fragment = new ViewpointFragment();
        
        return fragment;
    }

    public ViewpointFragment() {
    	
    }
    
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
    	mContext = getActivity();
    	super.onCreate(savedInstanceState);
    	Log.i(TAG, "onCreate");
    	initData();
    }
    
    @Override
	public void onActivityCreated(@Nullable Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onActivityCreated(savedInstanceState);
		Log.i(TAG, "onActivityCreated");
	}
	
	

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
    	Log.i(TAG, "onCreateView");
        View rootView = inflater.inflate(R.layout.activity_viewpoint_circle1, container, false);
        initViewpointView(rootView);
        return rootView;
    }
    
    @Override
	public void onResume() {
    	Log.i(TAG, "onResume");
		if (!mHandler.hasMessages(0) && mImagePageViewList != null && mImagePageViewList.size() > 1) {
			mHandler.sendEmptyMessageDelayed(0, 3000);
		}
		try {
			String myAvatar = sharedHelper.getString("avatar", "");
			if (!TextUtils.equals(myAvatar, mMyIcon)) {
				mMyIcon = myAvatar;
				imageLoader.displayImage(Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD + myAvatar, title_icon, optionsIcon);
			}

			
			// String myAvatar = sharedHelper.getString("avatar", "");
			// if (!TextUtils.isEmpty(myAvatar))
			// imageLoader.displayImage(Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD +
			// myAvatar, title_icon, optionsIcon);
		} catch (Exception e) {
			e.printStackTrace();
		}

		super.onResume();
		/*if (isNotf) {
			newsLayout.setVisibility(View.GONE);
			((HomeActivity) getParent()).findViewById(R.id.tabspec_tip).setVisibility(View.GONE);
			isNotf = false;
		}*/
	}

	@Override
	public void onPause() {
		Log.i(TAG, "onPause");
		if (circleAdapter != null && circleAdapter.getMusicPlayerService() != null) {
			circleAdapter.getMusicPlayerService().stop();

			try {
				if (animaition != null && animaition.isRunning()) {
					animaition.stop();
					animaition.selectDrawable(0);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			animaition = null;
		}
		mHandler.removeMessages(0);
		
		super.onPause();
	}
    
    @Override
    public void onDestroyView() {
    	// TODO Auto-generated method stub
    	Log.i(TAG, "onDestroyView");
    	isInitView = false;
    	try {
			if (mBroadcastReceiver != null)
				LocalBroadcastManager.getInstance(mContext).unregisterReceiver(mBroadcastReceiver);
		} catch (Exception e) {
			e.printStackTrace();
		}
    	super.onDestroyView();
    }
    
    private void initData(){
    	sharedHelper = SharedHelper.getShareHelper(mContext);
		myName = sharedHelper.getString(SharedHelper.USER_NAME, "");
		mySession = sharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
		myNickName = sharedHelper.getString(SharedHelper.USER_NICKNAME, "");
		dbHelper = ViewpointDBHelper.GetInstance(mContext);

		options = new DisplayImageOptions.Builder().showImageOnLoading(R.drawable.pic_default)
				.showImageForEmptyUri(R.drawable.pic_default).showImageOnFail(R.drawable.pic_default)
				.cacheInMemory(true).cacheOnDisk(true).considerExifParams(true)// .resetViewBeforeLoading(true)
				.imageScaleType(ImageScaleType.NONE)
				// .displayer(new FadeInBitmapDisplayer(100))
				.build();
		
		optionsTop = new DisplayImageOptions.Builder().showImageForEmptyUri(R.drawable.default_pic)
				.showImageOnFail(R.drawable.default_pic).cacheInMemory(true).cacheOnDisk(true)
				.considerExifParams(true).build();

		optionsIcon = new DisplayImageOptions.Builder()
		.showImageOnLoading(R.drawable.user_logo)
		.showImageForEmptyUri(R.drawable.user_logo)
		.showImageOnFail(R.drawable.user_logo)
		.cacheInMemory(true)
		.cacheOnDisk(true)
		.considerExifParams(true)
		.resetViewBeforeLoading(true)
				.displayer(
						new RoundedBitmapDisplayer(getResources().getDimensionPixelOffset(R.dimen.user_rounded_avatar)))
				.build();

		float dp4 = getResources().getDimension(R.dimen.head_details_viewpoint_4dp);
		float margin = getResources().getDimension(R.dimen.viewpoint_image_margin);
		float afterWith = (float) getActivity().getWindowManager().getDefaultDisplay().getWidth() - margin;
		itemW = getActivity().getWindowManager().getDefaultDisplay().getWidth() - 66;

		imgItemW = imgItemH = (int) ((afterWith - 2 * dp4) / 3);
		imageMaxWidth = (int) (2.0f * imgItemW + dp4);
		videoMaxWidth = (int) (imageMaxWidth * 3.0 / 4);
		videoMaxHeight = imageMaxWidth;
    }

    
    private void initViewpointView(View v){
	
		IntentFilter ifi = new IntentFilter();
		ifi.addAction(ViewpointDBHelper.VIEWPOINT_ACTION_DB_INSERT);
		ifi.addAction(ViewpointDBHelper.VIEWPOINT_CIRCLE_MESSAGE_ACTION_DB_INSERT);
		ifi.addAction("UPDATE_TAB");
		ifi.addAction(REFRESH_COMMENTS_NUM);
		ifi.addAction(DownloadUtils.DOWNLOAN_VOICE_FAIL);
		ifi.addAction(DownloadUtils.DOWNLOAN_VOICE_SUCCESS);
		ifi.addAction(MusicPlayerService.PLAY_COMPLETED);
		ifi.addAction(NOTIFY_ADAPTER);
		ifi.addAction(Utils.LOGIN_STATE_CHANGE);
		LocalBroadcastManager.getInstance(mContext).registerReceiver(mBroadcastReceiver, ifi);

		myName = sharedHelper.getString(SharedHelper.USER_NAME, "");
		mySession = sharedHelper.getString(SharedHelper.USER_SESSION_ID, "");
		
		initTitle(v);
		initView(v);
		showLoadDialog();
		initDataFromDB(true, true);
		
		//getTopViewThread();
    }
    

	int videoMaxWidth;
	int videoMaxHeight;
	int imageMaxWidth;
	int imgItemW, imgItemH;

	private void initTitle(View v) {
		TextView title_middle1 = (TextView) v.findViewById(R.id.title_middle1);
		title_middle1.setText("朋友圈");
//		title_middle1.setBackgroundResource(R.drawable.logo_text_friendroll);
		title_icon = (ImageView) v.findViewById(R.id.title_iamgeview);
		
		v.findViewById(R.id.title_iamgeview_layout).setVisibility(View.GONE);
		v.findViewById(R.id.title_back).setVisibility(View.GONE);
		
		ImageView title_right = (ImageView) v.findViewById(R.id.title_right_view);
		title_right.setVisibility(View.VISIBLE);
		title_right.setImageResource(R.drawable.title_paizhao);
		title_right.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {				

					List<String> name = new ArrayList<String>();
					name.add("拍照");
					name.add("从相册选取");
					name.add("文字");
					mCompleteActionPlusActivity = new CompleteActionPlusActivity(getActivity(), name,
							onShareClickListener, null, mHandler);
					mCompleteActionPlusActivity.setAnimationStyle(R.style.AnimBottom);
					mCompleteActionPlusActivity.showAtLocation(
							getActivity().findViewById(R.id.pull_to_refresh_gridview),
							Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); // 设置layout在PopupWindow中显示的位置
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
		
		v.findViewById(R.id.title_layout).setOnClickListener(this);
	}

	CompleteActionPlusActivity mCompleteActionPlusActivity = null;
	private OnClickListener onShareClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			mCompleteActionPlusActivity.dismiss();
			switch (v.getId()) {
			case R.id.exitBtn0:
				if(!isLogin()){
					showLoginView();
					return;
				}
				
				takePicture();
				break;
			case R.id.exitBtn1:
				if(!isLogin()){
					showLoginView();
					return;
				}
				
				Intent i = new Intent(getActivity(), PhotoAlbumActivity.class);
				i.putExtra("share", true);
				startActivity(i);
				break;
			case R.id.exitBtn2: {
				if(!isLogin()){
					showLoginView();
					return;
				}
				try {
					ArrayList<String> mSelectedPath = new ArrayList<String>();
					Intent intent = new Intent(getActivity(), ActivityShare.class);
					intent.putStringArrayListExtra("pic", mSelectedPath);
					startActivity(intent);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
				break;
			default:
				goback();
				break;
			}

		}
	};
	
	private boolean isLogin(){
		myName = sharedHelper.getString(SharedHelper.USER_NAME, "");
		if(sharedHelper.getInt(SharedHelper.WHICH_ME, 0) == 1
				&& !TextUtils.isEmpty(myName)){
			return true;
		}
		return false;
	}
	
	private void showLoginView(){
		Intent lintent = new Intent(mContext, LoginActivity.class);
		startActivity(lintent);
	}

	private Uri picFileFullName;

	public void takePicture() {
		try {
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
		} catch (Exception e) {

		}
	}

	private static final int CAMERA = 101;
	private static final int VIDEO = 102;
	
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == CAMERA) {
			if (resultCode == Activity.RESULT_OK) {
				Log.e("", "获取图片成功，path=" + picFileFullName);

				try {
					ArrayList<String> mSelectedPath = new ArrayList<String>();
					mSelectedPath.add(picFileFullName.getPath());
					insertImage(picFileFullName);
					Intent intent = new Intent(mContext, ActivityShare.class);
					intent.putStringArrayListExtra("pic", mSelectedPath);
					startActivity(intent);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if (resultCode == Activity.RESULT_CANCELED) {
				// 用户取消了图像捕获
			} else {
				// 图像捕获失败，提示用户
				Log.e("", "拍照失败");
			}
		} else if (requestCode == VIDEO) {
			if (resultCode == Activity.RESULT_OK) {
				String path = data.getStringExtra("path");
				Intent intent = new Intent(mContext, ActivityShare.class);
				intent.putExtra(ActivityShare.EXTRA_SHARE_TYPE, ActivityShare.SHARE_TYPE_VDIEO);
				intent.putExtra(ActivityShare.EXTRA_VIDEO_PATH, path);
				startActivity(intent);
				// ToastUtil.showToast(this, "视频拍摄成功，文件路径为： " + path);
			} else {
				// ToastUtil.showToast(this, "视频拍摄取消");
			}
		}

		super.onActivityResult(requestCode, resultCode, data);
	}

	private void insertImage(Uri picFileFullName) {
		Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
		intent.setData(picFileFullName);
		mContext.sendBroadcast(intent);
	}

	private int pullNum = 20;

	private void initDataFromDB(boolean isGetRemote, boolean is2Top) {
		int getCount = pullNum;
		if (mCircles != null && mCircles.size() > pullNum) {
			getCount = mCircles.size();
		}
		ArrayList<Circle> data = dbHelper.getCirclesByPage2(mContext, 0 + "," + getCount);
		dbHelper.loadCirclesReview(mContext, data);
		mCircles = data;
		if (mCircles != null && mCircles.size() > 0) {
			MyProgressDialog.closeLoadingDialog();
			if (circleAdapter != null) {
				refreshList(is2Top);
			} else {
				circleAdapter = new ViewPointCircleAdapter();
				pullToRefreshView.setAdapter(circleAdapter);
				isInitView = true;
			}
		} else {
			if (circleAdapter == null) {
				circleAdapter = new ViewPointCircleAdapter();
				pullToRefreshView.setAdapter(circleAdapter);
				isInitView = true;
			}
		}
		if (isGetRemote) {
			isToTop = is2Top;
			// new GetDataNewTask().execute();
			new GetDatasTask().execute(0);
		}
	}

	private long firstClick = -1l;

	@Override
	public void onClick(View v) {
		switch (v.getId()) {

		case R.id.title_layout: {
			if (firstClick > 0) {
				long c_time = System.currentTimeMillis() - firstClick;
				firstClick = -1l;
				if (c_time <= 1000) {
					toListTop();
				} else {

				}
			} else {
				firstClick = System.currentTimeMillis();
			}
		}
			break;
		case R.id.input_layout: {
			inputView.requestFocus();
		}
			break;
		case R.id.btn_send: {
			sendComment();
		}
			break;
		default:
			break;
		}

	};

	/**
	 * 列表返回顶部
	 */
	private void toListTop() {
		try {
			pullToRefreshView.getRefreshableView().setSelection(0);
//			btn_top.setVisibility(View.INVISIBLE);
			/*
			 * circleAdapter.closeItemViewAll();
			 * circleAdapter.openItemView(listPos);
			 */
			lastListPos = listPos;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	//TextView tv_message;
	
	PullToRefreshListView pullToRefreshView;
	int listPos = -1;
	int firstVisiblePosition = 0;
	private ViewPager mViewPager;
	private TextView pager_txt;

	private View faceLayoutView;
	private RelativeLayout inputLayout;
	private EditText inputView;
	private Button sendBtn;

	private void initView(View v) {
		try {
			String myAvatar = sharedHelper.getString("avatar", "");
			mMyIcon = myAvatar;
			imageLoader.displayImage(Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD + myAvatar, title_icon, optionsIcon);
//			titleIamgeviewRoundrect
//			imageLoader.displayImage(Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD + myAvatar, titleIamgeviewRoundrect, optionsTitle);
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			pullToRefreshView = (PullToRefreshListView) v.findViewById(R.id.pull_to_refresh_gridview);
			loadingView = v.findViewById(R.id.progress_layout);

			// circleAdapter = new ViewPointCircleAdapter();
			// pullToRefreshView.setAdapter(circleAdapter);
			
			ListView refreshlistView = pullToRefreshView.getRefreshableView();
			
			View heardView = LayoutInflater.from(mContext).inflate(R.layout.simple_textview, null);
			//tv_message = (TextView) heardView.findViewById(R.id.tv_message);
			//newsLayout = heardView.findViewById(R.id.newsLayout);
		
			indicatorLayout = (LinearLayout) heardView.findViewById(R.id.indicator_ayout);
			mViewPager = (ViewPager) heardView.findViewById(R.id.viewPager);	 
			pager_txt = (TextView) heardView.findViewById(R.id.pager_txt);

			pullToRefreshView.setOnItemClickListener(new OnItemClickListener() {

				@Override
				public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
					if (position > 1) {
						position = position - 2;
					}
					
					/*Circle circle = (Circle) circleAdapter.getItem(position);
					Intent intent = new Intent();
					if (!TextUtils.isEmpty(circle.getmUrl())) {
						intent.setClass(mContext, WebsiteViewPoint.class);
					} else {
						intent.setClass(mContext, DetailsMicroViewPointActivity1.class);
						return;
					}
					intent.putExtra("circle", circle);

					try {
						if (animaition != null && animaition.isRunning()) {
							animaition.stop();
							animaition.selectDrawable(0);
							animaition = null;
						}
					} catch (Exception e) {
						e.printStackTrace();
					}

					startActivity(intent);*/
					// overridePendingTransition(R.anim.activity_open,0);
				}
			});

			pullToRefreshView.setOnScrollListener(new PauseOnScrollListener(imageLoader, false, true, mScrollListener));

			pullToRefreshView.setMode(Mode.BOTH);
			pullToRefreshView.setOnRefreshListener(new OnRefreshListener2<ListView>() {

				public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
					String label = DateUtils.formatDateTime(mContext, System.currentTimeMillis(),
							DateUtils.FORMAT_SHOW_TIME | DateUtils.FORMAT_SHOW_DATE | DateUtils.FORMAT_ABBREV_ALL);
					refreshView.getLoadingLayoutProxy().setLastUpdatedLabel(label);
					
					new GetDatasTask().execute(0);
					/*if (!isloadTopics) {
						getTopViewThread();
					}*/
				}

				public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
					// addLastItemHeight();
					// new GetDataMoreTask().execute();
					new GetDatasTask().execute(1);
				}
				
			});
			
			//refreshlistView.addHeaderView(heardView);
			//setHearderData();			
			//initViewPager();

			// ---------
			imm = (InputMethodManager) mContext.getSystemService(Context.INPUT_METHOD_SERVICE);
			faceLayoutView =  v.findViewById(R.id.FaceRelativeLayout);
			inputLayout = (RelativeLayout) v.findViewById(R.id.input_layout);
			inputView = (EditText) v.findViewById(R.id.input);
			sendBtn = (Button) v.findViewById(R.id.btn_send);

			v.findViewById(R.id.expression_layout).setVisibility(View.VISIBLE);
			v.findViewById(R.id.chat_icon).setVisibility(View.GONE);
			//this.findViewById(R.id.btnStart).setVisibility(View.GONE);
			v.findViewById(R.id.btn_iamge_send).setVisibility(View.GONE);
			
			inputView.setFilters(new InputFilter[]{ new InputFilter.LengthFilter(MAX_COMMENT)});
			
			inputView.addTextChangedListener(mTextWatcher);
			inputLayout.setOnClickListener(this);
			sendBtn.setOnClickListener(this);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static final int MAX_COMMENT = 500;
	TextWatcher mTextWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			if (s.length() == 0 || TextUtils.isEmpty(s.toString().trim())) {
				sendBtn.setEnabled(false);
				sendBtn.setClickable(false);
				sendBtn.setFocusable(false);
			} else {
				sendBtn.setEnabled(true);
				sendBtn.setClickable(true);
				sendBtn.setFocusable(true);

				// 文字过长的提醒
				if (s.toString().trim().length() >= MAX_COMMENT) {
					Toast.makeText(mContext, "文字长度已到最大！", Toast.LENGTH_SHORT).show();
				}
			}

		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {
		}

	};

	InputMethodManager imm;

	private void displayInput() {
		if(getActivity() instanceof MainActivity){
			((MainActivity)getActivity()).closeTabView();
		}
		
		inputLayout.setVisibility(View.VISIBLE);
		inputView.setVisibility(View.VISIBLE);

		inputView.requestFocus();
		imm.showSoftInput(inputView, InputMethodManager.SHOW_FORCED);
		
		faceLayoutView.setVisibility(View.VISIBLE);	
		mHandler.sendEmptyMessageDelayed(2, 500);
	}

	private void closeInputView() {
		try {
			if (imm != null && imm.isActive()) {
				imm.hideSoftInputFromWindow(getActivity().getWindow().getDecorView().getWindowToken(), 0);
				// imm.hideSoftInputFromWindow(inputView.getWindowToken(),
				// InputMethodManager.HIDE_NOT_ALWAYS);
			}
			
			faceLayoutView.setVisibility(View.GONE);
			
			inputLayout.setVisibility(View.GONE);
			
			if(getActivity() instanceof MainActivity){
				((MainActivity)getActivity()).showTabView();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private Circle currCircle;

	private void sendComment() {

		String content = inputView.getText().toString();
		if (!TextUtils.isEmpty(content) && currCircle != null) {
			String contentStr = inputView.getEditableText().toString();

			myName = sharedHelper.getString(SharedHelper.USER_NAME, "");
			myNickName = sharedHelper.getString(SharedHelper.USER_NICKNAME, "");
			Review comment = Review.creatComment(currCircle.getmPhoneNum(), currCircle.getmTime(), myName, myNickName,
					contentStr);

			/*
			 * Message msg = mHandler.obtainMessage(); msg.what =
			 * LOAD_COMMENT_REP; msg.obj = initReview(mReviewList, 2, comment);
			 * msg.sendToTarget();
			 */

			publishReviewThread(currCircle, comment);

			inputView.setText("");
		}

		inputView.setTag(null);
		inputView.setHint("");
		currCircle = null;
		closeInputView();

	}

	// private View lastView = null;
	// private void addLastItemHeight(){
	// if(lastView != null){
	// lastView.setPadding(0, 0, 0, 0);
	// }
	// pullToRefreshView.getFooterLoadingView().setPadding(0, 0, 0,
	// getResources().getDimensionPixelOffset(R.dimen.padding_bottom));
	// pullToRefreshView.getRefreshableView().setSelection(ListView.FOCUS_DOWN);
	// }
	//
	// private void remveLastItemHeight(){
	// pullToRefreshView.getFooterLoadingView().setPadding(0, 0, 0, 0);
	// }

	int lastListPos = 0;

	private void setHearderData() {
		/*circleMessages = dbHelper.getNewCircleMessages(mContext);
		if (circleMessages != null && !circleMessages.isEmpty()) {
			newsLayout.setVisibility(View.VISIBLE);
			tv_message.setText("您有" + circleMessages.size() + "条新消息");
			newsLayout.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					((HomeActivity) getParent()).findViewById(R.id.tabspec_tip).setVisibility(View.GONE);
					dbHelper.setReadCircleMessage(mContext);
					isNotf = true;
					Intent intent = new Intent();
					intent.setClass(mContext, MessageActivity.class);
					startActivity(intent);
				}
			});
		} else {
			newsLayout.setVisibility(View.GONE);
		}*/
	}

	private OnScrollListener mScrollListener = new OnScrollListener() {

		@Override
		public void onScrollStateChanged(AbsListView view, int scrollState) {
			switch (scrollState) {
			case OnScrollListener.SCROLL_STATE_IDLE: //

				/*
				 * circleAdapter.closeItemViewAll();
				 * circleAdapter.openItemView(listPos);
				 */
				lastListPos = listPos;
				ListView listView = pullToRefreshView.getRefreshableView();
				try {
					if (listView.getLastVisiblePosition() == (listView.getCount() - 1)) {// 判断滚动到底部
						pullToRefreshView.showFooterLoadingView();
					}
//					if (btn_top != null) {
//						if (listView.getFirstVisiblePosition() == 0) {
//							btn_top.setVisibility(View.INVISIBLE);
//						} else {
//							btn_top.setVisibility(View.VISIBLE);
//						}
//					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				break;
			case OnScrollListener.SCROLL_STATE_TOUCH_SCROLL:
				closeInputView();
				break;
			case OnScrollListener.SCROLL_STATE_FLING:
				// circleAdapter.closeAllExcept(null);
				closeInputView();
				break;
			}
		}

		@Override
		public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
			firstVisiblePosition = firstVisibleItem;
			if (firstVisibleItem == 0) {
				listPos = 0;
			} else {
				listPos = firstVisibleItem - 1;
			}
		}
	};

	private ArrayList<Circle> getCircles(String tid) {
		try {
			
			String url = Utils.REMOTE_SERVER_URL + "/topic?uid=" + sharedHelper.getString(SharedHelper.USER_NAME,	"")
						+"&session="+ sharedHelper.getString(SharedHelper.USER_SESSION_ID,	"")
						+"&tid=" + tid;

            // 生成请求对象
            HttpGet httpGet = new HttpGet(url);
            HttpClient httpClient = new DefaultHttpClient();

            // 发送请求
            HttpResponse response = httpClient.execute(httpGet);
			

			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return null;
			}
			
			String mHistoryList = EntityUtils.toString(response.getEntity());
			JSONObject jsonObj= new JSONObject(mHistoryList);
			
			int resultCode = -1;
			if(jsonObj.has("code")){
				resultCode = jsonObj.getInt("code");
			}
			
			if (resultCode == 0) {
				
				ArrayList<Circle> mCircles = new ArrayList<Circle>();
				JSONArray jsonArray = jsonObj.getJSONArray("data");
				for (int i = 0; i < jsonArray.length(); i++) {
					JSONObject jsonObject = jsonArray.getJSONObject(i);
					Circle mCircle = new Circle();
					
					mCircle.setmId(jsonObject.getString("Id"));
					mCircle.setmPosition(jsonObject.getString("Address"));
					mCircle.setmContent( jsonObject.getString("Content"));
					mCircle.setmTime(jsonObject.getString("CreateTime"));
					
					String circleUserId = jsonObject.getString("UserId");
					
					mCircle.setmPhoneNum(circleUserId);

					String voice = jsonObject.getString("Voice");
					mCircle.setmVoice(voice);
					if (!TextUtils.isEmpty(voice)) {
						Message message = new Message();
						message.obj = mCircle;
						message.what = 0;
						loadVoiceHandler.sendMessage(message);
					}
					if (jsonObject.has("Nickname")) {
						mCircle.setmLickName(jsonObject.getString("Nickname"));
					}
					if (jsonObject.has("Avatar")) {
						mCircle.setmIcon(jsonObject.getString("Avatar"));
					}				

					if (jsonObject.has("TopicStars")) {
						JSONArray array = jsonObject.getJSONArray("TopicStars");

						ArrayList<Review> list = new ArrayList<Review>();

						if (array != null) {
							for (int k = 0; k < array.length(); k++) {
								try {
									JSONObject temp = (JSONObject) array.get(k);
									
									String rid = "";
									String userId = "";
									String nickName = "";
									String creatTime = "";
									
									if (temp.has("Id")) {
										rid = temp.getString("Id");
									}
									
									if (temp.has("UserId")) {
										userId = temp.getString("UserId");
									}
									
									if (temp.has("Nickname")) {
										nickName = temp.getString("Nickname");
									}else{
										nickName = "用户" + userId;
									}
									
									if (temp.has("CreateTime")) {
										creatTime = temp.getString("CreateTime");
									}
									
									Review zanUser = Review.creatZanData(circleUserId, creatTime, userId, nickName);
									zanUser.setId(rid);
									zanUser.setType(Review.TYPE_ZAN);
									zanUser.setCircleTime(mCircle.getmTime());
									zanUser.setCircleUser(mCircle.getmPhoneNum());

									if (myName.equals(zanUser.getFriendName())) {
										mCircle.hasZan = true;
									}

									list.add(zanUser);
								} catch (Exception e) {
									e.printStackTrace();
								}
							}
						}

						mCircle.setZanList(list);
					}

					// commentList
					if (jsonObject.has("TopicComments")) {

						JSONArray array = jsonObject.getJSONArray("TopicComments");
						ArrayList<Review> comments = new ArrayList<Review>();
						if (array != null) {

							for (int k = 0; k < array.length(); k++) {
								try {
									
									String rid = "";
									String userId = "";
									String nickName = "";
									String creatTime = "";
									String rContent = "";
									
									JSONObject temp = (JSONObject) array.get(k);
									
									
									if (temp.has("Id")) {
										rid = temp.getString("Id");
									}
									
									if (temp.has("UserId")) {
										userId = temp.getString("UserId");
									}
									
									if (temp.has("Nickname")) {
										nickName = temp.getString("Nickname");
									}else{
										nickName = "用户" + userId;
									}
									
									if(TextUtils.isEmpty(nickName)){
										nickName = "用户" + userId;
									}
									
									if (temp.has("CreateTime")) {
										creatTime = temp.getString("CreateTime");
									}
									
									if (temp.has("Comment")) {
										rContent = temp.getString("Comment");
									}
									
									Review review = Review.creatComment(mCircle.getmPhoneNum(), mCircle.getmTime(), userId, nickName, rContent);
									review.setId(rid);									
									review.setTime(creatTime);					

									comments.add(review);
								} catch (Exception e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}

							}
						}

						mCircle.setCommentList(comments);
					}

					if (jsonObject.has("Images")) {
						JSONArray array = jsonObject.getJSONArray("Images");
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
				return mCircles;
				// dbHelper.insertCircleInfo(ViewPointCircleActivity3.this,
				// mCircles);
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

	boolean isLoading;
	// ProgressDialog dialog = null;

	private class GetDatasTask extends AsyncTask<Integer, Void, ArrayList<Circle>> {

		int isFirst;

		@Override
		protected void onPostExecute(ArrayList<Circle> result) {
			isLoading = false;
			pullToRefreshView.onRefreshComplete();
			if (isFirst != 0) {
				// remveLastItemHeight();
				if (result == null || (mCircles != null && result.size() == mCircles.size())) {
					ToastUtil.showToast(mContext, "网络异常");
					return;
				}
				mCircles = result;
				try {
					int top = 0;
					int topPosition = 0;
					ListView listView = pullToRefreshView.getRefreshableView();
					topPosition = listView.getFirstVisiblePosition();
					top = listView.getChildAt(0).getTop();
					if (circleAdapter == null) {
						circleAdapter = new ViewPointCircleAdapter();
						pullToRefreshView.setAdapter(circleAdapter);
						isInitView = true;
					} else {
						mHandler.sendEmptyMessage(9998);
					}
					listView.setSelectionFromTop(topPosition, top);
				} catch (Exception e) {
					e.printStackTrace();
				}

			} else {
				if (result == null) {
					ToastUtil.showToast(mContext, "网络异常");
					return;
				}
				sharedHelper.putBoolean(SharedHelper.HAS_CICLE_VIEWPOINT, false);
				mCircles = result;
				mAllTextId.clear();
				mAllDownId.clear();
				if (circleAdapter == null) {
					circleAdapter = new ViewPointCircleAdapter();
					pullToRefreshView.setAdapter(circleAdapter);
					isInitView = true;
				} else {
					refreshList(isToTop);
				}
				MyProgressDialog.closeLoadingDialog();
			}
			super.onPostExecute(result);
		}

		@Override
		protected void onPreExecute() {
			isLoading = true;
			super.onPreExecute();
		}

		@Override
		protected ArrayList<Circle> doInBackground(Integer... arg0) {
			isFirst = arg0[0];
			ArrayList<Circle> list = null;
			try {
				if (isFirst == 0) {// 拉取最新
					list = getCircles("0");
					if (list != null && list.size() > 0) {
						dbHelper.clearCircles();
						dbHelper.clearReviews();
						dbHelper.insertCircleInfo(mContext, list);
						ArrayList<Circle> data = dbHelper.getCirclesByPage2(mContext,
								0 + "," + 50);
						dbHelper.loadCirclesReview(mContext, data);
						return data;
					}
				} else {
					if (mCircles != null && mCircles.size() > 0) {
						list = getCircles(mCircles.get(mCircles.size() - 1).getmId());
					} else {
						list = getCircles(String.valueOf(0));
					}
					if (list != null && list.size() > 0) {
						dbHelper.insertCircleInfo(mContext, list);
					}
					if (mCircles != null && mCircles.size() > 0) {
						ArrayList<Circle> data = dbHelper.getCirclesByPage2(mContext,
								0 + "," + (mCircles.size() + pullNum));
						dbHelper.loadCirclesReview(mContext, data);
						return data;
					} else {
						ArrayList<Circle> data = dbHelper.getCirclesByPage2(mContext,
								0 + "," + pullNum);
						dbHelper.loadCirclesReview(mContext, data);
						return data;
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				return null;
			}

			return list;
		}

	}
	

	private void getCircleDetails(ArrayList<Circle> noCircles) {
		if (noCircles.isEmpty()) {
			return;
		}
		try {
			JSONArray sidArray = new JSONArray();
			for (int i = 0; i < noCircles.size(); i++) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("userName", noCircles.get(i).getmPhoneNum());
				jsonObject.put("sid", noCircles.get(i).getmId());
				jsonObject.put("needProfile", noCircles.get(i).needProfile);
				sidArray.put(jsonObject);
			}
			JSONObject obj = new JSONObject();
			obj.put("sidArray", sidArray);
			obj.put("timestamp", "");
			obj.put("shareCount", 0);
			HttpResponse response = Utils.getResponse(Utils.REMOTE_SERVER_URL + "getShareList", obj,
					 30000, 30000);

			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return;
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
					if (!TextUtils.isEmpty(voice)) {
						Message message = new Message();
						message.obj = mCircle;
						message.what = 0;
						loadVoiceHandler.sendMessage(message);
					}
					if (jsonObject.has("nickName")) {
						mCircle.setmLickName(jsonObject.getString("nickName"));
					}
					if (jsonObject.has("avatar")) {
						mCircle.setmIcon(jsonObject.getString("avatar"));
					}

					if (jsonObject.has("gender")) {
						mCircle.setmGender(jsonObject.getString("gender"));
					}

					if (jsonObject.has("commentCount")) {
						mCircle.setCommentCount(jsonObject.getInt("commentCount"));
					}

					if (jsonObject.has("zanCount")) {
						mCircle.setZanCount(jsonObject.getInt("zanCount"));
					}

					if (jsonObject.has("imageWidth")) {
						mCircle.setImageWidth(jsonObject.getInt("imageWidth"));
					}

					if (jsonObject.has("imageHeight")) {
						mCircle.setImageHeight(jsonObject.getInt("imageHeight"));
					}

					if (jsonObject.has("video")) {
						String video = jsonObject.getString("video");
						mCircle.setmVideo(video);

						/*
						 * if (!TextUtils.isEmpty(video)) { Message message =
						 * new Message(); message.obj = mCircle; message.what =
						 * 1; loadVoiceHandler.sendMessage(message); }
						 */
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

					if (jsonObject.has("url")) {
						try {
							mCircle.setmUrl(jsonObject.getString("url"));
							mCircle.setmImage(jsonObject.getString("image"));
							mCircle.setmTitle(jsonObject.getString("title"));
							mCircle.setmBrief(jsonObject.getString("brief"));
						} catch (Exception e) {
							e.printStackTrace();
						}
					}

					if (jsonObject.has("zanList")) {
						JSONArray array = jsonObject.getJSONArray("zanList");

						ArrayList<Review> list = new ArrayList<Review>();

						if (array != null) {
							for (int k = 0; k < array.length(); k++) {
								try {
									JSONObject temp = (JSONObject) array.get(k);
									Review zanUser = Review.fromJSON(temp.toString());
									zanUser.setType(Review.TYPE_ZAN);
									zanUser.setCircleTime(mCircle.getmTime());
									zanUser.setCircleUser(mCircle.getmPhoneNum());

									if (myName.equals(zanUser.getFriendName())) {
										mCircle.hasZan = true;
									}

									list.add(zanUser);
								} catch (Exception e) {
									e.printStackTrace();
								}
							}
						}

						mCircle.setZanList(list);
					}

					// commentList
					if (jsonObject.has("commentList")) {

						JSONArray array = jsonObject.getJSONArray("commentList");
						ArrayList<Review> comments = new ArrayList<Review>();
						if (array != null) {

							for (int k = 0; k < array.length(); k++) {
								JSONObject temp = (JSONObject) array.get(k);

								Review review = Review.fromJSON(temp.toString());
								review.setCircleTime(mCircle.getmTime());
								review.setCircleUser(mCircle.getmPhoneNum());
								review.setType(Review.TYPE_COMMENT);

								comments.add(review);

							}
						}

						mCircle.setCommentList(comments);
					}

					mCircle.setCommentCount(jsonObject.getInt("commentCount"));
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
				dbHelper.insertCircleInfo(mContext, mCircles);
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
		return;
	}

	

	public class ViewPointCircleAdapter extends BaseAdapter implements OnClickListener, OnLongClickListener
	// , SwipeItemMangerInterface, SwipeAdapterInterface
	{
		// protected SwipeItemMangerImpl mItemManger = new
		// SwipeItemMangerImpl(this);
		public HashMap<Integer, View> mViews = new HashMap<Integer, View>();
		MusicPlayerService musicPlayerService;
		MusicPlayerService getPlayer;

		public ViewPointCircleAdapter() {
			musicPlayerService = new MusicPlayerService();
			getPlayer = new MusicPlayerService();
		}

		public MusicPlayerService getMusicPlayerService() {
			return musicPlayerService;
		}

		@Override
		public int getCount() {
			if (mCircles == null) {
				return 0;
			}
			return mCircles.size();
		}

		@Override
		public Object getItem(int position) {
			if (mCircles == null) {
				return null;
			}
			return mCircles.get(position);
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			View view = convertView;
			try {
				ViewHolder holder = null;
				boolean isNewView = true;
				if (view == null) {
					holder = new ViewHolder();
					LayoutInflater inflater = LayoutInflater.from(mContext);
					view = inflater.inflate(R.layout.adapter_viewpoint_circle_item3, null);

					holder.zan_user_layout = view.findViewById(R.id.zan_user_layout);
					holder.item_layout = view.findViewById(R.id.circle_item_layout);
					holder.user_icon = (ImageView) view.findViewById(R.id.user_icon);
					holder.user_lickname = (TextView) view.findViewById(R.id.user_lickname);
					holder.share_date = (TextView) view.findViewById(R.id.share_date);
					holder.share_content = (TextView) view.findViewById(R.id.share_content);
					holder.text_switch = (TextView) view.findViewById(R.id.content_up_down);

					holder.delete_txt = (TextView) view.findViewById(R.id.circle_delete);
					holder.tv_comment_num = (ImageView) view.findViewById(R.id.tv_comment_num);
					holder.tv_zan_num = (TextView) view.findViewById(R.id.tv_zan_num);
					holder.tv_zan_ainm = (TextView) view.findViewById(R.id.tv_zan_anim);
					holder.tv_voice = (TextView) view.findViewById(R.id.tv_voice);
					holder.tv_location = (TextView) view.findViewById(R.id.tv_location);

					holder.layout_review = view.findViewById(R.id.review_layout);
					holder.txt_zan_users = (TextView) view.findViewById(R.id.zan_user_names);
					holder.layout_review_line = view.findViewById(R.id.review_line);
					holder.layout_comments = (LinearLayout) view.findViewById(R.id.comments_layout);

					holder.url_point_view = view.findViewById(R.id.url_point_view);

					holder.gender = (ImageView) view.findViewById(R.id.gender);

					holder.url_iamge_view = (ImageView) view.findViewById(R.id.url_iamge_view);
					holder.url_title_view = (TextView) view.findViewById(R.id.url_title_view);
					holder.url_brief_view = (TextView) view.findViewById(R.id.url_brief_view);

					holder.voiceLayout = view.findViewById(R.id.voice_view);

					holder.imgLayout = view.findViewById(R.id.imgLayout);
					holder.imgLayout1 = view.findViewById(R.id.img1Layout);
					holder.imgRaw1 = view.findViewById(R.id.imgs_raw1);
					holder.imgRaw2 = view.findViewById(R.id.imgs_raw2);
					holder.imgRaw3 = view.findViewById(R.id.imgs_raw3);

					holder.img1 = (ImageView) view.findViewById(R.id.img1);

					holder.imgItems[0] = (ImageView) view.findViewById(R.id.img_11);
					holder.imgItems[1] = (ImageView) view.findViewById(R.id.img_12);
					holder.imgItems[2] = (ImageView) view.findViewById(R.id.img_13);

					holder.imgItems[3] = (ImageView) view.findViewById(R.id.img_21);
					holder.imgItems[4] = (ImageView) view.findViewById(R.id.img_22);
					holder.imgItems[5] = (ImageView) view.findViewById(R.id.img_23);

					holder.imgItems[6] = (ImageView) view.findViewById(R.id.img_31);
					holder.imgItems[7] = (ImageView) view.findViewById(R.id.img_32);
					holder.imgItems[8] = (ImageView) view.findViewById(R.id.img_33);

					// holder.rightLayout = view.findViewById(R.id.rightLayout);
					// holder.swipe = (SwipeLayout)
					// view.findViewById(R.id.swipe);

					holder.voice_iamgeciew = (ImageView) view.findViewById(R.id.voice_iamgeciew);
					/*
					 * holder.layout_pinglun =
					 * view.findViewById(R.id.layout_pinglun); holder.layout_zan
					 * = view.findViewById(R.id.layout_zan);
					 * holder.iamgeview_zan =
					 * (ImageView)view.findViewById(R.id.iamgeview_zan);
					 */

					holder.root = view;
					holder.item_layout.setOnClickListener(this);

					holder.share_content.setOnLongClickListener(this);
					holder.share_content.setOnClickListener(this);
					holder.text_switch.setOnClickListener(this);
					holder.text_switch.setTag(holder);

					holder.delete_txt.setOnClickListener(this);
					holder.tv_zan_num.setOnClickListener(this);
					holder.tv_comment_num.setOnClickListener(this);
					//holder.add_friend_bt.setOnClickListener(this);

					LayoutParams lpu = holder.voiceLayout.getLayoutParams();
					lpu.height = imgItemH;
					lpu.width = imageMaxWidth;
					holder.voiceLayout.setLayoutParams(lpu);

					/*LayoutParams lpv = holder.videoLayout.getLayoutParams();
					lpv.height = videoMaxHeight;
					lpv.width = videoMaxWidth;
					holder.videoLayout.setLayoutParams(lpv);*/

					/*
					 * LayoutParams lpvd = holder.videoView.getLayoutParams();
					 * lpvd.height = videoMaxHeight; lpvd.width = videoMaxWidth;
					 * holder.videoLayout.setLayoutParams((RelativeLayout.
					 * LayoutParams)lpvd);
					 */

					/*holder.videoFloat.setOnClickListener(this);
					holder.videoFloat.setOnLongClickListener(this);*/

					holder.user_icon.setOnClickListener(this);
					holder.voice_iamgeciew.setOnClickListener(this);
					// holder.rightLayout.setOnClickListener(this);

					holder.img1.setOnClickListener(this);
					holder.img1.setOnLongClickListener(this);
					holder.img1.setMaxHeight(imageMaxWidth);
					holder.img1.setMaxWidth(imageMaxWidth);

					/* holder.img1.setAdjustViewBounds(true); */

					for (ImageView v : holder.imgItems) {
						LayoutParams lp = v.getLayoutParams();
						lp.width = imgItemW;
						lp.height = imgItemH;
						v.setLayoutParams(lp);
						v.setOnClickListener(this);
						v.setOnLongClickListener(this);
					}

					view.setTag(holder);
					// mItemManger.initialize(view, position);
					mViews.put(position, view);
					/*
					 * if (listPos == -1 && position == 0) {
					 * holder.swipe.setSwipeEnabled(true);
					 * holder.rightLayout.setVisibility(View.VISIBLE); }
					 * 
					 * holder.txt_pinglun.setOnClickListener(this);
					 * holder.layout_zan.setOnClickListener(this);
					 */
				} else {
					holder = (ViewHolder) view.getTag();
					// mItemManger.updateConvertView(view, position);
					mViews.put(position, view);
					isNewView = false;
				}
				Circle mCircle = mCircles.get(position);
				holder.circle = mCircle;

				holder.item_layout.setTag(mCircle);

				if (!TextUtils.isEmpty(mCircle.getmLickName())) {
					holder.user_lickname.setText(mCircle.getmLickName());
				} else {
					holder.user_lickname.setText("");
				}

				String userNum = mCircle.getmPhoneNum();
				String myName = SharedHelper.getShareHelper(mContext)
						.getString(SharedHelper.USER_NAME, "");
				/*if (TextUtils.isEmpty(userNum) || userNum.equals(myName)) {
					holder.add_friend_bt.setVisibility(View.INVISIBLE);
					holder.add_friend_bt.setTag(R.id.tag_second, UserGroup.TYPE_RELATIONSHIP_FRIEND);
				} else {
					UserGroup ug = mUserGroupDBHelper.queryUserGroupInfo(userNum);
					if (TextUtils.isEmpty(ug.focusUserName)) {// 不是好友
						holder.add_friend_bt.setVisibility(View.VISIBLE);
						holder.add_friend_img.setVisibility(View.VISIBLE);
						holder.add_friend_text.setText("好友");
						holder.add_friend_bt.setTag(R.id.tag_second, UserGroup.TYPE_RELATIONSHIP_ADD_NO);
					} else {
						if (ug.focusType == UserGroup.TYPE_RELATIONSHIP_FRIEND) {// 是好友
							holder.add_friend_bt.setVisibility(View.INVISIBLE);
							holder.add_friend_bt.setTag(R.id.tag_second, UserGroup.TYPE_RELATIONSHIP_FRIEND);
						} else if (ug.focusType == UserGroup.TYPE_RELATIONSHIP_VERIFICATION) {// 验证中
							holder.add_friend_bt.setVisibility(View.VISIBLE);
							holder.add_friend_img.setVisibility(View.INVISIBLE);
							holder.add_friend_text.setText(getString(R.string.verfication));
							holder.add_friend_bt.setTag(R.id.tag_second, UserGroup.TYPE_RELATIONSHIP_VERIFICATION);
						} else {// 不是好友
							holder.add_friend_bt.setVisibility(View.VISIBLE);
							holder.add_friend_img.setVisibility(View.VISIBLE);
							holder.add_friend_text.setText("好友");
							if (ug.focusType == UserGroup.TYPE_RELATIONSHIP_ACCEPT) {
								holder.add_friend_bt.setTag(R.id.tag_second, UserGroup.TYPE_RELATIONSHIP_ACCEPT);
							} else {
								holder.add_friend_bt.setTag(R.id.tag_second, UserGroup.TYPE_RELATIONSHIP_ADD_NO);
							}

						}
					}
				}*/
				//holder.add_friend_bt.setTag(R.id.tag_first, userNum);

				String gender = mCircle.getmGender();
				/*
				 * if (ug != null){ gender = ug.gender; }
				 */
				if (TextUtils.equals(gender, "F")) {
					holder.gender.setImageResource(R.drawable.nv);
				} else {
					holder.gender.setImageResource(R.drawable.nan);
				}

				String url = null;
				if (!TextUtils.isEmpty(mCircle.getmIcon())) {
					url = Utils.DOWNLOAD_PIC  + mCircle.getmPhoneNum() + "&session=" + mySession + "&fid=" + mCircle.getmIcon()
							+ "&size=small";
					//url = Utils.REMOTE_SERVER_URL_FOR_DOWNLOAD + mCircle.getmIcon() + "&mode=original";
					
					imageLoader.displayImage(url, holder.user_icon, optionsIcon);
					 
				} else {
					/*
					 * if (ug != null && TextUtils.equals(ug.gender, "F")){
					 * holder.user_icon.setImageResource(R.drawable.nv_icon);
					 * }else{
					 * holder.user_icon.setImageResource(R.drawable.nan_icon); }
					 */
					// holder.user_icon.setImageResource(R.drawable.user_logo);
					imageLoader.displayImage(null, holder.user_icon, optionsIcon);
					 
				}

				holder.user_icon.setTag(mCircle);
				holder.user_lickname.setText(mCircle.getmLickName());
				
				holder.share_date.setText(DateUtil.getTimeFormatText(mCircle.getmTime()));
				holder.tv_zan_num.setTag(holder);
				holder.tv_comment_num.setTag(mCircle);

				if (myName.equals(mCircle.getmPhoneNum())) {
					holder.delete_txt.setVisibility(View.VISIBLE);
				} else {
					holder.delete_txt.setVisibility(View.GONE);
				}
				holder.delete_txt.setTag(mCircle);

				setReviewLayout(holder, mCircle);

				holder.position = position;
				// if (mCircles.size() - 1 == position) {
				// lastView = holder.root;
				// holder.root.setPadding(0, 0, 0,
				// getResources().getDimensionPixelOffset(R.dimen.padding_bottom));
				// } else {
				// holder.root.setPadding(0, 0, 0, 0);
				// }

				//releaseVideoView(holder.videoView);

				if (!TextUtils.isEmpty(mCircle.getmUrl())) {
					holder.url_point_view.setVisibility(View.VISIBLE);
					//holder.videoLayout.setVisibility(View.GONE);
					holder.voiceLayout.setVisibility(View.GONE);
					holder.imgLayout.setVisibility(View.GONE);
					holder.share_content.setVisibility(View.GONE);
					if (!TextUtils.isEmpty(mCircle.getmImage())) {
						imageLoader.displayImage(mCircle.getmImage(), holder.url_iamge_view, options);
						 
					}
					if (!TextUtils.isEmpty(mCircle.getmTitle())) {
						holder.url_title_view.setText(mCircle.getmTitle());
					}
					if (!TextUtils.isEmpty(mCircle.getmBrief())) {
						holder.url_brief_view.setText(mCircle.getmBrief());
					}
					holder.position = position;
				} else {
					holder.url_point_view.setVisibility(View.GONE);

					if (!TextUtils.isEmpty(mCircle.getmContent())) {
						holder.share_content.setVisibility(View.VISIBLE);
						int textSize = (int) (holder.share_content.getTextSize());
						/*SpannableString content = FaceConversionUtil.getInstace()
								.getExpressionString(mContext, mCircle.getmContent(), textSize);*/
						/*
						 * holder.share_content.setEllipsize(TextUtils.
						 * TruncateAt.END);
						 */
						holder.share_content.setMaxLines(100);
						holder.share_content.setText(mCircle.getmContent());

						if (oneLineHeight == -1) {
							oneLineHeight = measureTextViewHeight("我", holder.share_content.getTextSize());
						}
						int lenght = measureTextViewHeight(mCircle.getmContent(), holder.share_content.getTextSize());
						// holder.text_switch.setText("全文");
						// holder.share_content.post(new
						// TextLineRunnable(holder));
						if (lenght > oneLineHeight * 6&&!TextUtils.isEmpty(mCircle.getmContent())) {
							holder.text_switch.setVisibility(View.VISIBLE);
							// holder.share_content.setMaxLines(6);

							if (mAllTextId.contains(mCircle.getmPhoneNum() + mCircle.getmTime())) {
								holder.share_content.setMaxLines(100);
								holder.text_switch.setText("收起");
							} else {
								holder.share_content.setMaxLines(6);
								holder.text_switch.setText("全文");
							}

						} else {
							holder.text_switch.setVisibility(View.GONE);
						}

						// holder.text_switch.setVisibility(View.VISIBLE);
						holder.share_content.setTag(mCircle);
					} else {
						holder.text_switch.setVisibility(View.GONE);
						holder.share_content.setVisibility(View.GONE);
					}

					if (!TextUtils.isEmpty(mCircle.getmVoice())) {

						holder.voiceLayout.setVisibility(View.VISIBLE);
						holder.imgLayout.setVisibility(View.GONE);
						//holder.videoLayout.setVisibility(View.GONE);

						holder.voice_iamgeciew.setImageResource(R.drawable.pic_bofang);
						holder.voice_iamgeciew.setTag(mCircle.getmVoice());
						String showVoiceText = checkVoice(mCircle);
						if (!TextUtils.isEmpty(showVoiceText)) {
							holder.tv_voice.setText(showVoiceText);
						} else {
							holder.tv_voice.setText("0\"");
						}

						checkVoiceImageState(mCircle, holder);

					} /*else if (!TextUtils.isEmpty(mCircle.getmVideo())) {

						holder.voiceLayout.setVisibility(View.GONE);
						holder.imgLayout.setVisibility(View.GONE);
						holder.videoLayout.setVisibility(View.VISIBLE);
						setVideoResource(mCircle, holder);
						holder.videoFloat.setTag(holder);
						holder.videoView.setTag(mCircle);

					} */else {

						holder.voiceLayout.setVisibility(View.GONE);
						//holder.videoLayout.setVisibility(View.GONE);
						holder.imgLayout.setVisibility(View.VISIBLE);

						setImageItem(mCircle, holder);

						if (mCircle.getmPicPaths() != null) {
							holder.img1.setTag(mCircle);
							for (ImageView v : holder.imgItems) {
								v.setTag(mCircle);
							}
						}

					}

				}

				if (TextUtils.isEmpty(mCircle.getmPosition())) {
					holder.tv_location.setVisibility(View.GONE);
				} else {
					holder.tv_location.setVisibility(View.VISIBLE);
					holder.tv_location.setText(mCircle.getmPosition());
				}

				try {
					if (isNewView) {
						if (holder.imgLayout.isShown()) {
							holder.imgLayout.requestLayout();
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				// 重新布局
				if (!isNewView) {
					view.requestLayout();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			return view;
		}

		class TextLineRunnable implements Runnable {

			private ViewHolder mholder;

			public TextLineRunnable(ViewHolder holder) {
				this.mholder = holder;
			}

			@Override
			public void run() {
				int count = mholder.share_content.getLineCount();
				if (count > 6) {
					mholder.text_switch.setVisibility(View.VISIBLE);
					mholder.share_content.setMaxLines(6);
				} else {
					mholder.text_switch.setVisibility(View.GONE);
				}
			}

		}

		private int measureTextViewHeight(String text, float textSize) {
			TextView textView = new TextView(mContext);
			textView.setText(text);
			textView.setTextSize(TypedValue.COMPLEX_UNIT_PX, textSize);
			int widthMeasureSpec = MeasureSpec.makeMeasureSpec(itemW, MeasureSpec.AT_MOST);
			int heightMeasureSpec = MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);
			textView.measure(widthMeasureSpec, heightMeasureSpec);
			return textView.getMeasuredHeight();
		}

		private void releaseVideoView(VideoView videoView) {
			try {
				videoView.stopPlayback();
				videoView.setOnErrorListener(new MediaPlayer.OnErrorListener() {
					@Override
					public boolean onError(MediaPlayer mp, int what, int extra) {
						return true;
					}
				});
				// videoView.setVideoPath(null);
				videoView.setVisibility(View.GONE);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		private boolean isJustText(Circle mCircle) {
			if (!TextUtils.isEmpty(mCircle.getmUrl())) {
				return false;
			}

			if (!TextUtils.isEmpty(mCircle.getmVoice())) {
				return false;
			}

			if (mCircle.getmPicPaths() != null && mCircle.getmPicPaths().size() > 0) {
				return false;
			}

			if (TextUtils.isEmpty(mCircle.getmContent())) {
				return false;
			}

			return true;
		}

		/**
		 * 设置评论和赞的数据显示
		 * 
		 * @param holder
		 * @param mCircle
		 */
		public void setReviewLayout(ViewHolder holder, Circle mCircle) {

			if (mCircle.getCommentCount() > 0 || mCircle.getZanCount() > 0) {

				holder.layout_review.setVisibility(View.VISIBLE);

				if (mCircle.getZanList() != null && mCircle.getZanList().size() <= 0) {
					holder.txt_zan_users.setVisibility(View.GONE);
					holder.zan_user_layout.setVisibility(View.GONE);
				} else {
					holder.zan_user_layout.setVisibility(View.VISIBLE);
					holder.txt_zan_users.setVisibility(View.VISIBLE);
					setZanUsers(holder.txt_zan_users, mCircle.getZanList());
				}

				if (mCircle.getCommentCount() > 0 && mCircle.getZanCount() > 0) {
					holder.layout_review_line.setVisibility(View.VISIBLE);
				} else {
					holder.layout_review_line.setVisibility(View.GONE);
				}

				if (mCircle.getCommentCount() <= 0) {
					holder.layout_comments.setVisibility(View.GONE);
				} else {
					holder.layout_comments.setVisibility(View.VISIBLE);
					setComments(holder.layout_comments, mCircle);
				}

			} else {
				holder.layout_review.setVisibility(View.GONE);
			}
		}

		private void setZanUsers(TextView zTxt, List<Review> zanUsers) {
			SpannableStringBuilder sp = new SpannableStringBuilder();
			int count = zanUsers != null ? zanUsers.size() : 0;
			for (int i = 0; i < count; i++) {
				Review review = zanUsers.get(i);
				String name = review.getNickName();
				String userId = review.getFriendName();
				int length = name.length();
				int start = sp.length();

				if (i < count - 1) {
					sp.append(name + " , ");
				} else {
					sp.append(name);
				}
				sp.setSpan(new MyURLSpan(userId), start, start + length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			}

			zTxt.setText(sp);
			zTxt.setMovementMethod(LinkMovementMethod.getInstance());
		}

		private void setComments(LinearLayout view, final Circle mCircle) {
			view.removeAllViews();
			List<Review> comments = mCircle.getCommentList();
			int count = comments != null ? comments.size() : 0;

			for (int i = 0; i < count; i++) {
				TextView ct = new TextView(view.getContext());
				final Review review = comments.get(i);
				ct.setTextColor(getResources().getColor(R.color.circle_comment_color));
				ct.setTextSize(14);
				ct.setBackgroundResource(R.drawable.bg_transparent_to_translucent);
				if (i != count - 1) {
					ct.setPadding(0, 0, 0, 5);
				}

				final String userId = review.getFriendName();
				final String nickName = review.getNickName();
				final String content = review.getContent();
				int length = nickName.length();

				final String replayId = review.getCommentTo();
				boolean isReplay = false;
				int rLength = 0;

				if (content != null && !TextUtils.isEmpty(replayId) && content.startsWith("回复")) {
					rLength = content.indexOf("：");
					if (rLength == -1) {
						rLength = content.indexOf(":");
					}
					isReplay = true;
				}

				int textHeight = getResources().getDimensionPixelOffset(R.dimen.circle_comment_size);
				
				SpannableStringBuilder sp = new SpannableStringBuilder();
				if (isReplay) {
					sp.append(nickName).append(content);
				} else {
					sp.append(nickName + " : ").append(content);
				}
				sp.setSpan(new MyURLSpan(userId), 0, length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

				if (isReplay) {
					sp.setSpan(new MyURLSpan(replayId), length + 2, length + rLength, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				}

				ct.setText(sp);
				ct.setTag(review);
				ct.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						//
						if (myName.equals(review.getFriendName())) {
							currCircle = mCircle;
							CustomDialog custom = new CustomDialog(mContext, R.style.tip_dialog,
									review);
							custom.show();
						} else {
							currCircle = mCircle;
							//replayComment(v, userId, nickName, "评论数据");
						}
					}
				});
				ct.setOnLongClickListener(new OnLongClickListener() {

					@Override
					public boolean onLongClick(View arg0) {
						if (myName.equals(review.getFriendName())) {
							return false;
						} else {
							CustomDialog custom = new CustomDialog(mContext, R.style.tip_dialog,
									content, 2);
							custom.show();
						}
						return true;
					}
				});
				ct.setMovementMethod(LinkMovementMethod.getInstance());
				view.addView(ct, new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
			}
		}

		public void replayComment(View v, String fUser, String fName, String content) {

			try {
				InputMethodManager imm = (InputMethodManager) mContext.getSystemService(Context.INPUT_METHOD_SERVICE);
				Review review = (Review) v.getTag();
				final String reply = "回复" + review.getNickName() + "：";
				if (inputView.getHint() != null) {
					String hint = inputView.getHint().toString();
					if (TextUtils.equals(reply, hint)) {
						inputView.setHint("");
						inputView.setTag("");
						imm.hideSoftInputFromWindow(inputView.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
						return;
					}
				}
				inputView.setTag(review);
				inputView.setHint(reply);
				imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
				inputView.requestFocus();
				displayInput();
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		class MyURLSpan extends ClickableSpan {

			private String mUrl;

			MyURLSpan(String url) {
				mUrl = url;
			}

			@Override
			public void onClick(View widget) {
				widget.setClickable(false);
				/*Intent intent = new Intent();
				intent.setClass(mContext, UserInfosActivity.class);
				intent.putExtra("phoneNum", mUrl);
				startActivity(intent);*/

			}

			@Override
			public void updateDrawState(TextPaint ds) {
				ds.setColor(getResources().getColor(R.color.light_grey_text));
				// ds.clearShadowLayer();
				ds.setUnderlineText(false);
			}
		}

		class ViewHolder {
			private ImageView user_icon;
			private TextView user_lickname;
			private TextView share_date;
			private TextView share_content;
			private TextView tv_voice;
			private TextView tv_location;
			private ImageView tv_comment_num;
			private TextView tv_zan_num;
			private TextView tv_zan_ainm;

			private View imgLayout;
			private View imgLayout1;
			private View imgRaw1;
			private View imgRaw2;
			private View imgRaw3;

			private ImageView img1;

			private ImageView[] imgItems = new ImageView[9];

			/**
			 * 文字 收起 或者 打开的开关
			 */
			private TextView text_switch;

			// private View rightLayout;
			// private SwipeLayout swipe;

			private View url_point_view;
			private ImageView url_iamge_view;
			private TextView url_title_view;
			private TextView url_brief_view;

			private View voiceLayout;
			private ImageView voice_iamgeciew;

			/*private View videoLayout;
			private ImageView videoFloat;
			private ProgressBar videoProgress;
			private VideoView videoView;
			private ImageView leftVideoPlay;*/

			/*
			 * private TextView txt_pinglun; private TextView txt_zan; private
			 * ImageView iamgeview_zan; private View layout_pinglun; private
			 * View layout_zan;
			 */

			private TextView delete_txt;

			private View layout_review;
			private TextView txt_zan_users;
			private View layout_review_line;
			private LinearLayout layout_comments;

			private View item_layout;

			private ImageView gender;
			private View root;
			private Circle circle;
			private int position;
			// private View sanjiao;
			private View zan_user_layout;

			private LinearLayout add_friend_bt;
			private ImageView add_friend_img;
			private TextView add_friend_text;
		}

		@Override
		public boolean onLongClick(View v) {
			int picNum = -1;
			switch (v.getId()) {
			case R.id.share_content:
				Circle circle0 = (Circle) v.getTag();
				if (!TextUtils.isEmpty(circle0.getmUrl())) {
					try {
						CustomDialog custom = new CustomDialog(mContext, R.style.tip_dialog,
								circle0.getmUrl(), circle0, 3, 3);
						custom.show();
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					try {
						String content = ((TextView) v).getText().toString();
						CustomDialog custom = new CustomDialog(mContext, R.style.tip_dialog,
								content, circle0);
						custom.show();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

				break;
			case R.id.img_33:
				if (picNum < 0)
					picNum = 8;
			case R.id.img_32:
				if (picNum < 0)
					picNum = 7;
			case R.id.img_31:
				if (picNum < 0)
					picNum = 6;
			case R.id.img_23:
				if (picNum < 0)
					picNum = 5;
			case R.id.img_22:
				if (picNum < 0)
					picNum = 4;
			case R.id.img_21:
				if (picNum < 0)
					picNum = 3;
			case R.id.img_13:
				if (picNum < 0)
					picNum = 2;
			case R.id.img_12:
				if (picNum < 0)
					picNum = 1;
			case R.id.img_11:
			case R.id.img1:
				Circle circle = (Circle) v.getTag();
				if (circle != null && circle.getmPicPaths() != null) {

					if (circle.getmPicPaths().size() == 4 && (picNum == 3 || picNum == 4)) {
						picNum -= 1;
					}

					if (picNum < 0 || picNum >= circle.getmPicPaths().size()) {
						picNum = 0;
					}
					try {

						String url = Utils.DOWNLOAD_PIC + circle.getmPhoneNum() + "&filename="
								+ circle.getmPicPaths().get(picNum).trim() + "&mode=original";
						/*CustomDialog custom = new CustomDialog(mContext, R.style.tip_dialog, url,
								circle, 3, 1);
						custom.show();*/

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				break;
		/*	case R.id.video_float_view:
				try {
					ViewHolder myHolder = (ViewHolder) v.getTag();
					Circle circle1 = myHolder.circle;
					String urlStr = circle1.getmVideo();

					urlStr = URLEncoder.encode(urlStr, "utf-8").replaceAll("\\+", "%20");
					urlStr = urlStr.replaceAll("%3A", ":").replaceAll("%2F", "/");
					String videoPath = Utils.DOWNLOAD_VIDEO + circle1.getmPhoneNum() + "&filename=" + urlStr;
					if (videoPath.startsWith(VideoDir)) {
						ToastUtil.showToast(mContext, "收藏失败！");
					}
					CustomDialog custom = new CustomDialog(mContext, R.style.tip_dialog, videoPath,
							circle1, 3, 2);
					custom.show();
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;*/

			default:
				break;
			}
			return true;
		}

		private long clickTime = 0l;

		@Override
		public void onClick(View v) {
			int picNum = -1;
			switch (v.getId()) {
			case R.id.user_icon: {
				Circle circle = (Circle) v.getTag();
				/*Intent intent = new Intent();
				// intent.setClass(ViewPointCircleActivity3.this,
				// MyTopicActivty.class);
				intent.setClass(mContext, UserInfosActivity.class);
				intent.putExtra("phoneNum", circle.getmPhoneNum());
				intent.putExtra("nickName", circle.getmLickName());
				intent.putExtra("avatar", circle.getmIcon());
				startActivity(intent);*/
			}
				break;
			case R.id.img_33:
				if (picNum < 0)
					picNum = 8;
			case R.id.img_32:
				if (picNum < 0)
					picNum = 7;
			case R.id.img_31:
				if (picNum < 0)
					picNum = 6;
			case R.id.img_23:
				if (picNum < 0)
					picNum = 5;
			case R.id.img_22:
				if (picNum < 0)
					picNum = 4;
			case R.id.img_21:
				if (picNum < 0)
					picNum = 3;
			case R.id.img_13:
				if (picNum < 0)
					picNum = 2;
			case R.id.img_12:
				if (picNum < 0)
					picNum = 1;
			case R.id.img_11:
			case R.id.img1:
				Circle circle = (Circle) v.getTag();
				if (circle != null && circle.getmPicPaths() != null) {

					if (circle.getmPicPaths().size() == 4 && (picNum == 3 || picNum == 4)) {
						picNum -= 1;
					}

					if (picNum < 0 || picNum >= circle.getmPicPaths().size()) {
						picNum = 0;
					}
					Intent intent = new Intent(mContext, ImagePagerActivity.class);
					try {
						ArrayList<String> drawables = new ArrayList<String>();
						for (int i = 0; i < circle.getmPicPaths().size(); i++) {
							String item = circle.getmPicPaths().get(i % circle.getmPicPaths().size());
							drawables.add(item.trim());
						}

						intent.putExtra("imageList", drawables);
						intent.putExtra("position", picNum);
						intent.putExtra("msgType", "aaa");
						intent.putExtra("phone", circle.getmPhoneNum());

						startActivity(intent);
						getActivity().getParent().overridePendingTransition(R.anim.zoomin,
								R.anim.zoomout);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				break;
			case R.id.content_up_down: {
				TextView upd = (TextView) v;
				String lable = upd.getText().toString();
				ViewHolder mHolder = (ViewHolder) v.getTag();
				if ("全文".equals(lable)) {
					mHolder.share_content.setMaxLines(100);
					upd.setText("收起");
					mAllTextId.add(mHolder.circle.getmPhoneNum() + mHolder.circle.getmTime());
				} else {
					mHolder.share_content.setMaxLines(6);
					upd.setText("全文");
					mAllTextId.remove(mHolder.circle.getmPhoneNum() + mHolder.circle.getmTime());
				}
			}
				break;
			case R.id.circle_item_layout:
				// case R.id.tv_comment_num:
			case R.id.share_content:
				circle = (Circle) v.getTag();

				if (!TextUtils.isEmpty(circle.getmUrl())) {
					/*Intent intent = new Intent();
					intent.setClass(mContext, WebsiteViewPoint.class);
					intent.putExtra("circle", circle);
					startActivity(intent);*/
				} else {
					closeInputView();
				}

				break;

			case R.id.tv_comment_num:
				closeInputView();
				circle = (Circle) v.getTag();
				showPopupWindow(v, circle);
				break;
			case R.id.voice_iamgeciew:
				playVoice(v);
				break;
			case R.id.tv_zan_num:
				if (System.currentTimeMillis() - clickTime < 1500l) {
					clickTime = System.currentTimeMillis();
					return;
				}
				clickTime = System.currentTimeMillis();

				final ViewHolder holder = (ViewHolder) v.getTag();
				final Circle circl = mCircles.get(holder.position);
				final boolean isPrise = !circl.hasZan;
				final TextView animText = holder.tv_zan_ainm;
				Animation anim = AnimationUtils.loadAnimation(mContext, R.anim.circle_zan);
				animText.setVisibility(View.VISIBLE);
				anim.setAnimationListener(new AnimationListener() {

					@Override
					public void onAnimationStart(Animation animation) {
						animText.setText(isPrise ? "+ 1" : "- 1");
						animText.setTextColor(mContext.getResources()
								.getColor(isPrise ? R.color.black_tag2 : R.color.orange_title));
						animText.setVisibility(View.VISIBLE);
					}

					@Override
					public void onAnimationRepeat(Animation animation) {
					}

					@Override
					public void onAnimationEnd(Animation animation) {
						animText.setVisibility(View.GONE);
						if (isPrise) {
							try {
								int zan = circl.getZanCount();
								holder.tv_zan_num.setText(zan + "");
								holder.tv_zan_num.setSelected(true);
							} catch (Exception e) {
								e.printStackTrace();
							}
						} else {
							try {
								int zan = circl.getZanCount();
								holder.tv_zan_num.setText(zan + "");
								holder.tv_zan_num.setSelected(false);
							} catch (Exception e) {
								e.printStackTrace();
							}
						}
					}
				});

				if (isPrise) {
					int zanCount = circl.getZanCount() + 1;
					circl.setZanCount(zanCount);
				} else {
					int zanCount = circl.getZanCount() - 1;

					if (zanCount < 0) {
						zanCount = 0;
					}
					circl.setZanCount(zanCount);
				}

				animText.startAnimation(anim);

				/*
				 * if(circl.hasZan){ deleteComment(circl); }else
				 * publishReviewThread(circl); circl.hasZan = !circl.hasZan;
				 * dbHelper.updateZanState(ViewPointCircleActivity3.this,circl.
				 * getmId(),circl.getmPhoneNum(), circl.hasZan);
				 */

				break;
			/*case R.id.video_float_view: {
				ViewHolder myHolder = (ViewHolder) v.getTag();
				circle = myHolder.circle;
				String videoPath = circle.getmVideo();

				if (videoPath.startsWith(VideoDir)) {
					File newFile = new File(videoPath);
					if (newFile == null || !newFile.exists()) {
						ToastUtil.showToast(mContext, getString(R.string.video_is_loading));
						return;
					}
				} else {
					String localPath = UploadFileDBHelper.getInstance(mContext)
							.getLocalFileName(circle.getmPhoneNum(), videoPath);
					if (TextUtils.isEmpty(localPath)) {
						videoPath = loadChatPath + videoPath;
						File newFile = new File(videoPath);
						if (newFile == null || !newFile.exists()) {
							// videoPath = Utils.DOWNLOAD_VIDEO +
							// circle.getmPhoneNum() + "&filename=" +
							// circle.getmVideo();
							if (myHolder.leftVideoPlay.getVisibility() == View.GONE) {
								ToastUtil.showToast(mContext,
										getString(R.string.video_is_loading));
							} else {
								myHolder.leftVideoPlay.setVisibility(View.GONE);
								myHolder.videoProgress.setVisibility(View.VISIBLE);
								Message message = new Message();
								message.obj = circle;
								message.arg1 = 1;
								message.what = 1;
								loadVoiceHandler.sendMessage(message);
							}

							return;
						}
					} else {
						videoPath = localPath;
					}

				}

				Intent vdIntent = new Intent(mContext, VideoPlayActivity.class);
				vdIntent.putExtra(VideoPlayActivity.EXTRA_VIDEO_PATH, videoPath);
				startActivity(vdIntent);
			}
				break;*/
			case R.id.circle_delete: {
				circle = (Circle) v.getTag();
				showDialog(circle);
			}
				break;
			/*case R.id.add_friend_bt: {
				int type = (Integer) v.getTag(R.id.tag_second);
				if (type == UserGroup.TYPE_RELATIONSHIP_FRIEND || type == UserGroup.TYPE_RELATIONSHIP_VERIFICATION) {
					return;
				}
				String phone = (String) v.getTag(R.id.tag_first);
				if (type == UserGroup.TYPE_RELATIONSHIP_ACCEPT) {
					feedBackFocus(phone);
				} else if (type == UserGroup.TYPE_RELATIONSHIP_ADD_NO) {
					doAttention(phone);
				}
			}
				break;*/
			default:
				break;
			}
		}

		/*private void doAttention(final String phone) {
			new Thread(new Runnable() {
				@Override
				public void run() {
					JSONObject obj = new JSONObject();
					try {
						obj.put("userName", SharedHelper.getShareHelper(mContext)
								.getString(SharedHelper.USER_NAME, ""));
						obj.put("focusUserName", phone);
						obj.put("verifyMsg", "");
						HttpResponse response = Utils.getResponse(Utils.REMOTE_SERVER_URL, "focusSomeone", obj,
								Utils.URL_TYPE_DEVICE_WT, 30000, 30000);
						int code = response.getStatusLine().getStatusCode();
						if (code != 200) {
							handler.sendEmptyMessage(R.string.SEND_ATTENTION_FAILURE);
							return;
						}

						int resultCode = Integer
								.valueOf(response.getHeaders(Utils.URL_KEY_RESULT_CODE)[0].getValue() + "");
						if (resultCode == 4001) {// 用户已在别处登录
							SharedHelper sharedHelper = SharedHelper.getShareHelper(mContext);
							sharedHelper.putString(SharedHelper.USER_NAME, null);
							sharedHelper.putString(SharedHelper.USER_NICKNAME, null);
							sharedHelper.putInt(SharedHelper.WHICH_ME, 0);
							sharedHelper.putString("avatar", null);
							sharedHelper.putString("declaration", null);
							startActivity(new Intent(mContext, VerifyDialogActivity.class));
							finish();
							return;
						}

						JSONObject jsonObject = new JSONObject(EntityUtils.toString(response.getEntity()));
						if (jsonObject.has("ok")) {
							UserGroupDBHelper.getInstance(mContext).updateFocusType(phone, "", "",
									"", UserGroup.TYPE_RELATIONSHIP_VERIFICATION);
							mHandler.sendEmptyMessage(9998);
						} else if (jsonObject.has("no")) {
							handler.sendEmptyMessage(R.string.ERR_UN_NOT_EXIST);
						} else if (jsonObject.has("error")) {
							try {
								String error = jsonObject.getString("error");
								if (error.startsWith("focus username is invalid")) {
									handler.sendEmptyMessage(R.string.error_focus_invalid);
								} else {
									handler.sendEmptyMessage(R.string.error_server);
								}
							} catch (JSONException e) {
								e.printStackTrace();
								handler.sendEmptyMessage(R.string.SEND_ATTENTION_FAILURE);
							}

						} else {
							handler.sendEmptyMessage(R.string.error_server);
						}
					} catch (Exception e) {
						e.printStackTrace();
						handler.sendEmptyMessage(R.string.SEND_ATTENTION_FAILURE);
					}
				}
			}).start();
		}

		private void feedBackFocus(final String phone) {
			new Thread(new Runnable() {
				@Override
				public void run() {
					JSONObject obj = new JSONObject();
					try {
						obj.put("userName", phone);
						obj.put("focusUserName", SharedHelper.getShareHelper(mContext)
								.getString(SharedHelper.USER_NAME, ""));
						obj.put("action", 1 + "");
						HttpResponse response = Utils.getResponse(Utils.REMOTE_SERVER_URL, "feedbackFocus", obj,
								Utils.URL_TYPE_DEVICE_WT, 30000, 30000);
						if (response == null) {
							return;
						}
						int code = response.getStatusLine().getStatusCode();
						if (code != 200) {
							return;
						}
						JSONObject jsonObject = new JSONObject(EntityUtils.toString(response.getEntity()));
						if (jsonObject.has("ok")) {
							// feedback focus ok
							String ok = jsonObject.getString("ok");
							if (ok.startsWith("feedback focus ok")) {
								UserGroupDBHelper.getInstance(mContext).updateFocusType(phone, "",
										"", "", UserGroup.TYPE_RELATIONSHIP_FRIEND);
								mHandler.sendEmptyMessage(9998);
							}
						} else if (jsonObject.has("error")) {
							String error = jsonObject.getString("error");
							if (error.startsWith("peer")) {
								handler.sendEmptyMessage(R.string.peer_cancel_focus);
							} else if (error.startsWith("db")) {
								handler.sendEmptyMessage(R.string.error_db);
							} else {
								handler.sendEmptyMessage(R.string.error_server);
							}
						} else {
							handler.sendEmptyMessage(R.string.error_server);
						}
					} catch (ConnectTimeoutException e) {
						handler.sendEmptyMessage(R.string.error_network);
						e.printStackTrace();
					} catch (SocketTimeoutException e) {
						handler.sendEmptyMessage(R.string.error_network);
						e.printStackTrace();
					} catch (ConnectException e) {
						handler.sendEmptyMessage(R.string.error_network);
						e.printStackTrace();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}).start();
		}

		Handler handler = new Handler() {
			public void handleMessage(android.os.Message msg) {
				switch (msg.what) {
				case R.string.error_server:
					Toast.makeText(mContext, R.string.error_server, Toast.LENGTH_SHORT).show();
					break;
				case R.string.error_network:
					Toast.makeText(mContext, R.string.error_network, Toast.LENGTH_SHORT).show();
					break;
				case R.string.ERR_TIMEOUT:
					Toast.makeText(mContext, R.string.ERR_TIMEOUT, Toast.LENGTH_SHORT).show();
					break;
				case R.string.ERR_UN_NOT_EXIST:
					Toast.makeText(mContext, R.string.ERR_UN_NOT_EXIST, Toast.LENGTH_SHORT).show();
					break;
				case R.string.error_db:
					Toast.makeText(mContext, R.string.error_db, Toast.LENGTH_SHORT).show();
					break;
				case R.string.SEND_ATTENTION_FAILURE:
					Toast.makeText(mContext, R.string.SEND_ATTENTION_FAILURE, Toast.LENGTH_LONG)
							.show();
					break;
				case R.string.error_focus_invalid:
					Toast.makeText(mContext, R.string.error_focus_invalid, Toast.LENGTH_SHORT)
							.show();
					break;
				case 2001:

					// int result = msg.arg1;
					if (msg.arg1 == 0) {
						ToastUtil.showToast(mContext, "收藏成功！");
					} else if (msg.arg1 == 9999) {
						ToastUtil.showToast(mContext, "收藏失败！");
					}
					break;
				default:
					break;
				}
			};
		};

		private String VideoDir = VideoRecorderActivity.VIDEO_DIR;

		private void setVideoResource(final Circle mCircle, final ViewHolder holder) {

			int loadImage = R.drawable.video_loading_240x320;
			int loadFail = R.drawable.video_failed_240x320;

			if (mCircle.getVideoWidth() == 0 || mCircle.getVideoHeight() == 0) {

				LayoutParams lpv = holder.videoLayout.getLayoutParams();
				lpv.height = videoMaxHeight;
				lpv.width = videoMaxWidth;
				holder.videoLayout.setLayoutParams(lpv);
				holder.videoLayout.requestLayout();

			} else {
				float fv = 1.0f * mCircle.getVideoWidth() / mCircle.getVideoHeight();

				LayoutParams lpv = holder.videoLayout.getLayoutParams();

				if (fv > 1) {
					lpv.height = (int) (videoMaxHeight / fv);
					lpv.width = videoMaxHeight;

					loadImage = R.drawable.video_loading_320x240;
					loadFail = R.drawable.video_failed_320x240;
				} else {
					lpv.height = videoMaxHeight;
					lpv.width = (int) (videoMaxHeight * fv);
				}

				holder.videoLayout.setLayoutParams(lpv);
				holder.videoLayout.requestLayout();

			}

			try {
				holder.videoView.stopPlayback();
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			String videoPath = mCircle.getmVideo();
			if (TextUtils.isEmpty(videoPath)) {
				return;
			}

			if (videoPath.startsWith(VideoDir)) {
				File newFile = new File(videoPath);
				if (newFile == null || !newFile.exists()) {
					// ToastUtil.showToast(ViewPointCircleActivity3.this,
					// "视频文件丢失！");
					holder.videoProgress.setVisibility(View.GONE);
					holder.leftVideoPlay.setVisibility(View.GONE);
					holder.videoFloat.setImageResource(loadFail);
					return;
				}
			} else {

				String localPath = UploadFileDBHelper.getInstance(mContext)
						.getLocalFileName(mCircle.getmPhoneNum(), videoPath);
				if (TextUtils.isEmpty(localPath)) {
					videoPath = loadChatPath + videoPath;
					File newFile = new File(videoPath);

					if (newFile == null || !newFile.exists()) {
						if (isWifi(mContext)) {
							mAllDownId.add(mCircle.getmVideo());
							Message message = new Message();
							message.obj = mCircle;
							message.arg1 = 1;
							message.what = 1;
							loadVoiceHandler.sendMessage(message);
							holder.videoProgress.setVisibility(View.VISIBLE);
							holder.leftVideoPlay.setVisibility(View.GONE);
						} else {
							if (mAllDownId.contains(mCircle.getmVideo())) {
								holder.videoProgress.setVisibility(View.VISIBLE);
								holder.leftVideoPlay.setVisibility(View.GONE);
							} else {
								holder.videoProgress.setVisibility(View.GONE);
								holder.leftVideoPlay.setVisibility(View.VISIBLE);
							}

						}
						holder.videoFloat.setImageResource(loadImage);
						String imgPath = Utils.DOWNLOAD_VIDEO_SNAPSHOT + mCircle.getmPhoneNum() + "&filename="
								+ mCircle.getmVideo().replace(".mp4", "");
						imageLoader.displayImage(imgPath, holder.videoFloat, optionsVideo);
						 
						return;
					}
				} else {
					Log.i("testTag", "本地存在的文件：" + localPath);
					videoPath = localPath;
				}

				// videoPath = Utils.DOWNLOAD_VIDEO + mCircle.getmPhoneNum() +
				// "&filename=" + videoPath;
			}
			holder.leftVideoPlay.setVisibility(View.GONE);
			holder.videoProgress.setVisibility(View.GONE);
			holder.videoView.setOnErrorListener(new MediaPlayer.OnErrorListener() {
				@Override
				public boolean onError(MediaPlayer mp, int what, int extra) {
					float fv = 0;
					try {
						fv = 1.0f * holder.videoFloat.getWidth() / holder.videoFloat.getHeight();
					} catch (Exception e) {
						e.printStackTrace();
					}
					holder.videoFloat.setImageResource(
							fv > 1 ? R.drawable.video_failed_320x240 : R.drawable.video_failed_240x320);
					return true;
				}
			});
			holder.videoView.setVideoPath(videoPath);
			holder.videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
				public void onCompletion(MediaPlayer mp) {

					mp.start();
					mp.setLooping(true);
				}
			});
			holder.videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
				@Override
				public void onPrepared(MediaPlayer mp) {
					holder.videoFloat.setImageResource(R.drawable.transparent_drawable);
					try {
						if (mp.isPlaying()) {
							mp.stop();
							mp.release();
							mp = new MediaPlayer();
						}
						mp.setVolume(0f, 0f);
						mp.setLooping(false);
						mp.start();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			});
			holder.videoView.setVisibility(View.VISIBLE);
		}
*/
		private void checkVoiceImageState(Circle mCircle, ViewHolder holder) {
			if (TextUtils.isEmpty(mCircle.getmVoice())) {
				return;
			}

			if (musicPlayerService.isPlaying()) {

				String voicePath = mCircle.getmVoice();

				if (!voicePath.contains("sdcard/.Tfire/point")) {
					voicePath = loadChatPath + voicePath;
				}

				if (!voicePath.equals(clickStr)) {
					return;
				}

				try {
					if (animaition != null) {
						animaition.stop();
						animaition.selectDrawable(0);
						animaition = null;
					}

					animaition = (AnimationDrawable) getResources().getDrawable(R.anim.voice_play);
					animaition.setBounds(0, 0, animaition.getIntrinsicWidth(), animaition.getIntrinsicHeight());
					holder.voice_iamgeciew.setImageDrawable(animaition);
					animaition.setOneShot(false);
					if (animaition.isRunning()) // 是否正在运行？
						animaition.stop();// 停止
					animaition.start();
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
		}

		String clickStr = "";

		private void playVoice(View tv) {
			String voice = (String) tv.getTag();
			if (TextUtils.isEmpty(voice) || !voice.endsWith("amr")) {
				return;
			}

			String voicePath = voice;
			if (!voicePath.contains("sdcard/.Tfire/point")) {
				voicePath = loadChatPath + voicePath;
			}

			File newFile = new File(voicePath);
			if (newFile == null || !newFile.exists()) {
				return;
			}

			if (musicPlayerService.isPlaying()) {
				musicPlayerService.stop();
				if (!voicePath.equals(clickStr)) {
					musicPlayerService.setDataSource(voicePath);
					musicPlayerService.start();
					clickStr = voicePath;
				} else if (animaition != null && animaition.isRunning()) {// 是否正在运行？
					animaition.stop();// 停止
					animaition.selectDrawable(0);
					return;
				}
			} else {
				musicPlayerService.setDataSource(voicePath);
				musicPlayerService.start();
				clickStr = voicePath;
				// musicPlayerService
			}

			try {
				if (animaition != null) {
					animaition.stop();
					animaition.selectDrawable(0);
					animaition = null;
				}

				animaition = (AnimationDrawable) getResources().getDrawable(R.anim.voice_play);
				animaition.setBounds(0, 0, animaition.getIntrinsicWidth(), animaition.getIntrinsicHeight());
				((ImageView) tv).setImageDrawable(animaition);
				animaition.setOneShot(false);
				if (animaition.isRunning()) // 是否正在运行？
					animaition.stop();// 停止
				animaition.start();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		private void setImageItem(final Circle mCircle, final ViewHolder holder) {
			try {
				if (mCircle.getmPicPaths() != null && mCircle.getmPicPaths().size() > 0) {

					holder.imgLayout.setVisibility(View.VISIBLE);
					int picCount = mCircle.getmPicPaths().size();

					if (picCount == 1) {

						holder.imgLayout1.setVisibility(View.VISIBLE);
						holder.imgRaw1.setVisibility(View.GONE);
						holder.imgRaw2.setVisibility(View.GONE);
						holder.imgRaw3.setVisibility(View.GONE);
						try {
							String item = mCircle.getmPicPaths().get(0);
							String url = "file://" + item.trim();
							if (!TextUtils.isEmpty(item.trim())) {
								if (!item.trim().contains(Environment.getExternalStorageDirectory().getPath())) {
									//  /file/image?uid=xxxx&session=yyyy&fid=zzz&size=small
									url = Utils.DOWNLOAD_PIC  + mCircle.getmPhoneNum() + "&session=" + mySession + "&fid=" + item.trim()
											+ "&size=small";
								}
							}
							// 设置imageView 的大小
							setImageViewBounds(holder.img1, mCircle.imageWidth, mCircle.imageHeight);
							imageLoader.displayImage(url, holder.img1, options, new SimpleImageLoadingListener() {
								@Override
								public void onLoadingComplete(String imageUri, View view, Bitmap loadedImage) {
									super.onLoadingComplete(imageUri, view, loadedImage);
									holder.img1.postInvalidate();
								}
							});
							 
						} catch (Exception e) {
							Log.i("testTag", "图片加载出错" + e.getMessage());
							e.printStackTrace();
							holder.imgLayout1.setVisibility(View.GONE);
						}
						// holder.img1.requestLayout();
					} else {

						holder.imgLayout1.setVisibility(View.GONE);
						holder.imgRaw1.setVisibility(View.VISIBLE);

						if (picCount < 4) {
							holder.imgRaw2.setVisibility(View.GONE);
						} else {
							holder.imgRaw2.setVisibility(View.VISIBLE);
						}

						if (picCount < 7) {
							holder.imgRaw3.setVisibility(View.GONE);
						} else {
							holder.imgRaw3.setVisibility(View.VISIBLE);
						}

						for (int i = 0; i < 9; i++) {

							int index = i;
							if (picCount == 4) {

								if (i == 2) {
									holder.imgItems[i].setVisibility(View.GONE);
									continue;
								} else if (i == 3 || i == 4) {
									index = i - 1;
								}

							}

							if (index < picCount) {
								holder.imgItems[i].setVisibility(View.VISIBLE);
								try {
									String item = mCircle.getmPicPaths().get(index);
									String url = "file://" + item.trim();
									if (!TextUtils.isEmpty(item.trim())) {
										if (!item.trim()
												.contains(Environment.getExternalStorageDirectory().getPath())) {
											url = Utils.DOWNLOAD_PIC  + mCircle.getmPhoneNum() + "&session=" + mySession + "&fid=" + item.trim()
													+ "&size=small";
										}
									}
									imageLoader.displayImage(url, holder.imgItems[i], options);
									 
								} catch (Exception e) {
									e.printStackTrace();
									// holder.imgItems[i].setVisibility(View.GONE);
								}
							} else {
								holder.imgItems[i].setVisibility(View.GONE);
							}

						}

					}

				} else {
					holder.imgLayout.setVisibility(View.GONE);
				}

			} catch (Exception e) {
				e.printStackTrace();
				Log.e("logo", "e：" + e.getMessage());
			}
		}

		private void setImageViewBounds(ImageView img, int w, int h) {
			LayoutParams lp = img.getLayoutParams();
			if (w > 0 && h > 0) {
				float hv = 1.0f * w / h;
				if (hv >= 1) {
					if (w > imageMaxWidth) {
						lp.width = imageMaxWidth;
						lp.height = (int) (imageMaxWidth / hv);
					} else if (w < imgItemW) {
						lp.width = imgItemW;
						lp.height = (int) (imgItemW / hv);
					} else {
						lp.width = w;
						lp.height = h;
					}

				} else {
					if (h > imageMaxWidth) {
						lp.width = (int) (imageMaxWidth * hv);
						lp.height = imageMaxWidth;
					} else if (h < imgItemH) {
						lp.width = (int) (imgItemH * hv);
						lp.height = imgItemH;
					} else {
						lp.width = w;
						lp.height = h;
					}
				}
				// Log.i("testTag", "计算显示信息【宽："+lp.width+" 高："+ lp.height+"】 ");
				// img.requestLayout();
			} else {
				lp.width = imageMaxWidth;
				lp.height = imageMaxWidth;
				// Log.i("testTag", "没有宽高，显示默认图片大小");
			}

			img.setLayoutParams(lp);
			img.setScaleType(ScaleType.FIT_XY);

		}

		private String checkVoice(Circle circle) {
			String returnStr = "";
			// /sdcard/.Tfire/point/voice_1416562915706.amr
			boolean needDownload = false;
			String voicePath = circle.getmVoice();
			if (!voicePath.contains("sdcard/.Tfire/point")) {
				voicePath = loadChatPath + voicePath;
				needDownload = true;
			}
			File file = new File(voicePath);
			if (file.exists() && file.length() > 0) {
				if (getPlayer == null)
					getPlayer = new MusicPlayerService();
				getPlayer.setDataSource(voicePath);
				int duration = (int) Math.rint(Double.valueOf(getPlayer.getDuration()) / 1000d);
				if (duration == 0) {
					duration = 1;
				}
				returnStr = duration + "\"";
				if (duration > 1000) {
					returnStr = "";
				}
				needDownload = false;
			} else {
				Message message = new Message();
				message.obj = circle;
				message.arg1 = 1;
				message.what = 0;
				loadVoiceHandler.sendMessage(message);
			}
			/*
			 * if (needDownload) { Message message = new Message(); message.obj
			 * = circle; message.arg1 = 1; message.what = 0;
			 * loadVoiceHandler.sendMessage(message); }
			 */
			return returnStr;
		}

		/*private ShareUtils shareUtil;

		public ShareUtils getShareUtils(Context context) {
			if (shareUtil == null) {
				shareUtil = new ShareUtils(mContext);
			}
			return shareUtil;
		}*/

		public class CustomDialog extends Dialog {

			private String mContent = "";

			private int type = 0;

			private Review review;
			private Circle circle;
			private int col_type = 0;

			public CustomDialog(Context context, int theme, String content, int type) {
				super(context, theme);
				mContent = content;
				this.type = type;
			}

			public CustomDialog(Context context, int theme, String content, Circle circle, int type, int col_type) {
				super(context, theme);
				mContent = content;
				this.circle = circle;
				this.type = type;
				this.col_type = col_type;
			}

			public CustomDialog(Context context, int theme, String content, Circle circle) {
				super(context, theme);
				mContent = content;
				this.circle = circle;
				type = 0;
			}

			public CustomDialog(Context context, int theme, Review comment) {
				super(context, theme);
				mContent = comment.getContent();
				review = comment;
				type = 1;
			}

			protected void onCreate(Bundle savedInstanceState) {
				super.onCreate(savedInstanceState);
				setContentView(R.layout.image_menu_layout);

				((TextView) findViewById(R.id.save_text)).setText("复制");
				((TextView) findViewById(R.id.collection_text)).setText("收藏");

				if (type == 0) {
					findViewById(R.id.forward_item_layout).setVisibility(View.VISIBLE);
					findViewById(R.id.share_item_layout).setVisibility(View.VISIBLE);
					findViewById(R.id.collection_item_layout).setVisibility(View.GONE);
					findViewById(R.id.report_item_layout).setVisibility(View.GONE);
					((TextView) findViewById(R.id.report_text)).setText("举报");
				} else if (type == 1) {
					((TextView) findViewById(R.id.share_text)).setText("删除");
					findViewById(R.id.share_item_layout).setVisibility(View.VISIBLE);
					findViewById(R.id.forward_item_layout).setVisibility(View.GONE);
					findViewById(R.id.collection_item_layout).setVisibility(View.GONE);
					findViewById(R.id.report_item_layout).setVisibility(View.GONE);
				} else if (type == 2) {
					findViewById(R.id.share_item_layout).setVisibility(View.GONE);
					findViewById(R.id.forward_item_layout).setVisibility(View.GONE);
					findViewById(R.id.collection_item_layout).setVisibility(View.GONE);
					findViewById(R.id.report_item_layout).setVisibility(View.GONE);
				} else if (type == 3) {
					findViewById(R.id.save_item_layout).setVisibility(View.GONE);
					findViewById(R.id.share_item_layout).setVisibility(View.GONE);
					findViewById(R.id.forward_item_layout).setVisibility(View.GONE);
					findViewById(R.id.collection_item_layout).setVisibility(View.VISIBLE);
					findViewById(R.id.report_item_layout).setVisibility(View.VISIBLE);
					((TextView) findViewById(R.id.report_text)).setText("举报");
				}

				findViewById(R.id.report_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
					@Override
					public void onClick(View v) {
						/*startActivity(new Intent(mContext, ReportActivity.class).putExtra("circle",
								circle));
						dismiss();*/
					}
				});

				findViewById(R.id.collection_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
					@Override
					public void onClick(View v) {
						/*if (col_type == 3) {
							// if
							// (cHelper.insertCollection(circle.getmPhoneNum(),
							// circle.getmIcon(),
							// circle.getmLickName(), circle.getmImage(),
							// circle.getmTitle(), mContent,
							// col_type)) {
							// ToastUtil.showToast(getContext(), "收藏成功！");

							addCollection(circle.getmPhoneNum(), circle.getmImage(), circle.getmTitle(), mContent,
									col_type,circle.getmIcon(),circle.getmLickName());
							// } else {
							// ToastUtil.showToast(getContext(), "收藏失败！");
							// }
						} else {
							addCollection(circle.getmPhoneNum(), mContent, null, null, col_type,circle.getmIcon(),circle.getmLickName());
							// if
							// (cHelper.insertCollection(circle.getmPhoneNum(),
							// circle.getmIcon(),
							// circle.getmLickName(), mContent, null, null,
							// col_type)) {
							// ToastUtil.showToast(getContext(), "收藏成功！");
							// } else {
							// ToastUtil.showToast(getContext(), "收藏失败！");
							// }
						}*/

						dismiss();
					}
				});

				findViewById(R.id.save_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
					@Override
					public void onClick(View v) {
						ClipboardManager cmb = (ClipboardManager) mContext.getSystemService(Context.CLIPBOARD_SERVICE);
						cmb.setText(mContent.trim());
						ToastUtil.showToast(getContext(), "复制成功！");
						dismiss();
					}
				});

				findViewById(R.id.forward_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
					@Override
					public void onClick(View v) {
						/*getShareUtils(mContext).sendTextShare(ShareUtils.TYPE_SHARE_WECHAT_FRIEND,
								mContent.trim());*/
						dismiss();
					}
				});

				findViewById(R.id.share_item_layout).setOnClickListener(new android.view.View.OnClickListener() {
					@Override
					public void onClick(View v) {
						if (type == 0) {
							/*getShareUtils(mContext).sendTextShare(ShareUtils.TYPE_SHARE_WECHAT,
									mContent.trim());*/
						} else if (type == 1 && review != null) {
							deleteComment(currCircle, review);
						}
						dismiss();
					}
				});

			}

		}

		/*void addCollection(final String fromUser, final String content, final String remark, final String linkUrl,
				final int type, final String avator, final String nickname) {
			new Thread(new Runnable() {

				@Override
				public void run() {
					CollectionBiz biz = new CollectionBiz();
					int result = biz
							.addCollection(
									SharedHelper.getShareHelper(mContext)
											.getString(SharedHelper.USER_NAME, ""),
									fromUser, content, remark, linkUrl, type, avator, nickname);
					Message message = new Message();
					message.arg1 = result;
					message.what = 2001;
					handler.sendMessage(message);

				}
			}).start();

		}*/

		private void showPopupWindow(View view, final Circle circle) {

			// 一个自定义的布局，作为显示的内容
			View contentView = LayoutInflater.from(mContext).inflate(R.layout.circle_review_pop,
					null);
			final PopupWindow popupWindow = new PopupWindow(contentView, LayoutParams.WRAP_CONTENT,
					LayoutParams.WRAP_CONTENT, true);

			final TextView zanText = (TextView) contentView.findViewById(R.id.zan_text);
			if (circle.hasZan) {
				zanText.setText("取消");
			} else {
				zanText.setText("赞");
			}
			// 设置按钮的点击事件
			contentView.findViewById(R.id.zan_text_layout).setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {

					if(!isLogin()){
						popupWindow.dismiss();
						showLoginView();
						return;
					}
					
					if (circle.hasZan) {						
						deleteZan(circle);
					} else {
						myName = sharedHelper.getString(SharedHelper.USER_NAME, "");
						myNickName = sharedHelper.getString(SharedHelper.USER_NICKNAME, "");
						Review review = Review.creatZanData(circle.getmPhoneNum(), circle.getmTime(), myName,
								myNickName);
						addZanThread(circle, review);
					}

//					circle.hasZan = !circle.hasZan;

					if (!circle.hasZan) {
						zanText.setText("取消");
					} else {
						zanText.setText("赞");
					}

//					dbHelper.updateZanState(ViewPointCircleActivity3.this, circle.getmId(), circle.getmPhoneNum(),
//							circle.hasZan);
					Animation anim = AnimationUtils.loadAnimation(mContext, R.anim.circle_pop_zan);
					anim.setAnimationListener(new AnimationListener() {

						@Override
						public void onAnimationStart(Animation animation) {
						}

						@Override
						public void onAnimationRepeat(Animation animation) {
						}

						@Override
						public void onAnimationEnd(Animation animation) {
							new Handler().post(new Runnable() {
								@Override
								public void run() {
									popupWindow.dismiss();
								}
							});
						}
					});
					v.findViewById(R.id.zan_text_icon).startAnimation(anim);
				}
			});

			contentView.findViewById(R.id.comment_text_layout).setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					
					popupWindow.dismiss();
					
					if(!isLogin()){
						showLoginView();
						return;
					}
					
					ListView listView = pullToRefreshView.getRefreshableView();
					listView.setSelectionFromTop(mCircles.indexOf(circle)+1, 0);
					currCircle = circle;

					try {
						InputMethodManager imm = (InputMethodManager)mContext.getSystemService(Context.INPUT_METHOD_SERVICE);
						inputView.setHint("");
						inputView.setTag("");
						imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
						inputView.requestFocus();
						displayInput();
					} catch (Exception e) {
						e.printStackTrace();
					}

				}
			});

			popupWindow.setFocusable(true);
			popupWindow.setOutsideTouchable(true);
			popupWindow.setBackgroundDrawable(new BitmapDrawable());
			popupWindow.setAnimationStyle(R.style.ReviewPopAnim);

			int[] location = new int[2];
			view.getLocationOnScreen(location);

			popupWindow.showAtLocation(view, Gravity.NO_GRAVITY,
					location[0] - getResources().getDimensionPixelOffset(R.dimen.circle_pop_width) - 20, location[1]);
		}

		private void showDialog(final Circle mCircle) {
			new AlertDialog.Builder(mContext).setTitle(R.string.app_name)
					.setMessage(R.string.delete_conf).setPositiveButton("确定", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialoginterface, int i) {
							if (mCircle.getmId().length() == 20) {
								Log.i("testTag", "删除未发送成功的话题！");
								deleteLocalCircle(mCircle);
							} else {
								deleteCircle(mCircle);
							}

						}
					}).setNegativeButton("取消", null).show();
		}

	}

	

	private Handler loadVoiceHandler = new Handler() {
		public void handleMessage(Message msg) {

			DeviceUtils.checkSDCard(mContext);

			switch (msg.what) {
			case 0: {
				final Circle circle = (Circle) msg.obj;
				// final int notify = msg.arg1;
				++downloadVoiceCount;
				new Thread() {
					public void run() {
						DownloadUtils.downloadCircleVoice(mContext, circle);
					};
				}.start();
			}
				break;
			case 1: {
				final Circle circle = (Circle) msg.obj;
				// final int notify = msg.arg1;
				downloadVideoCount++;
				new Thread() {
					public void run() {
						//DownloadUtils.downloadCircleVideo(mContext, circle);
					};
				}.start();
			}
				break;
			default:
				break;
			}

		};
	};
	public static String loadChatPath = "/sdcard/.Tfire/point/";

	boolean isNotf;

	private ArrayList<View> mImagePageViewList;
	private LinearLayout indicatorLayout;

	private class ImagePageChangeListener implements OnPageChangeListener {
		@Override
		public void onPageScrollStateChanged(int arg0) {
			if (mImagePageViewList.size() > 1 && !mHandler.hasMessages(0)) {
				mHandler.sendEmptyMessageDelayed(0, 3000);
			}

		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
			if (mHandler.hasMessages(0)) {
				mHandler.removeMessages(0);
				mHandler.sendEmptyMessageDelayed(0, 3000);
			}
		}

		@Override
		public void onPageSelected(int index) {
			index = index % indicatorLayout.getChildCount();
			selectIndicatorPoint(index);
			refreshTopView(index);
		}
	}

	private void refreshTopView(int index) {
		try {
			if (firstVisiblePosition < 2 && index < mTopicList.size() && index < mImagePageViewList.size()
					&& index >= 0) {
				Topic topic = mTopicList.get(index);
				String imageUrl = "http://img.tomoon.cn/share/offical_topics_pics?filename=" + topic.getImage();
				ImageView imageView = (ImageView) mImagePageViewList.get(index).findViewById(R.id.img_guandian);
				imageLoader.displayImage(imageUrl, imageView, optionsTop);
				 
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private void refreshList(boolean is2Top) {
		mHandler.removeMessages(9998);
		mHandler.removeMessages(9999);
		if (is2Top) {
			isToTop = false;
			mHandler.sendEmptyMessage(9999);
		} else {
			mHandler.sendEmptyMessage(9998);
		}
	}

	Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case 9998:
				mHandler.removeMessages(9998);
				if(!isInitView){
					pullToRefreshView.setAdapter(circleAdapter);
					isInitView = true;
				}
				if (circleAdapter != null) {
					circleAdapter.notifyDataSetChanged();
				}
				break;
			case 9999:
				
				if(!isInitView){
					pullToRefreshView.setAdapter(circleAdapter);
					isInitView = true;
				}
				
				if (circleAdapter != null) {
					circleAdapter.notifyDataSetChanged();
					// if(mCircles.get(0).getmPhoneNum().equals(myName)){
					toListTop();
					// }
				}
				break;
			case 9992: {
				int code = (Integer) (msg.obj);
				if (code == -1) {
					ToastUtil.showToast(mContext, "点赞失败！");
				}
			}
				break;
			case 9993: {
				int code = (Integer) (msg.obj);
				if (code == -1) {
					ToastUtil.showToast(mContext, "评论发表失败！");
				}
			}
				break;
			case 9994: {
				ToastUtil.showToast(mContext, "评论删除失败！");
			}
				break;
			case 101:
				goback();
				break;
			case 0:
				if (firstVisiblePosition < 2) {
					toRight();
				} else {
					// Log.i("testTag", "推广栏没有显示，不在头部。当前头部 == " +
					// firstVisiblePosition);
				}
				mHandler.removeMessages(0);
				mHandler.sendEmptyMessageDelayed(0, 3000);
				break;
			case 1:
				initViewPager();
				if (!mHandler.hasMessages(0) && mImagePageViewList != null && mImagePageViewList.size() > 1) {
					mHandler.sendEmptyMessageDelayed(0, 3000);
				}
				break;
			case 2:{
				imm.showSoftInput(inputView, InputMethodManager.SHOW_FORCED);
			}break;
				
			default:
				break;
			}
		};
	};

	private void toRight() {
		try {
			if (mImagePageViewList != null && mImagePageViewList.size() > 1) {
				int nextItem = mViewPager.getCurrentItem() + 1;
				if (mImagePageViewList.size() == nextItem) {
					nextItem = 0;
				}
				mViewPager.setCurrentItem(nextItem);
				nextItem = nextItem % indicatorLayout.getChildCount();
				selectIndicatorPoint(nextItem);
				// raGrop_indicator.check(nextItem);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void selectIndicatorPoint(int index) {
		int oldCount = indicatorLayout.getChildCount();
		for (int i = 0; i < oldCount; i++) {
			indicatorLayout.getChildAt(i).setSelected(index == i);
		}

	}

	public void setIndicatorPoint(int index, int count) {

		int oldCount = indicatorLayout.getChildCount();
		if (oldCount > count) {
			for (int i = oldCount - 1; i >= count; i--) {
				indicatorLayout.removeViewAt(i);
			}
		} else if (oldCount < count) {
			for (int i = 0; i < (count - oldCount); i++) {
				addIndicatorPoint();
			}
		}
		selectIndicatorPoint(index);
	}

	private void addIndicatorPoint() {
		ImageView pointImg = new ImageView(getActivity());
		int width = getResources().getDimensionPixelSize(R.dimen.point_dicator_width);
		int space = getResources().getDimensionPixelSize(R.dimen.point_dicator_space);
		LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(width, width);
		lp.leftMargin = space;
		pointImg.setScaleType(ScaleType.FIT_XY);
		pointImg.setImageResource(R.drawable.dicator_point_selector);
		indicatorLayout.addView(pointImg, lp);
	}

	private ArrayList<Topic> getTopicList() {
		Gson gson = new Gson();
		String json = sharedHelper.getString(TOPIC_LIST, "");
		try {
			if (!TextUtils.isEmpty(json)) {
				ArrayList<Topic> list = gson.fromJson(json, new TypeToken<ArrayList<Topic>>() {
				}.getType());
				return list;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private void saveTopicList(ArrayList<Topic> list) {
		Gson gson = new Gson();
		String str = gson.toJson(list);
		sharedHelper.putString(TOPIC_LIST, str);
	}

	public static final String TOPIC_LIST = "TOPIC_LIST";
	ArrayList<Topic> mTopicList;
	private boolean isloadTopics = false;

	private void initViewPager() {
		mTopicList = getTopicList();
		if (mTopicList == null || mTopicList.size() == 0) {
			mImagePageViewList = new ArrayList<View>();
			View view = LayoutInflater.from(mContext).inflate(R.layout.simple_imageview, null);
			ImageView imageView = (ImageView) view.findViewById(R.id.img_guandian);
			imageView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					// startActivity(new Intent(ViewPointCircleActivity3.this,
					// ViewPointActivity.class));
				}
			});
			mImagePageViewList.add(view);
			indicatorLayout.setVisibility(View.GONE);
			mViewPager.setAdapter(new MyPagerAdapter(mImagePageViewList));
			return;
		}
		isloadTopics = true;
		ArrayList<String> mPicPaths = new ArrayList<String>();
		ArrayList<Integer> integers = new ArrayList<Integer>();

		for (int i = 0; i < mTopicList.size(); i++) {
			Topic viewPoint = mTopicList.get(i);
			if (TextUtils.isEmpty(viewPoint.getImage())) {
				integers.add(i);
			} else {
				mPicPaths.add(viewPoint.getImage());
				if (mPicPaths.size() >= 3) {
					break;
				}
			}
		}

		// 去除不可用的
		for (int i = 0; i < integers.size(); i++) {
			mTopicList.remove(integers.get(i));
		}

		mImagePageViewList = new ArrayList<View>();

		for (int i = 0; i < mTopicList.size() && i < 9; i++) {
			final Topic topic = mTopicList.get(i);
			String imageUrl = "http://img.tomoon.cn/share/offical_topics_pics?filename=" + topic.getImage();
			View view = LayoutInflater.from(mContext).inflate(R.layout.simple_imageview, null);
			ImageView imageView = (ImageView) view.findViewById(R.id.img_guandian);
			imageLoader.displayImage(imageUrl, imageView, optionsTop);
			 
			imageView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					Intent webViewIntent = new Intent(mContext, WebViewActivity.class);
				    webViewIntent.putExtra(WebViewFragment.ARG_TARGET_URL, topic.getUrl());
				    startActivity(webViewIntent);
				}
			});
			/*imageView.setOnTouchListener(new View.OnTouchListener() {

				@Override
				public boolean onTouch(View v, MotionEvent event) {
					topTouchListener(event);
					return false;
				}
			});*/
			mImagePageViewList.add(view);
		}

		if (mImagePageViewList.size() > 1) {
			indicatorLayout.setVisibility(View.VISIBLE);
			setIndicatorPoint(0, mImagePageViewList.size());
		} else {
			indicatorLayout.setVisibility(View.GONE);
		}
		pager_txt.setVisibility(View.GONE);
		

		mViewPager.setAdapter(new MyPagerAdapter(mImagePageViewList));
		mViewPager.setOnPageChangeListener(new ImagePageChangeListener());
	}

	private void getTopViewThread() {
		new Thread(new Runnable() {
			@Override
			public void run() {
				ArrayList<Topic> mTopics = getViewTopList();
				saveTopicList(mTopics);
				if (mTopics != null) {
					if (mTopicList != null) {
						if (mTopics.size() != mTopicList.size()) {
							mHandler.sendEmptyMessage(1);
						} else {

							for (int i = 0; i < mTopics.size(); i++) {
								boolean isSame = false;
								Topic nt = mTopics.get(i);
								for (int j = 0; j < mTopicList.size(); j++) {
									Topic ot = mTopicList.get(j);
									if (nt.getImage().equals(ot.getImage()) && nt.getUrl().equals(ot.getUrl())) {
										isSame = true;
										break;
									}
								}

								if (!isSame) {
									// Log.i("testTag", "幻灯片数据有更新");
									mHandler.sendEmptyMessage(1);
									break;
								} else {
									// Log.i("testTag", "幻灯片数据已存在：" +
									// nt.getTitle());
								}
							}
						}
					} else {
						mHandler.sendEmptyMessage(1);
					}
				}
			}
		}).start();
	}

	private ArrayList<Topic> getViewTopList() {
		try {
			JSONObject obj = new JSONObject();

			HttpResponse response = Utils.getResponse( Utils.REMOTE_SERVER_URL + "GetOfficalTopics", obj,
					 30000, 30000);

			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return null;
			}
			int resultCode = Integer.valueOf(response.getHeaders(Utils.URL_KEY_RESULT_CODE)[0].getValue() + "");
			String mViewPointCircle = EntityUtils.toString(response.getEntity());
			if (resultCode == 3003) {
			} else if (resultCode == 9999) {
			} else if (resultCode == 0) {
				JSONObject jb = new JSONObject(mViewPointCircle);
				ArrayList<Topic> mTopic = null;
				if (jb.has("itemList")) {

					JSONArray arr = jb.getJSONArray("itemList");
					mTopic = new ArrayList<Topic>();
					for (int i = 0; i < arr.length(); i++) {
						try {
							Topic topic = new Topic();
							JSONObject temp = (JSONObject) arr.get(i);
							String title = temp.getString("title");
							String pic = temp.getString("pic_name");
							String url = temp.getString("page_url");

							// http://img.tomoon.cn/share/offical_topics_pics?filename=
							topic.setTitle(title);
							;
							topic.setImage(pic);
							;
							topic.setUrl(url);

							mTopic.add(topic);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}

				return mTopic;
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

	private void publishReviewThread(final Circle circle, final Review review) {// 发布评论
		new Thread(new Runnable() {
			@Override
			public void run() {
				int code = publishReview(circle, review);
				Message msg = mHandler.obtainMessage();
				
				msg.what =  9993;
				msg.obj = code;
				msg.sendToTarget();
			}
		}).start();
	}

	private int publishReview(final Circle circle, final Review review) {
		try {
			JSONObject obj = new JSONObject();
			obj.put("Comment", review.getContent());
			String url = Utils.REMOTE_SERVER_URL+ "/topic/comment?uid="+myName+"&session="+mySession+"&tid="+circle.getmId();
			HttpResponse response = Utils.getResponse(url, obj,
					 30000, 30000);

			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return -1;
			}
			String mInfo = EntityUtils.toString(response.getEntity());
			JSONObject json = new JSONObject(mInfo);
			
			if(json.has("code")){
				int resultCode = json.getInt("code");
				if (resultCode == 0 && json.has("data")) {
					JSONObject jsb = json.getJSONObject("data");
					int sid = jsb.getInt("CommentId");
					review.setId(""+sid);			
					
					circle.addComment(review);
					circle.setCommentCount(circle.getCommentCount() + 1);
					dbHelper.addCircleReview(mContext, review);
					
					refreshList(false);
					return 0;
				}
			}
			
		
		} catch (ConnectTimeoutException e) {
			e.printStackTrace();
			return -1;
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
			return -1;
		} catch (ConnectException e) {
			e.printStackTrace();
			return -1;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		return -1;
	}
	
	private void addZanThread(final Circle circle, final Review review) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				int code = addZanRequest(circle, review);
				Message msg = mHandler.obtainMessage();
				if ( code == 0) {// 点赞成功
					circle.hasZan = true;
					dbHelper.updateZanState(mContext, circle.getmId(), circle.getmPhoneNum(),
							circle.hasZan);
				}
				msg.what = 9992;
				msg.obj = code;
				msg.sendToTarget();
			}
		}).start();
	}
	
	private int addZanRequest(final Circle circle, final Review review) {
		try {
			JSONObject obj = new JSONObject();
			String url = Utils.REMOTE_SERVER_URL+ "/topic/star?uid="+myName+"&session="+mySession+"&tid="+circle.getmId();
			HttpResponse response = Utils.getResponse(url, obj,
					 30000, 30000);

			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return -1;
			}
			String mInfo = EntityUtils.toString(response.getEntity());
			JSONObject json = new JSONObject(mInfo);
			
			if(json.has("code")){
				int resultCode = json.getInt("code");
				if (resultCode == 0 && json.has("data")) {
					JSONObject jsb = json.getJSONObject("data");
					int sid = jsb.getInt("StarId");
					review.setId(""+sid);					
					if (review.getType() == Review.TYPE_ZAN) {
						if(dbHelper.hasZan(mContext,review)){
							
						}else {
							circle.addZanData(review);
							circle.setZanCount(circle.getZanCount() + 1);
							dbHelper.addCircleReview(mContext, review);
						}					
					} 
					
					refreshList(false);
					return 0;
				}
			}
			
		} catch (ConnectTimeoutException e) {
			e.printStackTrace();
			return -1;
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
			return -1;
		} catch (ConnectException e) {
			e.printStackTrace();
			return -1;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		return -1;
	}

	
	private void deleteComment(final Circle circle, final Review review) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				int result = -1;
				try {
										
					String url  = Utils.REMOTE_SERVER_URL + "/topic/comment?uid="+myName
							+"&session="+mySession+"&cid="+review.getId();
					
					JSONObject obj = new JSONObject();
					HttpResponse response = Utils.deteteResponse(url, obj);
				
					int code = response.getStatusLine().getStatusCode();
					if (code != 200) {
						return;
					}	
					
					JSONObject jsonObject = new JSONObject(EntityUtils.toString(response.getEntity()));
					if (jsonObject.has("code")) {
						
						int resultCode = jsonObject.getInt("code");
						if(resultCode == 0){
							result = 0;
							dbHelper.deleteCircleReview(mContext, review);
							circle.setCommentCount(circle.getCommentCount() - 1);
							circle.deleteComment(review.getFriendName(), review.getTime());
							refreshList(false);
						}
					} 
				} catch (Exception e) {
					e.printStackTrace();
				}
				
				if(result != 0)
					mHandler.sendEmptyMessage(9994);
			}
		}).start();
	}

	private void deleteZan(final Circle circle) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				int result = -1;
				try {
					Review zanData = circle.getZanDatabyId(myName);
					String rId = zanData.getId();
					String url  = Utils.REMOTE_SERVER_URL + "/topic/star?uid="+myName
							+"&session="+mySession+"&sid="+rId;
					
					JSONObject obj = new JSONObject();
					HttpResponse response = Utils.deteteResponse(url, obj);
					
					int code = response.getStatusLine().getStatusCode();
					if (code != 200) {
						return;
					}				
					
					JSONObject jsonObject = new JSONObject(EntityUtils.toString(response.getEntity()));
					if (jsonObject.has("code")) {
						
						int resultCode = jsonObject.getInt("code");
						if(resultCode == 0){
							result = 0;
							dbHelper.deleteCircleReview(mContext, zanData);
							circle.setZanCount(circle.getZanCount() - 1);
							circle.deleteZanData(myName);
							circle.hasZan = false;
							refreshList(false);
							
						}
						

					} 
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}).start();
	}

	private void goback() {
	
		if (mCompleteActionPlusActivity != null) {
			mCompleteActionPlusActivity.setAnimationStyle(R.style.AnimTop2);
		}
	}

	
	/*@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO 自动生成的方法存根
		if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
			if (inputLayout.isShown()) {
				closeInputView();
				return true;
			} else {
				return super.onKeyDown(keyCode, event);
			}
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}*/

	/*
	 * @Override public void onBackPressed() { if(inputLayout.isShown()){
	 * closeInputView(); }else{ ((HomeActivity) getParent()).onBack(); } }
	 */
	private void deleteLocalCircle(final Circle circle) {

		int state = ShareService.getSendingState(circle.getmId());

		if (state >= 0) {
			ToastUtil.showToast(mContext, "表达正在发送中，请刷新表达列表后重试！");
			return;
		} else {
			Log.e("testTag", "删除发送失败的话题！");
		}

		final ProgressDialog dialog = new ProgressDialog(getActivity());
		dialog.setCanceledOnTouchOutside(false);
		dialog.show();
		dialog.setMessage(getString(R.string.delete));
		new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					ViewpointDBHelper.GetInstance(mContext).deleteCircle(
							mContext, circle.getmId(),
							SharedHelper.getShareHelper(mContext).getString(SharedHelper.USER_NAME,
									""),
							true);
					dialog.dismiss();
					// finish();

				} catch (Exception e) {
					e.printStackTrace();
					dialog.dismiss();
				}
			}
		}).start();
	}

	private void deleteCircle(final Circle circle) {
		final ProgressDialog dialog = new ProgressDialog(getActivity());
		dialog.setCanceledOnTouchOutside(false);
		dialog.show();
		dialog.setMessage(getString(R.string.delete));
		new Thread(new Runnable() {
			@Override
			public void run() {
				
				try {
					
					JSONObject obj = new JSONObject();	
					
					String url  = Utils.REMOTE_SERVER_URL + "/topic?uid=" + myName + "&session="+ mySession + "&tid="+ circle.getmId();
					
					HttpResponse response = Utils.deteteResponse(url, obj);
					
					int code = response.getStatusLine().getStatusCode();
					if (code != 200) {
						dialog.dismiss();
						return;
					}				
					
					JSONObject jsonObject = new JSONObject(EntityUtils.toString(response.getEntity()));
					if(jsonObject.has("code")){
						int resultCode = jsonObject.getInt("code");
						
						if (jsonObject.has("data")) {
							JSONObject jsb = jsonObject.getJSONObject("data");
							
							if(jsb.has("TopicId")){
								boolean isDelete = dbHelper.deleteCircle(mContext, circle.getmId(), SharedHelper
										.getShareHelper(mContext).getString(SharedHelper.USER_NAME, ""),
										true);
								/*boolean isDelete = dbHelper.deleteCircleMessages(mContext,
										circle.getmPhoneNum(), circle.getmId());*/

								if (isDelete) {
									Log.i("testTag", "话题相关消息删除成功！");
								} else {
									Log.i("testTag", "话题相关消息删除失败！");
								}
							}							
							

							dialog.dismiss();
							return;
						} 
						
					} else {
						mHandler.sendEmptyMessage(R.string.error_server);
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				dialog.dismiss();
			}
		}).start();
	}

	private static boolean isWifi(Context mContext) {
		ConnectivityManager connectivityManager = (ConnectivityManager) mContext
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo activeNetInfo = connectivityManager.getActiveNetworkInfo();
		if (activeNetInfo != null && activeNetInfo.getType() == ConnectivityManager.TYPE_WIFI) {
			return true;
		}
		return false;
	}
    
    
}
