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
	public String showList(HttpServletRequest req, String searchKeywordType, String searchKeyword,
			@RequestParam(defaultValue = "1") int page, Map<String, Object> param) {

		if (searchKeywordType != null) {
			searchKeywordType = searchKeywordType.trim();
		}

		if (searchKeywordType == null || searchKeywordType.length() == 0) {
			searchKeywordType = "codeAndName";
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
		int totleItemsCount = boardService.getBoardsTotleCount(searchKeywordType, searchKeyword);

		List<Board> boards = boardService.getForPrintBoards(searchKeywordType, searchKeyword, itemsInAPage,
				itemsInAPage, param);

		// 총 페이지 갯수 (총 게시물 수 / 한 페이지 안의 게시물 갯수)
		int totlePage = (int) Math.ceil(totleItemsCount / (double) itemsInAPage);

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

		// req.setAttribute( "" , ) -> 이게 있어야지 jsp에서 뜸!
		req.setAttribute("totleItemsCount", totleItemsCount);
		req.setAttribute("totlePage", totlePage);
		req.setAttribute("pageMenuArmSize", pageMenuArmSize);
		req.setAttribute("pageMenuStrat", pageMenuStrat);
		req.setAttribute("pageMenuEnd", pageMenuEnd);
		req.setAttribute("page", page);
		req.setAttribute("boards", boards);

		return "adm/board/list";
	}

}
