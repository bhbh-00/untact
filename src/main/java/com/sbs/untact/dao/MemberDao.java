package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Member;

@Mapper
public interface MemberDao {

	void join(Map<String, Object> param);

	Member getMember(@Param("id") int id);

	Member getMemberByAuthKey(@Param("authKey") String authKey);

	Member getMembers(@Param("authLevel") int authLevel);

	List<Member> getForPrintMembers(Map<String, Object> param);

	Member getForPrintMember(@Param("id") int id);

	void delete(@Param("id") Integer id);

	Member getMemberByLoginId(@Param("loginId") String loginId);

	Member getMemberByLoginPw(@Param("loginPw") String loginPw);

	Member getMemberByNameAndEmail(@Param("name") String name, @Param("email") String email);

	void modify(@Param("id") int id, @Param("loginPw") String loginPw, @Param("authLevel") int authLevel,
			@Param("name") String name, @Param("nickname") String nickname, @Param("cellphoneNo") String cellphoneNo,
			@Param("email") String email);

	int getMemberTotleCount(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

}
