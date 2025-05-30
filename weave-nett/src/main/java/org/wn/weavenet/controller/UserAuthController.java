package org.wn.weavenet.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.enums.UserStatus;
import org.wn.weavenet.service.EmployeeService;
import org.wn.weavenet.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api")
public class UserAuthController {

	@Autowired
	private UserService userService;

	@Autowired
	private EmployeeService employeeService; // 회원가입 시 사용

	/** 로그인 화면 진입 */
	@GetMapping("/user")
	public String goLogin(Model model, @RequestParam(required = false) String sessionExpired) {
		model.addAttribute("contentPage", "pages/login.jsp");
		model.addAttribute("message", "위브넷 사원만 로그인 가능합니다");
		if ("true".equals(sessionExpired)) {
			model.addAttribute("errorMessage", "세션이 만료되었거나 로그인이 필요합니다. 다시 로그인해주세요.");
		}
		return "main";
	}

	/** 회원가입 성공 화면 진입 */
	@PostMapping("/user/join/success")
	public String registerSuccess(Model model) {
		model.addAttribute("contentPage", "pages/login.jsp");
		model.addAttribute("message", "가입신청이 완료되었습니다.");
		return "main";
	}

	/** 로그인 처리 */
	/**
	 * SUPER_ADMIN EMAIL : w05256442@gmail.com PW : 123!@#
	 * 
	 */
	@PostMapping("/user/login")
	public String doLogin(@RequestParam String eEmail, @RequestParam String uPassword, Model model,
			HttpSession session) {

		model.addAttribute("message", "위브넷 사원만 로그인가능합니다");

		boolean loginSuccess = userService.login(eEmail, uPassword);

		if (loginSuccess) {
			Optional<User> optionalUser = userService.findUserByEEmail(eEmail);

			if (!optionalUser.isPresent()) {
				model.addAttribute("errorMessage", "사용자 정보를 불러 올 수 없습니다.");
				model.addAttribute("contentPage", "pages/login.jsp");
				return "main";
			}

			User user = optionalUser.get();

			// 사용자 상태에 따른 처리 (PENDING, INACTIVE, REJECTED)
			if (user.getuStatus() == UserStatus.PENDING) {
				model.addAttribute("errorMessage", "승인 대기중입니다.");
				model.addAttribute("contentPage", "pages/login.jsp");
				System.out.println("승인대기중 : " + user.getuEmail());
				return "main";
			}

			if (user.getuStatus() == UserStatus.INACTIVE) {
				model.addAttribute("errorMessage", "비활성화된 계정입니다.");
				model.addAttribute("contentPage", "pages/login.jsp");
				return "main";
			}

			if (user.getuStatus() == UserStatus.REJECTED) {
				model.addAttribute("errorMessage", "승인이 거절된 계정입니다.");
				model.addAttribute("contentPage", "pages/login.jsp");
				System.out.println("승인 거절 : " + user.getuEmail());
				return "main";
			}

			// 로그인 성공 및 활성 사용자: 세션 설정 및 리디렉션
			session.setAttribute("loginUser", user);
			session.setAttribute("loginAuth", user.getuAuth());

			// 권한에 따라 다른 메인 페이지로 리디렉션
			if (user.getuAuth() == UserAuth.SUPER_ADMIN || user.getuAuth() == UserAuth.EMPLOYEE_MANAGER
					|| user.getuAuth() == UserAuth.BOARD_MANAGER) {

				System.out.println("[DEBUG] 관리자 이메일 : " + user.getuEmail());
				System.out.println("[DEBUG] 관리자 권한 : " + user.getuAuth());
				return "redirect:/api/admin/main";

			} else { // 일반 사용자 (USER)
				System.out.println("승인허가 : " + user.getuEmail());
				System.out.println("현재 권한 : " + user.getuAuth());
				return "redirect:/api/posts/postList";
			}

		} else { // 로그인 실패
			model.addAttribute("errorMessage", "이메일이 존재하지 않거나 비밀번호가 틀렸습니다.");
			model.addAttribute("contentPage", "pages/login.jsp");
			return "main";
		}
	}

	/** 로그아웃 처리 */
	@GetMapping("/user/logout")
	public String doLogout(HttpSession session) {
		session.invalidate(); // 세션 무효화
		return "redirect:/api/user"; // 로그인 페이지로 리디렉션
	}

