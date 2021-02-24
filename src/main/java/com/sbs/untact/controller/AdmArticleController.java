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
import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;

@Controller
public class AdmArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/adm/article/doModify")
	@ResponseBody
	public ResultData doModify(Integer id, String title, String body, HttpServletRequest req) {
		// String title, String body는 레퍼런스라서 입력 값?을 넣지않아도 오류 안남, null값이 들어감
		// int는 고유?타입이라서 값을 넣지않아도 null이 될 수 없음
		int loginMemberId = (int)req.getAttribute("loginedMemberId");

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

	@RequestMapping("/adm/article/doDelete")
	@ResponseBody
	public ResultData doDelete(Integer id, HttpServletRequest req) {
		int loginMemberId = (int) req.getAttribute("loginedMemberId");

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

	@RequestMapping("/adm/article/doAdd")
	@ResponseBody
	public ResultData doAdd(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		// String title, String body이 null이면 내용이 없는 거!!
		int loginMemberId = (int) req.getAttribute("loginedMemberId");
		/*
		 * HttpSession 말고 Http서블릿리쿼스트 req로 바꿔주기 Util.getAsInt 필요 없음 (int로 형변환 필요함)
		 * !!로그인과 회원가입은 세션이 필요함
		 */

		if (param.get("title") == null) {
			return new ResultData("F-1", "제목을 입력해주세요.");
		}

		if (param.get("body") == null) {
			return new ResultData("F-1", "내용을 입력해주세요.");
		}

		param.put("memberId", loginMemberId);

		return articleService.doAdd(param);

		/*
		 * 0221 코멘트 게시물 추가를 할 때 boardId도 추가를 해주어야지 오류가 발생하지 않음! 그에 대한 해결책을 적용해서 만들기!
		 */

	}

	@RequestMapping("/adm/article/detail")
	@ResponseBody
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

	@RequestMapping("/adm/article/list")
	@ResponseBody
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
