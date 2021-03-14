package com.sbs.untact.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartRequest;

import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.GenFile;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.service.GenFileService;
import com.sbs.untact.util.Util;

@Controller
public class AdmArticleController extends BaseController {
	@Autowired
	private ArticleService articleService;
	@Autowired
	private GenFileService genFileService;

	@RequestMapping("/adm/article/modify")
	public String ShowModify(Integer id, HttpServletRequest req) {

		if (id == null) {
			return msgAndBack(req, "게시물 번호를 입력해주세요.");
		}

		Article article = articleService.getForPrintArticle(id);

		if (article == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
		}

		List<GenFile> files = genFileService.getGenFiles("article", article.getId(), "common", "attachment");

		Map<String, GenFile> filesMap = new HashMap<>();

		for (GenFile file : files) {
			filesMap.put(file.getFileNo() + "", file);
		}

		article.getExtraNotNull().put("file__common__attachment", filesMap);
		req.setAttribute("article", article);

		return "/adm/article/modify";
	}

	@RequestMapping("/adm/article/doModify")
	@ResponseBody
	public ResultData doModify(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		// String title, String body는 레퍼런스라서 입력 값?을 넣지않아도 오류 안남, null값이 들어감
		// int는 고유?타입이라서 값을 넣지않아도 null이 될 수 없음
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		int id = Util.getAsInt(param.get("id"), 0);

		if (id == 0) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}

		if (Util.isEmpty(param.get("title"))) {
			return new ResultData("F-1", "제목을 입력해주세요.");
		}

		if (Util.isEmpty(param.get("body"))) {
			return new ResultData("F-1", "내용을 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanModifyRd = articleService.getActorCanModifyRd(article, loginedMember);

		if (actorCanModifyRd.isFail()) {
			return actorCanModifyRd;
		}

		return articleService.modifyArticle(param);
	}

	@RequestMapping("/adm/article/doDelete")
	@ResponseBody
	public ResultData doDelete(Integer id, HttpServletRequest req) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (id == null) {
			return new ResultData("F-1", "id를 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = articleService.getActorCanDeleteRd(article, loginedMember);

		if (actorCanDeleteRd.isFail()) {
			return actorCanDeleteRd;
		}

		return articleService.deleteArticle(id);
	}

	@RequestMapping("/adm/article/add")
	public String ShowAdd(@RequestParam Map<String, Object> param, HttpServletRequest req) {

		return "/adm/article/add";

	}

	@RequestMapping("/adm/article/doAdd")
	public String doAdd(@RequestParam Map<String, Object> param, HttpServletRequest req,
			MultipartRequest multipartRequest) {
		// String title, String body이 null이면 내용이 없는 거!!

		int loginMemberId = (int) req.getAttribute("loginedMemberId");
		/*
		 * HttpSession 말고 Http서블릿리쿼스트 req로 바꿔주기 Util.getAsInt 필요 없음 (int로 형변환 필요함)
		 * !!로그인과 회원가입은 세션이 필요함
		 */

		if (param.get("title") == null) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		if (param.get("body") == null) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		param.put("memberId", loginMemberId);

		ResultData addArticleRd = articleService.doAdd(param);

		int newArticleId = (int) addArticleRd.getBody().get("id");

		return msgAndReplace(req, String.format("%d번 게시물이 작성되었습니다.", newArticleId),
				"../article/detail?id=" + newArticleId);
	}

	@RequestMapping("/adm/article/detail")
	public String showDetail(HttpServletRequest req, Integer id) {
		if (id == null) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		Article article = articleService.getForPrintArticle(id);

		if (article == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
		}

		req.setAttribute("article", article);
		
		// 수정을 응용

		return "/adm/article/detail";
	}

	@RequestMapping("/adm/article/list")
	// @ResponseBody가 없으면 return /adm/article/list.jps로 가야함
	public String showList(HttpServletRequest req, @RequestParam(defaultValue = "1") int boardId,
			String searchKeywordType, String searchKeyword, @RequestParam(defaultValue = "1") int page) {
		// @RequestParam(defaultValue = "1") -> page를 입력하지 않아도 1page가 되도록

		Board board = articleService.getBoard(boardId);

		req.setAttribute("board", board);

		if (board == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
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

		// 한 페이지에 포함 되는 게시물의 갯수
		int itemsInAPage = 30;

		// 총 게시물의 갯수를 구하는
		int totleItemsCount = articleService.getArticlesTotleCount(boardId, searchKeywordType, searchKeyword);

		List<Article> articles = articleService.getForPrintArticles(boardId, searchKeywordType, searchKeyword, page,
				itemsInAPage);

		// 총 페이지 갯수 (총 게시물 수 / 한 페이지 안의 게시물 갯수)
		int totlePage = (int)Math.ceil(totleItemsCount / (double) itemsInAPage);

		/*
		 * 반지름이라고 생각하면 됌. 현재 페이지가 10일 때 pageMenuArmSize가 5이면 10을 기준으로 왼쪽은 4 5 6 7 8 9 10
		 * 오른쪽은 10 11 12 13 14 15 16 페이지네이션의 총 갯수는 11 (기준인 10도 포함 해야함)
		 */
		int pageMenuArmSize = 5;

		// 시작 페이지 번호
		int pageMenuStrat = page - pageMenuArmSize;

		// 시작 페이지가 1보다 작다면 시작 페이지는 1
		if (pageMenuStrat < 1) {
			pageMenuStrat = 1;
		}

		// 끝 페이지 페이지 번호
		int pageMenuEnd = page + pageMenuArmSize;

		if (pageMenuEnd > totlePage) {
			pageMenuEnd = totlePage;
		}

		// req.setAttribute( "" ,  ) -> 이게 있어야지 jsp에서 뜸!
		req.setAttribute("totleItemsCount", totleItemsCount);
		req.setAttribute("totlePage", totlePage);
		req.setAttribute("pageMenuArmSize", pageMenuArmSize);
		req.setAttribute("pageMenuStrat", pageMenuStrat);
		req.setAttribute("pageMenuEnd", pageMenuEnd);
		req.setAttribute("page", page);
		req.setAttribute("articles", articles);

		return "/adm/article/list";
	}

}