	/** 회원가입 화면 진입 */
	@GetMapping("/users")
	public String goJoin(Model model) {
		model.addAttribute("message", "등록된 이메일로 회원가입 해주세요");
		model.addAttribute("contentPage", "pages/join.jsp");
		return "main";
	}

	/** 회원가입 처리 */
	@PostMapping("/users/signup")
	public String doJoin(@RequestParam("number") String eNum, @RequestParam("password") String uPassword, Model model,
			HttpSession session) {

		Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
		String signupEmail = (String) session.getAttribute("signupEmail");
		// 사원 번호로 등록된 이메일 조회 (EmployeeService 사용)
		String registeredEmail = employeeService.findEEmailByENum(eNum);

		if (emailVerified == null || !emailVerified) {
			model.addAttribute("errorMessage", "이메일 인증이 완료되지 않았습니다.");
			model.addAttribute("contentPage", "pages/join.jsp");
			return "main";
		}

		if (signupEmail == null || signupEmail.isEmpty()) {
			model.addAttribute("errorMessage", "세션에 이메일 정보가 없습니다. 다시 시도해주세요.");
			model.addAttribute("contentPage", "pages/join.jsp");
			return "main";
		}

		if (registeredEmail == null || !registeredEmail.equals(signupEmail)) {
			model.addAttribute("errorMessage", "입력하신 사원번호와 인증된 이메일이 일치하지 않습니다.");
			model.addAttribute("contentPage", "pages/join.jsp");
			return "main";
		}

		User user = new User();
		user.setuEmail(signupEmail);
		user.seteNum(eNum);
		user.setuPassword(uPassword); // 비밀번호는 서비스에서 암호화

		try {
			boolean success = userService.registerUser(user);

			if (!success) {
				model.addAttribute("errorMessage", "이미 등록된 이메일이거나 회원가입에 실패했습니다.");
				model.addAttribute("contentPage", "pages/join.jsp");
				return "main";
			}

			session.removeAttribute("signupEmail");
			session.removeAttribute("emailVerified");

			return "forward:/api/user/join/success"; // 가입 성공 페이지로 포워딩

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMessage", "회원가입 중 오류가 발생했습니다.");
			model.addAttribute("contentPage", "pages/join.jsp");
			return "main";
		}
	}

	/** 비밀번호 찾기로 이동 */
	@GetMapping("/user/password")
	public String goFindPassword(Model model) {
		model.addAttribute("contentPage", "pages/findPassword.jsp");
		return "main";
	}

	/** 비밀번호 찾기 */
	@PostMapping("/user/password")
	@ResponseBody
	public Map<String, Object> findPassword(@RequestParam String eEmail) {
		boolean result = userService.sendTempPassword(eEmail);
		Map<String, Object> response = new HashMap<>();
		response.put("success", result);
		response.put("message", result ? "임시 비밀번호가 발송되었습니다." : "등록된 이메일이 아닙니다.");
		return response;
	}

	/** 비밀번호 재설정 */
	/**@PathVariable("uNum")Long myPageNumber,*/
	@GetMapping("/user/password/reset")
	public String goResetPassword(Model model, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		
		if (loginUser == null) {
			return "redirect:/api/user?sessionExpired=true";
		}
		
		model.addAttribute("uNum", loginUser.getuNum());
		model.addAttribute("eEmail", loginUser.getuEmail());
		model.addAttribute("message", "새로운 비밀번호를 입력해주세요");
		model.addAttribute("errorMessage", "새로운 비밀번호랑 기존 비밀번호는 같을 수 없습니다.");
		
		model.addAttribute("contentPage", "/WEB-INF/views/pages/resetPassword.jsp");
		if (loginUser.getuAuth() == UserAuth.SUPER_ADMIN) {
			return "admin_layout";
		} else {
			return "user_layout";
		}
	}

	/** 비밀번호 재설정 */
	@PostMapping("/user/password/reset")
    @ResponseBody
    public Map<String, Object> processPasswordReset( 
            @RequestParam String eEmail, 
            @RequestParam String currentPassword, 
            @RequestParam String newPassword) {
        
        // UserService의 새 메서드 호출
        Map<String, Object> response = userService.changePassword(eEmail, currentPassword, newPassword);
        
        return response;
    }
}











