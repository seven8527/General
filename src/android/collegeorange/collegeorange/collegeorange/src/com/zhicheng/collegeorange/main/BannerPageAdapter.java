/**
 *
 * Copyright 2015 Telenav, Inc. All rights reserved.
 * BannerPageAdapter.java
 *
 */
package com.zhicheng.collegeorange.main;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.View;

import com.zhicheng.collegeorange.R;

class BannerPageAdapter extends FragmentPagerAdapter {

    protected static final int[] CLICKABLE_IDS = new int[]{0,
            0, 0, 0};

    protected static final int[] LAYOUT_RES = new int[]{R.layout.banner_main,
            R.layout.banner_main, R.layout.banner_main, R.layout.banner_main};


    private final View.OnClickListener listener;


    public BannerPageAdapter(FragmentManager fm, View.OnClickListener listener) {
        super(fm);
        this.listener = listener;
    }

    @Override
    public Fragment getItem(int position) {
        int pos = position % CLICKABLE_IDS.length;
        return BannerItemFragment.newInstance(CLICKABLE_IDS[pos], listener, LAYOUT_RES[pos], pos);
    }

    @Override
    public int getCount() {
        return CLICKABLE_IDS.length;
    }
}
