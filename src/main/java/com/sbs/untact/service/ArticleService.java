package com.sbs.untact.service;

import java.util.ArrayList;
import java.util.List;

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

	public ResultData doModify(int id, String title, String body) {
		articleDao.doModify(id, title, body);
		
		return new ResultData("s-1", "수정완료되었습니다.", "id", id);
	}

	public ResultData deleteArticle(int id) {
		boolean rs = articleDao.deleteArticle(id);

		if (rs == false) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.", "id", id);
		}

		return new ResultData("S-1", "삭제하였습니다.", "id", id);
	}

	public Article getArticle(int id) {
		return articleDao.getArticle(id);
	}

	public ResultData doAdd(String title, String body) {
		int id = articleDao.addArticle(title, body);

		return new ResultData("s-1", "게시물이 추가되었습니다.", "id", id);
	}

	public List<Article> getArticleList(String searchKeywordType, String searchKeyword) {
		return articleDao.getArticles(searchKeywordType, searchKeyword);
	}

}
