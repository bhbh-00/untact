package com.sbs.untact.cotroller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;
import com.sbs.untact.util.Util;

@Controller
public class UsrArticleController {
	private int articleLastId = 0;
	private List<Article> articles;

	public UsrArticleController() {
		articles = new ArrayList<>();

		// 멤버변수 초기화
		articleLastId = 0;

		articles.add(new Article(++articleLastId, "2021-12-12 12:12:12", "2021-12-12 12:12:12", "내용1", "제목1"));
		articles.add(new Article(++articleLastId, "2021-12-12 12:12:12", "2021-12-12 12:12:12", "내용2", "제목2"));
		articles.add(new Article(++articleLastId, "2021-12-12 12:12:12", "2021-12-12 12:12:12", "내용3", "제목3"));
		// ++articleLastId => 0에서 ++
	}

	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public Map<String, Object> doModify(int id, String title, String body) {
		// 1. id 찾기 -> 반복문 돌려서 찾기
		// 2. rs 세팅
		// 3. 수정하기 setBody, setTitle에 받아서

		Article selActicle = null;

		for (Article article : articles) {
			if (article.getId() == id) {
				selActicle = article;
				break;
			}
		}

		Map<String, Object> rs = new HashMap<>();

		if (selActicle == null) {
			rs.put("resultCode", "f-1");
			rs.put("msg", String.format("%d번 해당 게시물은 존재하지 않습니다.", id));
		}

		selActicle.setUpdateDate(Util.getCurrenDate());
		selActicle.setBody(body);
		selActicle.setTitle(title);

		rs.put("resultCode", "s-1");
		rs.put("msg", String.format("%d번 게시물이 수정되었습니다.", id));
		rs.put("id", articleLastId);

		return rs;
	}

	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	// http://localhost:8024
	public Map<String, Object> doDelete(int id) {
		boolean deleteArticleRs = deleteArticle(id);

		Map<String, Object> rs = new HashMap<>();

		if (deleteArticleRs) {
			rs.put("resultCode", "s-1");
			rs.put("msg", "게시물이 취소 되었습니다.");
		} else {
			rs.put("resultCode", "f-1");
			rs.put("msg", "해당 게시물은 존재하지 않습니다.");
		}
		rs.put("id", articleLastId);

		return rs;
	}

	private boolean deleteArticle(int id) {
		for (Article article : articles) {
			if (article.getId() == id) {
				articles.remove(id);
				return true;
			}
		}

		return false;
	}

	@RequestMapping("/usr/article/doAdd")
	@ResponseBody
	// http://localhost:8024/usr/article/doAdd?regDate=2020-12-12
	// 12:12:12&title=제목4&body=내용4
	public Map<String, Object> doAdd(String title, String body) {
		String regDate = Util.getCurrenDate();
		String updateDate = regDate;

		articles.add(new Article(++articleLastId, regDate, updateDate, title, body));

		Map<String, Object> rs = new HashMap<>();
		// 해시맵으로 구체적인 성공과 실패의 여부를 알려주기 위한 수단
		rs.put("resultCode", "s-1");
		rs.put("msg", "게시물이 추가 되었습니다.");
		rs.put("id", articleLastId);

		return rs;
	}

	@RequestMapping("/usr/article/detail")
	@ResponseBody
	// http://localhost:8024
	public Article showDetail(int id) {

		return articles.get(id - 1);
	}

	@RequestMapping("/usr/article/list")
	@ResponseBody
	// http://localhost:8024
	public List<Article> showList(String searchKeyword) {
		

		return articles;
	}

}
