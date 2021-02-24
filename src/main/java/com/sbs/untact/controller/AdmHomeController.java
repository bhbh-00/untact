package com.sbs.untact.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AdmHomeController {
	@RequestMapping("/adm/home/main")
	@ResponseBody
	// http://localhost:8024/usr/home/main
	public String showMain() {
		return "ㅋㅋㅋ";
	}
}
