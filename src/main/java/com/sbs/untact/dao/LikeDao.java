package com.sbs.untact.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Like;

@Mapper
public interface LikeDao {

	// 좋아요
	void doLike(Map<String, Object> param);

	// 좋아요 갯수
	Like getLikeTotleCount(@Param("id") Integer id);

	// 해당 게시물의 좋아요
	Like getLikeByArticle(@Param("id") Integer id);

	// 해당 게시물의 좋아요 갯수
	int getLikeTotleCountByArticle(@Param("id") Integer id);

	Like getLike(@Param("id") Integer id);

	Like getLikeByMemberId(@Param("id") int id);

	Like totleCountLikeByArticle();

	// 좋아요 해제
	void delete(@Param("id") Integer id);

}
