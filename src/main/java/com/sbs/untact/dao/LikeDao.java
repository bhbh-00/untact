package com.sbs.untact.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Like;

@Mapper
public interface LikeDao {

	Like getLikeTotleCount(@Param("id") Integer id);

	void doLike(Map<String, Object> param);

	Like getLike(@Param("id") Integer id);

	Like getLikeByArticle(@Param("id") Integer id);

	int getLikeTotleCountByArticle(@Param("id") Integer id);

	Like getLikeByMemberId(@Param("id")int id);

	Like totleCountLikeByArticle();

	void delete(@Param("id") Integer id);

}
