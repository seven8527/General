/**
 *
 * Copyright 2015 Telenav, Inc. All rights reserved.
 * BannerItemFragment.java
 *
 */
package com.zhicheng.collegeorange.main;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.zhicheng.collegeorange.R;

public class BannerItemFragment extends Fragment {

    private static final String KEY_CONTENT = "BannerItemFragment:Content";
    private View.OnClickListener listener;

    private ImageView bannerView;


    public static BannerItemFragment newInstance(int clickableId, View.OnClickListener listener, int layoutRes, int index) {
        BannerItemFragment fragment = new BannerItemFragment();

        fragment.content = new SavedState();
        fragment.content.clickableId = clickableId;
        fragment.content.layoutRes = layoutRes;
        fragment.content.index = index;

        fragment.listener = listener;

        return fragment;
    }

    public SavedState content;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if ((savedInstanceState != null) && savedInstanceState.containsKey(KEY_CONTENT)) {
            content = savedInstanceState.getParcelable(KEY_CONTENT);
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        int layout = content.layoutRes;
        View contentView = inflater.inflate(layout, container, false);
        bannerView = (ImageView)contentView.findViewById(R.id.banner_image);
        bannerView.setImageResource(getImageResId(content.index));

        if (content.clickableId != 0) {
            View clickable = contentView.findViewById(content.clickableId);
            if (clickable != null) {
                clickable.setOnClickListener(this.listener);
            }
        }

        return contentView;
    }

    private int getImageResId(int index) {
        switch (index){
            case 0:
                return R.drawable.ftue_1_bg_unfocused;
            case 1:
                return R.drawable.ftue_2_bg_unfocused;
            case 2:
                return R.drawable.ftue_3_bg_unfocused;
            case 3:
                return R.drawable.ftue_4_bg_unfocused;
            default:
                return R.drawable.ftue_1_bg_unfocused;
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putParcelable(KEY_CONTENT, content);
    }

    static class SavedState implements Parcelable {
        int clickableId;
        int layoutRes;
        int index;

        private SavedState(Parcel in) {
            clickableId = in.readInt();
            layoutRes = in.readInt();
            index = in.readInt();
        }

        public SavedState() {

        }

        @Override
        public int describeContents() {
            return 0;
        }

        @Override
        public void writeToParcel(Parcel dest, int flags) {
            dest.writeInt(clickableId);
            dest.writeInt(layoutRes);
            dest.writeInt(index);
        }

        public static final Parcelable.Creator<SavedState> CREATOR = new Parcelable.Creator<SavedState>() {
            @Override
            public SavedState createFromParcel(Parcel in) {
                return new SavedState(in);
            }

            @Override
            public SavedState[] newArray(int size) {
                return new SavedState[size];
            }
        };
    }
}
