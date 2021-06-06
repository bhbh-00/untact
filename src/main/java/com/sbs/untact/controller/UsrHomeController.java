package com.sbs.untact.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sbs.untact.dto.Article;
import com.sbs.untact.service.ArticleService;

@Controller
public class UsrHomeController extends BaseController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/home/main")
	public String showMain(HttpServletRequest req) {

		// 가장 최신 자유 게시물 1개
		List<Article> LatestArticleByBoardNameFree = articleService.getLatestArticleByBoardNameFree();

		// 가장 최신 공지사항 게시물 1개
		List<Article> LatestArticleByBoardNameNotice = articleService.getLatestArticleByBoardNameNotice();

		req.setAttribute("LatestArticleByBoardNameFree", LatestArticleByBoardNameFree);
		req.setAttribute("LatestArticleByBoardNameNotice", LatestArticleByBoardNameNotice);

		return "/usr/home/main";
	}
}
