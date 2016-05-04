package com.zhicheng.collegeorange.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Circle implements Serializable {

	private static final long serialVersionUID = -6449419797058737470L;

	private String mId;

	private String mPhoneNum;

	private String mContent;

	private String mTime;

	private String mPosition;

	private String mLickName;

	private String mIcon;
	
	private String mGender;
	
	private String mUrl;
	
	private String mImage;
	
	private String mTitle;
	
	private String mBrief;

	private ArrayList<String> mPicPaths;

	// private String mPage;
	private String mVoice;
	
	private String mVideo;
	
	private int commentCount;
	
	private int zanCount;
	
	public boolean needProfile;
	
	public boolean hasZan;
	
	public int imageWidth = 0;
	
	public int imageHeight = 0;
	
	public int videoWidth = 0;
	
	public int videoHeight = 0;	

	private List<Review> zanList;
	
	private List<Review> commentList;
	
	/*public int getZanCount() {
		if(zanList != null){
			return zanList.size();
		}
		
		return 0;
	}

	

	public int getCommentCount() {
		if(commentList != null){
			return commentList.size();
		}
		return 0;
	}*/

	
	public void setZanList(List<Review> zanList) {
		this.zanList = zanList;
	}
	
	public List<Review> getZanList() {
		return zanList;
	}
	
	public void setCommentList(List<Review> commentList) {
		this.commentList = commentList;
	}
	
	public List<Review> getCommentList() {
		return commentList;
	}
	
	public int getZanCount() {
		return zanList == null ? 0 : zanList.size();
		//return zanCount;
	}

	public void setZanCount(int zanCount) {
		this.zanCount = zanCount;
	}

	public int getCommentCount() {
		return commentList == null ? 0 : commentList.size();
		//return commentCount;
	}

	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}

	public String getmVoice() {
		return mVoice;
	}

	public void setmVoice(String mVoice) {
		this.mVoice = mVoice;
	}

	public String getmVideo() {
		return mVideo;
	}
	
	public void setmVideo(String mVideo) {
		this.mVideo = mVideo;
	}
	
	public String getmId() {
		return mId;
	}

	public void setmId(String mId) {
		this.mId = mId;
	}

	public String getmPhoneNum() {
		return mPhoneNum;
	}

	public void setmPhoneNum(String mPhoneNum) {
		this.mPhoneNum = mPhoneNum;
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

	public String getmPosition() {
		return mPosition;
	}

	public void setmPosition(String mPosition) {
		this.mPosition = mPosition;
	}

	public ArrayList<String> getmPicPaths() {
		return mPicPaths;
	}

	public void setmPicPaths(ArrayList<String> mPicPaths) {
		this.mPicPaths = mPicPaths;
	}

	public String getmLickName() {
		return mLickName;
	}

	public void setmLickName(String mLickName) {
		this.mLickName = mLickName;
	}

	public String getmIcon() {
		return mIcon;
	}

	public void setmIcon(String mIcon) {
		this.mIcon = mIcon;
	}
	
	public void setmGender(String mGender) {
		this.mGender = mGender;
	}
	
	public String getmGender() {
		return mGender;
	}
	
	public void setmUrl(String url){
		this.mUrl = url;
	}
	
	public String getmUrl(){
		return mUrl;
	}
	
	
	public void setmImage(String iamge){
		this.mImage = iamge;
	}
	
	public String getmImage(){
		return mImage;
	}
	
    public void setmTitle(String title){
    	this.mTitle = title;
	}
	
	public String getmTitle() {
		return mTitle;
	}

	public void setmBrief(String brief) {
		this.mBrief = brief;
	}

	public String getmBrief() {
		return mBrief;
	}	
	
	public int getImageWidth(){
		return imageWidth;
	}
	
	public int getImageHeight(){
		return imageHeight;
	}
	
	public void setImageHeight(int imageHeight) {
		this.imageHeight = imageHeight;
	}
	
	public void setImageWidth(int imageWidth) {
		this.imageWidth = imageWidth;
	}
	
	public int getVideoHeight() {
		return videoHeight;
	}
	
	public int getVideoWidth() {
		return videoWidth;
	}
	
	public void setVideoHeight(int videoHeight) {
		this.videoHeight = videoHeight;
	}
	
	public void setVideoWidth(int videoWidth) {
		this.videoWidth = videoWidth;
	}

	@Override
	public String toString() {
		return "Circle [mId=" + mId + ", mPhoneNum=" + mPhoneNum + ", mContent=" + mContent + ", mTime=" + mTime + ", mPosition=" + mPosition + ", mLickName="
				+ mLickName + ", mIcon=" + mIcon + ", mPicPaths=" + mPicPaths + ", mVoice=" + mVoice + "]";
	}
	
	public void deleteZanData(String zanUser){
		if(zanList != null){
			for(Review zan : zanList){
				if(zanUser.equals(zan.getFriendName())){
					zanList.remove(zan);
					break;
				}
			}		
		}
	}
	
	public void deleteComment(String sendUser, String sendTime){
		if(commentList != null){
			for(Review zan : commentList){
				if(sendUser.equals(zan.getFriendName())
						&& sendTime.equals(zan.getTime())){
					commentList.remove(zan);
					break;
				}
			}		
		}
	}
	
	public void addZanData(Review zan){
		if(zanList == null){
			zanList = new ArrayList<Review>();			
		}
		zanList.add(zan);
	}
	
	public void addComment(Review comment){
		if(commentList == null){
			commentList = new ArrayList<Review>();			
		}
		commentList.add(comment);
	}
	
	public Review getZanDatabyId(String zanUser){
		if(zanList == null){
			return null;	
		}
		for(Review zan : zanList){
			if(zanUser.equals(zan.getFriendName())){
				return zan;
			}
		}	
		return null;
	}

	// public String getmPage() {
	// return mPage;
	// }
	//
	// public void setmPage(String mPage) {
	// this.mPage = mPage;
	// }

}
