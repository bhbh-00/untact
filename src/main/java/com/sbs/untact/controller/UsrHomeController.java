package com.sbs.untact.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.untact.util.Util;

@Controller
public class UsrHomeController {
	@RequestMapping("/usr/home/main")
	@ResponseBody
	// http://localhost:8024/usr/home/main
	public String showMain() {
		return "ㅋㅋㅋ";
	}
	
	// Get과 Post 테스트
	@RequestMapping("/usr/home/doFormTest")
	@ResponseBody
	public Map<String, Object> doFormTest(String name, int age) {
		return Util.mapOf("name", name, "age", age);
	}
}
