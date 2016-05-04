package com.zhicheng.collegeorange.main;

/**
 */

import java.io.File;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import android.R.string;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.Image;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
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
import com.zhicheng.collegeorange.IModelObserver;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.WebViewFragment;
import com.zhicheng.collegeorange.view.MyPagerAdapter;

/**
 * Main page.
 */
public class MainFragment extends Fragment implements View.OnClickListener, IModelObserver {

    public static final String TAG = "MainFragment";
    /**
     * The fragment argument representing the section number for this
     * fragment.
     */
    private static final String ARG_SECTION_NUMBER = "section_number";

    private static final String BUTTONS_URL = "http://123.56.233.226/index/button";
    private static final int CIRCLE_BUTTONS_COUNT = 8;
    
    PullToRefreshListView pullToRefreshView;
    private ViewPager bannerViewPager;
    
   
    private ImageView[] circleImageViews;

    private DisplayImageOptions options;
    protected ImageLoader imageLoader = ImageLoader.getInstance();
    
    private Context mContext;
    
    private AdItemAdapter itemAdapter;
    private LayoutInflater mInflater;
    
    
    /**
     * Returns a new instance of this fragment for the given section
     * number.
     */
    public static MainFragment newInstance(int sectionNumber) {
        MainFragment fragment = new MainFragment();
        Bundle args = new Bundle();
        args.putInt(ARG_SECTION_NUMBER, sectionNumber);
        fragment.setArguments(args);
        return fragment;
    }

    public MainFragment() {
    	options = new DisplayImageOptions.Builder().showImageOnLoading(R.drawable.pic_default)
				.showImageForEmptyUri(R.drawable.pic_default).showImageOnFail(R.drawable.pic_default)
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
				new LoadDataTask().execute(0);
//				pullToRefreshView.onRefreshComplete();	
//				itemAdapter.notifyDataSetChanged();
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
		
		initHeadView();
		if(!isLoadList)
			loadListData();
		
		if(!isLoadAd){
			loadAdData();			
		}
		initViewPager();
		
		if(!isloadButtons){
			loadButtonData();
		}
		onModelChanged(null);
		
		itemAdapter = new AdItemAdapter();
		pullToRefreshView.setAdapter(itemAdapter);
		if(!isLoadList)
		new LoadDataTask().execute(0);
		
		if(!isLoadAd)
		new LoadDataTask().execute(1);
		
		if(!isloadButtons)
        new DownloadTask().execute(BUTTONS_URL);
        
        return rootView;
    }
    
    private Gson gson = new Gson();
    //----------------- msg list -------------------
    private boolean isLoadList = false;
    
