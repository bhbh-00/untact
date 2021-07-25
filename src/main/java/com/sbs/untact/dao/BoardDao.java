package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Board;

@Mapper
public interface BoardDao {

	// 게시판 수정
	void modify(Map<String, Object> param);

	// 게시판 리스트
	List<Board> getForPrintBoards(Map<String, Object> param);

	// 게시판의 총 갯수
	int getBoardsTotleCount(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

	// 게시판 번호로 정보 불러오기
	Board getForPrintBoard(@Param("id") int id);

	// 게시판 생성
	void add(Map<String, Object> param);

	// 기존의 이름 확인
	Board getBoardByName(@Param("name") String name);

	// 기존의 코드 확인
	Board getBoardByCode(@Param("code") String code);

	// 게시판 삭제
	void delete(@Param("id") int id);

	// 게시판 번호 확인
	Board getBoard(@Param("id") int id);

}
