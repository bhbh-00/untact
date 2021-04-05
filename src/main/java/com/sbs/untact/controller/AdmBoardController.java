package com.sbs.untact.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartRequest;

import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.BoardService;
import com.sbs.untact.util.Util;

@Controller
public class AdmBoardController extends BaseController {
	@Autowired
	private BoardService boardService;

	@RequestMapping("/adm/board/doDelete")
	@ResponseBody
	public ResultData doDelete(int id, HttpServletRequest req) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (id == 0) {
			return new ResultData("F-1", "id를 입력해주세요.");
		}

		Board board = boardService.getBoard(id);

		if (board == null) {
			return new ResultData("F-1", "해당 게시판은 존재하지 않습니다.");
		}
		
		ResultData actorCanDeleteRd = boardService.getActorCanDeleteRd(board, loginedMember);

		if (actorCanDeleteRd.isFail()) {
			return actorCanDeleteRd;
		}


		return boardService.deleteBoard(id);
	}

	@RequestMapping("/adm/board/getCodeDup")
	@ResponseBody
	public ResultData getCodeDup(String code) {

		if (code == null) {
			return new ResultData("F-1", "code를 입력해주세요.");
		}

		Board existingBoard = boardService.getBoardByCode(code);

		if (existingBoard != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용중인 code 입니다.", code));
		}

		return new ResultData("S-1", String.format("%s(은)는 사용가능한 code 입니다.", code), "code", code);
	}
	
	@RequestMapping("/adm/board/getNameDup")
	@ResponseBody
	public ResultData getNameDup(String name) {

		if (name == null) {
			return new ResultData("F-1", "name를 입력해주세요.");
		}

		Board existingBoard = boardService.getBoardByName(name);

		if (existingBoard != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용중인 name 입니다.", name));
		}

		return new ResultData("S-1", String.format("%s(은)는 사용가능한 name 입니다.", name), "name", name);
	}

	@RequestMapping("/adm/board/modify")
	public String ShowModify(Integer id, HttpServletRequest req) {

		if (id == null) {
			return msgAndBack(req, "게시물 번호를 입력해주세요.");
		}

		Board board = boardService.getForPrintBoard(id);

		if (board == null) {
			return msgAndBack(req, "해당 게시판은 존재하지 않습니다.");
		}

		req.setAttribute("board", board);

		return "/adm/board/modify";
	}

	@RequestMapping("/adm/board/doModify")
	@ResponseBody
	public ResultData doModify(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		int id = Util.getAsInt(param.get("id"), 0);

		if (id == 0) {
			return new ResultData("F-1", "게시물 번호를 입력해주세요.");
		}

		if (Util.isEmpty(param.get("name"))) {
			return new ResultData("F-1", "이름을 입력해주세요.");
		}

		Board board = boardService.getBoard(id);

		if (board == null) {
			return new ResultData("F-1", "해당 게시물은 존재하지 않습니다.");
		}

		ResultData actorCanModifyRd = boardService.getActorCanModifyRd(board, loginedMember);

		if (actorCanModifyRd.isFail()) {
			return actorCanModifyRd;
		}

		return boardService.modifyBoard(param);
	}

	@RequestMapping("/adm/board/add")
	public String ShowAdd(@RequestParam Map<String, Object> param, HttpServletRequest req) {

		return "/adm/board/add";

	}

	@RequestMapping("/adm/board/doAdd")
	public String doAdd(@RequestParam Map<String, Object> param, HttpServletRequest req,
			MultipartRequest multipartRequest) {
		int loginMemberId = (int) req.getAttribute("loginedMemberId");

		if (param.get("code") == null) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		if (param.get("name") == null) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		param.put("memberId", loginMemberId);

		ResultData addBoardRd = boardService.doAdd(param);

		int newBoardId = (int) addBoardRd.getBody().get("id");

		return msgAndReplace(req, String.format("%d번 게시물이 작성되었습니다.", newBoardId), "../board/list?id=" + newBoardId);
	}

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
