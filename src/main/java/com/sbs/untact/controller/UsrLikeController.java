package com.sbs.untact.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.Like;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.service.LikeService;
import com.sbs.untact.util.Util;

@Controller
public class UsrLikeController extends BaseController {
	@Autowired
	private ArticleService articleService;
	@Autowired
	private LikeService likeService;

	@RequestMapping("/usr/article/deleteLike")
	@ResponseBody
	public ResultData doDeleteLike(Integer id, HttpServletRequest req) {

		if (id == null) {
			return new ResultData("F-1", "id를 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		return likeService.deleteLike(id);
	}

	@RequestMapping("/usr/like/doLike")
	@ResponseBody
	public String doLike(@RequestParam Map<String, Object> param, HttpServletRequest req, String redirectUrl) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (param.get("relTypeCode") == "article") {
			Article articleid = articleService.getArticle((int) param.get("relId"));

			if (articleid == null) {
				return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
			}

			if (param.get("relTypeCode") == null) {
				return msgAndBack(req, "relTypeCode를 입력해주세요.");
			}

		}
		
		req.setAttribute("loginedMember", loginedMember);

		ResultData doLikeRd = likeService.doLike(param);

		return Util.msgAndReplace(doLikeRd.getMsg(), redirectUrl);
	}
}
