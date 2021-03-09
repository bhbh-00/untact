package com.sbs.untact.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.MemberService;

@Controller
public class UsrMemberController {
	@Autowired
	private MemberService memberService;

	@PostMapping("/usr/member/doModify")
	@ResponseBody
	public ResultData doModify(@RequestParam Map<String, Object> param, HttpSession session) {

		if (param.isEmpty()) {
			return new ResultData("F-2", "수정할 정보를 입력해주세요.");
		}

		int loginedMember = (int) session.getAttribute("loginedMemberId");
		param.put("id", loginedMember);

		return memberService.modifyMember(param);
	}
	@PostMapping("/usr/member/Logout")
	public String Logout() {
		return ("/usr/member/Logout");
	}
	
	@PostMapping("/usr/member/doLogout")
	@ResponseBody
	public ResultData doLogout(HttpSession session) {

		session.removeAttribute("loginedMemberId");

		return new ResultData("S-1", "로그아웃 되었습니다.");
	}

	@PostMapping("/usr/member/memberByauthKey")
	@ResponseBody
	public ResultData showMemberByauthKey(String authKey) {

		if (authKey == null) {
			return new ResultData("F-1", "아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getForPrintMemberByAuthKey(authKey);

		return new ResultData("S-1", String.format("유효한 회원"), "member", existingMember);
	}

	@PostMapping("/usr/member/authKey")
	@ResponseBody
	public ResultData showAuthKey(String loginId, String loginPw) {

		if (loginId == null) {
			return new ResultData("F-1", "아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getForPrintMemberByLoginId(loginId);

		if (existingMember == null) {
			return new ResultData("F-2", "존재하지 않는 아이디입니다.", "loginId", loginId);
		}

		if (loginPw == null) {
			return new ResultData("F-1", "비밀번호를 입력해주세요.");
		}

		if (existingMember.getLoginPw().equals(loginPw) == false) {
			return new ResultData("F-3", "비밀번호가 일치하지 않습니다.");
		}

		return new ResultData("S-1", String.format("%s님 환영합니다.", existingMember.getNickname()), "authKey", existingMember.getAuthKey(), "member", existingMember);
	}

	@PostMapping("/usr/member/doLogin")
	@ResponseBody
	public ResultData doLogin(String loginId, String loginPw, HttpSession session) {

		if (loginId == null) {
			return new ResultData("F-1", "아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getMemberByloginId(loginId);

		if (existingMember == null) {
			return new ResultData("F-2", "존재하지 않는 아이디입니다.", "loginId", loginId);
		}

		if (loginPw == null) {
			return new ResultData("F-1", "비밀번호를 입력해주세요.");
		}

		if (existingMember.getLoginPw().equals(loginPw) == false) {
			return new ResultData("F-3", "비밀번호가 일치하지 않습니다.");
		}

		session.setAttribute("loginedMemberId", existingMember.getId());

		return new ResultData("S-1", String.format("%s님! 환영합니다.", existingMember.getNickname()));
	}

	@PostMapping("/usr/member/doJoin")
	@ResponseBody
	public ResultData doAdd(@RequestParam Map<String, Object> param) {

		if (param.get("loginId") == null) {
			return new ResultData("F-1", "아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getMemberByloginId((String) param.get("loginId"));

		if (existingMember != null) {
			return new ResultData("F-2", String.format("이미 사용 중인 아이디입니다.", param.get("loginId")));
		}

		if (param.get("loginPw") == null) {
			return new ResultData("F-1", "비밀번호를 입력해주세요.");
		}
		if (param.get("name") == null) {
			return new ResultData("F-1", "이름을 입력해주세요.");
		}

		if (param.get("nickname") == null) {
			return new ResultData("F-1", "닉네임을 입력해주세요.");
		}

		if (param.get("cellphoneNo") == null) {
			return new ResultData("F-1", "핸드폰을 입력해주세요.");
		}

		if (param.get("email") == null) {
			return new ResultData("F-1", "이메일을 입력해주세요.");
		}

		return memberService.join(param);
	}

}
