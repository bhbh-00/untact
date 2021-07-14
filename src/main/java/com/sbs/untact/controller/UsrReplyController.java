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
import com.sbs.untact.dto.Reply;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.service.ReplyService;
import com.sbs.untact.util.Util;

@Controller
public class UsrReplyController extends BaseController {
	@Autowired
	private ReplyService replyService;
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/reply/doDelete")
	@ResponseBody
	public String doDelete(Integer id, HttpServletRequest req, String redirectUrl) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (id == null) {
			return msgAndBack(req, "댓글 번호를 입력해주세요.");
		}

		Reply reply = replyService.getReply(id);

		if (reply == null) {
			return msgAndBack(req, "해당 댓글은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = replyService.getActorCanDeleteRd(reply, loginedMember);
		// articleService 말고 이제는 reply서비스에게!

		if (actorCanDeleteRd.isFail()) {
			return msgAndBack(req, actorCanDeleteRd.getMsg());
		}

		ResultData deleteReplyRd = replyService.delete(id);

		return Util.msgAndReplace(deleteReplyRd.getMsg(), "../article/detail?id=" + reply.getRelId());
	}

	@RequestMapping("/usr/reply/modify")
	public String ShowModify(Integer id, HttpServletRequest req) {

		if (id == null) {
			return msgAndBack(req, "게시물 번호를 입력해주세요.");
		}
		
		Reply reply = replyService.getReply(id);

		if (reply == null) {
			return msgAndBack(req, "해당 댓글은 존재하지 않습니다.");
		}
		
		req.setAttribute("reply", reply);

		return "/usr/reply/modify";
	}

	@RequestMapping("/usr/reply/doModify")
	@ResponseBody
	public String doModify(Integer id, String body, HttpServletRequest req, String redirectUrl) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (id == null) {
			return msgAndBack(req, "게시물 번호를 입력해주세요.");
		}
		
		Reply reply = replyService.getReply(id);

		if (reply == null) {
			return msgAndBack(req, "해당 댓글은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = replyService.getActorCanModifyRd(reply, loginedMember);

		if (actorCanDeleteRd.isFail()) {
			return msgAndBack(req, actorCanDeleteRd.getMsg());
		}

		ResultData modifyReplyRd = replyService.modify(id, body);

		req.setAttribute("reply", reply);

		return Util.msgAndReplace(modifyReplyRd.getMsg(), redirectUrl);
	}

	@RequestMapping("/usr/reply/doAdd")
	@ResponseBody
	public String doReply(@RequestParam Map<String, Object> param, HttpServletRequest req, String redirectUrl) {
				
		if (param.get("relTypeCode") == "article") {
			Article article = articleService.getArticle((int) param.get("relId"));

			if (article == null) {
				return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
			}

			if (param.get("relTypeCode") == null) {
				return msgAndBack(req, "relTypeCode를 입력해주세요.");
			}

		}

		if (param.get("body") == null) {
			return msgAndBack(req, "댓글을 입력해주세요.");
		}

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		req.setAttribute("loginedMember", loginedMember);

		ResultData doAddRd = replyService.doAdd(param);

		return Util.msgAndReplace(doAddRd.getMsg(), redirectUrl);
	}

}
