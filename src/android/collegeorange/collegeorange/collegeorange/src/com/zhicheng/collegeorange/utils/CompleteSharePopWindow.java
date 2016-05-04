package com.zhicheng.collegeorange.utils;

import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.zhicheng.collegeorange.R;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.Toast;

public class CompleteSharePopWindow  extends PopupWindow{

	private View mView;
	private Button mSomeone;
	private Button mPenyouQuan;
	private ClickListener mListener = new ClickListener();
	private Context mContext;
	
	private static final String APP_ID= "";
	private IWXAPI api;
	
	
	
	public CompleteSharePopWindow(Context context){
		super(context);  
		this.mContext = context;
		
		initIWXAPI();
		
        LayoutInflater inflater = (LayoutInflater) context  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE); 
        mView = inflater.inflate(R.layout.share_to_item, null);
        mSomeone = (Button) mView.findViewById(R.id.shareSomeone);
        mPenyouQuan = (Button) mView.findViewById(R.id.sharePengyouquan);
        mSomeone.setOnClickListener(mListener);
        mPenyouQuan.setOnClickListener(mListener);
        this.setContentView(mView);
        this.setWidth(LayoutParams.MATCH_PARENT);  
        //设置SelectPicPopupWindow弹出窗体的高  
        this.setHeight(LayoutParams.WRAP_CONTENT);  
        //设置SelectPicPopupWindow弹出窗体可点击  
        this.setFocusable(true);
      //实例化一个ColorDrawable颜色为半透明  
        ColorDrawable dw = new ColorDrawable(0x00000000);  
        //设置SelectPicPopupWindow弹出窗体的背景  
        this.setBackgroundDrawable(dw);  
        
        mView.setOnTouchListener(new OnTouchListener() {  
            
          public boolean onTouch(View v, MotionEvent event) {  
                
              int height = mView.findViewById(R.id.share_item).getTop();  
              int y=(int) event.getY();  
              if(event.getAction()==MotionEvent.ACTION_UP){  
                  if(y<height){  
                  	dismiss(); 
                  }  
              }                 
              return true;  
          }  
      });  
	}
	private void initIWXAPI() {
		// TODO Auto-generated method stub
		//api = WXAPIFactory.createWXAPI(this, Constants.APP_ID);
	}
	private class  ClickListener implements OnClickListener{

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			switch(v.getId()){
			case R.id.shareSomeone:
				Toast.makeText(mContext, "这是分享给朋友 ",Toast.LENGTH_SHORT).show();
				shareToSome();
				break;
			case R.id.sharePengyouquan:
				Toast.makeText(mContext, "这是分享到朋友圈 ",Toast.LENGTH_SHORT).show();
				shareToPengyouQuan();
				break;
			
			}
			
		}

		
		
	}
	//分享到朋友圈
	private void shareToPengyouQuan() {
		// TODO Auto-generated method stub
		
	}
	//分享给朋友 
	private void shareToSome() {
		// TODO Auto-generated method stub
		
	}
}
