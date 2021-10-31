package com.sbs.untact.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.BoardService;
import com.sbs.untact.util.Util;

@Controller
public class AdmBoardController extends BaseController {
	@Autowired
	private BoardService boardService;
	
	// 게시판 삭제
	@RequestMapping("/adm/board/doDelete")
	@ResponseBody
	public String doDelete(int id, HttpServletRequest req) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (id == 0) {
			return msgAndBack(req, "id를 입력해주세요.");
		}

		Board board = boardService.getBoard(id);

		if (board == null) {
			return msgAndBack(req, "해당 게시판은 존재하지 않습니다.");
		}
		
		ResultData actorCanDeleteRd = boardService.getActorCanDeleteRd(board, loginedMember);

		if (actorCanDeleteRd.isFail()) {
			return Util.msgAndBack(actorCanDeleteRd.getMsg());
		}

		ResultData deleteBoardRd = boardService.delete(id);

		String redirectUrl = "../board/list";

		return Util.msgAndReplace(deleteBoardRd.getMsg(), redirectUrl);
	}
	
	// 게시판 이름 중복 확인
	@RequestMapping("/adm/board/getNameDup")
	@ResponseBody
	public ResultData getNameDup(String name) {

		if (name == null) {
			return new ResultData("F-1", "이름을 입력해주세요.");
		}

		Board existingBoard = boardService.getBoardByName(name);

		if (existingBoard != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용중인 이름 입니다.", name));
		}

		return new ResultData("S-1", String.format("%s(은)는 사용가능한 이름 입니다.", name), "name", name);
	}

	// 게시판 코드 생성의 조건
	@RequestMapping("/adm/board/getCodeDup")
	@ResponseBody
	public ResultData getCodeDup(String code) {

		if (code == null) {
			return new ResultData("F-1", "code를 입력해주세요.");
		}
		
		// 기존의 코드 확인
		Board existingBoard = boardService.getBoardByCode(code);

		if (existingBoard != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용중인 code 입니다.", code));
		}
		
		if (Util.isStandardCodeString(code) == false) {
			return new ResultData("F-1", "영문 소문자 조합으로 1자 이상으로 구성되어야 합니다.");
		}

		return new ResultData("S-1", String.format("%s(은)는 사용가능한 code 입니다.", code), "code", code);
	}
	
	// 게시판 수정
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
	
	// 게시판 수정
	@RequestMapping("/adm/board/doModify")
	@ResponseBody
	public String doModify(@RequestParam Map<String, Object> param, HttpServletRequest req) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		int id = Util.getAsInt(param.get("id"), 0);

		if (id == 0) {
			return msgAndBack(req, "번호를 입력해주세요.");
		}

		if (Util.isEmpty(param.get("name"))) {
			return msgAndBack(req, "이름을 입력해주세요.");
		}

		Board board = boardService.getBoard(id);

		if (board == null) {
			return msgAndBack(req, "해당 게시판은 존재하지 않습니다.");
		}

		ResultData actorCanModifyRd = boardService.getActorCanModifyRd(board, loginedMember);

		if (actorCanModifyRd.isFail()) {
			return Util.msgAndBack(actorCanModifyRd.getMsg());
		}

		ResultData modifyBoardRd = boardService.modify(param);
		String redirectUrl = "../board/list";

		return Util.msgAndReplace(modifyBoardRd.getMsg(), redirectUrl);
	}

	@RequestMapping("/adm/board/add")
	public String ShowAdd(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		return "/adm/board/add";
	}
	
	// 게시판 작성
	@RequestMapping("/adm/board/doAdd")
	public String doAdd(@RequestParam Map<String, Object> param, HttpServletRequest req) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (param.get("code") == null) {
			return msgAndBack(req, "code를 입력해주세요");
		}

		if (param.get("name") == null) {
			return msgAndBack(req, "name를 입력해주세요");
		}
		
		// 기존의 이름 확인
		Board existingBoard = boardService.getBoardByName((String) param.get("name"));

		if (existingBoard != null) {
			return msgAndBack(req, String.format("「 %s 」은 이미 등록되어 있습니다.", existingBoard.getName()));
		}
		
		param.put("loginedMember", loginedMember);

		ResultData addBoardRd = boardService.doAdd(param);

		int newBoardId = (int) addBoardRd.getBody().get("id");

		return msgAndReplace(req, String.format("%s번 게시판이 생성되었습니다.", newBoardId), "../board/list");
	}

	// 게시판 리스트
	@RequestMapping("/adm/board/list")
	public String showList(HttpServletRequest req, String searchKeywordType, String searchKeyword,
			@RequestParam(defaultValue = "1") int page) {

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
		int itemsInAPage = 10;

		// 총 게시물의 갯수를 구하는
		int totleItemsCount = boardService.getBoardsTotleCount(searchKeywordType, searchKeyword);

		List<Board> boards = boardService.getForPrintBoards(searchKeywordType, searchKeyword, page,
				itemsInAPage );

		// 총 페이지 갯수 (총 게시물 수 / 한 페이지 안의 게시물 갯수)
		int totlePage = (int) Math.ceil(totleItemsCount / (double) itemsInAPage);

		// 페이징의 반지름
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
		req.setAttribute("boards", boards);

		return "adm/board/list";
	}

}
