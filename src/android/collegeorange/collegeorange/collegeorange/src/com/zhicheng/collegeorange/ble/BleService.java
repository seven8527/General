package com.zhicheng.collegeorange.ble;

import java.util.ArrayList;
import java.util.List;

import android.app.Notification;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.LocationClientOption.LocationMode;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.model.LostRecord;
import com.zhicheng.collegeorange.model.Topic;
import com.zhicheng.collegeorange.utils.DateUtil;
import com.zy.find.FindDevice;
import com.zy.find.FindOperate;
import com.zy.find.FindUtils;
import com.zy.find.SaveSetting;

public class BleService extends Service {
	
	private Context mContext;
	
	public static boolean isCameraOpen = false;
	public boolean isSupport = true;
	
	@Override
	public IBinder onBind(Intent arg0) {
		// TODO Auto-generated method stub
		return null;
	}
	

	
	@Override
	public void onCreate() {
		super.onCreate();
		this.mContext = this;
		if(FindOperate.getInstance(mContext).isSupport()){
			FindOperate.getInstance(this).initMankoOperate();
		}else{
			isSupport = false;
		}
		
		
		IntentFilter filter = new IntentFilter();
		filter.addAction(FindUtils.ACTION_MANKO_DISCONNECT);
		filter.addAction(FindUtils.ACTION_MANKO_DATA_CHANGE);
		LocalBroadcastManager.getInstance(this).registerReceiver(mCmdReceiver,filter);
		initLocation();
		putServiceToForeground();
		
		if(getLocationRecord() == null){
			getLocation();
		}
	}
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		return START_STICKY;
	}
	
	public void putServiceToForeground() {
		Notification  notif = new NotificationCompat.Builder(this)
        .setContentTitle("防丢功能服务")
        .setContentText("防丢服务运行中……")
        .setSmallIcon(R.drawable.ic_launcher)
        .setTicker("")
        .build();
	    startForeground(7788, notif);
	}

	public void removeServiceFromForeground() {
	  
	    stopForeground(true);
	}
	
	private BroadcastReceiver mCmdReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			
			String action = intent.getAction();
			if(FindUtils.ACTION_MANKO_DISCONNECT.equals(action)){
				String address = intent.getStringExtra("address");
				boolean isAlert = intent.getBooleanExtra("alert", false);
				FindDevice mk = SaveSetting.getInstance(mContext).getMankoDevice(address);
				
				if(isAlert && mk != null 
						&& SaveSetting.getInstance(mContext).getMankouNotifyStatus()){
					
					//给出曼扣断连提醒
					Intent lostIntent = new Intent(mContext, LossPrompt.class);
					lostIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					lostIntent.putExtra("address", address);
					lostIntent.putExtra("name", mk.name);
					lostIntent.putExtra("notice_type", mk.notice_type);
					lostIntent.putExtra("ring", mk.ringtone);
					lostIntent.putExtra("type", 0);
					
					mContext.startActivity(lostIntent);
					
					addLostRecord(address);
				}
			}else if(FindUtils.ACTION_MANKO_DATA_CHANGE.equals(action)){
				
				String address = intent.getStringExtra("address");
				String uuid = intent.getStringExtra("uuid");
				
				if(FindUtils.Custom_EVENT_UUID.toString().equals(uuid)){
					
					byte[] value = intent.getByteArrayExtra("value");
					FindDevice mk = SaveSetting.getInstance(mContext).getMankoDevice(address);
					if(value != null ){
					
						if(value[0] == 0x01 
								&& System.currentTimeMillis() - firstClick < 500
								){
							//曼扣呼叫手机
							Intent lostIntent = new Intent(mContext, LossPrompt.class);
							lostIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
							lostIntent.putExtra("address", address);
							lostIntent.putExtra("name", mk.name);
							lostIntent.putExtra("notice_type", mk.notice_type);
							lostIntent.putExtra("ring", mk.ringtone);
							lostIntent.putExtra("type", 1);						
							mContext.startActivity(lostIntent);
						}else{
							//onEvent(value, address);
						}					
						firstClick = System.currentTimeMillis();
					}
					
				}
				
			}
		}
	};
	
	private long firstClick = 0l;
	
	@Override
	public void onDestroy() {		
		super.onDestroy();
		if(isSupport)
		FindOperate.getInstance(this).close();
		if(mCmdReceiver != null){
			LocalBroadcastManager.getInstance(this).unregisterReceiver(mCmdReceiver);
		}
		
		removeServiceFromForeground();
	}

	
	private boolean isLocation = false;
	public LocationClient mLocationClient = null;
	public BDLocationListener myListener = new MyLocationListener();
	
	private List<String> lostList = new ArrayList<String>();
	
	private void initLocation(){
		
		mLocationClient = new LocationClient(getApplicationContext());     //声明LocationClient类
	    mLocationClient.registerLocationListener( myListener ); 
	    
		LocationClientOption option = new LocationClientOption();
        option.setLocationMode(LocationMode.Hight_Accuracy);//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
        option.setCoorType("bd09ll");//可选，默认gcj02，设置返回的定位结果坐标系
        option.setScanSpan(0);//可选，默认0，即仅定位一次，设置发起定位请求的间隔需要大于等于1000ms才是有效的
        option.setIsNeedAddress(true);//可选，设置是否需要地址信息，默认不需要
        option.setOpenGps(true);//可选，默认false,设置是否使用gps
        option.setLocationNotify(true);//可选，默认false，设置是否当gps有效时按照1S1次频率输出GPS结果
        option.setIsNeedLocationDescribe(true);//可选，默认false，设置是否需要位置语义化结果，可以在BDLocation.getLocationDescribe里得到，结果类似于“在北京天安门附近”
        option.setIsNeedLocationPoiList(true);//可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到
        option.setIgnoreKillProcess(false);//可选，默认true，定位SDK内部是一个SERVICE，并放到了独立进程，设置是否在stop的时候杀死这个进程，默认不杀死  
        option.SetIgnoreCacheException(false);//可选，默认false，设置是否收集CRASH信息，默认收集
        option.setEnableSimulateGps(false);//可选，默认false，设置是否需要过滤gps仿真结果，默认需要
        mLocationClient.setLocOption(option);
        
	}
	
	private BDLocation getLocationRecord(){
		SharedHelper sh =SharedHelper.getShareHelper(this);
		String json = sh.getString("Location", "");
		Gson gson = new Gson();
		if(!TextUtils.isEmpty(json)){
			BDLocation db = null;
			try {
				db = gson.fromJson(json, BDLocation.class);
			} catch (JsonSyntaxException e) {
				e.printStackTrace();
			}
			return db;
		}
		return null;
	}
	
	private void saveLocationRecord(BDLocation db){
		SharedHelper sh =SharedHelper.getShareHelper(this);
		Gson gson = new Gson();
		String str = gson.toJson(db);
		sh.putString("Location", str);
	}
	
	private void getLocation(){
		if(isLocation){
			return;
		}
	    mLocationClient.start();
	    isLocation = true;
	}
	
	class MyLocationListener implements BDLocationListener{

		@Override
		public void onReceiveLocation(BDLocation arg0) {
			// TODO Auto-generated method stub
			
			String posi = "";
			double la = 0l;
			double lon = 0l;
			
			if(arg0 != null){
				saveLocationRecord(arg0);
				la = arg0.getLatitude();
				lon = arg0.getLongitude();
				StringBuffer sb = new StringBuffer();
				if(arg0.getAddrStr()!= null){
					sb.append(arg0.getAddrStr());
				}else{
					sb.append("无法获取详细地址");
				}				
				posi = sb.toString();
				
				Log.v("BleService", "定位结果 ：" + posi + "  Latitude = "+la+"  Longitude = "+lon);
			}else{
				Log.v("BleService", "定位失败！");
			}
			
			saveLostRecord(posi, la, lon);
			isLocation = false;
		}
		
	} 
	
	private void addLostRecord(String address){
		synchronized (lostList) {
			lostList.add(address);
			getLocation();
		}
	}
	
	private void saveLostRecord(String posi,double la, double lon ){
		synchronized (lostList) {
			if(lostList.size() <= 0){
				return;
			}
			String timeStr = DateUtil.currentFormatDate();
			SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
			String json = shareHelper.getString("lost_list", "");
			Gson gson = new Gson();
			List<LostRecord> records = null;
			if(TextUtils.isEmpty(json)){
				records = new ArrayList<LostRecord>();
			}else{
				try {
					records = gson.fromJson(json, new TypeToken<ArrayList<LostRecord>>(){}.getType());
				} catch (JsonSyntaxException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					records = new ArrayList<LostRecord>();
				}
			}
			
			for(int i = lostList.size() - 1 ; i >= 0;i--){
				String address = lostList.get(i);
				FindDevice fd = SaveSetting.getInstance(mContext).getMankoDevice(address);
				LostRecord lr = new LostRecord();
				lr.address = address;
				lr.name = fd.name;
				lr.addrPosition = posi;
				lr.latitude = la;
				lr.longitude = lon;
				lr.time = timeStr;
				records.add(lr);
			}
			lostList.clear();
			
			String str = gson.toJson(records);
			shareHelper.putString("lost_list", str);
		}
	}

}
