package com.sbs.untact.dto;

import java.util.Map;

import com.sbs.untact.util.Util;

import lombok.Getter;

public class Rq {

	@Getter
	private boolean isAjax;

	@Getter
	private boolean isAdmin;
	
	private String currentUrl;
	@Getter
	private String currentUri;
	private Member loginedMember;
	private Map<String, String> paramMap;
	@Getter
	private boolean needToChangePassword;

	public Rq(boolean isAjax, boolean isAdmin, Member loginedMember, String currentUrl, Map<String, String> paramMap,
			boolean needToChangePassword) {
		this.isAjax = isAjax;
		this.isAdmin = isAdmin;
		this.loginedMember = loginedMember;
		this.currentUrl = currentUrl.split("\\?")[0];
		this.currentUrl = currentUrl;
		this.paramMap = paramMap;
		this.needToChangePassword = needToChangePassword;
	}

	public String getParamJsonStr() {
		return Util.toJsonStr(paramMap);
	}

	public boolean isNotAdmin() {
		return isAdmin == false;
	}

	public boolean isLogined() {
		return loginedMember != null;
	}

	public boolean isNotLogined() {
		return isLogined() == false;
	}

	public int getLoginedMemberId() {
		if (isNotLogined())
			return 0;

		return loginedMember.getId();
	}

	public Member getLoginedMember() {
		return loginedMember;
	}

	public String getEncodedCurrentUrl() {
		return Util.getUrlEncoded(getCurrentUrl());
	}

	public String getCurrentUrl() {
		return currentUrl;
	}

	public String getLoginPageUrl() {
		String afterLoginUrl;

		if (isLoginPage()) {
			afterLoginUrl = Util.getUrlEncoded(paramMap.get("afterLoginUrl"));
		} else {
			afterLoginUrl = getEncodedCurrentUrl();
		}

		return "../member/login?afterLoginUrl=" + afterLoginUrl;
	}

	private boolean isLoginPage() {
		return currentUrl.equals("/usr/member/login");
	}
}
