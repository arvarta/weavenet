package org.wn.weavenet.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.service.BoardService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api")
public class ViewController {
	
	@Autowired
	private BoardService boardService;
	@Autowired
	private EmployeeRepository employeeRepository;

	@GetMapping("/user/main")
	public String main(Model model, HttpSession session, 
			@ModelAttribute String contentPage,
			RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
		
		if (loginUser == null) {
		    // 로그인 안한 사용자가 다른 경로로 이동시 로그인 페이지로 리다이렉트
		    redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
		    return "redirect:/api/user";  
		}
		
		String eNum = loginUser.geteNum();
	    String eName = "";

	    if (eNum != null) {
	        Employee employee = employeeRepository.findById(eNum).orElse(null);
	        eName = (employee != null) ? employee.geteName() : "";
	        session.setAttribute("eName", eName);
	        
	        Long deptNum = employeeRepository.getDeptNumByEmployeeNum(eNum);
	        session.setAttribute("deptNum", deptNum);
	    }
		
		List<Board> boards = boardService.getActiveBoards();
		List<Employee> members = boardService.getAllMembers();
		
		if (contentPage == null || contentPage.isEmpty()) {
	        contentPage = "pages/userPostList.jsp";
	    }
		
	    model.addAttribute("contentPage", contentPage);
		model.addAttribute("loginUser", loginUser);
		model.addAttribute("boards", boards);
		model.addAttribute("members", members);
		return "user_layout";
	}
	
	@GetMapping("/location")
	public String location(Model model) {
		List<Board> boards = boardService.getActiveBoards();
		model.addAttribute("boards", boards);
		model.addAttribute("contentPage", "pages/location.jsp");
		return "user_layout";
	}
	
	@GetMapping("/error")
	public String goError(Model model) {
		List<Board> boards = boardService.getActiveBoards();
		model.addAttribute("boards", boards);
		model.addAttribute("contentPage", "pages/access_controller_post.jsp");
		return "user_layout";
	}
	
	@GetMapping("/admin/error")
	public String goAdminError(Model model) {
		List<Board> boards = boardService.getActiveBoards();
		model.addAttribute("boards", boards);
		model.addAttribute("contentPage", "pages/access_controller_post.jsp");
		return "admin_layout";
	}
}

