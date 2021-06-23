package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Board;

@Mapper
public interface BoardDao {

	Board getBoard(@Param("id") int id);

	List<Board> getForPrintBoards(Map<String, Object> param);

	Board getForPrintBoard(@Param("id") int id);

	int getBoardsTotleCount(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

	void add(Map<String, Object> param);

	void modify(Map<String, Object> param);

	Board getBoardByName(@Param("name") String name);

	void delete(@Param("id") int id);

	Board getBoardByCode(@Param("code") String code);

}
