package com.sbs.untact.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Like extends EntityDto {

	// 중요한 순으로 나열하는 게 좋음
	private int id;
	private String regDate; 
	private String updateDate;
	private String relTypeCode;
	private int relId;
	private int memberId;
	private String like;
	
	private String extra__writer;
	private String extra__boardName;
	private String extra__thumbImg; // 썸네일
	
	public String getWriterThumbImgUrl() {
		return "/common/genFile/file/member/" + memberId + "/common/attachment/1";
	}
}
