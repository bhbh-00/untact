package com.sbs.untact.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Like;

@Mapper
public interface LikeDao {

	void deleteLike(@Param("id") Integer id);

	Like getLikeTotleCount(@Param("id") Integer id);

	void addLike(Map<String, Object> param);

	Like getLike(@Param("id")Integer id);
}
