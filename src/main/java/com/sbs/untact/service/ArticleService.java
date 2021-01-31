package com.sbs.untact.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class ArticleService {

	private int articleLastId;
	private List<Article> articles;

	public ArticleService() {
		// 멤버변수 초기화
		articleLastId = 0;
		articles = new ArrayList<>();

		articles.add(new Article(++articleLastId, "2021-12-12 12:12:12", "2021-12-12 12:13:13", "제목1", "내용1"));
		articles.add(new Article(++articleLastId, "2021-12-12 12:12:12", "2021-12-12 12:13:13", "제목2", "내용2"));
		articles.add(new Article(++articleLastId, "2021-12-12 12:12:12", "2021-12-12 12:13:13", "제목3", "내용3"));
		// ++articleLastId => 0에서 ++
	}

	public ResultData doModify(int id, String title, String body) {
		Article article = getArticle(id);

		article.setBody(body);
		article.setTitle(title);
		article.setUpdateDate(Util.getCurrenDate());

		return new ResultData("s-1", "수정완료되었습니다.", "id", id);
	}

	public ResultData deleteArticle(int id) {
		for (Article article : articles) {
			if (article.getId() == id) {
				articles.remove(id);
				new ResultData("s-1", "삭제완료되었습니다.", "id", id);
			}
		}

		return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.", "id", id);
	}

	public Article getArticle(int id) {
		for (Article article : articles) {
			if (article.getId() == id) {
				return article;
			}
		}

		return null;
	}

	public ResultData doAdd(String title, String body) {
		int id = ++articleLastId;
		String regDate = Util.getCurrenDate();
		String updateDate = regDate;

		articles.add(new Article(id, regDate, updateDate, title, body));

		return new ResultData("s-1", "게시물이 추가되었습니다.", "id", id);
	}

	public List<Article> getArticleList(String searchKeywordType, String searchKeyword) {
		if (searchKeyword == null) {
			return articles;
		}

		List<Article> filtered = new ArrayList<>();

		for (Article article : articles) {
			boolean contains = false;

			if (searchKeywordType.equals("title")) {
				contains = article.getTitle().contains(searchKeyword);
			} else if (searchKeywordType.equals("body")) {
				contains = article.getBody().contains(searchKeyword);
			} else {
				contains = article.getTitle().contains(searchKeyword);

				if (contains == false) {
					contains = article.getBody().contains(searchKeyword);
				}
			}

			if (contains) {
				filtered.add(article);
			}
		}

		return filtered;
	}

}
