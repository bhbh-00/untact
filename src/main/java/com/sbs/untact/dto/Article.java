package com.sbs.untact.dto;

import java.text.SimpleDateFormat;
import java.util.Date;


public class Article {
	
	// 중요한 순으로 나열하는 게 좋음
	private int id;
	private String regDate; // 등록 시점
	private String updateDate; // 수정 시점
	private String title;
	private String body;
	

	public Article(int id, String regDate, String updateDate, String title, String body) {
		super();
		this.id = id;
		this.regDate = regDate;
		this.updateDate = updateDate;
		this.title = title;
		this.body = body;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

}
