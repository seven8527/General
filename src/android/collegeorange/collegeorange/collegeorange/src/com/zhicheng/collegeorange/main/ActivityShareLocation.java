package com.zhicheng.collegeorange.main;

import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.location.BDLocation;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.core.CityInfo;
import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiDetailResult;
import com.baidu.mapapi.search.poi.PoiNearbySearchOption;
import com.baidu.mapapi.search.poi.PoiResult;
import com.baidu.mapapi.search.poi.PoiSearch;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.zhicheng.collegeorange.R;


public class ActivityShareLocation extends Activity implements OnGetPoiSearchResultListener {

//	private MyListView listView;
	// private TextView mCityNameView, mLicationView;
	// private RelativeLayout mCityNameLayout, mLayoutLicationView;
	private AdapterShareLocation shareLocation;

	private PoiSearch mPoiSearch;

	private String mCityName;
	private String mLication;
	private int load_Index = 0;
	BDLocation mCurLocation;
	ProgressDialog dialog;
	
	PullToRefreshListView refreshListView;
	
	String defultLocation;
	
	String cityStr = null;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_share_location);
		mCurLocation = getLocationRecord();
		if(mCurLocation != null)
			cityStr = mCurLocation.getCity();
		initTitle();
		initView();
		
		
		defultLocation = getIntent().getStringExtra("location");
		
		dialog = new ProgressDialog(this);
		dialog.show();
		dialog.setCanceledOnTouchOutside(false);
		dialog.setMessage("正在搜索附近位置");
		if (mCurLocation == null) {
			locationHandler.sendEmptyMessage(0);
			return;
		}
		initData();
	}

	private void initTitle() {
		TextView title_middle1 = (TextView) findViewById(R.id.title_middle1);
		title_middle1.setText("所在位置");
		View backView = findViewById(R.id.title_back);
		backView.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				finish();
			}
		});
	}

	private void initView() {
		refreshListView = (PullToRefreshListView) findViewById(R.id.pull_to_refresh_gridview);
		refreshListView.setOnItemClickListener(onItemClickListener);
		// mCityNameView = (TextView) findViewById(R.id.layout_city_name);
		// mCityNameLayout = (RelativeLayout) findViewById(R.id.layout_city);
		// mLicationView = (TextView) findViewById(R.id.lication);s
		// mLayoutLicationView = (RelativeLayout)
		// findViewById(R.id.layout_lication);
		// mCityNameLayout.setOnClickListener(onClickListener);
		// mLayoutLicationView.setOnClickListener(onClickListener);
		// findViewById(R.id.layout_do_not_show).setOnClickListener(onClickListener);
		refreshListView.setMode(Mode.PULL_FROM_END);
		mPoiSearch = PoiSearch.newInstance();
		mPoiSearch.setOnGetPoiSearchResultListener(this);
		refreshListView.getRefreshableView().setDividerHeight(1);

		refreshListView.setOnRefreshListener(new OnRefreshListener<ListView>() {

			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				load_Index++;
				initData();
			}
		});
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

	Handler locationHandler = new Handler() {
		public void handleMessage(Message msg) {
			mCurLocation = getLocationRecord();
			if (mCurLocation == null) {
				locationHandler.sendEmptyMessageDelayed(0, 2000);
			} else {
				initData();
			}
		};
	};

	private void initData() {
		LatLng cenpt = new LatLng(mCurLocation.getLatitude(), mCurLocation.getLongitude());
		PoiNearbySearchOption option = new PoiNearbySearchOption();
		option.radius(10000);
		option.keyword("餐厅");
		option.location(cenpt);
		option.pageNum(load_Index);
		mPoiSearch.searchNearby(option);
	}



	private OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			PoiInfo poiItem = (PoiInfo) shareLocation.getItem(position - 1);
			Intent intent = new Intent();
			if (position-1 == 0) {
				intent.putExtra("location", "");
			} else {
				String str =  poiItem.name;
				if(!TextUtils.isEmpty(cityStr)){
					str = cityStr +"."+str;
				}
				intent.putExtra("location",str);
			}
			setResult(RESULT_OK, intent);
			finish();
		}
	};

	@Override
	protected void onDestroy() {
		// mLocationManagerProxy.destory();
		mPoiSearch.destroy();
		super.onDestroy();
	}

	@Override
	public void onGetPoiDetailResult(PoiDetailResult result) {
		dialog.dismiss();
		refreshListView.onRefreshComplete();
		if (result.error != SearchResult.ERRORNO.NO_ERROR) {
			Toast.makeText(ActivityShareLocation.this, "抱歉，未找到结果", Toast.LENGTH_SHORT).show();
		} else {
			Toast.makeText(ActivityShareLocation.this, result.getName() + ": " + result.getAddress(), Toast.LENGTH_SHORT).show();
		}
	}

	@Override
	public void onGetPoiResult(PoiResult result) {
		dialog.dismiss();
		refreshListView.onRefreshComplete();
		if (result == null || result.error == SearchResult.ERRORNO.RESULT_NOT_FOUND) {
			Toast.makeText(ActivityShareLocation.this, "未找到结果", Toast.LENGTH_LONG).show();
			return;
		}
		
		if (!TextUtils.isEmpty(defultLocation)&&!"所在位置".equals(defultLocation)) {
			for (int i = 0; i < result.getAllPoi().size(); i++) {
				if (result.getAllPoi().get(i).name.equals(defultLocation)) {
					result.getAllPoi().remove(i);
				}
			}
		}
		if (result.error == SearchResult.ERRORNO.NO_ERROR) {
			if (shareLocation == null) {
				int selected = 0;
				int index= 0;
				List<PoiInfo> datas = result.getAllPoi();
				
				PoiInfo info = new PoiInfo();
				info.name = "不显示位置";
				datas.add(index, info);
				if( !TextUtils.isEmpty(defultLocation) && "所在位置".equals(defultLocation) ){
					selected = index;
				}	
				
				if( TextUtils.isEmpty(defultLocation) || !defultLocation.equals(mCurLocation.getCity()) ){
					++index;
					info = new PoiInfo();
					info.name = mCurLocation.getCity();
					datas.add(index, info);
				}					
				
				if(!TextUtils.isEmpty(defultLocation) && !"所在位置".equals(defultLocation)){
					++index;
					info = new PoiInfo();
					info.name = defultLocation;
					datas.add(index, info);
					selected = index;					
				}
				
				if( TextUtils.isEmpty(defultLocation) || !defultLocation.equals(mCurLocation.getAddrStr()) ){
					++index;
					info = new PoiInfo();
					info.name = mCurLocation.getAddrStr();
					datas.add(index, info);
				}	
				
				shareLocation = new AdapterShareLocation(ActivityShareLocation.this, datas,selected);
				refreshListView.setAdapter(shareLocation);
			} else {
				shareLocation.addData(result.getAllPoi());
			}
			return;
		}
		if (result.error == SearchResult.ERRORNO.AMBIGUOUS_KEYWORD) {

			// 当输入关键字在本市没有找到，但在其他城市找到时，返回包含该关键字信息的城市列表
			String strInfo = "在";
			for (CityInfo cityInfo : result.getSuggestCityList()) {
				strInfo += cityInfo.city;
				strInfo += ",";
			}
			strInfo += "找到结果";
			Toast.makeText(ActivityShareLocation.this, strInfo, Toast.LENGTH_LONG).show();
		}
	}

}