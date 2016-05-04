package com.zhicheng.collegeorange.profile;

import java.util.List;

import com.zhicheng.collegeorange.R;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.TextView;


public class ActionPopupWindow extends PopupWindow {  
    private Button[] exitBtn = new Button[7]; //五个按钮 
    private View mMenuView;  
    private List<String> nameList;
    private Handler mHandler;
    public ActionPopupWindow(Activity context,List<String> list,OnClickListener itemsOnClick,String title,Handler handle) {  
        super(context);  
        LayoutInflater inflater = (LayoutInflater) context  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
                
        mMenuView = inflater.inflate(R.layout.complete_action_plus, null);  
        nameList = list;
        TextView tv = (TextView) mMenuView.findViewById(R.id.content_text);
        if (!TextUtils.isEmpty(title)){       	  
        	tv.setText(title);
        	tv.setVisibility(View.VISIBLE);
        }else{
        	tv.setVisibility(View.GONE);
        }
        exitBtn[0] = (Button) mMenuView.findViewById(R.id.exitBtn0);  
        exitBtn[1] = (Button) mMenuView.findViewById(R.id.exitBtn1);  
        exitBtn[2] = (Button) mMenuView.findViewById(R.id.exitBtn2);  
        exitBtn[3] = (Button) mMenuView.findViewById(R.id.exitBtn3);  
        exitBtn[4] = (Button) mMenuView.findViewById(R.id.exitBtn4);  
        exitBtn[5] = (Button) mMenuView.findViewById(R.id.exitBtn5); 
        exitBtn[6] = (Button) mMenuView.findViewById(R.id.exitBtn6); 
        int size = (nameList.size() < 7)? nameList.size():7;
        for(int i = 0; i < size; i++){
        	exitBtn[i].setText(nameList.get(i));
        	exitBtn[i].setVisibility(View.VISIBLE);
        	exitBtn[i].setOnClickListener(itemsOnClick); 
        }
        mHandler = handle;
        //取消按钮  
        mMenuView.findViewById(R.id.exitBtn).setOnClickListener(new OnClickListener() {  
  
            public void onClick(View v) {  
            	dismiss(); 
            }  
        });   
  
        //设置SelectPicPopupWindow的View  
        this.setContentView(mMenuView);  
        //设置SelectPicPopupWindow弹出窗体的宽  
        this.setWidth(LayoutParams.FILL_PARENT);  
        //设置SelectPicPopupWindow弹出窗体的高  
        this.setHeight(LayoutParams.WRAP_CONTENT);  
        //设置SelectPicPopupWindow弹出窗体可点击  
        this.setFocusable(true);  
        //设置SelectPicPopupWindow弹出窗体动画效果  
//        this.setAnimationStyle(R.style.AnimBottom);  
        //实例化一个ColorDrawable颜色为半透明  
        ColorDrawable dw = new ColorDrawable(0x00000000);  
        //设置SelectPicPopupWindow弹出窗体的背景  
        this.setBackgroundDrawable(dw);  
        //mMenuView添加OnTouchListener监听判断获取触屏位置如果在选择框外面则销毁弹出框  
        mMenuView.setOnTouchListener(new OnTouchListener() {  
              
            public boolean onTouch(View v, MotionEvent event) {  
                  
                int height = mMenuView.findViewById(R.id.layout).getTop();  
                int y=(int) event.getY();  
                if(event.getAction()==MotionEvent.ACTION_UP){  
                    if(y<height){  
                    	dismiss(); 
                    }  
                }                 
                return true;  
            }  
        });  
//        content_layout = (LinearLayout)mMenuView.findViewById(R.id.content_layout);
//        layout = (LinearLayout)mMenuView.findViewById(R.id.layout);
//        Animation animation = new AlphaAnimation(0.1f, 1.0f);
//        animation.setDuration(5000);
//        layout.setAnimation(animation);
//        Animation ani = AnimationUtils.loadAnimation(this, R.style.AnimBottom);
//        content_layout.setAnimationStyle(R.style.AnimBottom);
        
        mMenuView.findViewById(R.id.layout).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				dismiss();
			}
		});
    }
	@Override
	public void dismiss() {
		if (mHandler != null){
    		mHandler.sendEmptyMessage(101);
    		mHandler = null;
    	}
		super.dismiss();
	}  

}
