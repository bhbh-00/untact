package com.sbs.untact.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.untact.dao.ReplyDao;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.Reply;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class ReplyService {
	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private MemberService memberService;

	// 댓글 작성
	public ResultData doAdd(Map<String, Object> param) {
		replyDao.doAdd(param);

		int id = Util.getAsInt(param.get("id"), 0);

		return new ResultData("s-1", "댓글이 추가되었습니다.", "id", id);
	}

	// 댓글 확인
	public Reply getReply(Integer id) {
		return replyDao.getReply(id);
	}

	// 댓글 수정
	public ResultData modify(Integer id, String body) {
		replyDao.modify(id, body);

		return new ResultData("s-1", "수정 완료되었습니다.", "id", id);
	}

	// 권한에 따른 수정 가능 여부
	public ResultData getActorCanModifyRd(Reply reply, Member actor) {
		if (reply.getMemberId() == actor.getId()) {
			return new ResultData("S-1", "가능합니다.");
		}

		if (memberService.isAdmin(actor)) {
			return new ResultData("S-2", "가능합니다.");
		}

		return new ResultData("F-1", "권한이 없습니다.");
	}

	// 권한에 따른 삭제 가능 여부
	public ResultData getActorCanDeleteRd(Reply reply, Member actor) {
		return getActorCanModifyRd(reply, actor);
	}

	// 댓글 삭제
	public ResultData delete(Integer id) {
		replyDao.delete(id);

		return new ResultData("S-1", "삭제하였습니다.", "id", id);
	}

	// 댓글 리스트
	public List<Reply> getForPrintReplies(Integer id) {
		return replyDao.getForPrintReplies(id);
	}

}
