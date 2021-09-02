package com.sbs.untact.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.MemberService;
import com.sbs.untact.util.Util;

@Controller
public class UsrMemberController extends BaseController {
	@Autowired
	private MemberService memberService;

	// 비밀번호 찾기
	@RequestMapping("/usr/member/findLoginPw")
	public String ShowfindLoginPw() {
		return ("/usr/member/findLoginPw");
	}

	// 비밀번호 찾기
	@RequestMapping("/usr/member/doFindLoginPw")
	@ResponseBody
	public String doFindLoginPw(HttpServletRequest req, String name, String loginId, String email, String redirectUrl) {

		if (Util.isEmpty(redirectUrl)) {
			redirectUrl = "/usr/member/login";
		}

		Member member = memberService.getMemberByLoginId(loginId);

		if (member == null) {
			return Util.msgAndBack("일치하는 회원이 존재하지 않습니다.");
		}

		if (member.getName().equals(name) == false) {
			return Util.msgAndBack("일치하는 회원이 존재하지 않습니다.");
		}

		if (member.getEmail().equals(email) == false) {
			return Util.msgAndBack("일치하는 회원이 존재하지 않습니다.");
		}

		ResultData notifyTempLoginPwByEmailRs = memberService.notifyTempLoginPwByEmail(member);

		return Util.msgAndReplace(notifyTempLoginPwByEmailRs.getMsg(), redirectUrl);
	}

	// 아이디 찾기
	@RequestMapping("/usr/member/findLoginId")
	public String ShowfindLoginId() {
		return ("/usr/member/findLoginId");
	}

	@RequestMapping("/usr/member/doFindLoginId")
	@ResponseBody
	public String doFindLoginId(HttpServletRequest req, String name, String email, String redirectUrl) {

		if (Util.isEmpty(redirectUrl)) {
			redirectUrl = "/";
		}

		Member member = memberService.getMemberByNameAndEmail(name, email);

		if (member == null) {
			return Util.msgAndBack("일치하는 회원이 존재하지 않습니다.");
		}

		return Util.msgAndBack(String.format("회원님의 아이디는 [ %s ] 입니다.", member.getLoginId()));
	}

	// 비밀번호 확인
	@RequestMapping("/usr/member/checkPassword")
	public String ShowCheckPassword(HttpServletRequest req) {
		return "/usr/member/checkPassword";
	}

	// checkPasswordAuthCode : 체크비밀번호인증코드
	// 비밀번호 확인
	@RequestMapping("/usr/member/doCheckPassword")
	public String doCheckPassword(HttpServletRequest req, String loginPw, String redirectUrl) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (loginPw == null) {
			return msgAndBack(req, "비밀번호를 입력해주세요.");
		}

		if (loginedMember.getLoginPw().equals(loginPw) == false) {
			return msgAndBack(req, "비밀번호가 일치하지 않습니다.");
		}

		// checkPasswordAuthCode 생성
		String authCode = memberService.genCheckPasswordAuthCode(loginedMember.getId());

		redirectUrl = "../member/modify?id=" + loginedMember.getId();

		// checkPasswordAuthCode가 포함 된 새로운 url 가져오기
		redirectUrl = Util.getNewUrl(redirectUrl, "checkPasswordAuthCode", authCode);

		req.setAttribute("loginedMember", loginedMember);

