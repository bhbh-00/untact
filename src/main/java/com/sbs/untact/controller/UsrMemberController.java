package com.sbs.untact.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.dto.GenFile;
import com.sbs.untact.dto.Member;
import com.sbs.untact.dto.ResultData;
import com.sbs.untact.service.GenFileService;
import com.sbs.untact.service.MemberService;
import com.sbs.untact.util.Util;

@Controller
public class UsrMemberController extends BaseController {
	@Autowired
	private MemberService memberService;
	@Autowired
	private GenFileService genFileService;

	@RequestMapping("/usr/member/findLoginPw")
	public String ShowfindLoginPw() {
		return ("/usr/member/findLoginPw");
	}

	@RequestMapping("/usr/member/doFindLoginPw")
	@ResponseBody
	public String doFindLoginPw(HttpServletRequest req, String loginId, String email, String redirectUrl) {

		if (Util.isEmpty(redirectUrl)) {
			redirectUrl = "/usr/member/login";
		}

		Member member = memberService.getMemberByLoginId(loginId);

		if (member == null) {
			return Util.msgAndBack("일치하는 회원이 존재하지 않습니다.");
		}

		if (member.getEmail().equals(email) == false) {
			return Util.msgAndBack("일치하는 회원이 존재하지 않습니다.");
		}

		ResultData notifyTempLoginPwByEmailRs = memberService.notifyTempLoginPwByEmail(member);

		return Util.msgAndReplace(notifyTempLoginPwByEmailRs.getMsg(), redirectUrl);
	}

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

	@RequestMapping("/usr/member/checkPassword")
	public String ShowCheckPassword(HttpServletRequest req) {
		return "/usr/member/checkPassword";
	}

	// checkPasswordAuthCode : 체크비밀번호인증코드
	@RequestMapping("/usr/member/doCheckPassword")
	public String doCheckPassword(HttpServletRequest req, String loginPw, String checkPasswordAuthCode) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		ResultData checkValidCheckPasswordAuthCodeResultData = memberService
				.checkValidCheckPasswordAuthCode(loginedMember.getId(), checkPasswordAuthCode);

		if (checkValidCheckPasswordAuthCodeResultData.isFail()) {
			return msgAndBack(req, checkValidCheckPasswordAuthCodeResultData.getMsg());
		}

		if (loginPw == null) {
			return msgAndBack(req, "비밀번호를 입력해주세요.");
		}

		if (loginedMember.getLoginPw().equals(loginPw) == false) {
			return msgAndBack(req, "비밀번호가 일치하지 않습니다.");
		}

		return msgAndReplace(req, String.format("", loginedMember.getId()),
				"../member/myPage?id=" + loginedMember.getId());
	}

	@RequestMapping("/usr/member/delete")
	public String delete(Integer id, HttpServletRequest req) {

		if (id == null) {
			return msgAndBack(req, "id를 입력해주세요.");
		}

		Member member = memberService.getMember(id);

		if (member == null) {
			return msgAndBack(req, "존재하지 않는 회원입니다.");
		}

		return "/usr/member/delete";
	}

	@RequestMapping("/usr/member/doDelete")
	@ResponseBody
	public String doDelete(Integer id, HttpServletRequest req) {

		ResultData deleteMemberRd = memberService.deleteMember(id);
		
		String redirectUrl = "/usr/member/login";

		return Util.msgAndReplace(deleteMemberRd.getMsg(), redirectUrl);
	}

	@RequestMapping("/usr/member/myPage")
	public String showMyPage(HttpServletRequest req, Integer id, HttpSession session) {
		
		if (id == null) {
			return msgAndBack(req, "id를 입력해주세요.");
		}
				
		Member member = memberService.getForPrintMember(id);

		if (member == null) {
			return msgAndBack(req, "존재하지 않는 회원입니다.");
		}

		req.setAttribute("member", member);
		
		return "/usr/member/myPage";
	}

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

		Member existingMember = memberService.getMemberByLoginId(loginId);

		if (existingMember != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용 중인 아이디 입니다.", loginId));
		}

		return new ResultData("S-1", String.format("%s(은)는 사용 가능한 아이디 입니다.", loginId), "loginId", loginId);

	}

	@RequestMapping("/usr/member/join")
	public String ShowJoin() {
		return "/usr/member/join";
	}

	@RequestMapping("/usr/member/doJoin")
	@ResponseBody
	public String doJoin(@RequestParam Map<String, Object> param) {

		if (param.get("loginId") == null) {
			return Util.msgAndBack("아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getMemberByLoginId((String) param.get("loginId"));

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

	@RequestMapping("/usr/member/doLogout")
	@ResponseBody
	public String doLogout(HttpSession session) {

		session.removeAttribute("loginedMemberId");

		return Util.msgAndReplace("로그아웃 되었습니다.", "../member/login");
	}

	@RequestMapping("/usr/member/login")
	public String ShowLogin() {
		return ("/usr/member/login");
	}

	@RequestMapping("/usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw, String redirectUrl, HttpSession session) {

		if (loginId == null) {
			return Util.msgAndBack("아이디를 입력해주세요.");
		}

		Member existingMember = memberService.getMemberByLoginId(loginId);

		if (existingMember == null) {
			return Util.msgAndBack("존재하지 않는 아이디입니다.");
		}

		if (loginPw == null) {
			return Util.msgAndBack("비밀번호를 입력해주세요.");
		}

		if (existingMember.getLoginPw().equals(loginPw) == false) {
			return Util.msgAndBack("비밀번호가 일치하지 않습니다.");
		}

		session.setAttribute("loginedMemberId", existingMember.getId());

		String msg = String.format("%s님! 환영합니다.", existingMember.getNickname());

		redirectUrl = Util.ifEmpty(redirectUrl, "../home/main");

		return Util.msgAndReplace(msg, redirectUrl);
	}

	@RequestMapping("/usr/member/modify")
	public String Modify(HttpServletRequest req) {
		
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		Member member = memberService.getForPrintMember(loginedMember.getId());

		if (member == null) {
			return msgAndBack(req, "존재하지 않는 회원입니다.");
		}

		List<GenFile> files = genFileService.getGenFiles("member", member.getId(), "common", "attachment");

		Map<String, GenFile> filesMap = new HashMap<>();

		for (GenFile file : files) {
			filesMap.put(file.getFileNo() + "", file);
		}

		member.getExtraNotNull().put("file__common__attachment", filesMap);
		req.setAttribute("member", member);

		return "/usr/member/modify";
	}

	@RequestMapping("/usr/member/doModify")
	@ResponseBody
	public String doModify(@RequestParam Map<String, Object> param, HttpServletRequest req, HttpSession session) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (loginedMember.getId() == 0) {
			return msgAndBack(req, "회원 번호를 입력해주세요.");
		}

		Member member = memberService.getForPrintMember(loginedMember.getId());

		if (member == null) {
			return msgAndBack(req, "존재하지 않는 회원입니다.");
		}

		ResultData modifyMemberRd = memberService.modifyMember(param);

		return Util.msgAndReplace(modifyMemberRd.getMsg(), "../member/myPage");
	}

}
