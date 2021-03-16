package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.ResultData;

@Mapper
public interface BoardDao {

	Board getBoard(@Param("id") int id);

	List<Board> getForPrintBoards(Map<String, Object> param);

	Board getForPrintBoard(@Param("id") int id);

	int getBoardsTotleCount(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

	void addBoard(Map<String, Object> param);

	void modifyBoard(Map<String, Object> param);

	Board getBoardByName(@Param("name") String name);

	void deleteBoard(@Param("id") int id);

}
