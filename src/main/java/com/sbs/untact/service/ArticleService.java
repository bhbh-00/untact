package com.sbs.untact.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.untact.dao.ArticleDao;
import com.sbs.untact.dto.Article;
import com.sbs.untact.dto.Board;
import com.sbs.untact.dto.GenFile;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class ArticleService {
	@Autowired
	private ArticleDao articleDao;
	@Autowired
	private MemberService memberService;
	@Autowired
	private GenFileService genFileService;

	//
	public Article getArticle(int id) {
		return articleDao.getArticle(id);
	}

	// 게시물 작성
	public ResultData doAdd(Map<String, Object> param) {
		articleDao.add(param);

		int id = Util.getAsInt(param.get("id"), 0);

		// 파일 업로드 시 파일의 번호를 게시물의 번호를 바꾼다.
		genFileService.changeInputFileRelIds(param, id);

		return new ResultData("s-1", "게시물이 추가되었습니다.", "id", id);
	}

	public List<Article> getArticleList(String searchKeywordType, String searchKeyword) {
		return articleDao.getArticles(searchKeywordType, searchKeyword);
	}

	// 게시물 상세 페이지
	public Article getForPrintArticle(Integer id) {
		return articleDao.getForPrintArticle(id);
	}

	public List<Article> getForPrintArticles(int boardId, String searchKeywordType, String searchKeyword, int page,
			int itemsInAPage) {
		// 페이징 - 시작과 끝 범위
		int limitStart = (page - 1) * itemsInAPage;
		// controller에서 한 페이지에 포함 되는 게시물의 갯수의 값을(itemsInAPage) 설정했음.
		int limitTake = itemsInAPage;
		// 한 페이지에 포함 되는 게시물의 갯수의 값
		// LIMIT 20, 20 => 2page LIMIT 40, 20 => 3page

		List<Article> articles = articleDao.getForPrintArticles(boardId, searchKeywordType, searchKeyword, limitStart,
				limitTake);
		List<Integer> articleIds = articles.stream().map(article -> article.getId()).collect(Collectors.toList());
		Map<Integer, Map<String, GenFile>> filesMap = genFileService.getFilesMapKeyRelIdAndFileNo("article", articleIds,
				"common", "attachment");

		for (Article article : articles) {
			Map<String, GenFile> mapByFileNo = filesMap.get(article.getId());

			if (mapByFileNo != null) {
				article.getExtraNotNull().put("file__common__attachment", mapByFileNo);
			}
		}

		return articles;
	}

	public Board getBoard(int boardId) {
		return articleDao.getBoard(boardId);
	}

	// 게시물 수정 가능 권한 여부
	public ResultData getActorCanModifyRd(Article article, Member actor) {
		if (article.getMemberId() == actor.getId()) {
			return new ResultData("S-1", "가능합니다.");
		}

		if (memberService.isAdmin(actor)) {
			return new ResultData("S-2", "가능합니다.");
		}

		return new ResultData("F-1", "권한이 없습니다.");
	}

	// 게시물 수정
	public ResultData modify(Map<String, Object> param) {
		articleDao.modify(param);

		int id = Util.getAsInt(param.get("id"), 0);

		return new ResultData("s-1", "수정 완료되었습니다.", "id", id);
	}

	// 게시물 삭제 가능 권한 여부 확인
	public ResultData getActorCanDeleteRd(Article article, Member actor) {
		return getActorCanModifyRd(article, actor);
	}

	// 게시물 삭제
	public ResultData delete(int id) {
		articleDao.delete(id);

		// 파일 삭제
		genFileService.deleteGenFiles("article", id);

		return new ResultData("S-1", "삭제되었습니다.", "id", id);
	}

	public int getArticlesTotleCount(int boardId, String searchKeywordType, String searchKeyword) {
		return articleDao.getArticlesTotleCount(boardId, searchKeywordType, searchKeyword);
	}

	public List<Article> getForPrintArticleByMemberId(int id) {
		return articleDao.getForPrintArticleByMemberId(id);
	}

	public List<Article> getForPrintArticlesByMyList(int loginMemberId, int boardId, String searchKeywordType,
			String searchKeyword, int page, int itemsInAPage) {
		// 페이징 - 시작과 끝 범위
		int limitStart = (page - 1) * itemsInAPage;
		// controller에서 한 페이지에 포함 되는 게시물의 갯수의 값을(itemsInAPage) 설정했음.
		int limitTake = itemsInAPage;
		// 한 페이지에 포함 되는 게시물의 갯수의 값
		// LIMIT 20, 20 => 2page LIMIT 40, 20 => 3page

		List<Article> articles = articleDao.getForPrintArticlesByMyList(loginMemberId, boardId, searchKeywordType,
				searchKeyword, limitStart, limitTake);
		List<Integer> articleIds = articles.stream().map(article -> article.getId()).collect(Collectors.toList());
		Map<Integer, Map<String, GenFile>> filesMap = genFileService.getFilesMapKeyRelIdAndFileNo("article", articleIds,
				"common", "attachment");

		for (Article article : articles) {
			Map<String, GenFile> mapByFileNo = filesMap.get(article.getId());

			if (mapByFileNo != null) {
				article.getExtraNotNull().put("file__common__attachment", mapByFileNo);
			}
		}

		return articles;
	}

	public int getArticlesTotleCountByMyList(int loginMemberId, int boardId, String searchKeywordType,
			String searchKeyword) {
		return articleDao.getArticlesTotleCountByMyList(loginMemberId, boardId, searchKeywordType, searchKeyword);
	}
	
	// 가장 최신 자유 게시물 2개
	public List<Article> getLatestArticleByBoardNameFree() {
		return articleDao.getLatestArticleByBoardNameFree();
	}
	
	// 가장 최신 공지사항 게시물 2개
	public List<Article> getLatestArticleByBoardNameNotice() {
		return articleDao.getLatestArticleByBoardNameNotice();
	}

	public Article getArticleByReply(Integer id) {
		return articleDao.getArticleByReply(id);
	}

}
