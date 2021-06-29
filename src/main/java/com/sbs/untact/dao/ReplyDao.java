package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Reply;

@Mapper
public interface ReplyDao {

	void doAdd(Map<String, Object> param);

	List<Reply> getForPrintReplies(@Param("id") Integer id);

	Reply getReply(@Param("id") Integer id);

	void delete(@Param("id") Integer id);

	void modify(@Param("id") Integer id, @Param("body") String body);

}
