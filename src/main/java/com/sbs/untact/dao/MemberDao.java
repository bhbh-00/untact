package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Member;

@Mapper
public interface MemberDao {

	void join(Map<String, Object> param);

	Member getMemberByloginId(@Param("loginId") String loginId);

	Member getMember(@Param("id") int id);

	void modifyMember(Map<String, Object> param);

	Member getMemberByAuthKey(@Param("authKey") String authKey);

	Member getMembers(@Param("authLevel") int authLevel);

	List<Member> getForPrintMembers(Map<String, Object> param);

	Member getForPrintMember(@Param("id") int id);

	void deleteMember(@Param("id") Integer id);

	Member getMemberByLoginId(@Param("loginId") String loginId);
}
