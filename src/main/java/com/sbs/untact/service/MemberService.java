package com.sbs.untact.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.untact.dao.MemberDao;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class MemberService {
	@Autowired
	private MemberDao memberDao;

	public ResultData join(Map<String, Object> param) {
		memberDao.join(param);

		int id = Util.getAsInt(param.get("id"), 0);

		return new ResultData("s-1", String.format("%s님! 반갑습니다.", param.get("nickname")));
	}

	public Member getMemberByloginId(String loginId) {
		return memberDao.getMemberByloginId(loginId);
	}

	public Member getMember(int id) {
		return memberDao.getMember(id);
	}

	public ResultData modifyMember(Map<String, Object> param) {
		memberDao.modifyMember(param);

		return new ResultData("s-1", "회원정보 수정이 완료되었습니다.");
	}

	public boolean isAdmin(int actorId) {
		return actorId == 1;
	}

	public boolean isAdmin(Member actor) {
		return isAdmin(actor.getId());
	}

	public Member getMemberByAuthKey(String authKey) {
		return memberDao.getMemberByAuthKey(authKey);
	}

	public Member getMembers(int authLevel) {
		return memberDao.getMember(authLevel);
	}

	public List<Member> getForPrintMembers(String searchKeywordType, String searchKeyword, int page, int itemsInAPage) {
		int limitStart = (page - 1) * itemsInAPage;
		int limitTake = itemsInAPage;

		return memberDao.getForPrintMembers(searchKeywordType, searchKeyword, limitStart, limitTake);
	}
}