    private void loadListData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = helper.getString("home_list", "");
    	List<ItemData> list = null;
    	if(!TextUtils.isEmpty(json)){
    		list = gson.fromJson(json, new TypeToken<ArrayList<ItemData>>(){}.getType());
    	}
    	if(list != null){
    		dataList = list;
    	}
    }
    
    private void saveListData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = gson.toJson(dataList);
    	helper.putString("home_list", json);
    }
    
    //-----------------ad data ---------------------
    boolean isLoadAd = false;
    
    private void loadAdData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = helper.getString("ad_list", "");
    	List<AdData> list = null;
    	if(!TextUtils.isEmpty(json)){
    		list = gson.fromJson(json, new TypeToken<ArrayList<AdData>>(){}.getType());
    	}
    	if(list != null){
    		adList = list;
    	}
    }
    
    private void saveAdData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = gson.toJson(adList);
    	helper.putString("ad_list", json);
    }
    
    //-------------------button --------------
    boolean isloadButtons = false;
    private void saveButtonData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = gson.toJson(circleButtonItems);
    	helper.putString("button_list", json);
    }
    
    private void loadButtonData(){
    	SharedHelper helper = SharedHelper.getShareHelper(mContext);
    	String json = helper.getString("button_list", "");
    	List<ButtonItem> list = null;
    	if(!TextUtils.isEmpty(json)){
    		list = gson.fromJson(json, new TypeToken<ArrayList<ButtonItem>>(){}.getType());
    	}
    	if(list != null){
    		circleButtonItems = list;
    	}
    }
    
  

    private void initTitleView(View v){
    	v.findViewById(R.id.title_back).setVisibility(View.GONE);
    	TextView titleText = (TextView)v.findViewById(R.id.title_middle1);
    	titleText.setText("首页");
    }
    
    private void initHeadView(){
    	ListView refreshlistView = pullToRefreshView.getRefreshableView();
    	View heardView = LayoutInflater.from(mContext).inflate(R.layout.home_head_layout, null);
    	
    	 bannerViewPager = (ViewPager) heardView.findViewById(R.id.bannerViewPager);
        
         circleImageViews = new ImageView[CIRCLE_BUTTONS_COUNT];
         circleImageViews[0] = (ImageView) heardView.findViewById(R.id.circleItem0);
         circleImageViews[1] = (ImageView) heardView.findViewById(R.id.circleItem1);
         circleImageViews[2] = (ImageView) heardView.findViewById(R.id.circleItem2);
         circleImageViews[3] = (ImageView) heardView.findViewById(R.id.circleItem3);

         circleImageViews[4] = (ImageView) heardView.findViewById(R.id.circleItem4);
         circleImageViews[5] = (ImageView) heardView.findViewById(R.id.circleItem5);
         circleImageViews[6] = (ImageView) heardView.findViewById(R.id.circleItem6);
         circleImageViews[7] = (ImageView) heardView.findViewById(R.id.circleItem7);
         
         refreshlistView.addHeaderView(heardView);
    }
    
    private void getNewData(){
//    	dataList.clear();
    	pageNum = 1;
    	new DownloadTask().execute(BUTTONS_URL);
    	new LoadDataTask().execute(0);
    	new LoadDataTask().execute(1);
    	
    }

    @Override
    public void onClick(View v) {

    }

    @Override
    public void onModelChanged(Bundle bundle) {
        if(circleButtonItems.size() !=0) {
        	for (int i = 0; i < CIRCLE_BUTTONS_COUNT; i++) {        		
//        		if (false) {
//        			String fileName =imageLoader.getDiskCache().get(circleButtonItems.get(i).imageUrl).getPath();
//        			circleImageViews[i].setImageBitmap(BitmapFactory.decodeFile(fileName));
//				}        		
        		imageLoader.displayImage(circleButtonItems.get(i).imageUrl, circleImageViews[i],options);
                circleImageViews[i].setTag(circleButtonItems.get(i).targetUrl);     		
               
            }
        }

    }

   @Override
	public void onDestroyView() {
		// TODO Auto-generated method stub
		super.onDestroyView();
		pageNum = 1;
//		dataList.clear();
   }
   
   @Override
	public void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		stopTimer();
	}
   
   @Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		startTimer();
	}
   
   private Timer timer;
   private TimerTask task;
   
   private void startTimer(){
	   if(timer != null){
   		timer.cancel();
   		timer = null;
   	}
   	
   	if(task != null){
   		task.cancel();
   		task = null;
   	}
   	timer = new Timer();
   	task = new TimerTask() {
			
			@Override
			public void run() {				
				mHandler.sendEmptyMessage(1);
			}
		};
   	timer.schedule(task, 1000, 5000);
   }
   
   private void stopTimer(){
	   if(timer != null){
   		timer.cancel();
   		timer = null;
   	}
   	
   	if(task != null){
   		task.cancel();
   		task = null;
   	}
   }
   
   private Handler mHandler = new Handler(){
	 
	   public void handleMessage(android.os.Message msg) {
		   switch (msg.what) {
		case 0:{
			
			try {
				JSONObject job = (JSONObject)msg.obj;
				String content = "";
				if(job.has("Url")){
					content = job.getString("Url");					
				}
				
				int newVersion = 0;
				if(job.has("Image")){
					newVersion = Integer.parseInt(job.getString("Image"));
				}
				
				PackageInfo packageInfo = mContext.getPackageManager().getPackageInfo(mContext.getPackageName(), 0);
				
				if(packageInfo.versionCode < newVersion){
					showAppVersionDialog(content);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}			
		}			
			break;
		case 1:{
			 toRight();
		}break;
		default:
			break;
		}
	   };
   };
   
   private void showAppVersionDialog(String content){
	   AlertDialog.Builder builder = new Builder(getActivity(), AlertDialog.THEME_HOLO_LIGHT);
	   builder.setTitle(R.string.app_update_title)
	   .setMessage(getString(R.string.app_update_message) +  content)
	   .setNegativeButton(R.string.my_app_cancel, new DialogInterface.OnClickListener() {
		
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				
			}
	   }).setPositiveButton(R.string.my_app_update, new DialogInterface.OnClickListener() {
		
			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub				
				try {					
					Uri uri = Uri.parse(Utils.NEW_VERSION_DOWNLOAD);		
					Intent intent = new  Intent(Intent.ACTION_VIEW, uri);
					startActivity(intent);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}).create().show();
   }
   
   private ArrayList<View> mImagePageViewList;
   
   private MyPagerAdapter mPagerAdapter;
   
   private void initViewPager() {
	   try {
		if(mImagePageViewList != null){
			   mImagePageViewList.clear();			   
//			   mImagePageViewList = null;
			 
	    }
		else
		{
			mImagePageViewList = new ArrayList<View>();
		}
			

			for (int i = 0; i < adList.size() && i < 9; i++) {
				final AdData topic = adList.get(i);
				String imageUrl = topic.image;
				View view = LayoutInflater.from(mContext).inflate(R.layout.simple_imageview, null);
				ImageView imageView = (ImageView) view.findViewById(R.id.img_guandian);
				imageLoader.displayImage(imageUrl, imageView, options);
				 
				imageView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View arg0) {
						Intent webViewIntent = new Intent(mContext, WebViewActivity.class);
					    webViewIntent.putExtra(WebViewFragment.ARG_TARGET_URL, topic.content);
					    startActivity(webViewIntent);
					}
				});
				
				mImagePageViewList.add(view);
			}	
			if(mImagePageViewList.size() > 0 ){
				mPagerAdapter = new MyPagerAdapter(mImagePageViewList);	
				mPagerAdapter.notifyDataSetChanged();
				bannerViewPager.setAdapter(mPagerAdapter);			
			}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
		//bannerViewPager.setOnPageChangeListener(new ImagePageChangeListener());
   }
   
   private void toRight() {
		try {
			if (mImagePageViewList != null && mImagePageViewList.size() > 1) {
				int nextItem = bannerViewPager.getCurrentItem() + 1;
				if (mImagePageViewList.size() == nextItem) {
					nextItem = 0;
				}
				bannerViewPager.setCurrentItem(nextItem);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


    /**
     * A ButtonItem representing a piece of content.
     */
    public static class ButtonItem {
        public int index;
        public String imageUrl;
        public int width;
        public int height;
        public String targetUrl;

        public ButtonItem(){

        }

        public ButtonItem(int index, String imageUrl, int width, int height, String targetUrl){
            this.index = index;
            this.imageUrl = imageUrl;
            this.width = width;
            this.height = height;
            this.targetUrl = targetUrl;
        }

        @Override
        public String toString(){
            return targetUrl;
        }
    }


    /**
     * Implementation of AsyncTask, to fetch the data in the background away from
     * the UI thread.
     */
    private class DownloadTask extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... urls) {
        	String result = "";
        	getButtonDatas();
        	return result;
        }

        /**
         * Uses the logging framework to display the output of the fetch
         * operation in the log fragment.
         */
        @Override
        protected void onPostExecute(String result) {
            Log.i(TAG, result);
            onModelChanged(null);
        }
    }
    
    private class LoadDataTask extends AsyncTask<Integer, Void, Integer> {

		@Override
		protected Integer doInBackground(Integer... params) {
			// TODO Auto-generated method stub
			int mode = params[0];
			if(mode == 1){
				getAdListDatas();
			}else if(mode == 0){
				getListDatas();
			}		
			return mode;
		}
		
		@Override
		protected void onPostExecute(Integer result) {
			if(result == 1){
				initViewPager();
			}else if(result == 0){
				try {
					pullToRefreshView.onRefreshComplete();
					itemAdapter.notifyDataSetChanged();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
   
    }   
   
    private List<ButtonItem> circleButtonItems =   new ArrayList<ButtonItem>();
    private void getButtonDatas(){
    	SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
    	String myName = shareHelper.getString(SharedHelper.USER_NAME, "");
    	String mySession = shareHelper.getString(SharedHelper.USER_SESSION_ID, "");
		try {
			String url = Utils.REMOTE_SERVER_URL + "/index/button?uid="+myName+"&session="+mySession;
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
				int count =  jsonArray.length();
				if(count > 0){
					circleButtonItems.clear();
				}
				for(int i = 0 ; i < jsonArray.length() &&  i < 8 ; i++){
					ButtonItem item = new ButtonItem();
					JSONObject jsonObject = jsonArray.getJSONObject(i);
                    item.index = jsonObject.getInt("Index");
                    item.imageUrl = jsonObject.getString("Image");
                    item.width = jsonObject.getInt("Width");
                    item.height = jsonObject.getInt("Height");
                    item.targetUrl = jsonObject.getString("Url");
                    circleButtonItems.add(item);
				}
				if( count >= 9){
					JSONObject jsonObject = jsonArray.getJSONObject(8);
					Message msg = new Message();
					msg.what = 0;
					msg.obj = jsonObject;
					mHandler.sendMessage(msg);
				}
				isloadButtons = true;
				saveButtonData();
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
    
    private List<AdData> adList = new ArrayList<AdData>();
    
    private void getAdListDatas(){
    	SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
    	String myName = shareHelper.getString(SharedHelper.USER_NAME, "");
    	String mySession = shareHelper.getString(SharedHelper.USER_SESSION_ID, "");
		try {
			String url = Utils.REMOTE_SERVER_URL + "/index/ad?uid="+myName+"&session="+mySession;
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
				if(count > 0){
					adList.clear();
				}
				
				for(int i = 0 ; i < jsonArray.length() ; i++){
					JSONObject infoObject = jsonArray.getJSONObject(i);
					AdData data = new AdData();
					if(infoObject.has("Id")){	
						data.id = infoObject.getInt("Id");
					}
					
					if(infoObject.has("Image")){
						data.image = infoObject.getString("Image");
					}
					
					if(infoObject.has("Url")){	
						data.content = infoObject.getString("Url");
					}
					
					if(infoObject.has("CreateTime")){
						data.creatTime = infoObject.getString("CreateTime");
					}   						
					    						
					adList.add(data);
				}		
				
				isLoadAd = true;
				saveAdData();
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
    
    class AdData{
    	int id;
    	String image;
    	String content;
    	String creatTime;
    }
    
    private List<ItemData> dataList = new ArrayList<ItemData>();
    private int pageNum = 1;
    
    private void getListDatas(){
    	SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
    	String myName = shareHelper.getString(SharedHelper.USER_NAME, "");
    	String mySession = shareHelper.getString(SharedHelper.USER_SESSION_ID, "");
		try {
			String url = Utils.REMOTE_SERVER_URL + "/news/list?uid="+myName+"&session="+mySession+"&page="+pageNum+"&page_num=20";
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
				if( count > 0){
					dataList.clear();
				}

				for(int i = 0 ; i < jsonArray.length() ; i++){
					 
					JSONObject infoObject = jsonArray.getJSONObject(i);
					ItemData data = new ItemData();
					if(infoObject.has("Id")){	
						data.id = infoObject.getInt("Id");
					}
					
					if(infoObject.has("Title")){
						data.title = infoObject.getString("Title");
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
					if(!isLoadList ){
						saveListData();
						isLoadList = true;
					}
					pageNum++;
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
    
    class ItemData{
    	int id;
    	String title;
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
				convertView = mInflater.inflate(R.layout.item_ad_view, null, false);;
				
				mHolder = new ViewHolder();
				
				mHolder.nameView = (TextView)convertView.findViewById(R.id.device_name);
				mHolder.timeView = (TextView)convertView.findViewById(R.id.lost_time);
				
				convertView.setTag(mHolder);
			}else{
				mHolder = (ViewHolder)convertView.getTag();
			}
			
			final ItemData lr = dataList.get(position);
			if(lr != null){
				mHolder.nameView.setText(lr.title);
				mHolder.timeView.setText(lr.creatTime);
			}
			
			return convertView;
		}
		
		class ViewHolder{
			TextView nameView;
			TextView timeView;		
		}
    	
    }
    
    
}
