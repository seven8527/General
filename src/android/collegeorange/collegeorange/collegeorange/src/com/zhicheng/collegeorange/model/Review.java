package com.zhicheng.collegeorange.model;

import java.io.Serializable;

import com.google.gson.Gson;

public class Review implements Serializable {

	private static final long serialVersionUID = -6725425306787201157L;

	/**
	 * 赞的个数
	 */
//	private String mZanCount;
	
	/**
	 * 评论
	 */
	public static final int TYPE_COMMENT = 10;
	
	/**
	 * 赞
	 */
	public static final int TYPE_ZAN = 20;
	
	private String id;
	
	/**
	 * 话题发表服务器时间
	 */
	private String circleTime;
	
	/**
	 * 话题发表用户
	 */
	private String circleUser;	
	
	/**
	 * 类型 10 评论  ， 20 赞
	 */
	private int type = TYPE_COMMENT;
	
	/**
	 * 评论人电话号码
	 */
	private String friendName;
	/**
	 * 评论人昵称
	 */
	private String nickName;
	/**
	 * 评论内容
	 */
	private String content;
	/**
	 * 评论人位置
	 */
	private String location;
	/**
	 * 评论时间
	 */
	private String time;
	/**
	 * 评论人头像
	 */
	private String avatar;
	
	/**
	 * 被回复者
	 */
	private String commentTo;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setCircleTime(String circleTime) {
		this.circleTime = circleTime;
	}
	
	public String getCircleUser() {
		return circleUser;
	}
	
	public String getCircleTime() {
		return circleTime;
	}
	
	public void setCircleUser(String circleUser) {
		this.circleUser = circleUser;
	}
	
	public int getType() {
		return type;
	}
	
	public void setType(int type) {
		this.type = type;
	}
	
	public String getFriendName() {
		return friendName;
	}

	public void setFriendName(String mFriendName) {
		this.friendName = mFriendName;
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String mNickName) {
		this.nickName = mNickName;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String mContent) {
		this.content = mContent;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String mLocation) {
		this.location = mLocation;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String mTime) {
		this.time = mTime;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String mAvatar) {
		this.avatar = mAvatar;
	}
	
	public void setCommentTo(String commentTo) {
		this.commentTo = commentTo;
	}
	
	public String getCommentTo() {
		return commentTo;
	}

	@Override
	public String toString() {
		return "Review [mFriendName=" + friendName + ", mNickName=" + nickName +", Type =" + type + ", mContent=" + content + ", mLocation="
				+ location + ", mTime=" + time + ", mAvatar=" + avatar + "]";
	}
	
	public static Review fromJSON(String json) {
		Gson gson = new Gson();
		Review steps = gson.fromJson(json, Review.class);
		return steps;
	}
	
	public static Review creatReview(String circleUser, String circleTime, String zanUser,String zanNick , int type){
		Review obj = new Review();
		obj.setType(type);
		obj.setCircleUser(circleUser);
		obj.setCircleTime(circleTime);
		obj.setFriendName(zanUser);
		obj.setNickName(zanNick);
		return obj;
	}
	
	public static Review creatZanData(String circleUser, String circleTime, String zanUser,String zanNick){
		Review obj = creatReview(circleUser, circleTime, zanUser, zanNick, TYPE_ZAN);		
		return obj;
	}
	
	public static Review creatComment(String circleUser, String circleTime, String zanUser,String zanNick,String content){
		Review obj = creatReview(circleUser, circleTime, zanUser, zanNick, TYPE_COMMENT);
		obj.setContent(content);
		return obj;
	}
	
	
}
