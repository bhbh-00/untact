package com.sbs.untact.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.sbs.untact.util.Util;

@Component("needLogoutInterceptor") // 컴포넌트 이름 설정
public class NeedLogoutInterceptor implements HandlerInterceptor {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		// 이 인터셉터 실행 전에 beforeActionInterceptor 가 실행되고 거기서 isLogined 라는 속성 생성
		// 그래서 여기서 단순히 request.getAttribute("isLogined"); 이것만으로 로그인 여부 알 수 있음
		boolean isLogined = (boolean) request.getAttribute("isLogined");

		boolean isAjax = (boolean) request.getAttribute("isAjax");
		
		if (isLogined) {
			String resultCode = "F-B";
			String resultMsg = "로그아웃 후 이용해주세요.";

			if (isAjax == false) {
				response.setContentType("application/json; charset=UTF-8");
				response.getWriter().append("{\"resultCode\":\"" + resultCode + "\",\"msg\":\"" + resultMsg + "\"}");
			} else {
				response.setContentType("text/html; charset=UTF-8");
				response.getWriter().append(Util.msgAndReplace(resultMsg, "../home/main"));
			}

			return false;
		}

		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}