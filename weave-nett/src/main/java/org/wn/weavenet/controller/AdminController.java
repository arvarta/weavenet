package org.wn.weavenet.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wn.weavenet.config.UserDisplayHelper;
import org.wn.weavenet.dto.AdminMainRequestDto;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.service.AdminService;
import org.wn.weavenet.service.BoardService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api")
public class AdminController {
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	UserDisplayHelper userDisplayHelper;
	
	@Autowired
	AdminService adminService;
	
	@GetMapping("/admin/main")
    public String showAdminMain(Model model, HttpSession session, RedirectAttributes redirectAttributes) {
        User loginUser = (User) session.getAttribute("loginUser");

        // 1. 로그인 확인
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/api/user"; 
        }

        UserAuth auth = loginUser.getuAuth();
        if (auth != UserAuth.SUPER_ADMIN && auth != UserAuth.BOARD_MANAGER && auth != UserAuth.EMPLOYEE_MANAGER) {
             redirectAttributes.addFlashAttribute("error", "접근 권한이 없습니다.");
             return "redirect:/"; /** 임시 */
        }

        // 3. 관리자 이름 설정
        String adminName = userDisplayHelper.getDisplayName(loginUser.getuNum()); 
        model.addAttribute("adminName", adminName);

        AdminMainRequestDto dashboardData = adminService.getDashboardData();
        model.addAttribute("dashboardData", dashboardData);

        List<Board> boards = boardService.getActiveBoards();
        model.addAttribute("boards", boards);

        model.addAttribute("contentPage", "pages/adminInfo.jsp");

        return "admin_layout";
    }
}
