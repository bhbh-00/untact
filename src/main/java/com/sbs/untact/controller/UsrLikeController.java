package com.sbs.untact.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Like;
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
		
		if (param.get("id") == null) {
			return msgAndBack(req, "");
		}
		
		Like existingLike = likeService.getLikeByArticle((int) param.get("id"));
		
		if (existingLike != null) {
			return msgAndBack(req, "이미 좋아요 되었습니다.");
		}
		
		if (param.get("relTypeCode") == null) {
			return msgAndBack(req, "relTypeCode를 입력해주세요.");
		}
		if (param.get("relId") == null) {
			return msgAndBack(req, "relId을 입력해주세요.");
		}
		
		Article article = articleService.getArticle((int) param.get("relId"));
		
		if (article == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
		}
		
		req.setAttribute("article", article);

		ResultData doLikeRd = likeService.doLike(param);

		return Util.msgAndReplace(doLikeRd.getMsg(), redirectUrl);
	}
}
