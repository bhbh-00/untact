package com.sbs.untact.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reply extends EntityDto {

	private int id;
	private String regDate; // 등록 시점
	private String updateDate; // 수정 시점
	private String relTypeCode;
	private int relId;
	private int memberId;
	private String body;
	private boolean blindStatus;
	private String blindDate;
	private boolean delStatus;
	private String delDate;

	private String extra__writer;

	private String Extra__thumbImg;

	public String getProfileImgUrl() {
		return "/common/genFile/file/member/" + memberId + "/common/attachment/1";

	}

	public String getProfileFallbackImgUrl() {
		return "https://via.placeholder.com/300?text=No image";
	}

	public String getProfileFallbackImgOnErrorHtmlAttr() {
		return "this.src = '" + getProfileFallbackImgUrl() + "'";
	}
}
