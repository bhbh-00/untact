package com.sbs.untact.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.untact.dto.Article;

@Mapper
public interface ArticleDao {

	public void doModify(@Param("id") Integer id, @Param("title") String title, @Param("body") String body);

	public void deleteArticle(@Param("id") Integer id);

	public Article getArticle(@Param("id") Integer id);

	public void addArticle(Map<String, Object> param);

	public List<Article> getArticles(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword);

	public Article getForPrintArticle(@Param("id") Integer id);

	public List<Article> getForPrintArticles(@Param("searchKeywordType") String searchKeywordType,
			@Param("searchKeyword") String searchKeyword, @Param("limitStart") int limitStart,
			@Param("limitTake") int limitTake);
	// 페이징 - 시작과 끝 범위

}
