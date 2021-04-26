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

	@RequestMapping("/usr/member/findLoginId")
	public String ShowfindLoginId() {
		return ("/usr/member/findLoginId");
	}

	@RequestMapping("/usr/member/doFindLoginId")
	@ResponseBody
	public String dofindLoginId(HttpServletRequest req, String name, String email, String redirectUrl) {
		
		if (Util.isEmpty(redirectUrl)) {
			redirectUrl = "/";
        }

        Member member = memberService.getMemberByNameAndEmail(name, email);

        if (member == null) {
            return Util.msgAndBack("일치하는 회원이 존재하지 않습니다.");
        }

        return Util.msgAndBack(String.format("회원님의 아이디는 [ %s ] 입니다.", member.getLoginId()));
	}

	@RequestMapping("/usr/member/ConfirmPassword")
	public String ShowConfirmPassword() {
		return "/usr/member/ConfirmPassword";
	}

	@RequestMapping("/usr/member/doConfirmPassword")
	public String doConfirmPassword(String loginPw, HttpServletRequest req) {

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		if (loginPw == null) {
			return msgAndBack(req, "loginPw를 입력해주세요.");
		}

		Member member = memberService.getMemberByLoginPw(loginPw);

		if (loginedMember.getLoginPw().equals(loginPw) == false) {
			return msgAndBack(req, "비밀번호가 일치하지 않습니다.");
		}

		req.setAttribute("member", member);

		return msgAndReplace(req, String.format("마이페이지입니다.", member.getId()), "../member/detail?id=" + member.getId());
	}

	@RequestMapping("/usr/member/doDelete")
	@ResponseBody
	public ResultData doDelete(Integer id, HttpServletRequest req) {
		if (id == null) {
			return new ResultData("F-1", "id를 입력해주세요.");
		}

		Member member = memberService.getMember(id);

		if (member == null) {
			return new ResultData("F-1", "해당 회원은 존재하지 않습니다.");
		}

		return memberService.deleteMember(id);
	}

	@RequestMapping("/usr/member/detail")
	public String showDetail(HttpServletRequest req, Integer id) {
		if (id == null) {
			return msgAndBack(req, "id을 입력해주세요.");
		}

		Member member = memberService.getForPrintMember(id);

		if (member == null) {
			return msgAndBack(req, "해당 회원은 존재하지 않습니다.");
		}

		req.setAttribute("member", member);

		return "/usr/member/detail";
	}

	@RequestMapping("/usr/member/list")
	public String showList(HttpServletRequest req, @RequestParam Map<String, Object> param) {

		String searchKeywordType = (String) param.get("searchKeywordType");
		String searchKeyword = (String) param.get("searchKeyword");

		if (searchKeywordType != null) {
			searchKeywordType = searchKeywordType.trim();
		}

		if (searchKeywordType == null || searchKeywordType.length() == 0) {
			searchKeywordType = "name";
		}

		if (searchKeyword != null && searchKeyword.length() == 0) {
			searchKeyword = null;
		}

		if (searchKeyword != null) {
			searchKeyword = searchKeyword.trim();
		}

		if (searchKeyword == null) {
			searchKeywordType = null;
		}

		int itemsInAPage = 20;

		List<Member> members = memberService.getForPrintMembers(searchKeywordType, searchKeyword, itemsInAPage,
				itemsInAPage, param);

		req.setAttribute("members", members);

		return "usr/member/list";
	}

	@RequestMapping("/usr/member/getLoginIdDup")
	@ResponseBody
	public ResultData getLoginIdDup(String loginId) {

		if (loginId == null) {
			return new ResultData("F-5", "loginId를 입력해주세요.");
		}

		if (Util.allNumberString(loginId)) {
			return new ResultData("F-3", "로그인아이디는 숫자만으로 구성될 수 없습니다.");
		}

		if (Util.startsWithNumberString(loginId)) {
			return new ResultData("F-4", "로그인아이디는 숫자로 시작할 수 없습니다.");
		}

		if (loginId.length() < 5) {
			return new ResultData("F-5", "로그인아이디는 5자 이상으로 입력해주세요.");
		}

		if (loginId.length() > 20) {
			return new ResultData("F-6", "로그인아이디는 20자 이하로 입력해주세요.");
		}

		if (Util.isStandardLoginIdString(loginId) == false) {
			return new ResultData("F-1", "로그인아이디는 영문소문자와 숫자의 조합으로 구성되어야 합니다.");
		}

		Member existingMember = memberService.getMemberByLoginId(loginId);

		if (existingMember != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용중인 로그인아이디 입니다.", loginId));
		}

		return new ResultData("S-1", String.format("%s(은)는 사용가능한 로그인아이디 입니다.", loginId), "loginId", loginId);

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
	public String Modify(int id, HttpServletRequest req) {

		if (id == 0) {
			return msgAndBack(req, "회원 번호를 입력해주세요.");
		}

		Member member = memberService.getForPrintMember(id);

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
	public String doModify(@RequestParam Map<String, Object> param, HttpSession session) {
		/*
		 * 기존의 session을 받으면 회원수정(로그인을 한 계정(관리자 1번)으로 덮어짐) 이러한 오류를 해결? 발생이 안되게 하기 위해서는
		 * int loginedMemberId = (int) req.getAttribute("loginedMemberId");
		 * param.put("id", loginedMemberId); -> 이게 없으면 됌!
		 */
		ResultData modifyMemberRd = memberService.modifyMember(param);
		String redirectUrl = "/usr/home/main";

		return Util.msgAndReplace(modifyMemberRd.getMsg(), redirectUrl);
	}

}
