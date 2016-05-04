package com.zhicheng.collegeorange.utils;


import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.text.TextUtils;

public class ShowDialog {
	private static ProgressDialog mProgressDialog;

	public static ProgressDialog showProgressDialog(Context context,
			String title, String msg, int resourceIcon, boolean isCancle) {
		if (context != null) {
			mProgressDialog = new ProgressDialog(context , ProgressDialog.THEME_HOLO_LIGHT);
			mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER); // Բ��
			mProgressDialog.setIcon(resourceIcon);
			mProgressDialog.setTitle(title);
			mProgressDialog.setMessage(msg);
			mProgressDialog.show();
			mProgressDialog.setCancelable(isCancle);
		}
		return mProgressDialog;
	}
	
	public static ProgressDialog showProgressDialog(Context context,String msg, boolean isCancle) {
		if (context != null) {
			mProgressDialog = new ProgressDialog(context , ProgressDialog.THEME_HOLO_LIGHT);
			mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER); 
			if(!TextUtils.isEmpty(msg)){
				mProgressDialog.setMessage(msg);
			}
			mProgressDialog.show();
			mProgressDialog.setCancelable(isCancle);
		}
		return mProgressDialog;
	}

	public static void closeProgressDialog() {
		if (mProgressDialog != null && mProgressDialog.isShowing()) {
			mProgressDialog.dismiss();
		}
	}

	public static void showDialogInOnClicker(Context context, String title,
			String message,
			android.content.DialogInterface.OnClickListener onClickListener) {

		if (title == null || title.equals("")) {
			title = "通知";
		}
		new AlertDialog.Builder(context).setTitle(title).setMessage(message)
				.setPositiveButton("确定", onClickListener).setCancelable(false)
				.show();
	}
	
	public static boolean isShowing(){
		if (mProgressDialog != null && mProgressDialog.isShowing()) {
			return true;
		}else{
			return false;			
		}
	}
}
