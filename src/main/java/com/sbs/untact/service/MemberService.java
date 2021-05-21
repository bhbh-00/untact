package com.sbs.untact.service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
	private MailService mailService;
	@Value("${custom.siteMainUri}")
	private String siteMainUri;
	@Value("${custom.siteName}")
	private String siteName;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private GenFileService genFileService;
	@Autowired
	private AttrService attrService;

	public ResultData join(Map<String, Object> param) {
		memberDao.join(param);

		int id = Util.getAsInt(param.get("id"), 0);

		genFileService.changeInputFileRelIds(param, id);

		return new ResultData("s-1", String.format("회원가입이 정상적으로 처리되었습니다.", param.get("nickname")));
	}

	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}

	public Member getMember(int id) {
		return memberDao.getMember(id);
	}

	public ResultData modifyMember(Map<String, Object> param) {
		memberDao.modifyMember(param);

		return new ResultData("s-1", "회원정보가 수정되었습니다.");
	}

	public boolean isAdmin(Member actor) {
		return actor.getAuthLevel() == 7;
	}

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
		return new ResultData("S-1", "탈퇴 완료되었습니다.", "id", id);
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

	public Member getMemberByLoginPw(String loginPw) {
		return memberDao.getMemberByLoginPw(loginPw);
	}

	public Member getMemberByNameAndEmail(String name, String email) {
		return memberDao.getMemberByNameAndEmail(name, email);
	}

	public Member getMemberByLoginIdAndEmail(String loginId, String email) {
		return memberDao.getMemberByLoginIdAndEmail(loginId, email);
	}

	// 비밀번호 찾기 메일 보내기
	public ResultData notifyTempLoginPwByEmail(Member actor) {
		String title = "[" + siteName + "] 임시 패스워드 발송";
		String tempPassword = Util.getTempPassword(6);
		String body = "<h1>임시 패스워드 : " + tempPassword + "</h1>";
		body += "<a href=\"" + siteMainUri + "/mpaUsr/member/login\" target=\"_blank\">로그인 하러가기</a>";

		ResultData sendResultData = mailService.send(actor.getEmail(), title, body);

		if (sendResultData.isFail()) {
			return sendResultData;
		}

		tempPassword = Util.sha256(tempPassword);

		setTempPassword(actor, tempPassword);

		return new ResultData("S-1", "계정의 이메일로 임시 패스워드가 발송되었습니다.");
	}

	private void setTempPassword(Member actor, String tempPassword) {
		memberDao.modifyUserMember(actor.getId(), tempPassword, null, null, null, null, null);
	}

	public ResultData checkValidCheckPasswordAuthCode(int actorId, String checkPasswordAuthCode) {
		if (attrService.getValue("member__" + actorId + "__extra__checkPasswordAuthCode")
				.equals(checkPasswordAuthCode)) {
			return new ResultData("S-1", "유효한 키 입니다.");
		}

		return new ResultData("F-1", "유효하지 않은 키 입니다.");
	}

	public String genCheckPasswordAuthCode(int actorId) {
		String attrName = "member__" + actorId + "__extra__checkPasswordAuthCode";
		String authCode = UUID.randomUUID().toString();
		String expireDate = Util.getDateStrLater(60 * 60);

		attrService.setValue(attrName, authCode, expireDate);

		return authCode;
	}

	public boolean needToChangePassword(int actorId) {
		return attrService.getValue("member", actorId, "extra", "needToChangePassword").equals("0") == false;
	}

}
