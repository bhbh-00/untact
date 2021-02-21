package com.sbs.untact.cotroller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.Reply;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.util.Util;

@Controller
public class UsrArticleController {
	@Autowired
	private ArticleService articleService;
	
	// =================================================== 댓글
	@RequestMapping("/usr/article/doDeleteReply")
	@ResponseBody
	// http://localhost:8024/usr/article/doDeleteReply?articleId=1&replyId=1
	public ResultData doDeleteReply(Integer articleId, Integer replyId, HttpSession session) {
		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);

		if (articleId == null) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}

		Article article = articleService.getArticle(articleId);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}
		
		if (replyId == null) {
			return new ResultData("F-1", "댓글 번호를 입력해주세요.");
		}

		Reply reply = articleService.getReply(replyId);

		if (reply == null) {
			return new ResultData("F-1", "해당 댓글은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = articleService.getActorCanDelete(article, loginMemberId);

		if (actorCanDeleteRd.isFail()) {
			return actorCanDeleteRd;
		}

		return articleService.deleteReply(articleId, replyId);
	}

	@RequestMapping("/usr/article/replies")
	@ResponseBody
	// http://localhost:8024/usr/article/replies
	public ResultData showReplies(Integer articleId, HttpSession session) {
		/* 선생님 -> 로그인 없이 댓글을 볼 수 있게 함
		 * 댓글 페이징까지!
		 * 댓글 전용 컨트롤러 따로 만들기!
		 * 댓글이 꼭 게시물에만 달 수 있는게 아니라 서비스 전체에 달 수 있게 끔 해준다. -> relTypeCode와 relId추가
		 * sql 쿼리 수정
		 * sql 인덱스 걸기 -> 순서 중요!
		 * beforeActionInterceptor에 로그인 없이 할 수 있게 수정 */

		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);
		
		if (articleId == null) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}
		
		Article article = articleService.getArticle(articleId);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}
		
		List<Reply> replies = articleService.getForPrintReplies(articleId);

		return new ResultData("S-1", "성공", "replies", replies);
	}

	@RequestMapping("/usr/article/doModifyReply")
	@ResponseBody
	// http://localhost:8024/usr/article/doModifyReply?articleId=1&body=새로운 댓글입니다!
	public ResultData doModifyReply(Integer articleId, String body, HttpSession session) {
		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);

		if (articleId == null) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}

		if (body == null) {
			return new ResultData("F-1", "내용을 입력해주세요.");
		}

		Article article = articleService.getArticle(articleId);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanModifyRd = articleService.getActorCanModify(article, loginMemberId);

		if (actorCanModifyRd.isFail()) {
			return actorCanModifyRd;
		}

		return articleService.doModifyReply(articleId, body);
	}

	@RequestMapping("/usr/article/doAddReply")
	@ResponseBody
	// http://localhost:8024/usr/article/doAddReply?articleId=댓글1
	public ResultData AddReply(@RequestParam Map<String, Object> param, HttpSession session) {
		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);

		if (param.get("articleId") == null) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}

		if (param.get("body") == null) {
			return new ResultData("F-1", "댓글을 입력해주세요.");
		}

		param.put("memberId", loginMemberId);

		return articleService.AddReply(param);
	}
	
	// =================================================== 게시물
	
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	// http://localhost:8024/usr/article/doModify?id=1&title=제목4&body=내용4
	public ResultData doModify(Integer id, String title, String body, HttpSession session) {
		// String title, String body는 레퍼런스라서 입력 값?을 넣지않아도 오류 안남, null값이 들어감
		// int는 고유?타입이라서 값을 넣지않아도 null이 될 수 없음
		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);

		if (id == null) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}

		if (title == null) {
			return new ResultData("F-1", "제목을 입력해주세요.");
		}

		if (body == null) {
			return new ResultData("F-1", "내용을 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanModifyRd = articleService.getActorCanModify(article, loginMemberId);

		if (actorCanModifyRd.isFail()) {
			return actorCanModifyRd;
		}

		return articleService.doModify(id, title, body);
	}

	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	// http://localhost:8024/usr/article/doDelete
	public ResultData doDelete(Integer id, HttpSession session) {
		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);

		if (id == null) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = articleService.getActorCanDelete(article, loginMemberId);

		if (actorCanDeleteRd.isFail()) {
			return actorCanDeleteRd;
		}

		return articleService.deleteArticle(id);
	}

	@RequestMapping("/usr/article/doAdd")
	@ResponseBody
	// http://localhost:8024/usr/article/doAdd?title=제목4&body=내용4
	public ResultData doAdd(@RequestParam Map<String, Object> param, HttpSession session) {
		// String title, String body이 null이면 내용이 없는 거!!
		
		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);

		if (param.get("title") == null) {
			return new ResultData("F-1", "제목을 입력해주세요.");
		}

		if (param.get("body") == null) {
			return new ResultData("F-1", "내용을 입력해주세요.");
		}
		
		param.put("memberId", loginMemberId);

		return articleService.doAdd(param);
		
		/* 0221 코멘트 
		 * 게시물 추가를 할 때 boardId도 추가를 해주어야지 오류가 발생하지 않음!
		 * 그에 대한 해결책을 적용해서 만들기! */
		
	}

	@RequestMapping("/usr/article/detail")
	@ResponseBody
	// http://localhost:8024/usr/article/detail
	public ResultData showDetail(Integer id) {
		if (id == null) {
			return new ResultData("F-1", "제목을 입력해주세요.");
		}

		Article article = articleService.getForPrintArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		return new ResultData("S-1", "게시물을 상세보기 입니다.", "article", article);
	}

	@RequestMapping("/usr/article/list")
	@ResponseBody
	// http://localhost:8024/usr/article/list
	public ResultData showList(@RequestParam(defaultValue = "1") int boardId, String searchKeywordType,
			String searchKeyword, @RequestParam(defaultValue = "1") int page) {
		// @RequestParam(defaultValue = "1") -> page를 입력하지 않아도 1page가 되도록
		
		Board board = articleService.getBoard(boardId);
		
		if (board == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}
		
		if (searchKeywordType != null) {
			searchKeywordType = searchKeywordType.trim();
		}

		if (searchKeywordType == null || searchKeywordType.length() == 0) {
			searchKeywordType = "titleAndBody";
		}

		if (searchKeyword != null && searchKeyword.length() == 0) {
			searchKeyword = null;
		}

		if (searchKeyword != null) {
			searchKeyword = searchKeyword.trim();
		}

		if (searchKeyword == null) {
			searchKeywordType = null;
		}

		int itemsInAPage = 20;
		// 한 페이지에 포함 되는 게시물의 갯수

		List<Article> articles = articleService.getForPrintArticles(boardId, searchKeywordType, searchKeyword, page,
				itemsInAPage);

		return new ResultData("S-1", "성공", "articles", articles);
	}

}
