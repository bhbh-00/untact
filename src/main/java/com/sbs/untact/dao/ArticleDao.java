package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Board;

@Mapper
public interface ArticleDao {
	// interface에서는 public 필요없음!

	void modify(Map<String, Object> param);

	void delete(@Param("id") Integer id);

	Article getArticle(@Param("id") Integer id);

	void add(Map<String, Object> param);

	List<Article> getArticles(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

	Article getForPrintArticle(@Param("id") Integer id);

	List<Article> getForPrintArticles(@Param("boardId") int boardId,
			@Param("searchKeywordType") String searchKeywordType, @Param("searchKeyword") String searchKeyword,
			@Param("limitStart") int limitStart, @Param("limitTake") int limitTake);

	Board getBoard(int boardId);

	int getArticlesTotleCount(@Param("boardId") int boardId, @Param("searchKeywordType") String searchKeywordType, @Param("searchKeyword") String searchKeyword);

	List<Article> getForPrintArticleByMemberId(@Param("id") int id);

	List<Article> getForPrintArticlesByMyList(@Param("id") int id, @Param("boardId") int boardId,
			@Param("searchKeywordType") String searchKeywordType, @Param("searchKeyword") String searchKeyword,
			@Param("limitStart") int limitStart, @Param("limitTake") int limitTake);

	int getArticlesTotleCountByMyList(@Param("id") int id, @Param("boardId") int boardId, @Param("searchKeywordType") String searchKeywordType, @Param("searchKeyword") String searchKeyword);

	List<Article> getLatestArticleByBoardNameFree();

	List<Article> getLatestArticleByBoardNameNotice();

	Article getArticleByReply(@Param("id") Integer id);

}
