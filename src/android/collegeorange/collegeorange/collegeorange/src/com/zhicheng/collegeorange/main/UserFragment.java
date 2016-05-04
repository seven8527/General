package com.zhicheng.collegeorange.main;

/**
 * Created by ypyang on 1/18/16.
 */

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ViewFlipper;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.display.RoundedBitmapDisplayer;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.WebViewFragment;
import com.zhicheng.collegeorange.ble.DeviceActivity;
import com.zhicheng.collegeorange.profile.LoginActivity;
import com.zhicheng.collegeorange.profile.MyInfosEditActivity;
import com.zhicheng.collegeorange.utils.ToastUtil;
import com.zy.find.FindOperate;

/**
 * Main page.
 */
public class UserFragment extends Fragment implements View.OnClickListener {

    public static final String TAG = "UserFragment";
    
    private static final String ARG_SECTION_NUMBER = "section_number";
   
    private Context mContext;
    private DisplayImageOptions options;
    protected ImageLoader imageLoader = ImageLoader.getInstance();
    
    private Button goLoginBtn;
    private Button loginOutBtn;
    private ImageView iconView;
    private TextView nickNameView;
    TextView titleRightText;
    
    
    public static UserFragment newInstance(int sectionNumber) {
        UserFragment fragment = new UserFragment();
        Bundle args = new Bundle();
        args.putInt(ARG_SECTION_NUMBER, sectionNumber);
        fragment.setArguments(args);
        return fragment;
    }

    public UserFragment() {   	
    	
    }
    
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
    	// TODO Auto-generated method stub
    	super.onCreate(savedInstanceState);
    	
