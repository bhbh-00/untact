package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Reply;

@Mapper
public interface ReplyDao {

	void doAdd(Map<String, Object> param);

	void doModify(@Param("id") Integer id, @Param("body") String body);

	List<Reply> getForPrintReplies(@Param("id") Integer id);

	Reply getReply(@Param("id") Integer id);

	void delete(@Param("id") Integer id);
	
	List<Reply> getReplyByArticle(@Param("id") Integer id, @Param("relTypeCode") String relTypeCode);

}
