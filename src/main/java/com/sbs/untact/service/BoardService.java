package com.sbs.untact.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.untact.dao.BoardDao;
import com.sbs.untact.dto.Board;

@Service
public class BoardService {
	@Autowired
	private BoardDao boardDao;

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

}
