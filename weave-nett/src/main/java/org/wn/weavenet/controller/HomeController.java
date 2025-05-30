package org.wn.weavenet.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	@GetMapping({"/"})
	public String home(Model model) {
		model.addAttribute("contentPage", "pages/login.jsp");
		model.addAttribute("message", "위브넷 사원만 로그인 가능합니다.");
//		System.out.println("home.jsp");
		return "main";
	}
}
