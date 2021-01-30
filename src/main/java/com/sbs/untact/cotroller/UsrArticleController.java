package com.sbs.untact.cotroller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.util.Util;

@Controller
public class UsrArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public ResultData doModify(int id, String title, String body) {
		Article article = articleService.getArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		return articleService.doModify(id, title, body);
	}

	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	// http://localhost:8024
	public ResultData doDelete(int id) {
		Article article = articleService.getArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}
		return articleService.deleteArticle(id);
	}

	@RequestMapping("/usr/article/doAdd")
	@ResponseBody
	// http://localhost:8024/usr/article/doAdd?title=제목4&body=내용4
	public ResultData doAdd(String title, String body) {

		if (title != null) {
			return new ResultData("F-1", "제목을 입력해주세요.");
		}

		if (body != null) {
			return new ResultData("F-1", "내용을 입력해주세요.");
		}

		return articleService.doAdd(title, body);
	}

	@RequestMapping("/usr/article/detail")
	@ResponseBody
	// http://localhost:8024
	public Article showDetail(int id) {
		
		Article article = articleService.getArticle(id);
		return article;
	}

	@RequestMapping("/usr/article/list")
	@ResponseBody
	// http://localhost:8024
	public List<Article> showList() {

		return articleService.getArticleList();
	}

}
