package com.sbs.untact.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Reply;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.service.ReplyService;

@Controller
public class AdmReplyController {
	@Autowired
	private ReplyService replyService;
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/adm/reply/doDelete")
	@ResponseBody
	public ResultData doDelete(Integer id, HttpServletRequest req) {
		int loginedMemberId = (int)req.getAttribute("loginedMemberId");

		// 선생님은 replyId로만!
		if (id == null) {
			return new ResultData("F-1", "댓글 번호를 입력해주세요.");
		}

		Reply reply = replyService.getReply(id);

		if (reply == null) {
			return new ResultData("F-1", "해당 댓글은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = replyService.getActorCanDeleteRd(reply, loginedMemberId);
		// articleService 말고 이제는 reply서비스에게!

		if (actorCanDeleteRd.isFail()) {
			return actorCanDeleteRd;
		}

		return replyService.delete(id);
	}

	@RequestMapping("/adm/reply/doModify")
	@ResponseBody
	public ResultData doModify(Integer id, String body, HttpServletRequest req) {
		int loginedMemberId = (int)req.getAttribute("loginedMemberId");

		// 선생님은 replyId로만!
		if (id == null) {
			return new ResultData("F-1", "댓글 번호를 입력해주세요.");
		}

		Reply reply = replyService.getReply(id);

		if (reply == null) {
			return new ResultData("F-1", "해당 댓글은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = replyService.getActorCanModifyRd(reply, loginedMemberId);
		// articleService 말고 이제는 reply서비스에게!

		if (actorCanDeleteRd.isFail()) {
			return actorCanDeleteRd;
		}

		return replyService.doModify(id, body);
	}

	@RequestMapping("/adm/reply/doAdd")
	@ResponseBody
	public ResultData doAdd(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		int loginMemberId = (int) req.getAttribute("loginedMemberId");

		if (param.get("relTypeCode") == null) {
			return new ResultData("F-1", "relTypeCode를 입력해주세요.");
		}
		if (param.get("relId") == null) {
			return new ResultData("F-1", "relId을 입력해주세요.");
		}

		/*
		 * if (param.get("relTypeCode") == "article") { Article article =
		 * articleService.getArticle(param.get("relId"));
		 * 
		 * if (article == null) { return new ResultData("F-1", "해당 게시물은 존재하지 않습니다."); }
		 * 
		 * }
		 */

		if (param.get("body") == null) {
			return new ResultData("F-1", "댓글을 입력해주세요.");
		}

		param.put("memberId", loginMemberId);

		return replyService.doAdd(param);
	}

	@RequestMapping("/adm/reply/list")
	@ResponseBody
	public ResultData showList(String relTypeCode, Integer relId) {
		/*
		 * 선생님 -> 로그인 없이 댓글을 볼 수 있게 함 댓글 페이징까지! 댓글 전용 컨트롤러 따로 만들기! 댓글이 꼭 게시물에만 달 수 있는게
		 * 아니라 서비스 전체에 달 수 있게 끔 해준다. -> relTypeCode와 relId추가 sql 쿼리 수정 sql 인덱스 걸기 -> 순서
		 * 중요! beforeActionInterceptor에 로그인 없이 할 수 있게 수정
		 */

		// relId는 게시물의 번호
		if (relTypeCode == null) {
			return new ResultData("F-1", "relTypeCode를 입력해주세요.");
		}

		if (relId == null) {
			return new ResultData("F-1", "댓글 번호를 입력해주세요.");
		}

		if (relTypeCode.equals("article")) {
			Article article = articleService.getArticle(relId);

			if (article == null) {
				return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
			}
		}

		List<Reply> replies = replyService.getForPrintReplies(relId);

		return new ResultData("S-1", "성공", "replies", replies);
	}

}
