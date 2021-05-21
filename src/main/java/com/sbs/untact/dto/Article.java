package com.sbs.untact.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Article extends EntityDto {

	// 중요한 순으로 나열하는 게 좋음
	private int id;
	private String regDate; // 등록 시점
	private String updateDate; // 수정 시점
	private int boardId; // 게시판 별 리스팅번호
	private int memberId;
	private String title;
	private String body;

	private String extra__writer;
	private String extra__boardName;
	private String extra__thumbImg; // 썸네일
	
	public String getWriterThumbImgUrl() {
		return "/common/genFile/file/member/" + memberId + "/common/attachment/1";
	}
	
	public String getWriterProfileFallbackImgUri() {
        return "https://via.placeholder.com/300?text=No thumbnail";
    }

    public String getWriterProfileFallbackImgOnErrorHtmlAttr() {
        return "this.src = '" + getWriterProfileFallbackImgUri() + "'";
    }
}
