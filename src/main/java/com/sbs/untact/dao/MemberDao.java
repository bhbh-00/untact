package com.sbs.untact.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Member;

@Mapper
public interface MemberDao {

	public void join(Map<String, Object> param);

	public Member getMemberByloginId(@Param("loginId") String loginId);

	public Member getMember(@Param("id") int id);

	public void modifyMember(Map<String, Object> param);

}
