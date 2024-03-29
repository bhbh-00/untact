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
import com.sbs.untact.dto.Like;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.Reply;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.service.GenFileService;
import com.sbs.untact.service.LikeService;
import com.sbs.untact.service.ReplyService;
import com.sbs.untact.util.Util;

@Controller
public class UsrArticleController extends BaseController {
	@Autowired
	private ArticleService articleService;

	@Autowired
	private GenFileService genFileService;

	@Autowired
	private LikeService likeService;

	@Autowired
	private ReplyService replyService;
	
	// 게시물 수정
	@RequestMapping("/usr/article/modify")
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

		return "/usr/article/modify";
	}
	
	// 게시물 수정
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String doModify(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		int id = Util.getAsInt(param.get("id"), 0);

		if (id == 0) {
			return msgAndBack(req, "게시물 번호를 입력해주세요.");
		}

		if (Util.isEmpty(param.get("title"))) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		if (Util.isEmpty(param.get("body"))) {
			return msgAndBack(req, "내용을 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanModifyRd = articleService.getActorCanModifyRd(article, loginedMember);

		if (actorCanModifyRd.isFail()) {
			return Util.msgAndReplace(actorCanModifyRd.getMsg(), "../article/detail?id=" + article.getId());
		}

		ResultData modifyArticleRd = articleService.modify(param);

		String redirectUrl = "../article/detail?id=" + article.getId();

		return Util.msgAndReplace(modifyArticleRd.getMsg(), redirectUrl);
	}
	
	// 게시물 삭제
	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(Integer id, HttpServletRequest req) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (id == null) {
			return msgAndBack(req, "id를 입력해주세요.");
		}

		Article article = articleService.getArticle(id);

		if (article == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanDeleteRd = articleService.getActorCanDeleteRd(article, loginedMember);

		if (actorCanDeleteRd.isFail()) {
			return Util.msgAndReplace(actorCanDeleteRd.getMsg(), "../article/detail?id=" + article.getId());
		}

		ResultData deleteArticleRd = articleService.delete(id);
		String redirectUrl = "../article/list";

		return Util.msgAndReplace(deleteArticleRd.getMsg(), redirectUrl);
	}

	@RequestMapping("/usr/article/add")
	public String ShowAdd(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		return "/usr/article/add";
	}

	// 게시물 작성
	@RequestMapping("/usr/article/doAdd")
	public String doAdd(@RequestParam Map<String, Object> param, HttpServletRequest req,
			MultipartRequest multipartRequest) {

		int loginMemberId = (int) req.getAttribute("loginedMemberId");

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

	// 게시물 상세 페이지
	@RequestMapping("/usr/article/detail")
	public String showDetail(HttpServletRequest req, Integer id) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

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
		
		// 좋아요
		Like like = likeService.getLikeByArticle(id);
		
		// 좋아요 갯수
		int totleItemsCountByLike = likeService.getLikeTotleCountByArticle(id);
		
		// 댓글 리스트
		List<Reply> replys = replyService.getForPrintReplies(id);

		article.getExtraNotNull().put("file__common__attachment", filesMap);
		req.setAttribute("article", article);
		req.setAttribute("replys", replys);
		req.setAttribute("like", like);
		req.setAttribute("totleItemsCountByLike", totleItemsCountByLike);
		req.setAttribute("loginedMember", loginedMember);

		return "/usr/article/detail";
	}

	// 내 게시물 보기
	@RequestMapping("/usr/article/myList")
	public String showMyList(HttpServletRequest req, @RequestParam(defaultValue = "1") int boardId,
			String searchKeywordType, String searchKeyword, @RequestParam(defaultValue = "1") int page) {

		int loginMemberId = (int) req.getAttribute("loginedMemberId");

		Board board = articleService.getBoard(boardId);

		req.setAttribute("board", board);

		if (board == null) {
			return msgAndBack(req, "해당 게시물은 존재하지 않습니다.");
		}

		List<Article> articles = articleService.getForPrintArticleByMemberId(loginMemberId);

		// 한 페이지에 포함 되는 게시물의 갯수
		int itemsInAPage = 20;

		// 총 게시물의 갯수를 구하는
		int totleItemsCount = articleService.getArticlesTotleCountByMyList(loginMemberId, boardId, searchKeywordType,
				searchKeyword);

		articles = articleService.getForPrintArticlesByMyList(loginMemberId, boardId, searchKeywordType, searchKeyword,
				page, itemsInAPage);

		// 총 페이지 갯수 (총 게시물 수 / 한 페이지 안의 게시물 갯수)
		int totlePage = (int) Math.ceil(totleItemsCount / (double) itemsInAPage);

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

		// req.setAttribute( "" , ) -> 이게 있어야지 jsp에서 뜸!
		req.setAttribute("totleItemsCount", totleItemsCount);
		req.setAttribute("totlePage", totlePage);
		req.setAttribute("pageMenuArmSize", pageMenuArmSize);
		req.setAttribute("pageMenuStrat", pageMenuStrat);
		req.setAttribute("pageMenuEnd", pageMenuEnd);
		req.setAttribute("page", page);
		req.setAttribute("articles", articles);

		return "/usr/article/myList";
	}

	// 게시물 리스트
	@RequestMapping("/usr/article/list")
	public String showList(HttpServletRequest req, @RequestParam(defaultValue = "1") int boardId,
			String searchKeywordType, String searchKeyword, @RequestParam(defaultValue = "1") int page) {

		int loginMemberId = (int) req.getAttribute("loginedMemberId");

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
		int itemsInAPage = 20;

		// 총 게시물의 갯수를 구하는
		int totleItemsCount = articleService.getArticlesTotleCount(boardId, searchKeywordType, searchKeyword);

		List<Article> articles = articleService.getForPrintArticles(boardId, searchKeywordType, searchKeyword, page,
				itemsInAPage);

		// 총 페이지 갯수 (총 게시물 수 / 한 페이지 안의 게시물 갯수)
		int totlePage = (int) Math.ceil(totleItemsCount / (double) itemsInAPage);
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

		req.setAttribute("totleItemsCount", totleItemsCount);
		req.setAttribute("totlePage", totlePage);
		req.setAttribute("pageMenuArmSize", pageMenuArmSize);
		req.setAttribute("pageMenuStrat", pageMenuStrat);
		req.setAttribute("pageMenuEnd", pageMenuEnd);
		req.setAttribute("page", page);
		req.setAttribute("articles", articles);
		req.setAttribute("loginMemberId", loginMemberId);

		return "/usr/article/list";
	}

}
