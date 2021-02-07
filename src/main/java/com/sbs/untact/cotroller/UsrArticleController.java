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
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.ArticleService;
import com.sbs.untact.util.Util;

@Controller
public class UsrArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	// http://localhost:8024/usr/article/doModify?id=1&title=제목4&body=내용4
	public ResultData doModify(Integer id, String title, String body, HttpSession session) {
		// String title, String body는 레퍼런스라서 입력 값?을 넣지않아도 오류 안남, null값이 들어감
		// int는 고유?타입이라서 값을 넣지않아도 null이 될 수 없음
		int loginMemberId = Util.getAsInt(session.getAttribute("loginedMemberId"), 0);
		if (loginMemberId == 0) {
			return new ResultData("F-2", "로그인 후 이용해주세요.");
		}

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

		if (loginMemberId == 0) {
			return new ResultData("F-2", "로그인 후 이용해주세요.");
		}

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
		if (loginMemberId == 0) {
			return new ResultData("F-2", "로그인 후 이용해주세요.");
		}

		if (param.get("title") == null) {
			return new ResultData("F-1", "제목을 입력해주세요.");
		}

		if (param.get("body") == null) {
			return new ResultData("F-1", "내용을 입력해주세요.");
		}

		param.put("MemberId", loginMemberId);

		return articleService.doAdd(param);
	}

	@RequestMapping("/usr/article/detail")
	@ResponseBody
	// http://localhost:8024/usr/article/detail
	public ResultData showDetail(Integer id) {	
		if (id  == null) {
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
	// http://localhost:8024
	public List<Article> showList(String searchKeywordType, String searchKeyword) {
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
		} // 불필요한 뛰어쓰기 같은거는 필터링하고 검색

		if (searchKeyword == null) {
			searchKeywordType = null;
		}

		return articleService.getForPrintArticleList(searchKeywordType, searchKeyword);
	}

}
