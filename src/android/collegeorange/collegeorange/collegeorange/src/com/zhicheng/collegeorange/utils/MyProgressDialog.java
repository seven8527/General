package com.zhicheng.collegeorange.utils;

import android.app.Dialog;
import android.content.Context;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.zhicheng.collegeorange.R;


public class MyProgressDialog{

/**
	 * 得到自定义的progressDialog
	 * @param context
	 * @param msg
	 * @return
	 */
	private static Dialog mMyDialogProgress = null;
	public static Dialog createLoadingDialog(Context context, String msg,final Handler handler) {

		LayoutInflater inflater = LayoutInflater.from(context);
		View v = inflater.inflate(R.layout.progress_dialog, null);// 得到加载view
		LinearLayout layout = (LinearLayout) v.findViewById(R.id.dialog_view);// 加载布局
		// main.xml中的ImageView
		ImageView spaceshipImage = (ImageView) v.findViewById(R.id.progress_img);
		TextView tipTextView = (TextView) v.findViewById(R.id.progress_test);// 提示文字
		// 加载动画
		Animation hyperspaceJumpAnimation = AnimationUtils.loadAnimation(
				context, R.anim.loading_animation);
		// 使用ImageView显示动画
		spaceshipImage.startAnimation(hyperspaceJumpAnimation);
		tipTextView.setText(msg);// 设置加载信息

		mMyDialogProgress = new Dialog(context, R.style.loading_dialog);// 创建自定义样式dialog

		mMyDialogProgress.setCancelable(true);// 不可以用“返回键”取消
		mMyDialogProgress.setContentView(layout, new LinearLayout.LayoutParams(
				LinearLayout.LayoutParams.WRAP_CONTENT,
				LinearLayout.LayoutParams.WRAP_CONTENT));// 设置布局
//		mMyDialogProgress.setOnKeyListener(new OnKeyListener() {		
//			@Override
//			public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
//				if (KeyEvent.KEYCODE_BACK == keyCode && handler != null){
//					handler.sendEmptyMessage(0);
//					if (mMyDialogProgress != null){
//						mMyDialogProgress.dismiss();
//					}
//				}
//				// TODO Auto-generated method stub
//				return true;
//			}
//		});
		mMyDialogProgress.show();
		return mMyDialogProgress;

	}
	
	public static boolean isMyDialogProgressNull(){
		if(mMyDialogProgress==null){
			return true;
		}else {
			return false;
		}
		
	}
	
	public static void closeLoadingDialog(){
		if (mMyDialogProgress != null){
			mMyDialogProgress.dismiss();
			mMyDialogProgress = null;
		}
	}
	
	public static void show(){
		if(mMyDialogProgress!=null){
			mMyDialogProgress.show();
		}
	}
}