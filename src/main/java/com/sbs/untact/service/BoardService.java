package com.sbs.untact.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.untact.dao.BoardDao;
import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class BoardService {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberService memberService;

	public Board getBoard(int id) {
		return boardDao.getBoard(id);
	}

	public List<Board> getForPrintBoards(String searchKeywordType, String searchKeyword, int page, int itemsInAPage,
			@RequestParam Map<String, Object> param) {
		int limitStart = (page - 1) * itemsInAPage;
		int limitTake = itemsInAPage;

		param.put("searchKeywordType", searchKeywordType);
		param.put("searchKeyword", searchKeyword);
		param.put("page", page);
		param.put("itemsInAPage", itemsInAPage);

		return boardDao.getForPrintBoards(param);
	}

	public Board getForPrintBoard(int id) {
		return boardDao.getForPrintBoard(id);
	}

	public int getBoardsTotleCount(String searchKeywordType, String searchKeyword) {
		return boardDao.getBoardsTotleCount(searchKeywordType, searchKeyword);
	}

	public ResultData doAdd(Map<String, Object> param) {
		boardDao.addBoard(param);

		int id = Util.getAsInt(param.get("id"), 0);

		return new ResultData("s-1", "게시물이 추가되었습니다.", "id", id);
	}

	public ResultData getActorCanModifyRd(Board board, Member actor) {
		if (board.getMemberId() == actor.getId()) {
			return new ResultData("S-1", "가능합니다.");
		}

		if (memberService.isAdmin(actor)) {
			return new ResultData("S-2", "가능합니다.");
		}

		return new ResultData("F-1", "권한이 없습니다.");
	}

	public ResultData getActorCanDeleteRd(Board board, Member actor) {
		return getActorCanModifyRd(board, actor);
	}

	public ResultData modifyBoard(Map<String, Object> param) {
		boardDao.modifyBoard(param);

		int id = Util.getAsInt(param.get("id"), 0);

		return new ResultData("s-1", "수정 완료되었습니다.", "id", id);
	}

	public Board getBoardByName(String name) {
		return boardDao.getBoardByName(name);
	}

	public ResultData deleteBoard(int id) {
		boardDao.deleteBoard(id);

		return new ResultData("s-1", "삭제되었습니다.", "id", id);
	}

	public Board getBoardByCode(String code) {
		return boardDao.getBoardByCode(code);
	}

}