		return msgAndReplace(req, "", redirectUrl);
	}

	// 회원탈퇴
	@RequestMapping("/usr/member/doDelete")
	@ResponseBody
	public String doDelete(Integer id, HttpServletRequest req) {

		if (id == null) {
			return msgAndBack(req, "id를 입력해주세요.");
		}

		Member member = memberService.getMember(id);

		if (member == null) {
			return msgAndBack(req, "존재하지 않는 회원입니다.");
		}

		ResultData deleteMemberRd = memberService.delete(id);

		String redirectUrl = "/usr/member/login";

		return Util.msgAndReplace(deleteMemberRd.getMsg(), redirectUrl);
	}

	// 내 프로필 보기
	@RequestMapping("/usr/member/mypage")
	public String showMyPage(HttpServletRequest req, Integer id) {

		if (id == null) {
			return msgAndBack(req, "id를 입력해주세요.");
		}

		Member member = memberService.getForPrintMember(id);

		if (member == null) {
			return msgAndBack(req, "존재하지 않는 회원입니다.");
		}

		req.setAttribute("member", member);

		return "/usr/member/mypage";
	}

	// 회원가입 시 아이디의 조건 확인
	@RequestMapping("/usr/member/getLoginIdDup")
	@ResponseBody
	public ResultData getLoginIdDup(String loginId) {

		if (loginId == null) {
			return new ResultData("F-5", "아이디를 입력해주세요.");
		}

		if (Util.allNumberString(loginId)) {
			return new ResultData("F-3", "아이디는 숫자만으로 구성될 수 없습니다.");
		}

		if (Util.startsWithNumberString(loginId)) {
			return new ResultData("F-4", "아이디는 숫자로 시작할 수 없습니다.");
		}

		if (loginId.length() < 5) {
			return new ResultData("F-5", "아이디는 5자 이상으로 입력해주세요.");
		}

		if (loginId.length() > 20) {
			return new ResultData("F-6", "아이디는 20자 이하로 입력해주세요.");
		}

		if (Util.isStandardLoginIdString(loginId) == false) {
			return new ResultData("F-1", "아이디는 영문소문자와 숫자의 조합으로 구성 되어야 합니다.");
		}

		// 아이디 중복 확인
		Member existingMember = memberService.getMemberByLoginId(loginId);

		if (existingMember != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용 중인 아이디 입니다.", loginId));
		}

		return new ResultData("S-1", String.format("%s(은)는 사용 가능한 아이디 입니다.", loginId), "loginId", loginId);

	}

	// 회원가입
	@RequestMapping("/usr/member/join")
	public String ShowJoin() {
		return "/usr/member/join";
	}

	// 회원가입
	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public String doJoin(@RequestParam Map<String, Object> param) {

		// 아이디 중복 확인
		Member existingMember = memberService.getMemberByLoginId((String) param.get("loginId"));

		if (existingMember != null) {
			return Util.msgAndBack("이미 사용 중인 아이디입니다.");
		}

		// 이름과 이메일 중복 확인
		existingMember = memberService.getMemberByNameAndEmail((String) param.get("name"), (String) param.get("email"));

		if (existingMember != null) {
			return Util.msgAndBack(String.format("%s님 이미 가입되어 있는「%s」메일 주소입니다. (%s)", param.get("name"),
					param.get("email"), existingMember.getRegDate()));
		}

		// 회원가입
		memberService.join(param);

		String msg = String.format("%s님! 가입을 환영합니다!", param.get("nickname"));

		String redirectUrl = Util.ifEmpty((String) param.get("redirectUrl"), "../member/login");

		return Util.msgAndReplace(msg, redirectUrl);
	}

	// 로그아웃
	@RequestMapping("/usr/member/doLogout")
	@ResponseBody
	public String doLogout(HttpSession session) {

		session.removeAttribute("loginedMemberId");

		return Util.msgAndReplace("로그아웃 되었습니다.", "../member/login");
	}

	// 로그인
	@RequestMapping("/usr/member/login")
	public String ShowLogin() {
		return ("/usr/member/login");
	}

	// 로그인
	@RequestMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw, String redirectUrl, HttpSession session) {

		if (loginId == null) {
			return Util.msgAndBack("아이디를 입력해주세요.");
		}

		// 아이디 확인
		Member member = memberService.getMemberByLoginId(loginId);

		if (member == null) {
			return Util.msgAndBack("존재하지 않는 아이디입니다.");
		}

		if (loginPw == null) {
			return Util.msgAndBack("비밀번호를 입력해주세요.");
		}

		// 비밀번호 확인
		if (member.getLoginPw().equals(loginPw) == false) {
			return Util.msgAndBack("비밀번호가 일치하지 않습니다.");
		}

		session.setAttribute("loginedMemberId", member.getId());

		String msg = String.format("%s님! 환영합니다.", member.getNickname());

		redirectUrl = Util.ifEmpty(redirectUrl, "../home/main");

		// 비밀번호 변경 90일 확인
		boolean needToChangePassword = memberService.needToChangePassword(member.getId());

		if (needToChangePassword) {
			msg = "현재 비밀번호를 사용한지 " + memberService.getNeedToChangePasswordFreeDays() + "일이 지났습니다. 비밀번호를 변경해주세요.";
			redirectUrl = "../member/mypage?id=" + member.getId();
		}

		// 임시비밀 번호 확인
		boolean usingTempPassword = memberService.usingTempPassword(member.getId());

		if (usingTempPassword) {
			msg = "임시 비밀번호를 변경해주세요.";
			redirectUrl = "../member/mypage?id=" + member.getId();
		}

		return Util.msgAndReplace(msg, redirectUrl);
	}

	// 회원 정보 수정
	@RequestMapping("/usr/member/modify")
	public String Modify(HttpServletRequest req, Integer id, String checkPasswordAuthCode) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		// checkPasswordAuthCode 확인
		ResultData checkValidCheckPasswordAuthCodeResultData = memberService
				.checkValidCheckPasswordAuthCode(loginedMember.getId(), checkPasswordAuthCode);

		if (checkValidCheckPasswordAuthCodeResultData.isFail()) {
			return msgAndBack(req, checkValidCheckPasswordAuthCodeResultData.getMsg());
		}

		if (id == 0) {
			return msgAndBack(req, "회원 번호를 입력해주세요.");
		}

		// 회원의 번호로 정보 불러오기
		Member member = memberService.getForPrintMember(id);

		if (member == null) {
			return msgAndBack(req, "존재하지 않는 회원입니다.");
		}

		req.setAttribute("member", member);

		return "/usr/member/modify";
	}

	// 회원 정보 수정
	@RequestMapping("/usr/member/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, String loginPw, int authLevel, String name, String nickname,
			String cellphoneNo, String email, String checkPasswordAuthCode) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		// checkPasswordAuthCode 확인
		ResultData checkValidCheckPasswordAuthCodeResultData = memberService
				.checkValidCheckPasswordAuthCode(loginedMember.getId(), checkPasswordAuthCode);

		if (checkValidCheckPasswordAuthCodeResultData.isFail()) {
			return msgAndBack(req, checkValidCheckPasswordAuthCodeResultData.getMsg());
		}

		// 회원 정보 수정
		ResultData modifyRd = memberService.modify(loginedMember.getId(), loginPw, authLevel, name, nickname,
				cellphoneNo, email);

		req.setAttribute("member", loginedMember);

		String redirectUrl = "../member/mypage?id=" + loginedMember.getId();

		return Util.msgAndReplace(modifyRd.getMsg(), redirectUrl);
	}

}
