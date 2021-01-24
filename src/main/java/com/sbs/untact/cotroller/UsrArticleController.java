package com.sbs.untact.cotroller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Article;

@Controller
public class UsrArticleController {
	private int articleLastId = 0;
	private List<Article> articles;

	public UsrArticleController() {
		articles = new ArrayList<>();

		// 멤버변수 초기화
		articleLastId = 0;

		articles.add(new Article(++articleLastId, "2020-12-12 12:12:12", "내용1", "제목1"));
		articles.add(new Article(++articleLastId, "2020-12-12 12:12:12", "내용2", "제목2"));
		articles.add(new Article(++articleLastId, "2020-12-12 12:12:12", "내용3", "제목3"));
		// ++articleLastId => 0에서 ++
	}
	
	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	// http://localhost:8024
	public Map<String, Object> doDelete(int id) {
	
		Map<String, Object> rs = new HashMap<>();
	
		// 해시맵으로 구체적인 성공과 실패의 여부를 알려주기 위한 수단
		rs.put("resultCode", "s-1");
		rs.put("msg", "성공하였습니다.");
		rs.put("id", articleLastId);
		
		return rs;
	}

	@RequestMapping("/usr/article/doAdd")
	@ResponseBody
	// http://localhost:8024/usr/article/doAdd?regDate=2020-12-12 12:12:12&title=제목4&body=내용4
	public Map<String, Object> doAdd(String regDate, String title, String body) {
		
		articles.add(new Article(++articleLastId, regDate, title, body));
		
		Map<String, Object> rs = new HashMap<>();
		// 해시맵으로 구체적인 성공과 실패의 여부를 알려주기 위한 수단
		rs.put("resultCode", "s-1");
		rs.put("msg", "성공하였습니다.");
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
	public List<Article> showList() {

		return articles;
	}

}
