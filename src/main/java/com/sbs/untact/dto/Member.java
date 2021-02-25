package com.sbs.untact.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Member {

	private int id;
	private String regDate;
	private String updateDate;
	private String loginId;
	@JsonIgnore
	// @JsonIgnore -> 보여지지 않게하기 위함
	private String loginPw;
	@JsonIgnore
	private String authKey;
	private String name;
	private String nickname;
	private String cellphoneNo;
	private String email;

}
