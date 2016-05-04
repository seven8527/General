package com.zhicheng.collegeorange.model;
public class Topic {

	/**
	 * 标题
	 */
	private String title;
	
	/**
	 * 图片名称
	 */
	private String image;
	
	/**
	 * 跳转链接地址
	 */
	private String url;	


	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String imageName) {
		this.image = imageName;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}	
	
}
