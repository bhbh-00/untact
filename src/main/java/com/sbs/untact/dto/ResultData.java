package com.sbs.untact.dto;

import java.util.Map;

import com.sbs.untact.util.Util;

import lombok.Data;

@Data
public class ResultData {
	private String resultCode; // 결과코드 s-1, f-1
	private String msg; // 결과메시지
	private Map<String, Object> body; // 내용

	public ResultData(String resultCode, String msg, Object... args) {
		this.resultCode = resultCode;
		this.msg = msg;
		this.body = Util.mapOf(args);
	}

	// 성공 시
	public boolean isSuccess() {
		return resultCode.startsWith("S-");
	}

	// 실패 시
	public boolean isFail() {
		return isSuccess() == false;
	}

}
