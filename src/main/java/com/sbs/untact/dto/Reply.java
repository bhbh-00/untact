package com.sbs.untact.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Reply {
	
	private int id;
	private String regDate; // 등록 시점
	private String updateDate; // 수정 시점
	private int articleId; 
	private int memberId;
	private String body;

}
