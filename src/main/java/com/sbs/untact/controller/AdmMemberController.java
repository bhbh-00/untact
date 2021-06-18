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
public class AdmMemberController extends BaseController {
	@Autowired
	private MemberService memberService;
	@Autowired
	private GenFileService genFileService;
	
	// 비밀번호 찾기
	@RequestMapping("/adm/member/findLoginPw")
	public String ShowfindLoginPw() {
		return ("/adm/member/findLoginPw");
	}

	@RequestMapping("/adm/member/doFindLoginPw")
	@ResponseBody
	public String doFindLoginPw(HttpServletRequest req, String loginId, String email, String redirectUrl) {

		if (Util.isEmpty(redirectUrl)) {
			redirectUrl = "/adm/member/login";
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

	// 아이디 찾기
	@RequestMapping("/adm/member/findLoginId")
	public String ShowfindLoginId() {
		return ("/adm/member/findLoginId");
	}

	@RequestMapping("/adm/member/doFindLoginId")
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

	@RequestMapping("/adm/member/doDelete")
	@ResponseBody
	public ResultData doDelete(Integer id, HttpServletRequest req) {

		if (id == null) {
			return new ResultData("F-1", "id를 입력해주세요.");
		}

		Member member = memberService.getMember(id);

		if (member == null) {
			return new ResultData("F-1", "해당 회원은 존재하지 않습니다.");
		}

		return memberService.delete(id);
	}

	@RequestMapping("/adm/member/detail")
	public String showDetail(HttpServletRequest req, Integer id) {

		if (id == null) {
			return msgAndBack(req, "제목을 입력해주세요.");
		}

		Member member = memberService.getForPrintMember(id);

		if (member == null) {
			return msgAndBack(req, "해당 회원은 존재하지 않습니다.");
		}

		req.setAttribute("member", member);

		return "/adm/member/detail";
	}

	@RequestMapping("/adm/member/list")
	public String showList(HttpServletRequest req, @RequestParam Map<String, Object> param,
			@RequestParam(defaultValue = "1") int page) {

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

		// 한 페이지에 포함 되는 게시물의 갯수
		int itemsInAPage = 20;

		// 총 게시물의 갯수를 구하는
		int totleItemsCount = memberService.getMemberTotleCount(searchKeywordType, searchKeyword);

		// 총 페이지 갯수 (총 게시물 수 / 한 페이지 안의 게시물 갯수)
		int totlePage = (int) Math.ceil(totleItemsCount / (double) itemsInAPage);

		int pageMenuArmSize = 5;

		// 시작 페이지 번호
		int pageMenuStrat = page - pageMenuArmSize;

		// 시작 페이지가 1보다 작다면 시작 페이지는 1
		if (pageMenuStrat < 1) {
			pageMenuStrat = 1;
		}

		// 끝 페이지 페이지 번호
		int pageMenuEnd = page + pageMenuArmSize;

		if (pageMenuEnd > totlePage) {
			pageMenuEnd = totlePage;
		}

		List<Member> members = memberService.getForPrintMembers(searchKeywordType, searchKeyword, itemsInAPage,
				itemsInAPage, param);

		req.setAttribute("totleItemsCount", totleItemsCount);
		req.setAttribute("totlePage", totlePage);
		req.setAttribute("pageMenuArmSize", pageMenuArmSize);
		req.setAttribute("pageMenuStrat", pageMenuStrat);
		req.setAttribute("pageMenuEnd", pageMenuEnd);
		req.setAttribute("page", page);
		req.setAttribute("members", members);

		return "adm/member/list";
	}

	@RequestMapping("/adm/member/getLoginIdDup")
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
			return new ResultData("F-1", "아이디는 영문소문자와 숫자의 조합으로 구성되어야 합니다.");
		}

		Member existingMember = memberService.getMemberByLoginId(loginId);

		if (existingMember != null) {
			return new ResultData("F-2", String.format("%s(은)는 이미 사용중인 아이디 입니다.", loginId));
		}

		return new ResultData("S-1", String.format("%s(은)는 사용가능한 아이디 입니다.", loginId), "loginId", loginId);

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

		if (param.get("authLevel") == null) {
			return Util.msgAndBack("권한번호를 선택해주세요.");
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

		String msg = String.format("%s님! 가입을 환영합니다.", param.get("nickname"));

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

		Member member = memberService.getMemberByLoginId(loginId);

		if (member == null) {
			return Util.msgAndBack("존재하지 않는 아이디입니다.");
		}

		if (loginPw == null) {
			return Util.msgAndBack("비밀번호를 입력해주세요.");
		}

		if (member.getLoginPw().equals(loginPw) == false) {
			return Util.msgAndBack("비밀번호가 일치하지 않습니다.");
		}

		if (memberService.isAdmin(member) == false) {
			return Util.msgAndBack("관리자만 이용 가능합니다.");
		}

		session.setAttribute("loginedMemberId", member.getId());

		String msg = String.format("%s님! 환영합니다.", member.getNickname());

		redirectUrl = Util.ifEmpty(redirectUrl, "../home/main");

		boolean needToChangePassword = memberService.needToChangePassword(member.getId());

		if (needToChangePassword) {
			msg = "현재 비밀번호를 사용한지" + memberService.getNeedToChangePasswordFreeDays() + "일이 지났습니다. 비밀번호를 변경해주세요.";
			redirectUrl = "../member/mypage?id=" + member.getId();
		}

		boolean usingTempPassword = memberService.usingTempPassword(member.getId());

		if (usingTempPassword) {
			msg = "임시 비밀번호를 변경해주세요.";
			redirectUrl = "/usr/member/mypage?id=" + member.getId();
		}

		return Util.msgAndReplace(msg, redirectUrl);
	}

	@RequestMapping("/adm/member/modify")
	public String Modify(Integer id, HttpServletRequest req) {

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

		return "/adm/member/modify";
	}

	@RequestMapping("/adm/member/doModify")
	@ResponseBody
	public String doModify(Integer id, String loginPw, int authLevel, String name, String nickname,
			String cellphoneNo, String email, HttpSession session) {
		/*
		 * 기존의 session을 받으면 회원수정(로그인을 한 계정(관리자 1번)으로 덮어짐) 이러한 오류를 해결? 발생이 안되게 하기 위해서는
		 * int loginedMemberId = (int) req.getAttribute("loginedMemberId");
		 * param.put("id", loginedMemberId); -> 이게 없으면 됌!
		 */
		ResultData modifyMemberRd = memberService.modify(id, loginPw, authLevel, name, nickname,
				cellphoneNo, email);
		String redirectUrl = "/adm/member/list";

		return Util.msgAndReplace(modifyMemberRd.getMsg(), redirectUrl);
	}

}
