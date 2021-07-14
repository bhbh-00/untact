package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Member;

@Mapper
public interface MemberDao {

	// 회원가입
	void join(Map<String, Object> param);
	
	// 기존 회원의 아이디 찾기
	Member getMemberByLoginId(@Param("loginId") String loginId);
	
	// 기존 회원의 이름과 이메일 찾기
	Member getMemberByNameAndEmail(@Param("name") String name, @Param("email") String email);

	//
	Member getMember(@Param("id") int id);

	//
	Member getMemberByAuthKey(@Param("authKey") String authKey);

	// 회원 리스트
	List<Member> getForPrintMembers(Map<String, Object> param);

	Member getForPrintMember(@Param("id") int id);

	// 회원탈퇴
	void delete(@Param("id") Integer id);

	// 기존 회원의 비밀번호 찾기
	Member getMemberByLoginPw(@Param("loginPw") String loginPw);


	// 회원 정보 수정
	void modify(@Param("id") int id, @Param("loginPw") String loginPw, @Param("authLevel") int authLevel,
			@Param("name") String name, @Param("nickname") String nickname, @Param("cellphoneNo") String cellphoneNo,
			@Param("email") String email);

	// 회원의 총
	int getMemberTotleCount(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

}
