package com.zhicheng.collegeorange.ble;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.RingtoneManager;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.InputFilter;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewFlipper;

import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.utils.ShowDialog;
import com.zhicheng.collegeorange.utils.ToastUtil;
import com.zy.find.FindController;
import com.zy.find.FindDevice;
import com.zy.find.FindUtils;
import com.zy.find.SaveSetting;

public class DeviceActivity extends Activity implements OnClickListener{

	private List<String> scanResult = new ArrayList<String>();	
	
	private HashMap<String, ScanDevice> scanDevices = new HashMap<String, ScanDevice>();
	
	private ViewFlipper mflipper;
	TextView titleRightText;
	private ListView bindList;
	private ListView scanDeviceList;	
	//private ListView lostDeviceList;
	private BindAdapter mBindAdapter;
	private DeviceAdapter mdeviceAdapter;
	
	private Context mContext;
	private LayoutInflater mInflater;
	class ScanDevice{		
		String name;
		String address;
		String record;
		int rssi;
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_device);
		mInflater = LayoutInflater.from(this);
		IntentFilter filter = new IntentFilter();
		
		filter.addAction(FindUtils.ACTION_MANKO_CONNECTED);		
		filter.addAction(FindUtils.ACTION_MANKO_READ);
		filter.addAction(FindUtils.ACTION_MANKO_WRITE);
		filter.addAction(FindUtils.ACTION_MANKO_DATA_CHANGE);
		filter.addAction(FindUtils.ACTION_MANKO_RSSI);
		
		filter.addAction(FindUtils.ACTION_MANKO_DISCONNECT);
		filter.addAction(FindUtils.ACTION_MANKO_CONNECT_FAIL);
		filter.addAction(FindUtils.ACTION_MANKO_CONNECT_NOTFOUND);
		filter.addAction(FindUtils.ACTION_MANKO_CONNECT_TIMEOUT);
		filter.addAction(FindUtils.ACTION_MANKO_BATTERY);
		
		filter.addAction(FindUtils.ACTION_SCAN_START);
		filter.addAction(FindUtils.ACTION_SCAN_OVER);
		filter.addAction(FindUtils.ACTION_SCAN_START_FAIL);
		filter.addAction(FindUtils.ACTION_SCANED_MANKOU);
		
		LocalBroadcastManager.getInstance(this).registerReceiver(mCmdReceiver,filter);
		
