package com.zhicheng.collegeorange.ble;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

import com.baidu.location.BDLocation;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.MyLocationConfiguration;
import com.baidu.mapapi.map.MyLocationConfiguration.LocationMode;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.main.SharedHelper;

public class MapActivity extends Activity implements OnClickListener{
	MapView mMapView = null;  
	private BaiduMap mBaiduMap;
	private double mLatitude;
	private double mLongitude;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_map);
		mMapView = (MapView) findViewById(R.id.bmapView);  
		findViewById(R.id.lost_record).setOnClickListener(this);
		initTitleView();
		initData();
	}
	
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		mMapView.onResume();
	}
	
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		mMapView.onPause();
	}
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		mMapView.onDestroy();
	}
	
	 private void initTitleView(){
	    	this.findViewById(R.id.title_back).setVisibility(View.VISIBLE);
	    	TextView titleText = (TextView)this.findViewById(R.id.title_middle1);
	    	titleText.setText("地图");
	    	this.findViewById(R.id.title_back).setOnClickListener(this);
	    	
	}
	 
	 private void initData(){
		mBaiduMap = mMapView.getMap();
		mBaiduMap.setMyLocationEnabled(true);
		
		BDLocation db = getLocationRecord();
		mLatitude = db.getLatitude();
		mLongitude = db.getLongitude();
		
		if(mLatitude == 0 || mLongitude == 0){
			return;
		}
		
		LatLng cenpt = new LatLng(mLatitude, mLongitude);
		MapStatus mMapStatus = new MapStatus.Builder().target(cenpt).zoom(13).build();
		MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mMapStatus);
		mBaiduMap.setMapStatus(mMapStatusUpdate);

		final BitmapDescriptor mCurrentMarker = BitmapDescriptorFactory.fromResource(R.drawable.me_loc);

		mBaiduMap.setMyLocationConfigeration(new MyLocationConfiguration(LocationMode.NORMAL, true, mCurrentMarker));
		MyLocationData locData = new MyLocationData.Builder().latitude(mLatitude).longitude(mLongitude).build();
		mBaiduMap.setMyLocationData(locData);
		//mBaiduMap.setOnMarkerClickListener(this);

		/*findViewById(R.id.btnMy).setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				mBaiduMap.setMyLocationConfigeration(new MyLocationConfiguration(LocationMode.FOLLOWING, true, mCurrentMarker));
				mBaiduMap.setMyLocationConfigeration(new MyLocationConfiguration(LocationMode.NORMAL, true, mCurrentMarker));
			}
		});*/
	 }
	 
	 private void initOverlay() {
			try {
				LatLng llA = new LatLng(Double.valueOf(mLatitude), Double.valueOf(mLongitude));
				OverlayOptions ooA = new MarkerOptions().position(llA).zIndex(9).draggable(false);
				Marker marker = (Marker) (mBaiduMap.addOverlay(ooA));
			} catch (Exception e) {
				e.printStackTrace();
			}
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
	 
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.title_back:
		{
			finish();
		}
			break;
		case R.id.lost_record:{
			Intent intent = new Intent(this, LostRecordActivity.class);
			startActivityForResult(intent, 1);
		}break;

		default:
			break;
		}
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		if(resultCode == RESULT_OK){
			switch (requestCode) {
			case 0:
			{
				double la = -1;
				double lo = -1;
				la = data.getDoubleExtra("latitude", -1);
				lo = data.getDoubleExtra("longitude", -1);
				showPosition(la, lo);
			}
			break;

			default:
				break;
			}
		}
		
	}
	
	private void showPosition(double la , double lo){
		if(lo == 0 || la == 0){
			return;
		}		
		MyLocationData locData = new MyLocationData.Builder().latitude(la).longitude(lo).build();
		mBaiduMap.setMyLocationData(locData);
	}
	
}
