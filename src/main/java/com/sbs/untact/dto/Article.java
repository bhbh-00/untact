package com.sbs.untact.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Article {

	// 중요한 순으로 나열하는 게 좋음
	private int id;
	private String regDate; // 등록 시점
	private String updateDate; // 수정 시점
	private int memberId;
	private String title;
	private String body;
	
	private String extra__writer;

}
