package com.sbs.untact.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Like;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.service.LikeService;

@Controller
public class UsrHomeController extends BaseController {
	@Autowired
	private ArticleService articleService;
	@Autowired
	private LikeService likeService;

	@RequestMapping("/usr/home/main")
	public String showMain(HttpServletRequest req) {

		// 가장 최신 자유 게시물 1개
		Article LatestArticleByBoardNameFree = articleService.getLatestArticleByBoardNameFree();

		// 가장 최신 공지사항 게시물 1개
		Article LatestArticleByBoardNameNotice = articleService.getLatestArticleByBoardNameNotice();
		
		// 좋아요 많은 게시물
		Like totleCountLikeByArticle = likeService.totleCountLikeByArticle();

		req.setAttribute("LatestArticleByBoardNameFree", LatestArticleByBoardNameFree);
		req.setAttribute("LatestArticleByBoardNameNotice", LatestArticleByBoardNameNotice);
		req.setAttribute("totleCountLikeByArticle", totleCountLikeByArticle);
		
		return "/usr/home/main";
	}
}
