package com.sbs.untact.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Board extends EntityDto {

	private int id;
	private String regDate;
	private String updateDate;
	private int memberId;
	private String code;
	private String name;

	private String extra__writer;

	public String getCodeThumbImgUrl() {
		return "/common/genFile/file/member/" + memberId + "/common/attachment/1";
	}

	public String getCodeProfileFallbackImgUri() {
		return "https://via.placeholder.com/300?text=" + code;
	}

	public String getCodeProfileFallbackImgOnErrorHtmlAttr() {
		return "this.src = '" + getCodeProfileFallbackImgUri() + "'";
	}

}