package com.zhicheng.collegeorange.model;

import java.io.Serializable;

public class Photo implements Serializable {

	private static final long serialVersionUID = -6449419797058737470L;

	private int mId;

	private String mPath;

	private String mFolder;

	private String mTakenDate;

	public int getmId() {
		return mId;
	}

	public void setmId(int mId) {
		this.mId = mId;
	}

	public String getmPath() {
		return mPath;
	}

	public void setmPath(String mPath) {
		this.mPath = mPath;
	}

	public String getmFolder() {
		return mFolder;
	}

	public void setmFolder(String mFolder) {
		this.mFolder = mFolder;
	}

	public String getmTakenDate() {
		return mTakenDate;
	}

	public void setmTakenDate(String mTakenDate) {
		this.mTakenDate = mTakenDate;
	}

	
}
