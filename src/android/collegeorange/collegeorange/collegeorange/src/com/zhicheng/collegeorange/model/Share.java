package com.zhicheng.collegeorange.model;

import java.io.Serializable;
import java.util.ArrayList;

public class Share implements Serializable {

	private static final long serialVersionUID = -6449419797058737470L;

	private String mSqlId;

	private String mId;

	private String mPhoneNum;

	private String mContent;

	private String mTime;

	private String mPosition;

	private ArrayList<String> mPicPaths;

	public String getmId() {
		return mId;
	}

	public void setmId(String mId) {
		this.mId = mId;
	}

	public String getmContent() {
		return mContent;
	}

	public void setmContent(String mContent) {
		this.mContent = mContent;
	}

	public String getmTime() {
		return mTime;
	}

	public void setmTime(String mTime) {
		this.mTime = mTime;
	}

	public ArrayList<String> getmPicPaths() {
		return mPicPaths;
	}

	public void setmPicPaths(ArrayList<String> mPicPaths) {
		this.mPicPaths = mPicPaths;
	}

	public String getmPhoneNum() {
		return mPhoneNum;
	}

	public void setmPhoneNum(String mPhoneNum) {
		this.mPhoneNum = mPhoneNum;
	}

	public String getmSqlId() {
		return mSqlId;
	}

	public void setmSqlId(String mSqlId) {
		this.mSqlId = mSqlId;
	}

	public String getmPosition() {
		return mPosition;
	}

	public void setmPosition(String mPosition) {
		this.mPosition = mPosition;
	}

}