    	options = new DisplayImageOptions.Builder()
		.showImageOnLoading(R.drawable.user_logo)
		.showImageForEmptyUri(R.drawable.user_logo)
		.showImageOnFail(R.drawable.user_logo)
		.cacheInMemory(true)
		.cacheOnDisk(true)
		.considerExifParams(true)
		.resetViewBeforeLoading(true)
				.displayer(
						new RoundedBitmapDisplayer(120))
				.build();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
    	mContext = getActivity();
        View rootView = inflater.inflate(R.layout.user_page_layout, container, false);
        initView(rootView);
        return rootView;
    }
    
    private void initView(View v){
    	initTitleView( v);
    	
    	iconView = (ImageView)v.findViewById(R.id.user_icon);
    	nickNameView = (TextView)v.findViewById(R.id.username_text);
    	goLoginBtn = (Button)v.findViewById(R.id.go_login_btn);
    	loginOutBtn = (Button)v.findViewById(R.id.log_out_btn);
    	
    	v.findViewById(R.id.go_login_btn).setOnClickListener(this);
    	v.findViewById(R.id.log_out_btn).setOnClickListener(this);
    	v.findViewById(R.id.device_setting_layout).setOnClickListener(this);
    	v.findViewById(R.id.about_layout).setOnClickListener(this);
    	getReceive();
    	IntentFilter ifi = new IntentFilter();
		ifi.addAction(Utils.LOGIN_STATE_CHANGE);	
		ifi.addAction(Utils.USER_INFO_CHANGE);
		LocalBroadcastManager.getInstance(mContext).registerReceiver(mBroadcastReceiver, ifi);
		setViewData();
    }
    
    private void initTitleView(View v){
    	
    	TextView titleText = (TextView)v.findViewById(R.id.title_middle1);
    	titleText.setText("我的");
    	
    	titleRightText = (TextView)v.findViewById(R.id.title_right_textview);
    	titleRightText.setText("编辑");
    	titleRightText.setVisibility(View.GONE);
    	titleRightText.setOnClickListener(this);
    }
    
    private void setViewData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	boolean islogin = helper.getInt(SharedHelper.WHICH_ME, 0) == 1;
    	if(islogin){
    		String uId = helper.getString(SharedHelper.USER_NAME, "");
    		String session = helper.getString(SharedHelper.USER_SESSION_ID, "");
    		String nickName = helper.getString(SharedHelper.USER_NICKNAME, "");
    		if(TextUtils.isEmpty(nickName)){
    			nickName = "用户"+uId;
    		}    		
    		
    		String avatar = helper.getString(SharedHelper.USER_ICON, "");
    		if(!TextUtils.isEmpty(avatar)){
    			String iconUrl = Utils.DOWNLOAD_PIC  + uId + "&session=" + session + "&fid=" + avatar + "&size=small";
    			imageLoader.displayImage(iconUrl, iconView, options);
    		}else {
    			iconView.setImageResource(R.drawable.user_logo);
    		} 
    		
    		nickNameView.setText(nickName);
    		goLoginBtn.setVisibility(View.GONE);
    		loginOutBtn.setVisibility(View.VISIBLE);
    		titleRightText.setVisibility(View.VISIBLE);
    	}else{
    		nickNameView.setText("未登录");
    		loginOutBtn.setVisibility(View.GONE);
    		goLoginBtn.setVisibility(View.VISIBLE);
    		titleRightText.setVisibility(View.GONE);
    	}
    }
    
    private BroadcastReceiver mBroadcastReceiver;
    private void getReceive(){
    	mBroadcastReceiver = new BroadcastReceiver() {
    		@Override
    		public void onReceive(Context context, Intent intent) {
    			String act = intent.getAction();
    			if (Utils.LOGIN_STATE_CHANGE.equals(act)
    					|| Utils.USER_INFO_CHANGE.equals(act)){
    				setViewData();
    			}
    		}
    	};
    }
    
    @Override
    public void onClick(View v) {
    	switch (v.getId()) {
		case R.id.go_login_btn:{
			SharedHelper helper = SharedHelper.getShareHelper(mContext);
        	boolean islogin = helper.getInt(SharedHelper.WHICH_ME, 0) == 1;
        	if(islogin){
        		ToastUtil.showToast(mContext, "您已经登录了");
        	}else{
        		Intent loginIntent = new Intent(getActivity(), LoginActivity.class);
                startActivity(loginIntent);
        	}
		}			
			break;
		case R.id.log_out_btn:
		{
			logout();
		}
			break;
		case R.id.device_setting_layout:
		{
			if(FindOperate.getInstance(mContext).isSupport()){
				Intent intent = new Intent(mContext, DeviceActivity.class);
				startActivity(intent);
			}else{
				ToastUtil.showToast(mContext, "您的手机支持此项功能！");
			}
			
		}
			break;
		case R.id.title_right_textview:{
			Intent intent = new Intent(mContext, MyInfosEditActivity.class);
			startActivity(intent);
		}break;
		case R.id.about_layout:
		{
			Intent webViewIntent = new Intent(mContext, WebViewActivity.class);
		    webViewIntent.putExtra(WebViewFragment.ARG_TARGET_URL, Utils.ABOUT_URL);
		    startActivity(webViewIntent);
		}
			break;		
		default:
			break;
		}
    }  
    
    private void logout(){
    	
    	new AlertDialog.Builder(getActivity())
		.setMessage("确定要退出登录吗？")
		.setPositiveButton("确定", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialoginterface, int i) {
                
				SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
		    	shareHelper.putString(SharedHelper.USER_NAME, "");
				shareHelper.putString(SharedHelper.USER_SESSION_ID, "");
				shareHelper.putInt(SharedHelper.WHICH_ME, 0);
				shareHelper.putString(SharedHelper.USER_NICKNAME, "");
				shareHelper.putString(SharedHelper.USER_ICON, "");
				shareHelper.putString(SharedHelper.USER_SIGNATION, "");
				shareHelper.putString(SharedHelper.USER_GENDER, "");
				shareHelper.putString(SharedHelper.USER_REGISTE_TIME, "");
				Intent intent = new Intent(Utils.LOGIN_STATE_CHANGE);
				LocalBroadcastManager.getInstance(mContext).sendBroadcast(intent);
				
			}
		})
		.setNegativeButton("取消", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int whichButton) {
				// 取消按钮事件
			}
		}).show();
    	
    	
    }
    
    @Override
    public void onDestroyView() {
    	try {
			if (mBroadcastReceiver != null)
				LocalBroadcastManager.getInstance(mContext).unregisterReceiver(mBroadcastReceiver);
			mBroadcastReceiver = null;
		} catch (Exception e) {
			e.printStackTrace();
		}
    	super.onDestroyView();
    }
    
    @Override
    public void onDestroy() {
    	// TODO Auto-generated method stub
    	super.onDestroy();
    }
    
}
