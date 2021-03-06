package com.sbs.untact.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.sbs.untact.util.Util;

import lombok.extern.slf4j.Slf4j;

@Component("needAdminInterceptor") // 컴포넌트 이름 설정
@Slf4j
public class NeedAdminInterceptor implements HandlerInterceptor {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		// 이 인터셉터 실행 전에 beforeActionInterceptor 가 실행되고 거기서 isLogined 라는 속성 생성
		// 그래서 여기서 단순히 request.getAttribute("isLogined"); 이것만으로 로그인 여부 알 수 있음
		boolean isAdmin = (boolean) request.getAttribute("isAdmin");

		// 이 인터셉터 실행 전에 beforeActionInterceptor 가 실행되고 거기서 isAjax 라는 속성 생성
		// 그래서 여기서 단순히 request.getAttribute("isAjax"); 이것만으로 해당 요청이 ajax인지 구분 가능
		boolean isAjax = (boolean) request.getAttribute("isAjax");

		if (isAdmin == false) {
			String authKeyStatus = (String) request.getAttribute("authKeyStatus");

			String resultCode = "F-A";
			String resultMsg = "관리자만 이용 가능합니다.";

			if (authKeyStatus.equals("invalid")) {
				resultCode = "F-B";
				resultMsg = "인증키가 올바르지 않습니다.";
			}

			if (isAjax == false) {
				response.setContentType("application/json; charset=UTF-8");
				response.getWriter().append("{\"resultCode\":\"" + resultCode + "\",\"msg\":\"" + resultMsg + "\"}");
			} else {
				response.setContentType("text/html; charset=UTF-8");
				response.getWriter().append(Util.msgAndReplace(resultMsg, "../member/login"));
			}

			return false;
		}

		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}
