package com.zhicheng.collegeorange.ble;


import com.zhicheng.collegeorange.R;
import com.zy.find.FindUtils;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Vibrator;
import android.provider.Settings;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

/**
 * 曼扣的断链提醒对话框
 * @author zy
 *
 */
public class LossPrompt extends Activity {
	private Vibrator mVibrator;
	private Ringtone mRingtone;
	private int mVolume;
	private int mModel;
	public static boolean isOn = false;
	private String mAddress = null;
	private String mName = null;
	private boolean startRing = false;
	
	private Uri mRingtoneUri = Settings.System.DEFAULT_RINGTONE_URI;
	
	private int ringType = 0;
	
	private int type = 0;
	

	private void ringAndVibrat() {
		if(!startRing){
			return;
		}
		try {
			if(ringType == 0 || ringType == 2){
				mVibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
				if (mVibrator != null) {
					long[] pattern = { 500, 20, 10, 20, 10, 20, 10, 20, 10, 20 }; // OFF/ON/OFF/ON...
					mVibrator.vibrate(pattern, 0);
				}
			}			

			if(ringType == 0 || ringType == 1){
				AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
				mVolume = am.getStreamVolume(AudioManager.STREAM_RING);
				mModel = am.getRingerMode();
				am.setStreamVolume(AudioManager.STREAM_RING, am.getStreamMaxVolume(AudioManager.STREAM_RING), 0);
				mRingtone = RingtoneManager.getRingtone(this, mRingtoneUri );				
				if (mRingtone != null) {
					mRingtone.play();
				}	
			}	
			
		} catch (Exception e) {
		}
	}
	
	
	private void stopRingAndVibrat() {
		try {
			if (mVibrator != null) {
				mVibrator.cancel();
				mVibrator = null;
			}
		} catch (Exception e) {
		}

		boolean isPlaySound = false;
		
		try {
			if (mRingtone != null &&( ringType == 0 || ringType == 1)) {
				isPlaySound = mRingtone.isPlaying();
				mRingtone.stop();
				mRingtone = null;
			}
		} catch (Exception e) {
		}

		try {
			if(isPlaySound && (ringType == 0 || ringType == 1)){
				((AudioManager) getSystemService(Context.AUDIO_SERVICE)).setStreamVolume(2, mVolume, 0);
				((AudioManager) getSystemService(Context.AUDIO_SERVICE)).setRingerMode(mModel);
			}
			
		} catch (Exception e) {
		}
		startRing = false;
	}


	@Override
	public void onResume() {
		super.onResume();
		mHandler.removeCallbacks(finishRunnable);
	}

	@Override
	public void onPause() {
		super.onPause();
		mHandler.postDelayed(finishRunnable, 5000);
	}


	Runnable finishRunnable = new Runnable() {
		@Override
		public void run() {
			startRing = false;
			finish();
		}
	};

	 @Override
	    public void onCreate(Bundle savedInstanceState) {
	        super.onCreate(savedInstanceState);
		setContentView(R.layout.manko_alert_dialog);
		
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD|
		        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON|
		        WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		
		mAddress = getIntent().getStringExtra("address");
		mName = getIntent().getStringExtra("name");
		ringType = getIntent().getIntExtra("notice_type", 0);
		
		type = getIntent().getIntExtra("type", 0);
		
		String ringTone = getIntent().getStringExtra("ring");
		
		if(!TextUtils.isEmpty(ringTone)){
			mRingtoneUri = Uri.parse(ringTone);
		}
		
		Button i_know = (Button) findViewById(R.id.i_know);
		i_know.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				stopRingAndVibrat();
				startRing = false;
				finish();
			}
		});
		
		
		
		if(!TextUtils.isEmpty(mName)){
			TextView text_view = (TextView)findViewById(R.id.msg_text);
			if(type == 0){
				text_view.setText(mName + "\r\n已超出了你的范围\r\n快快找回吧！");
			}else if(type == 1){
				text_view.setText(mName + "\r\n正在呼叫你！");
			}		
		}
		
		IntentFilter filter = new IntentFilter();
		filter.addAction(FindUtils.ACTION_MANKO_CONNECTED);
		LocalBroadcastManager.getInstance(this).registerReceiver(mCmdReceiver,filter);
		
		mHandler.sendEmptyMessageDelayed(9995, 30*1000);//最多响铃一分钟
		startRing = true;
		mHandler.sendEmptyMessageDelayed(9996, 1000);
	}
	 
	 
		private BroadcastReceiver mCmdReceiver = new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				
				final String action = intent.getAction();
				if (FindUtils.ACTION_MANKO_CONNECTED.equals(action)) {
					if(TextUtils.equals(mAddress, intent.getStringExtra("address"))){
						startRing = false;
						finish();
					}
				}
			}
		};

	@Override
	protected void onDestroy() {
		mHandler.removeMessages(9996);
		mHandler.removeMessages(9995);
		stopRingAndVibrat();
		LocalBroadcastManager.getInstance(this).unregisterReceiver(mCmdReceiver);
		super.onDestroy();
		mHandler.removeCallbacks(finishRunnable);
		isOn = false;
	}

	@Override
	public void finish() {
		startRing = false;
		super.finish();
		mHandler.removeCallbacks(finishRunnable);
	}

	public Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case 9995:
				stopRingAndVibrat();
				startRing = false;
				finish();
				break;
			case 9996:
				mHandler.removeMessages(9996);
				ringAndVibrat();
				break;
			}
		}
	};
}
