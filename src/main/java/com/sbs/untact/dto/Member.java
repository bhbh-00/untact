package com.sbs.untact.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.sbs.untact.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Member extends EntityDto {

	private int id;
	private String regDate;
	private String updateDate;
	private String loginId;
	@JsonIgnore
	// @JsonIgnore -> 보여지지 않게하기 위함
	private String loginPw;
	private int authLevel;
	@JsonIgnore
	private String authKey;
	private String name;
	private String nickname;
	private String cellphoneNo;
	private String email;
	private boolean delStatus;
    private String delDate;
	
	private String Extra__thumbImg;
	
	public String getAuthLevelName() {
		return MemberService.getAuthLevelName(this);
	}
	
	public String getAuthLevelNameColor() {
		return MemberService.getAuthLevelNameColor(this);
	}
	
}
