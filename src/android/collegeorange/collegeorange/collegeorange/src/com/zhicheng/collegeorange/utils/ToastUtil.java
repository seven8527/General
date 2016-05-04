package com.zhicheng.collegeorange.utils;

import android.content.Context;
import android.widget.Toast;

/**
 * @author test
 * Toast������
 */
public class ToastUtil {

	/**
	 * @param context
	 * @param message
	 * ��ʱ����ʾ
	 */
	public static void showToast(Context context,String message){
		Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
	}
	
	/**
	 * @param context
	 * @param message
	 * ��ʱ����ʾ
	 */
	public static void showLongToast(Context context,String message){
		Toast.makeText(context, message, Toast.LENGTH_LONG).show();
	}
}
