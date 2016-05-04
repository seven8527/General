package com.zhicheng.collegeorange;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.baidu.mapapi.SDKInitializer;
import com.zhicheng.collegeorange.ble.BleService;
import com.zhicheng.collegeorange.main.WebViewActivity;
import com.zhicheng.collegeorange.view.MyViewPager;

public class MainActivity extends FragmentActivity  {

    /**
     * The {@link android.support.v4.view.PagerAdapter} that will provide
     * fragments for each of the sections. We use a
     * {@link FragmentPagerAdapter} derivative, which will keep every
     * loaded fragment in memory. If this becomes too memory intensive, it
     * may be best to switch to a
     * {@link android.support.v4.app.FragmentStatePagerAdapter}.
     */
    private SectionsPagerAdapter mSectionsPagerAdapter;

    /**
     * The {@link ViewPager} that will host the section contents.
     */
    private MyViewPager mainViewPager;

    private View bottomItemView1;
    private View bottomItemView2;
    private View bottomItemView3;
    private View bottomItemView4;
    
    private View currItemView;
    private View mTabView;
    private ImageView imageView;
    private TextView textView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Utils.initImageLoader(this);
        SDKInitializer.initialize(getApplicationContext()); 
        
        Intent bleIntent = new Intent(this, BleService.class);
        startService(bleIntent);
        
        // Create the adapter that will return a fragment for each of the three
        // primary sections of the activity.
        mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());

        // Set up the ViewPager with the sections adapter.
        mainViewPager = (MyViewPager) findViewById(R.id.container);
        mainViewPager.setAdapter(mSectionsPagerAdapter);
        mainViewPager.setScrollble(false);
        mTabView = findViewById(R.id.bottom_tab);

        bottomItemView1 = findViewById(R.id.iconItem1);
        imageView = (ImageView) bottomItemView1.findViewById(R.id.item_image);
        imageView.setImageResource(R.drawable.home_tab_selector);
        textView = (TextView) bottomItemView1.findViewById(R.id.item_text);
        textView.setText("首页");

        bottomItemView2 = findViewById(R.id.iconItem2);
        imageView = (ImageView) bottomItemView2.findViewById(R.id.item_image);
        imageView.setImageResource(R.drawable.find_tab_selector);
        textView = (TextView) bottomItemView2.findViewById(R.id.item_text);
        textView.setText("发现");

        bottomItemView3 = findViewById(R.id.iconItem3);
        imageView = (ImageView) bottomItemView3.findViewById(R.id.item_image);
        imageView.setImageResource(R.drawable.share_tab_selector);
        textView = (TextView) bottomItemView3.findViewById(R.id.item_text);
        textView.setText("吐槽");

        bottomItemView4 = findViewById(R.id.iconItem4);
        imageView = (ImageView) bottomItemView4.findViewById(R.id.item_image);
        imageView.setImageResource(R.drawable.mine_tab_selector);
        textView = (TextView) bottomItemView4.findViewById(R.id.item_text);
        textView.setText("我的");

        currItemView = bottomItemView1;
        currItemView.setSelected(true);
        
        mainViewPager.setOnPageChangeListener(new OnPageChangeListener() {
			
			@Override
			public void onPageSelected(int arg0) {
				// TODO Auto-generated method stub
				selectTab(arg0);
			}
			
			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void onPageScrollStateChanged(int arg0) {
				// TODO Auto-generated method stub
				
			}
		});
    }

    public void onCircleItemClicked(View view) {
        //Toast.makeText(MainActivity.this, String.format("Clicked circle item %1$s", (String)view.getTag()), Toast.LENGTH_SHORT).show();
        // After login, simply start the list activity
        Intent webViewIntent = new Intent(getApplicationContext(), WebViewActivity.class);
        webViewIntent.putExtra(WebViewFragment.ARG_TARGET_URL, (String)view.getTag());
        startActivity(webViewIntent);
    }

    public void onIconItemClicked(View view) {
    	switch (view.getId()) {
		case R.id.iconItem1:
		{
			mainViewPager.setCurrentItem(0);
			selectTab(0);
		}
			break;
		case R.id.iconItem2:
		{
			mainViewPager.setCurrentItem(1);
			selectTab(1);
		}
			break;
		case R.id.iconItem3:
		{
			mainViewPager.setCurrentItem(2);
			selectTab(2);
		}
			break;
		case R.id.iconItem4:
		{
			mainViewPager.setCurrentItem(3);
			selectTab(3);
		}
			break;
		default:
			break;
		}       	
       
    }
   
    private void selectTab(int index){
    	if(currItemView != null){
    		currItemView.setSelected(false);
    	} 
    	switch (index) {
		case 0:
		{
			
			currItemView = bottomItemView1;
		}
			break;
		case 1:
		{
			
			currItemView = bottomItemView2;
		}
			break;
		case 2:
		{
			
			currItemView = bottomItemView3;
		}
			break;
		case 3:
		{
			
			currItemView = bottomItemView4;
		}
			break;
		default:
			break;
		}   
    	 currItemView.setSelected(true);
    }
    
    public void showTabView(){
    	mTabView.setVisibility(View.VISIBLE);
    }
    
    public void closeTabView(){
    	mTabView.setVisibility(View.GONE);
    }
    
    @Override
    public void onBackPressed() {
    	// TODO Auto-generated method stub
    	if(mTabView.getVisibility() != View.VISIBLE){
    		showTabView();
    	}else{
    		super.onBackPressed();
    	}
    	
    }
    
}