		initView();
	}
	
	private BroadcastReceiver mCmdReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			
			String action = intent.getAction();
			if(FindUtils.ACTION_MANKO_DISCONNECT.equals(action)){
				mBindAdapter.refreshList();
			}else if(FindUtils.ACTION_SCAN_START.equals(action)){
				titleRightText.setEnabled(false);
				titleRightText.setText("扫描中");
			}else if(FindUtils.ACTION_SCAN_OVER.equals(action)){
				titleRightText.setEnabled(true);
				titleRightText.setText("扫描");
			}else if(FindUtils.ACTION_SCAN_START_FAIL.equals(action)){
				
			}else if(FindUtils.ACTION_SCANED_MANKOU.equals(action)){
				
				String address = intent.getStringExtra("address");
				String name = intent.getStringExtra("name");
				String scanRecord = intent.getStringExtra("record");
				int rssi = intent.getIntExtra("rssi", 0);
				if(!scanResult.contains(address)){
					scanResult.add(address);
					ScanDevice sd = new ScanDevice();
					sd.address = address;
					sd.name = name;
					sd.record = scanRecord;
					sd.rssi = rssi;					
					scanDevices.put(address, sd);
					
					mdeviceAdapter.notifyDataSetChanged();
				}
				
			}else if(FindUtils.ACTION_MANKO_CONNECTED.equals(action)){
				ShowDialog.closeProgressDialog();
				String address = intent.getStringExtra("address");
				//ToastUtil.showToast(mContext, "绑定成功！ " + address);
				mBindAdapter.refreshList();
			}else if(FindUtils.ACTION_MANKO_CONNECT_TIMEOUT.equals(action)){
				ShowDialog.closeProgressDialog();
				String address = intent.getStringExtra("address");
				
			}else if(FindUtils.ACTION_MANKO_DATA_CHANGE.equals(action)){
				
			}else if(FindUtils.ACTION_MANKO_WRITE.equals(action)){
				
			}else{
				
			} 
		}
	};
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		if(mCmdReceiver != null){
			LocalBroadcastManager.getInstance(this).unregisterReceiver(mCmdReceiver);
		}
	}

	private void initView(){
		initTitleView();
		mflipper = (ViewFlipper)this.findViewById(R.id.mflipper);
		bindList = (ListView)this.findViewById(R.id.bind_list);
		scanDeviceList = (ListView)this.findViewById(R.id.scan_list);
		
		this.findViewById(R.id.item_bind_list).setOnClickListener(this);
		//this.findViewById(R.id.item_scan_list).setOnClickListener(this);
		this.findViewById(R.id.item_lost_list).setOnClickListener(this);
		this.findViewById(R.id.item_camera).setOnClickListener(this);
		
		mdeviceAdapter = new DeviceAdapter();
		scanDeviceList.setAdapter(mdeviceAdapter);
		
		mBindAdapter = new BindAdapter();
		bindList.setAdapter(mBindAdapter);
		
		View foodView  = findViewById(R.id.add_device_layout);//mInflater.inflate(R.layout.add_device_view, null, false);
		foodView.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				mflipper.setDisplayedChild(2);
				titleRightText.setVisibility(View.VISIBLE);
			}
		});
		//bindList.addFooterView(foodView);
		
		scanDeviceList.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				try {
					String sd = (String)arg0.getItemAtPosition(arg2);					
					FindController.connectManko(mContext, sd);
					ShowDialog.showProgressDialog(mContext, "正在绑定中……", false);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
		
		bindList.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				try {
					FindDevice sd = (FindDevice)arg0.getItemAtPosition(arg2);	
					
    				CustomPromptDialog mCustomPromptDialog = new CustomPromptDialog(DeviceActivity.this,
    						R.style.MySearchStyle,sd.address,sd.name,sd.status);
    				
    				mCustomPromptDialog.show();
				} catch (Exception e) {
					e.printStackTrace();
				}  
			}
		});	
		
		mflipper.setDisplayedChild(0);
		
	}
	private Map<String, Boolean> ringMap = new HashMap<String, Boolean>();
	
	 private void initTitleView(){
	    	this.findViewById(R.id.title_back).setVisibility(View.VISIBLE);
	    	TextView titleText = (TextView)this.findViewById(R.id.title_middle1);
	    	titleText.setText("设备管理");
	    	this.findViewById(R.id.title_back).setOnClickListener(this);
	    	
	    	titleRightText = (TextView)this.findViewById(R.id.title_right_textview);
	    	titleRightText.setText("扫描");
	    	titleRightText.setVisibility(View.GONE);
	    	titleRightText.setOnClickListener(this);
	    }
	
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.title_back:
		{
			if(onBack()){
				
			}else{
				finish();
			}
		}
			break;
		case R.id.item_bind_list:
		{
			mflipper.setDisplayedChild(1);
		}
			break;
		/*case R.id.item_scan_list:
		{
			mflipper.setDisplayedChild(2);
			titleRightText.setVisibility(View.VISIBLE);
		}
			break;*/
		case R.id.item_lost_list:
			//mflipper.setDisplayedChild(3);
			Intent intent = new Intent(this, MapActivity.class);
			startActivity(intent);
			
			break;
		case R.id.item_camera:
			startCamera();
			break;
		case R.id.title_right_textview:
		{
			FindController.startScanLe(mContext);
		}
			break;
		default:
			break;
		}
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if(keyCode == KeyEvent.KEYCODE_BACK){
			if(onBack()){
				return true;
			}else{				
				return super.onKeyDown(keyCode, event);
			}			
		}else{
			return super.onKeyDown(keyCode, event);
		}	
	}
	
	private boolean onBack(){
		
		if(mflipper.getDisplayedChild() != 0){
			int page = mflipper.getDisplayedChild();
			if(page == 2){
				/*FindController.stopScanLe(mContext);
				scanResult.clear();
				scanDevices.clear();
				mdeviceAdapter.notifyDataSetChanged();*/
				titleRightText.setVisibility(View.GONE);
				mflipper.setDisplayedChild(1);
			}else{
				titleRightText.setVisibility(View.GONE);
				mflipper.setDisplayedChild(0);
			}
			
			return true;
		}else{			
			return false;
		}
		
	}
	
	private void startCamera(){
		Intent intent = new Intent(this, CameraActivity.class);
		startActivity(intent);		
	}
	
	private class DeviceAdapter extends BaseAdapter{

		
		@Override
		public int getCount() {
			return scanResult.size();
		}

		@Override
		public Object getItem(int position) {
			// TODO 自动生成的方法存根
			String address = scanResult.get(position);
			return address;
		}

		@Override
		public long getItemId(int position) {
			// TODO 自动生成的方法存根
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// 
			ViewHolder mHolder;
			if(convertView == null){
				convertView = mInflater.inflate(R.layout.item_device_view, null, false);;
				
				mHolder = new ViewHolder();
				mHolder.nameView = (TextView)convertView.findViewById(R.id.device_name);
				mHolder.addrView = (TextView)convertView.findViewById(R.id.device_address);
				convertView.setTag(mHolder);
			}else{
				mHolder = (ViewHolder)convertView.getTag();
			}
			
			String address = scanResult.get(position);
			if(!TextUtils.isEmpty(address)){
				ScanDevice sd = scanDevices.get(address);
				if(sd != null){
					mHolder.nameView.setText(sd.name);
					mHolder.addrView.setText(sd.address);
				}else{
					mHolder.nameView.setText("UNKNOW_DEVICE");
					mHolder.addrView.setText(address);
				}
			}
			
			return convertView;
		}
		
		class ViewHolder{
			TextView nameView;
			TextView addrView;
		}
		
	}
	
 private class BindAdapter extends BaseAdapter{

		private List<FindDevice> list = null;
		public BindAdapter() {
			list = SaveSetting.getInstance(mContext).getMankoList();
		}
		@Override
		public int getCount() {
			if(list == null){
				return 0;
			}else{
				return	list.size();
			}
		}
		
		public void refreshList(){
			list = SaveSetting.getInstance(mContext).getMankoList();
			notifyDataSetChanged();
		}

		@Override
		public Object getItem(int position) {
			// TODO 自动生成的方法存根
			if(list == null){
				return 0;
			}else{
				return	list.get(position);
			}
		}

		@Override
		public long getItemId(int position) {
			// TODO 自动生成的方法存根
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// 
			ViewHolder mHolder;
			if(convertView == null){
				convertView = mInflater.inflate(R.layout.item_bind_view, null, false);;
				
				mHolder = new ViewHolder();
				
				mHolder.nameView = (TextView)convertView.findViewById(R.id.device_name);
				mHolder.addrView = (TextView)convertView.findViewById(R.id.device_address);
				mHolder.stateView = (TextView)convertView.findViewById(R.id.state_text);
				mHolder.ringBtn = (Button)convertView.findViewById(R.id.ring_btn);
				
				convertView.setTag(mHolder);
			}else{
				mHolder = (ViewHolder)convertView.getTag();
			}
			
			final FindDevice device = list.get(position);
			if(device != null){
				mHolder.nameView.setText(device.name);
				mHolder.addrView.setText(device.address);
				if(device.status == -1){
					mHolder.stateView.setText("未连接");
				}else if(device.status == 0){
					mHolder.stateView.setText("断开连接");
				}else if(device.status == 1){
					mHolder.stateView.setText("已连接");
				}else {
					mHolder.stateView.setText("未连接");
				}
				
				if(device.status == 1){
					mHolder.ringBtn.setVisibility(View.VISIBLE);
				}else{
					mHolder.ringBtn.setVisibility(View.GONE);
				}
				
				boolean isRing = ringMap.get(device.address)!= null ? ringMap.get(device.address) : false ;
				mHolder.ringBtn.setText(isRing ? "停止" : "呼叫");
				mHolder.ringBtn.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						
						boolean isRing = ringMap.get(device.address)!= null ? ringMap.get(device.address) : false ;
						isRing = !isRing;
						FindController.startMankoRing(mContext, device.address, isRing);
						ringMap.put(device.address, isRing);
						
						((Button)v).setText(isRing ? "停止" : "呼叫");
					}
				});
			}
			
			return convertView;
		}
		
		class ViewHolder{
			TextView nameView;
			TextView addrView;
			TextView stateView;
			Button ringBtn;
		}
		
	}
 
 	private class CustomPromptDialog extends Dialog {
		private Context mContext;
		private String address;
		public String name;
		private int status = 0;
		public CustomPromptDialog(Context context,int theme,String address,String name,int status) {
			super(context, theme);
			mContext = context;
			this.address = address;
			this.name = name;
			this.status = status;
		}
		
		protected void onCreate(Bundle savedInstanceState) {
			super.onCreate(savedInstanceState);
			setContentView(R.layout.mankou_item_click_dialog);
			View rename = findViewById(R.id.rename);
			View unbind = findViewById(R.id.unbind);
			View rebind = findViewById(R.id.rebind);
			View delete = findViewById(R.id.delete);
			
			if(status == 1){
				unbind.setVisibility(View.VISIBLE);
				FindDevice mk = SaveSetting.getInstance(mContext).getMankoDevice(address);
				
				rebind.setVisibility(View.GONE);
				delete.setVisibility(View.GONE);
				unbind.setOnClickListener(new Button.OnClickListener() {
					@Override
					public void onClick(View arg0) {							
						// 断开连接
						FindController.disconnectManko(mContext, address);						
						dismiss();
					}
				});
			}else{
				unbind.setVisibility(View.GONE);
				rebind.setVisibility(View.VISIBLE);
				delete.setVisibility(View.VISIBLE);
				
				rebind.setOnClickListener(new Button.OnClickListener() {
					@Override
					public void onClick(View arg0) {
						FindDevice mk = SaveSetting.getInstance(mContext).getMankoDevice(address);
						//连接曼扣
						FindController.connectManko(mContext, address);
						
						ShowDialog.showProgressDialog(DeviceActivity.this, "正在重连，请稍候……", true);
						
						//mHandler.sendEmptyMessageDelayed(9995, 35*1000);
						
						dismiss();
					}
				});
				delete.setOnClickListener(new Button.OnClickListener() {
					@Override
					public void onClick(View arg0) {
						//删除曼扣
						FindController.removeManko(mContext, address);
						dismiss();
					}
				});
				
			}			
			
			rename.setOnClickListener(new Button.OnClickListener() {
				public void onClick(View v) {
					final View view = getLayoutInflater().inflate(R.layout.remark_dialog,null);
					
					EditText edit = (EditText) view.findViewById(R.id.remark_text);
					edit.setFilters(new InputFilter[]{new InputFilter.LengthFilter(16)});
					
					new AlertDialog.Builder(mContext)
							.setTitle("重命名")
							.setView(view)
							.setPositiveButton("确定", new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog, int i) {
									
									EditText edit = (EditText) view.findViewById(R.id.remark_text);
									if (edit != null) {
										String name = edit.getEditableText().toString().trim();										
										if(TextUtils.isEmpty(name)){
											Toast.makeText(DeviceActivity.this, "无效备注名，请重新设置！", Toast.LENGTH_LONG).show();
											 try  
										        {  
										            Field field = dialog.getClass().getSuperclass().getDeclaredField("mShowing");  
										            field.setAccessible(true);  
										            field.set(dialog, false);  
										        } catch(Exception e) {  
										            e.printStackTrace();  
										        } 
										}else{
											SaveSetting.getInstance(mContext).setMankouName(name,address);
											mBindAdapter.refreshList();											
											try  
									        {  
									            Field field = dialog.getClass().getSuperclass().getDeclaredField("mShowing");  
									            field.setAccessible(true);  
									            field.set(dialog, true);  
									        } catch(Exception e) {  
									            e.printStackTrace();  
									        }
										}
									}
								}
							})
							.setNegativeButton("取消", new DialogInterface.OnClickListener() {
								public void onClick(DialogInterface dialog, int whichButton) {
									try  
							        {  
							            Field field = dialog.getClass().getSuperclass().getDeclaredField("mShowing");  
							            field.setAccessible(true);  
							            field.set(dialog, true);  
							        } catch(Exception e) {  
							            e.printStackTrace();  
							        }
								}
							}).show();
					dismiss();
				}
			});	
			
			
			findViewById(R.id.layout).setOnClickListener(new Button.OnClickListener() {
				@Override
				public void onClick(View arg0) {
					dismiss();
				}
			});
		}
	}
	
}
