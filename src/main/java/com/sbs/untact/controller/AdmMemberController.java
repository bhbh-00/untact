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
public class AdmMemberController extends BaseController {
	@Autowired
	private MemberService memberService;

	@RequestMapping("/adm/member/list")
	public String ShowList(@RequestParam(defaultValue = "1") int id, HttpServletRequest req) {
		Member member = memberService.getMember(id);

		req.setAttribute("member", member);

		return "/adm/member/list";

	}

	@RequestMapping("/adm/member/join")
	public String ShowJoin() {
		return "/adm/member/join";
	}

	@RequestMapping("/adm/member/doJoin")
	@ResponseBody
	public String doJoin(@RequestParam Map<String, Object> param) {

		if (param.get("loginId") == null) {
			return Util.msgAndBack("아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getMemberByloginId((String) param.get("loginId"));

		if (existingMember != null) {
			return Util.msgAndBack("이미 사용 중인 아이디입니다.");
		}

		if (param.get("loginPw") == null) {
			return Util.msgAndBack("비밀번호를 입력해주세요.");
		}
		if (param.get("name") == null) {
			return Util.msgAndBack("이름을 입력해주세요.");
		}

		if (param.get("nickname") == null) {
			return Util.msgAndBack("닉네임을 입력해주세요.");
		}

		if (param.get("cellphoneNo") == null) {
			return Util.msgAndBack("핸드폰을 입력해주세요.");
		}

		if (param.get("email") == null) {
			return Util.msgAndBack("이메일을 입력해주세요.");
		}

		memberService.join(param);

		String msg = String.format("%s님! 환영합니다.", param.get("nickname"));

		String redirectUrl = Util.ifEmpty((String) param.get("redirectUrl"), "../member/login");

		return Util.msgAndReplace(msg, redirectUrl);
	}

	@RequestMapping("/adm/member/doLogout")
	@ResponseBody
	public String doLogout(HttpSession session) {

		session.removeAttribute("loginedMemberId");

		return Util.msgAndReplace("로그아웃 되었습니다.", "../member/login");
	}

	@RequestMapping("/adm/member/login")
	public String ShowLogin() {
		return ("/adm/member/login");
	}

	@RequestMapping("/adm/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw, String redirectUrl, HttpSession session) {

		if (loginId == null) {
			return Util.msgAndBack("아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getMemberByloginId(loginId);

		if (existingMember == null) {
			return Util.msgAndBack("존재하지 않는 아이디입니다.");
		}

		if (loginPw == null) {
			return Util.msgAndBack("비밀번호를 입력해주세요.");
		}

		if (existingMember.getLoginPw().equals(loginPw) == false) {
			return Util.msgAndBack("비밀번호가 일치하지 않습니다.");
		}

		if (memberService.isAdmin(existingMember) == false) {
			return Util.msgAndBack("관리자만 접근 가능합니다.");
		}

		session.setAttribute("loginedMemberId", existingMember.getId());

		String msg = String.format("%s님! 환영합니다.", existingMember.getNickname());

		redirectUrl = Util.ifEmpty(redirectUrl, "../home/main");

		return Util.msgAndReplace(msg, redirectUrl);
	}
	
	@RequestMapping("/adm/member/modify")
	public String Modify() {
		return "/adm/member/modify";
	}


	@RequestMapping("/adm/member/doModify")
	@ResponseBody
	public ResultData doModify(@RequestParam Map<String, Object> param, HttpSession session) {

		if (param.isEmpty()) {
			return new ResultData("F-2", "수정할 정보를 입력해주세요.");
		}

		int loginedMember = (int) session.getAttribute("loginedMemberId");
		param.put("id", loginedMember);

		return memberService.modifyMember(param);
	}

}
