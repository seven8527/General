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

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.model.LostRecord;
import com.zhicheng.collegeorange.utils.ShowDialog;
import com.zhicheng.collegeorange.utils.ToastUtil;
import com.zy.find.FindController;
import com.zy.find.FindDevice;
import com.zy.find.FindUtils;
import com.zy.find.SaveSetting;

public class LostRecordActivity extends Activity implements OnClickListener{	
	
	TextView titleRightText;
	
	private ListView lostDeviceList;
	private LostAdapter mLostAdapter;
	
	private Context mContext;
	private LayoutInflater mInflater;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.activity_lost);
		mInflater = LayoutInflater.from(this);
		initView();
	}
	
	
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
	}

	private void initView(){
		initTitleView();
		lostDeviceList = (ListView)this.findViewById(R.id.lost_list);		
		
		mLostAdapter = new LostAdapter();
		lostDeviceList.setAdapter(mLostAdapter);	
		
		lostDeviceList.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
				try {
					LostRecord ld = (LostRecord)arg0.getItemAtPosition(arg2);	
					if(ld != null
							&& ld.latitude != 0 && ld.longitude != 0){
						Intent intent = new Intent();
						intent.putExtra("latitude", ld.latitude);
						intent.putExtra("longitude", ld.longitude);
						setResult(RESULT_OK, intent);
						finish();
					}	
    				
				} catch (Exception e) {
					e.printStackTrace();
				}  
			}
		});		
		
	}
	
	 private void initTitleView(){
    	this.findViewById(R.id.title_back).setVisibility(View.VISIBLE);
    	TextView titleText = (TextView)this.findViewById(R.id.title_middle1);
    	titleText.setText("设备管理");
    	this.findViewById(R.id.title_back).setOnClickListener(this);
    	
    	titleRightText = (TextView)this.findViewById(R.id.title_right_textview);
    	titleRightText.setText("清空");
    	titleRightText.setVisibility(View.GONE);
    	titleRightText.setOnClickListener(this);
    	
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
		case  R.id.title_right_textview:
		{
			SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
			shareHelper.putString("lost_list", "");
			mLostAdapter.refreshList();
		}break;
		default:
			break;
		}
	}
	
	
	
  class LostAdapter extends BaseAdapter{

		private List<LostRecord> list = null;
		
		public LostAdapter() {			
			loadData();			
		}
		
		private void loadData(){
			SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
			String json = shareHelper.getString("lost_list", "");
			Gson gson = new Gson();
			if(TextUtils.isEmpty(json)){
				list = new ArrayList<LostRecord>();
			}else{
				try {
					list = gson.fromJson(json, new TypeToken<ArrayList<LostRecord>>(){}.getType());
				} catch (JsonSyntaxException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					list = new ArrayList<LostRecord>();
				}
			}	
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
			loadData();	
			notifyDataSetChanged();
		}

		@Override
		public Object getItem(int position) {
			// TODO 自动生成的方法存根
			if(list == null){
				return null;
			}else{
				return list.get(position);
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
				convertView = mInflater.inflate(R.layout.item_lost_view, null, false);;
				
				mHolder = new ViewHolder();
				
				mHolder.nameView = (TextView)convertView.findViewById(R.id.device_name);
				mHolder.timeView = (TextView)convertView.findViewById(R.id.lost_time);
				mHolder.posiView = (TextView)convertView.findViewById(R.id.lost_posi);
				mHolder.addrStrView = (TextView)convertView.findViewById(R.id.lost_addre);
				
				convertView.setTag(mHolder);
			}else{
				mHolder = (ViewHolder)convertView.getTag();
			}
			
			final LostRecord lr = list.get(position);
			if(lr != null){
				mHolder.nameView.setText(lr.name);
				mHolder.timeView.setText(lr.time);
				mHolder.posiView.setText("" + lr.latitude +" , "+ lr.longitude);
				mHolder.addrStrView.setText(lr.addrPosition);				
			}
			
			return convertView;
		}
		
		class ViewHolder{
			TextView nameView;
			TextView timeView;
			TextView posiView;
			TextView addrStrView;
			
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
						
						ShowDialog.showProgressDialog(LostRecordActivity.this, "正在重连，请稍候……", true);
						
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
											Toast.makeText(LostRecordActivity.this, "无效备注名，请重新设置！", Toast.LENGTH_LONG).show();
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
											mLostAdapter.refreshList();											
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
