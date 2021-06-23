package com.sbs.untact.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.service.LikeService;
import com.sbs.untact.util.Util;

@Controller
public class AdmLikeController extends BaseController {
	@Autowired
	private ArticleService articleService;
	@Autowired
	private LikeService likeService;

	@RequestMapping("/adm/like/doDelete")
	@ResponseBody
	public String doDelete(Integer id, HttpServletRequest req, String redirectUrl) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (id == null) {
			return msgAndBack(req, "id를 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
		}

		req.setAttribute("loginedMember", loginedMember);

		ResultData dodeleteRd = likeService.delete(id);
		
		redirectUrl = "../article/detail?id=" + article.getId();
		
		return Util.msgAndReplace(dodeleteRd.getMsg(), redirectUrl);
	}

	@RequestMapping("/adm/like/doLike")
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
