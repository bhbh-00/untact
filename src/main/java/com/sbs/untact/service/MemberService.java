package com.sbs.untact.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.untact.dao.MemberDao;
import com.sbs.untact.dto.GenFile;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.util.Util;

@Service
public class MemberService {
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private GenFileService genFileService;

	public ResultData join(Map<String, Object> param) {
		memberDao.join(param);

		int id = Util.getAsInt(param.get("id"), 0);

		genFileService.changeInputFileRelIds(param, id);

		return new ResultData("s-1", String.format("%s님! 반갑습니다.", param.get("nickname")));
	}

	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}

	public Member getMember(int id) {
		return memberDao.getMember(id);
	}

	public ResultData modifyMember(Map<String, Object> param) {
		memberDao.modifyMember(param);

		return new ResultData("s-1", "수정완료 되었습니다.");
	}

	public boolean isAdmin(Member actor) {
		return actor.getAuthLevel() == 7;
	}

//	public boolean isAdmin(Member actor) {
//		return isAdmin(actor.getId());
//	}

	public Member getMemberByAuthKey(String authKey) {
		return memberDao.getMemberByAuthKey(authKey);
	}

	public Member getMembers(int authLevel) {
		return memberDao.getMember(authLevel);
	}

	public List<Member> getForPrintMembers(String searchKeywordType, String searchKeyword, int page, int itemsInAPage,
			@RequestParam Map<String, Object> param) {
		int limitStart = (page - 1) * itemsInAPage;
		int limitTake = itemsInAPage;

		param.put("searchKeywordType", searchKeywordType);
		param.put("searchKeyword", searchKeyword);
		param.put("page", page);
		param.put("itemsInAPage", itemsInAPage);

		return memberDao.getForPrintMembers(param);
	}

	public Member getForPrintMember(int id) {
		return memberDao.getForPrintMember(id);
	}

	// static이여야함!
	// static 시작
	public static String getAuthLevelName(Member member) {
		switch (member.getAuthLevel()) {
		case 7:
			return "관리자";
		case 3:
			return "일반";
		default:
			return "유형정보없음";
		}
	}

	public static String getAuthLevelNameColor(Member member) {
		switch (member.getAuthLevel()) {
		case 7:
			return "blue";
		case 3:
			return "yellow";
		default:
			return "";
		}
	}
	// static 끝

	public ResultData deleteMember(Integer id) {
		memberDao.deleteMember(id);
		return new ResultData("S-1", "삭제하였습니다.", "id", id);
	}

	public Member getForPrintMemberByAuthKey(String authKey) {
		Member member = memberDao.getMemberByAuthKey(authKey);

		updateForPrint(member);

		return member;
	}

	private void updateForPrint(Member member) {
		GenFile genFile = genFileService.getGenFile("member", member.getId(), "common", "attachment", 1);

		if (genFile != null) {
			String imgUrl = genFile.getForPrintUrl();
			member.setExtra__thumbImg(imgUrl);
		}
	}

	public Member getForPrintMemberByLoginId(String loginId) {
		Member member = memberDao.getMemberByLoginId(loginId);

		updateForPrint(member);

		return member;
	}

}
