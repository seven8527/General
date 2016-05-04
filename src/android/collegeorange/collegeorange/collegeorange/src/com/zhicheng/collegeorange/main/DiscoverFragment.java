package com.zhicheng.collegeorange.main;

/**
 * Created by ypyang on 1/18/16.
 */

import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.WebViewFragment;
import com.zhicheng.collegeorange.model.Topic;

/**
 * Main page.
 */
public class DiscoverFragment extends Fragment implements View.OnClickListener {

    public static final String TAG = "DiscoverFragment";
    /**
     * The fragment argument representing the section number for this
     * fragment.
     */
    private static final String ARG_SECTION_NUMBER = "section_number";

    PullToRefreshListView pullToRefreshView;
    private DisplayImageOptions options;
    protected ImageLoader imageLoader = ImageLoader.getInstance();
    
    private Context mContext;
    
    private AdItemAdapter itemAdapter;
    private LayoutInflater mInflater;
    private boolean isloaded = false;
    
    
    /**
     * Returns a new instance of this fragment for the given section
     * number.
     */
    public static DiscoverFragment newInstance(int sectionNumber) {
        DiscoverFragment fragment = new DiscoverFragment();
        Bundle args = new Bundle();
        args.putInt(ARG_SECTION_NUMBER, sectionNumber);
        fragment.setArguments(args);
        return fragment;
    }

