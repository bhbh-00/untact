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

	@Autowired
	private MemberDao memberDao;

	@Autowired
	private GenFileService genFileService;

	@Autowired
	private AttrService attrService;

	@Value("${custom.needToChangePasswordFreeDays}")
	private int needToChangePasswordFreeDays;

	// 사이트 주소
	@Value("${custom.siteMainUri}")
	private String siteMainUri;

	// 사이트 이름
	@Value("${custom.siteName}")
	private String siteName;

	// 비밀번호 찾기 메일 보내기
	public ResultData notifyTempLoginPwByEmail(Member actor) {
		String title = "[" + siteName + "] 임시 패스워드 발송";
		String tempPassword = Util.getTempPassword(6);
		String body = "<h1>임시 패스워드 : " + tempPassword + "</h1>";
		body += "<a href=\"" + siteMainUri + "/usr/member/login\" target=\"_blank\">로그인 하러가기</a>";

		// 위의 내용으로 메일 보내기
		ResultData sendResultData = mailService.send(actor.getEmail(), title, body);

		if (sendResultData.isFail()) {
			return sendResultData;
		}

		// 비밀번호 암호화
		tempPassword = Util.sha256(tempPassword);

		// 비밀번호를 임시 비밀번호로 저장
		setTempPassword(actor, tempPassword);

		return new ResultData("S-1", "계정의 이메일로 임시 패스워드가 발송되었습니다.");
	}

	// 비밀번호를 임시 비밀번호로 저장
	private void setTempPassword(Member actor, String tempPassword) {
		attrService.setValue("member", actor.getId(), "extra", "useTempPassword", "1", null);
		memberDao.modify(actor.getId(), tempPassword, 0, null, null, null, null);
	}

	// 비밀번호를 유지할 수 있는 기간
	public int getNeedToChangePasswordFreeDays() {
		return needToChangePasswordFreeDays;
	}

	// 비밀번호를 변경해야 하는 지
	private void setNeedToChangePasswordLater(int actorId) {
		int days = getNeedToChangePasswordFreeDays();
		attrService.setValue("member", actorId, "extra", "needToChangePassword", "0",
				Util.getDateStrLater(60 * 60 * 24 * days));
	}

	// 임시 비밀번호인지 확인
	public boolean usingTempPassword(int actorId) {
		return attrService.getValue("member", actorId, "extra", "useTempPassword").equals("1");
	}

	// 비밀번호를 바꿔야 하는지 확인
	public boolean needToChangePassword(int actorId) {
		return attrService.getValue("member", actorId, "extra", "needToChangePassword").equals("0") == false;
	}

	// 기존 회원의 아이디 조회
	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}

	// 관리자
	public boolean isAdmin(Member actor) {
		return actor.getAuthLevel() == 7;
	}

	// 회원가입
	public ResultData join(Map<String, Object> param) {
		memberDao.join(param);

		int id = Util.getAsInt(param.get("id"), 0);

		// 비밀번호 등록 시점
		setNeedToChangePasswordLater(id);

		return new ResultData("s-1", "회원가입이 정상적으로 처리되었습니다.");
	}

	// 기존 회원의 이름과 이메일 확인
	public Member getMemberByNameAndEmail(String name, String email) {
		return memberDao.getMemberByNameAndEmail(name, email);
	}

	public Member getMember(int id) {
		return memberDao.getMember(id);
	}

	// 회원정보 수정
	public ResultData modify(int id, String loginPw, int authLevel, String name, String nickname, String cellphoneNo,
			String email) {

		memberDao.modify(id, loginPw, authLevel, name, nickname, cellphoneNo, email);

		if (loginPw != null) {
			setNeedToChangePasswordLater(id);
			attrService.remove("member", id, "extra", "useTempPassword");
		}

		return new ResultData("s-1", "회원정보가 수정되었습니다.");
	}

	// 회원의 번호로 정보 불러오기
	public Member getForPrintMember(int id) {
		return memberDao.getForPrintMember(id);
	}

	// checkPasswordAuthCode 생성
	public String genCheckPasswordAuthCode(int actorId) {
		String attrName = "member__" + actorId + "__extra__checkPasswordAuthCode";
		String authCode = UUID.randomUUID().toString();
		String expireDate = Util.getDateStrLater(60 * 60);

		attrService.setValue(attrName, authCode, expireDate);

		return authCode;
	}

	// checkPasswordAuthCode 확인
	public ResultData checkValidCheckPasswordAuthCode(int actorId, String checkPasswordAuthCode) {

		if (attrService.getValue("member__" + actorId + "__extra__checkPasswordAuthCode")
				.equals(checkPasswordAuthCode)) {
			return new ResultData("S-1", "유효한 키 입니다.");
		}

		return new ResultData("F-1", "유효하지 않은 키 입니다.");
	}

	//
	public Member getMemberByAuthKey(String authKey) {
		return memberDao.getMemberByAuthKey(authKey);
	}

	// 회원 리스트
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

	// static이여야함!
	// static 시작
	// 권한레벨별 이름 설정
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

	// 권한 레벨별 색깔 설정
	public static String getAuthLevelNameColor(Member member) {
		switch (member.getAuthLevel()) {
		case 7:
			return "badge-warning";
		case 3:
			return "badge-info";
		default:
			return "";
		}
	}
	// static 끝

	// 회원탈퇴
	public ResultData delete(Integer id) {
		memberDao.delete(id);
		return new ResultData("S-1", "탈퇴 완료되었습니다.", "id", id);
	}

	// 회원
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

	public int getMemberTotleCount(String searchKeywordType, String searchKeyword) {
		return memberDao.getMemberTotleCount(searchKeywordType, searchKeyword);
	}

	public ResultData admModify(int id, int authLevel) {
		memberDao.admModify(id, authLevel);

		return new ResultData("s-1", "회원정보가 수정되었습니다.");
	}

}
