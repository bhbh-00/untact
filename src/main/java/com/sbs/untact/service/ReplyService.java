package com.sbs.untact.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.untact.dao.ReplyDao;
import com.sbs.untact.dto.Reply;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class ReplyService {
	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private MemberService memberService;

	public ResultData doAdd(Map<String, Object> param) {
		replyDao.doAdd(param);

		int id = Util.getAsInt(param.get("id"), 0);

		return new ResultData("s-1", "게시물이 추가되었습니다.", "id", id);
	}

	public ResultData doModify(Integer id, String body) {
		replyDao.doModify(id, body);

		return new ResultData("s-1", "수정완료되었습니다.", "id", id);
	}

	public List<Reply> getForPrintReplies(Integer id) {
		return replyDao.getForPrintReplies(id);
	}

	public Reply getReply(Integer id) {
		return replyDao.getReply(id);
	}

	public ResultData delete(Integer id) {
		replyDao.delete(id);

		return new ResultData("S-1", "삭제하였습니다.", "id", id);
	}

	public ResultData getActorCanModify(Reply reply, int actorId) {
		if (reply.getMemberId() == actorId) {
			return new ResultData("s-1", "가능합니다.");
		}

		if (memberService.isAdmin(actorId)) {
			return new ResultData("s-1", "가능합니다.");
		}

		return new ResultData("F-1", "권한이 없습니다.");
	}

	public ResultData getActorCanDelete(Reply reply, int actorId) {
		return getActorCanModify(reply, actorId);
	}

}
