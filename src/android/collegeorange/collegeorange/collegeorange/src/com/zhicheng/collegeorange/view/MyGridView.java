package com.zhicheng.collegeorange.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.GridView;

public class MyGridView extends GridView { 
    public MyGridView(Context context, AttributeSet attrs) { 
        super(context, attrs); 
    } 

    public MyGridView(Context context) { 
        super(context); 
    } 

    public MyGridView(Context context, AttributeSet attrs, int defStyle) { 
        super(context, attrs, defStyle); 
    } 

    @Override 
    public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) { 
        int expandSpec = MeasureSpec.makeMeasureSpec( 
                Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST); 
        super.onMeasure(widthMeasureSpec, expandSpec); 
        
        
//        setMeasuredDimension(getDefaultSize(0, widthMeasureSpec), getDefaultSize(0, heightMeasureSpec));
//        
//        // Children are just made to fill our space.
//        int childWidthSize = getMeasuredWidth();
//        int childHeightSize = getMeasuredHeight();
//        //高度和宽度一样
//        heightMeasureSpec = widthMeasureSpec = MeasureSpec.makeMeasureSpec(childWidthSize, MeasureSpec.EXACTLY);
//        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

    } 
    
    @Override  
    public boolean dispatchTouchEvent(MotionEvent ev) {  
        if (ev.getAction() == MotionEvent.ACTION_MOVE) {  
            return true;  
        }
        return super.dispatchTouchEvent(ev);  
    }  
}