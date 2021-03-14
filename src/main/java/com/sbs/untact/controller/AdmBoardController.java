package com.sbs.untact.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.untact.dto.Board;
import com.sbs.untact.service.BoardService;

@Controller
public class AdmBoardController extends BaseController {
	@Autowired
	private BoardService boardService;

	@RequestMapping("/adm/board/list")
	public String showList(HttpServletRequest req, @RequestParam Map<String, Object> param) {

		String searchKeywordType = (String) param.get("searchKeywordType");
		String searchKeyword = (String) param.get("searchKeyword");

		if (searchKeywordType != null) {
			searchKeywordType = searchKeywordType.trim();
		}

		if (searchKeywordType == null || searchKeywordType.length() == 0) {
			searchKeywordType = "name";
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

		List<Board> boards = boardService.getForPrintBoards(searchKeywordType, searchKeyword, itemsInAPage,
				itemsInAPage, param);

		req.setAttribute("boards", boards);

		return "adm/board/list";
	}


}
