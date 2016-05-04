package com.zhicheng.collegeorange.main;

import java.util.List;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.baidu.mapapi.search.core.PoiInfo;
import com.zhicheng.collegeorange.R;

public class AdapterShareLocation extends BaseAdapter {

	Context context;
	private LayoutInflater inflater;
	private List<PoiInfo> poiItems;
	int selected;

	public AdapterShareLocation(Context context, List<PoiInfo> list,int selected) {
		this.context = context;
		inflater = LayoutInflater.from(context);
		this.poiItems = list;
		this.selected = selected;
	}
	public void addData(List<PoiInfo> list) {
		poiItems.addAll(list);
		notifyDataSetChanged();
	}

	@Override
	public int getCount() {
		return poiItems.size();
	}

	@Override
	public Object getItem(int position) {
		return poiItems.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = (View) inflater.inflate(R.layout.activity_share_location_item, null);
			holder.title = (TextView) convertView.findViewById(R.id.title);
			holder.snippet = (TextView) convertView.findViewById(R.id.snippet);

			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		PoiInfo poiItem = poiItems.get(position);
		if (position == 0) {
			holder.title.setTextColor(context.getResources().getColor(R.color.blue));
		} else {
			holder.title.setTextColor(context.getResources().getColor(R.color.black));			
		}
		
		if (position == selected) {
			if(position == 0){
				holder.title.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.selector_folder_blue, 0);
			}else{
				holder.title.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.selector_folder, 0);
			}
		} else {
			holder.title.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
		}
		
		holder.title.setText(poiItem.name);
		if (TextUtils.isEmpty(poiItem.address)) {
			holder.snippet.setVisibility(View.GONE);
		} else {
			holder.snippet.setVisibility(View.VISIBLE);
			holder.snippet.setText(poiItem.address);
		}

		return convertView;
	}

	class ViewHolder {
		public TextView title;
		public TextView snippet;
	}

}