    public DiscoverFragment() {
    	options = new DisplayImageOptions.Builder().showImageOnLoading(R.drawable.default_pic)
				.showImageForEmptyUri(R.drawable.default_pic).showImageOnFail(R.drawable.default_pic)
				.cacheInMemory(true).cacheOnDisk(true).considerExifParams(true)// .resetViewBeforeLoading(true)
				.imageScaleType(ImageScaleType.NONE)				
				.build();
    	
    }
    
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
    	// TODO Auto-generated method stub
    	super.onCreate(savedInstanceState);
    	mContext = getActivity();
    }
    

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_main, container, false);
        mInflater = LayoutInflater.from(mContext);
        initTitleView(rootView);
        pullToRefreshView = (PullToRefreshListView) rootView.findViewById(R.id.home_page_list);
       
        
        pullToRefreshView.setMode(Mode.BOTH);
		pullToRefreshView.setOnRefreshListener(new OnRefreshListener2<ListView>() {

			public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
				getNewData();
			}

			public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
				getListDatas(pageNum);
			}
			
		});
		pullToRefreshView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				try {
					ItemData ld = (ItemData)arg0.getItemAtPosition(arg2);
					String url = ld.content;
					if(!TextUtils.isEmpty(url)){
						Intent webViewIntent = new Intent(mContext, WebViewActivity.class);
					    webViewIntent.putExtra(WebViewFragment.ARG_TARGET_URL, url);
					    startActivity(webViewIntent);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}	
				
			}
		});
		
		itemAdapter = new AdItemAdapter();
		pullToRefreshView.setAdapter(itemAdapter);
		
		if(!isloaded && dataList.size() < 1){
			loadLocalData();
		}
		if(!isloaded)
			getListDatas(pageNum);
		
        return rootView;
    }

    private void initTitleView(View v){
    	v.findViewById(R.id.title_back).setVisibility(View.GONE);
    	TextView titleText = (TextView)v.findViewById(R.id.title_middle1);
    	titleText.setText("发现");
    }
    
    private Gson gson = new Gson();
    
    private void loadLocalData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = helper.getString("discover_list", "");
    	List<ItemData> list = null;
    	if(!TextUtils.isEmpty(json)){
    		list = gson.fromJson(json, new TypeToken<ArrayList<ItemData>>(){}.getType());
    	}
    	if(list != null){
    		dataList = list;
    	}
    }
    
    private void saveLocalData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = gson.toJson(dataList);
    	helper.putString("discover_list", json);
    }
    
    private void getNewData(){
    	dataList.clear();
    	pageNum = 1;    	
    	getListDatas(pageNum);
    }

    @Override
    public void onClick(View v) {

    }

   @Override
	public void onDestroyView() {
		// TODO Auto-generated method stub
		super.onDestroyView();
		pageNum = 1;
		//dataList.clear();
	}


    
    private Handler mHandler = new Handler(){
    	public void handleMessage(android.os.Message msg) {
    		switch (msg.what) {
			case 0:
			{
				pullToRefreshView.onRefreshComplete();
				itemAdapter.notifyDataSetChanged();
			}
				break;
			default:
				break;
			}
    	};    	
    };
    
 
    
    private List<ItemData> dataList = new ArrayList<ItemData>();
    private int pageNum = 1;
    
    private void getListDatas(final int pagenum){
    	new Thread(){
    		public void run() {
    			SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
    	    	String myName = shareHelper.getString(SharedHelper.USER_NAME, "");
    	    	String mySession = shareHelper.getString(SharedHelper.USER_SESSION_ID, "");
    			try {
    				String url = Utils.REMOTE_SERVER_URL + "/discover/list?uid="+myName+"&session="+mySession+"&page="+pagenum+"&page_num=20";
    				HttpGet httpGet = new HttpGet(url);
    	            HttpClient httpClient = new DefaultHttpClient();

    	            // 发送请求
    	            HttpResponse response = httpClient.execute(httpGet);
    				int code = response.getStatusLine().getStatusCode();
    				if (code != 200) {
    					return;
    				}
    				String mHistoryList = EntityUtils.toString(response.getEntity());
    				JSONObject jsonObj= new JSONObject(mHistoryList);
    				
    				int resultCode = -1;
    				if(jsonObj.has("code")){
    					resultCode = jsonObj.getInt("code");
    				}
    				
    				if (resultCode == 0 && jsonObj.has("data")) {
    					
    					JSONArray jsonArray = jsonObj.getJSONArray("data");
    					
    					int count = jsonArray.length();
    					if(!isloaded && count >0){
    						dataList.clear();
    					}
    					for(int i = 0 ; i < jsonArray.length() ; i++){
    						JSONObject infoObject = jsonArray.getJSONObject(i);
    						ItemData data = new ItemData();
    						if(infoObject.has("Id")){	
    							data.id = infoObject.getInt("Id");
    						}
    						
    						if(infoObject.has("Image")){
    							data.image = infoObject.getString("Image");
    						}
    						
    						if(infoObject.has("Content")){	
    							data.content = infoObject.getString("Content");
    						}
    						
    						if(infoObject.has("CreateTime")){
    							data.creatTime = infoObject.getString("CreateTime");
    						}   						
    						    						
    						dataList.add(data);
    					}
    					if(count > 0){
    						if(!isloaded){
    							saveLocalData();
    						}
    						isloaded = true;
    						pageNum++;
    					}
    					mHandler.sendEmptyMessage(0);
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
    		};
    	}.start();
    }
    
    class ItemData{
    	int id;
    	String image;
    	String content;
    	String creatTime;
    }
    
    class AdItemAdapter extends BaseAdapter{

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return dataList.size();
		}

		@Override
		public Object getItem(int position) {
			// TODO Auto-generated method stub
			return dataList.get(position);
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			ViewHolder mHolder;
			if(convertView == null){
				convertView = mInflater.inflate(R.layout.item_discover_view, null, false);				
				mHolder = new ViewHolder();				
				mHolder.imageView = (ImageView)convertView.findViewById(R.id.image_view);				
				convertView.setTag(mHolder);
			}else{
				mHolder = (ViewHolder)convertView.getTag();
			}
			
			final ItemData lr = dataList.get(position);
			if(lr != null){
				
				imageLoader.displayImage(lr.image, mHolder.imageView, options);
			}			
			return convertView;
		}
		
		class ViewHolder{		
			ImageView imageView;
		}
    	
    }
    
    
}
