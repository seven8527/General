/*******************************************************************************
 * Copyright 2011-2013 Sergey Tarasevich
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/
package com.zhicheng.collegeorange.database;

import android.app.Activity;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;

import com.nostra13.universalimageloader.core.ImageLoader;
import com.zhicheng.collegeorange.R;

/**
 * 
 * 
 * @author Sergey Tarasevich (nostra13[at]gmail[dot]com)
 */
public abstract class AbsListViewBaseActivity extends Activity {

	protected static final String STATE_PAUSE_ON_SCROLL = "STATE_PAUSE_ON_SCROLL";
	protected static final String STATE_PAUSE_ON_FLING = "STATE_PAUSE_ON_FLING";

	protected AbsListView listView;
	protected ImageLoader imageLoader = ImageLoader.getInstance();
	protected boolean pauseOnScroll = false;
	protected boolean pauseOnFling = true;
	protected boolean isBottom = true;
	protected View top;

	@Override
	public void onRestoreInstanceState(Bundle savedInstanceState) {
		pauseOnScroll = savedInstanceState.getBoolean(STATE_PAUSE_ON_SCROLL, false);
		pauseOnFling = savedInstanceState.getBoolean(STATE_PAUSE_ON_FLING, true);
	}
	
	private void initSwipeLayout() {
		
	}
	
	protected void setTop(View top) {
		this.top = top;
	}

	@Override
	protected void onResume() {
		applyScrollListener();
		initSwipeLayout();
		super.onResume();
	}

	private void applyScrollListener() {
		if (listView != null)
			listView.setOnScrollListener(listener);
		
	}
	
	public OnScrollListener listener = new OnScrollListener() {
		
		@Override
		public void onScrollStateChanged(AbsListView view, int scrollState) {
			isBottom = false;
			//Log.e("***********===========", scrollState+"");
			switch (scrollState) {
			case OnScrollListener.SCROLL_STATE_IDLE:// 当不滚动时
				try{
					if (listView.getLastVisiblePosition() == (listView.getCount() - 1)) {// 判断滚动到底部
						isBottom = true;
					}
					if (top != null) {
						if (listView.getFirstVisiblePosition() == 0) {
							top.setVisibility(View.INVISIBLE);
						} else {
							top.setVisibility(View.VISIBLE);
						}
					}
				}catch(Exception e){
					e.printStackTrace();
				}	
				break;
			case OnScrollListener.SCROLL_STATE_TOUCH_SCROLL:// 当不滚动时
				closeInputMethod();
				closeMsdPompt();
				break;
			}
		}
		
		@Override
		public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
		
		}
		
		
	};
	

//	PauseOnScrollListener listener = new PauseOnScrollListener(imageLoader, pauseOnScroll, pauseOnFling) {
//
//		@Override
//		public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
//			super.onScroll(view, firstVisibleItem, visibleItemCount, totalItemCount);
//		}
//
//		@Override
//		public void onScrollStateChanged(AbsListView view, int scrollState) {
//			super.onScrollStateChanged(view, scrollState);
//			isBottom = false;
//			switch (scrollState) {
//			case OnScrollListener.SCROLL_STATE_IDLE:// 当不滚动时
//				if (listView.getLastVisiblePosition() == (listView.getCount() - 1)) {// 判断滚动到底部
//					isBottom = true;
//				}
//				break;
//			}
//		}
//
//	};

	@Override
	public void onSaveInstanceState(Bundle outState) {
		outState.putBoolean(STATE_PAUSE_ON_SCROLL, pauseOnScroll);
		outState.putBoolean(STATE_PAUSE_ON_FLING, pauseOnFling);
	}

	

	// @Override
	// public boolean onPrepareOptionsMenu(Menu menu) {
	// MenuItem pauseOnScrollItem = menu.findItem(R.id.item_pause_on_scroll);
	// pauseOnScrollItem.setVisible(true);
	// pauseOnScrollItem.setChecked(pauseOnScroll);
	//
	// MenuItem pauseOnFlingItem = menu.findItem(R.id.item_pause_on_fling);
	// pauseOnFlingItem.setVisible(true);
	// pauseOnFlingItem.setChecked(pauseOnFling);
	// return true;
	// }

	// @Override
	// public boolean onOptionsItemSelected(MenuItem item) {
	// switch (item.getItemId()) {
	// case R.id.item_pause_on_scroll:
	// pauseOnScroll = !pauseOnScroll;
	// item.setChecked(pauseOnScroll);
	// applyScrollListener();
	// return true;
	// case R.id.item_pause_on_fling:
	// pauseOnFling = !pauseOnFling;
	// item.setChecked(pauseOnFling);
	// applyScrollListener();
	// return true;
	// default:
	// return super.onOptionsItemSelected(item);
	// }
	// }
	abstract protected void closeInputMethod();
	
	
	public void closeMsdPompt() {
	}
		
}
