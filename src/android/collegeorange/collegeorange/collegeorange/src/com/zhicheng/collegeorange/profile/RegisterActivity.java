package com.zhicheng.collegeorange.profile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Handler.Callback;
import android.os.Message;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import cn.smssdk.EventHandler;
import cn.smssdk.SMSSDK;

import com.google.gson.internal.bind.TimeTypeAdapter;
import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.utils.MD5;
import com.zhicheng.collegeorange.utils.ShowDialog;
import com.zhicheng.collegeorange.utils.StringUtil;
import com.zhicheng.collegeorange.utils.ToastUtil;

public class RegisterActivity extends Activity implements Callback{
	private static final int CODE_LENGTH = 4;
	
	private static final int TIME_SECONED = 60;
	
	private EditText editPhone;
	private EditText editVerfiyCode;
	private EditText editPwd;
	private Button getVerfiyBtn;
	private Button registerBtn;
	
	private Context mContext;
	
	int mode = 0; // 0  注册， 1 找回密码
	
	private int timeCount = 0;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.mContext = this;
        setContentView(R.layout.activity_register);
        initData();
        initTitleView();
        initView();
    }
    
    private void initTitleView(){
    	this.findViewById(R.id.title_back).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});
    	
    	TextView titleText = (TextView)this.findViewById(R.id.title_middle1);
    	titleText.setText(R.string.title_register);
    }
    
    private void initView(){
    	editPhone = (EditText)this.findViewById(R.id.phone_edit);
    	editVerfiyCode = (EditText)this.findViewById(R.id.verfiy_edit);
    	editPwd = (EditText)this.findViewById(R.id.pwd_edit);
    	
    	getVerfiyBtn= (Button)this.findViewById(R.id.get_verfiy);
    	registerBtn= (Button)this.findViewById(R.id.register_btn);
    	
    	getVerfiyBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				getVerfiyCode();
			}
		});
    	
    	registerBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				register();
			}
		});
    }
    
    private void initData(){
    	mode = getIntent().getIntExtra("mode", 0);
    	initSDK() ;
    }
    
    private Handler mHandler = new Handler(){
    	@Override
    	public void handleMessage(Message msg) {
    		switch (msg.what) {
			case 0:
			{
				getVerfiyBtn.setEnabled(false);
				startTime();
			}
				break;
			case 1:
			{
				String str = "验证码("+(TIME_SECONED - timeCount)+")";
				
				getVerfiyBtn.setText(str);
			}
				break;
			case 2:
			{
				getVerfiyBtn.setEnabled(true);
				getVerfiyBtn.setText(R.string.verfiy_code);
			}
				break;

			default:
				break;
			}
    	}
    };
    

    
    private void getVerfiyCode(){
    	String phoneNumber = editPhone.getText().toString();
    	if(checkPhoneNumber()){
    		ShowDialog.showProgressDialog(this, "请稍后……", false);
    		// 打开注册页面
    		SMSSDK.getVerificationCode(county, phoneNumber);
    	}else{
    		ToastUtil.showToast(this, "请输入正确的手机号码！");
    	}
    }    
    
    private void register(){
    	if(checkPhoneNumber()){
    		
    	}else{
    		ToastUtil.showToast(this, "请输入正确的手机号码！");
    		return;
    	}
    	
    	if(checkVerfiy()){
			
		}else{
			ToastUtil.showToast(this, "请输入正确的验证码！");
			return;
		}
    	
    	if(checkPwd()){
			
		}else{
			ToastUtil.showToast(this, "请设置合法的登录密码！（大于等于6个字符）");
			return;
		}
    	String phoneNumber = editPhone.getText().toString();
    	String verfiyCode = editVerfiyCode.getText().toString();
    	String pwd = editPwd.getText().toString();
    	
    	ShowDialog.showProgressDialog(mContext, "请稍后……", false);
    	SMSSDK.submitVerificationCode( county,phoneNumber,  verfiyCode);
    }
    private boolean checkVerfiy(){
    	String verfiyCode = editVerfiyCode.getText().toString();
    	if(TextUtils.isEmpty(verfiyCode)){
    		return false;
    	}
    	
    	if(verfiyCode.length() == CODE_LENGTH &&
    			StringUtil.isNumeric(verfiyCode)){
    		return true;
    	}
    	return false;
    }
    
    private boolean checkPhoneNumber(){
    	String phoneNumber = editPhone.getText().toString();
    	if(TextUtils.isEmpty(phoneNumber)){
    		return false;
    	}
    	
    	if(phoneNumber.length() == 11 &&
    			StringUtil.isNumeric(phoneNumber)){
    		return true;
    	}
    	return false;
    }
    
    private boolean checkPwd(){
    	
    	String pwd = editPwd.getText().toString();
    	if(TextUtils.isEmpty(pwd)){
    		return false;
    	}
    	
    	if(pwd.length() >= 6 ){
    		return true;
    	}
    	return false;
    }
    private Timer timer;
    private TimerTask task;
    
    private void startTime(){
    	
    	if(timer != null){
    		timer.cancel();
    		timer = null;
    	}
    	
    	if(task != null){
    		task.cancel();
    		task = null;
    	}
    	timeCount = 0;
    	timer = new Timer();
    	task = new TimerTask() {
			
			@Override
			public void run() {				
				timeCount ++;
				mHandler.sendEmptyMessage(1);
				if(timeCount >= TIME_SECONED){
					stopTimer();
				}
			}
		};
    	timer.schedule(task, 1000, 1000);
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
    	mHandler.sendEmptyMessage(2);
    }
    
       
    private class RegisterTask extends AsyncTask<Integer, Void, Integer>{
    	
    	String phoneNumber;
    	
    	String pwd;
    	
    	int mode = 0;
    	
    	public RegisterTask(String phone,String pwd){
    		this.phoneNumber = phone;    		
    		this.pwd = pwd;
    	}

		@Override
		protected Integer doInBackground(Integer... params) {
			mode = params[0];
			int result = -1;
			try {
				String pwdMd5 = MD5.digestString(pwd).toLowerCase();
				
				JSONObject obj = new JSONObject();
				obj.put("Username", phoneNumber);				
				obj.put("Password", pwdMd5);
				
				HttpResponse response = Utils.getResponse( Utils.REMOTE_SERVER_URL+ "/user/register", obj, 30000, 30000);				
				
				int code = response.getStatusLine().getStatusCode();
				if (code != 200) {
					Log.e("logo", "register code:"+code);
					return result;
				}			
				
				String mCommentViewpointList = EntityUtils.toString(response.getEntity());
				 if (!TextUtils.isEmpty(mCommentViewpointList)) {
					 JSONObject jsonObject = new JSONObject(mCommentViewpointList);
					if (jsonObject.has("code")) {
						int resultCode = jsonObject.getInt("code");
						if(resultCode == 0){
							JSONObject jsonObj = jsonObject.getJSONObject("data");
							int uid = jsonObj.getInt("Uid");
														
							return 0;
						}else{							
							return resultCode;
						}					
					}
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}           
            return result;
		}
		
		@Override
		protected void onPostExecute(Integer result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			ShowDialog.closeProgressDialog();
			
			if(result == 0){
				ToastUtil.showToast(mContext, mode == 0 ? "注册成功！" : "密码找回成功！");
				onRegisterOk();	
			}else{
				ToastUtil.showToast(mContext, mode == 0 ? "注册失败！" : "密码找回失败！");
			}
					
		}
    	
    }
    
    private void onRegisterOk(){
    	this.finish();
    }
    
    private boolean ready = false;
    
    private String county = "86";
    
    private void initSDK() {
		// 初始化短信SDK
	
		//SMSSDK.getNewFriendsCount();
		SMSSDK.initSDK(this.getApplicationContext(),Utils.SMS_SEND_KEY, Utils.SMS_SEND_SECRET);
        EventHandler eh = new EventHandler(){
 
            @Override
            public void afterEvent(int event, int result, Object data) {
 
            	Log.v("Register", "验证码请求返回！" + result);
            	
                if (result == SMSSDK.RESULT_COMPLETE) {
            	   //回调完成
                	
                if (event == SMSSDK.EVENT_SUBMIT_VERIFICATION_CODE) {
                	//提交验证码成功
                	String phoneNumber = editPhone.getText().toString();
                	String verfiyCode = editVerfiyCode.getText().toString();
                	String pwd = editPwd.getText().toString();
                	new RegisterTask(phoneNumber,  pwd).execute( mode );
                }else if (event == SMSSDK.EVENT_GET_VERIFICATION_CODE){
                	//获取验证码成功
                	ShowDialog.closeProgressDialog();
                	mHandler.sendEmptyMessage(0);
                	
                }else if (event ==SMSSDK.EVENT_GET_SUPPORTED_COUNTRIES){
                //返回支持发送验证码的国家列表
                	
                } 
              }else{                                                                 
                 ((Throwable)data).printStackTrace(); 
              }
         } 
       }; 
       
       ready = true;
       SMSSDK.registerEventHandler(eh); //注册短信回调
 }

	@Override
	public boolean handleMessage(Message msg) {
		/*if (pd != null && pd.isShowing()) {
			pd.dismiss();
		}
*/
		int event = msg.arg1;
		int result = msg.arg2;
		Object data = msg.obj;
		if (event == SMSSDK.EVENT_SUBMIT_USER_INFO) {
			// 短信注册成功后，返回MainActivity,然后提示新好友
			if (result == SMSSDK.RESULT_COMPLETE) {
				Toast.makeText(this,"短信验证码请求成功", Toast.LENGTH_SHORT).show();
			} else {
				((Throwable) data).printStackTrace();
			}
		} 
		return false;
	}
    

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		
	}
	
    @Override
    protected void onDestroy() {
    	if (ready) {
			// 销毁回调监听接口
			SMSSDK.unregisterAllEventHandler();
		}
    	super.onDestroy();
    }
}
