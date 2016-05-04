package com.zhicheng.collegeorange;

/**
 * Created by ypyang on 1/18/16.
 */


import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.zhicheng.collegeorange.main.DiscoverFragment;
import com.zhicheng.collegeorange.main.MainFragment;
import com.zhicheng.collegeorange.main.UserFragment;
import com.zhicheng.collegeorange.main.ViewpointFragment;

/**
 * A {@link FragmentPagerAdapter} that returns a fragment corresponding to
 * one of the sections/tabs/pages.
 */
public class SectionsPagerAdapter extends FragmentPagerAdapter {
    private static final int  fragmentCount = 4;

    public SectionsPagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int position) {
        return getFragmentItem(position);
    }

    private Fragment getFragmentItem(int sectionNumber){
        switch (sectionNumber){
            case 0:
                return MainFragment.newInstance(sectionNumber + 1);
            case 1:
                return DiscoverFragment.newInstance(sectionNumber+1);
            case 2:
                return ViewpointFragment.newInstance(sectionNumber + 1);
            case 3:
                return UserFragment.newInstance(sectionNumber + 1);
            default:
                return MainFragment.newInstance(1);
        }
    }

    @Override
    public int getCount() {
        return fragmentCount;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        switch (position) {
            case 0:
                return "首页";
            case 1:
                return "发现";
            case 2:
                return "吐槽";
            default:
                return "New Sections";
        }
    }
}
