package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.Reply;

@Mapper
public interface ArticleDao {

	public void doModify(@Param("id") Integer id, @Param("title") String title, @Param("body") String body);

	public void deleteArticle(@Param("id") Integer id);

	public Article getArticle(@Param("id") Integer id);

	public void addArticle(Map<String, Object> param);

	public List<Article> getArticles(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

	public Article getForPrintArticle(@Param("id") Integer id);

	public List<Article> getForPrintArticles(@Param("boardId") int boardId,
			@Param("searchKeywordType") String searchKeywordType, @Param("searchKeyword") String searchKeyword,
			@Param("limitStart") int limitStart, @Param("limitTake") int limitTake);

	public void addReply(Map<String, Object> param);

	public void doModifyReply(@Param("articleId") Integer articleId, @Param("body") String body);

	public List<Reply> getForPrintReplies(@Param("articleId") Integer articleId);

	public Board getBoard(int boardId);

	public Reply getReply(@Param("replyId") Integer replyId);

	public void deleteReply(@Param("articleId") Integer articleId, @Param("replyId") Integer replyId);

}
