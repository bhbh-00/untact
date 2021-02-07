package com.sbs.untact.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.untact.dao.ArticleDao;
import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class ArticleService {
	@Autowired
	private ArticleDao articleDao;
	@Autowired
	private MemberService memberService;

	public ResultData doModify(int id, String title, String body) {
		articleDao.doModify(id, title, body);

		return new ResultData("s-1", "수정완료되었습니다.", "id", id);
	}

	public ResultData deleteArticle(int id) {
		articleDao.deleteArticle(id);

		return new ResultData("S-1", "삭제하였습니다.", "id", id);
	}

	public Article getArticle(int id) {
		return articleDao.getArticle(id);
	}

	public ResultData doAdd(Map<String, Object> param) {
		articleDao.addArticle(param);

		int id = Util.getAsInt(param.get("id"), 0);

		return new ResultData("s-1", "게시물이 추가되었습니다.", "id", id);
	}

	public List<Article> getArticleList(String searchKeywordType, String searchKeyword) {
		return articleDao.getArticles(searchKeywordType, searchKeyword);
	}

	public ResultData getActorCanModify(Article article, int actorId) {
		if (article.getMemberId() == actorId) {
			return new ResultData("s-1", "가능합니다.");
		}

		if (memberService.isAdmin(actorId)) {
			return new ResultData("s-1", "가능합니다.");
		}

		return new ResultData("F-1", "권한이 없습니다.");
	}

	public ResultData getActorCanDelete(Article article, int actorId) {
		return getActorCanModify(article, actorId);
	}

	public Article getForPrintArticle(Integer id) {
		return articleDao.getForPrintArticle(id);
	}

	public List<Article> getForPrintArticleList(String searchKeywordType, String searchKeyword) {
		return articleDao.getForPrintArticleList(searchKeywordType,searchKeyword);
	}

}
