package org.wn.weavenet.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wn.weavenet.dto.EmployeeMyInformationDto;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.service.BoardService;
import org.wn.weavenet.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api")
public class UserController {

	/** 프로필 이미지 저장 (application_properties) */
	@Value("${file.upload-dir.profile}")
	private String profileUploadDir;

	@Autowired
	private UserService userService;

	@Autowired
	private BoardService boardService;

	/** 내정보 보기 */
	@GetMapping("/user/myPage/{uNum}")
	public String goMyPage(@PathVariable Long uNum, Model model, HttpSession session, RedirectAttributes red) {
		Object sessionUserObject = session.getAttribute("loginUser");

		if (sessionUserObject == null) {
			red.addFlashAttribute("errorMessage", "세션이 만료되었습니다. 다시 로그인해주세요.");
			return "redirect:/api/user";
		}

		User loggedInUser;
		if (sessionUserObject instanceof User) {
			loggedInUser = (User) sessionUserObject;
		} else {
			red.addFlashAttribute("errorMessage", "세션 정보가 올바르지 않습니다. 다시 로그인해주세요.");
			return "redirect:/api/user";
		}

		Long loggedInUserNum = loggedInUser.getuNum();

		if (!loggedInUserNum.equals(uNum)) {
			return "error/error_403";
		}

		EmployeeMyInformationDto empDto = userService.getEmployeeDetailsForMyPage(loggedInUserNum);

		if (empDto == null) {
			System.out.println("빈 값 : " + loggedInUserNum);
			red.addFlashAttribute("errorMessage", "사용자 정보를 불러올 수 없습니다.");
			return "redirect:/api/user";
		}

		/** 관리자 레이아웃 다르게 수정 */

		List<Board> boards = boardService.getActiveBoards();

		model.addAttribute("boards", boards);
		model.addAttribute("empDto", empDto);
		
		switch (loggedInUser.getuAuth()) {
		case SUPER_ADMIN:
		case BOARD_MANAGER:
		case EMPLOYEE_MANAGER:
			model.addAttribute("contentPage", "pages/myPage.jsp");
			return "admin_layout";
		default:
			model.addAttribute("contentPage", "pages/myPage.jsp");
			return "user_layout";
		}
	}

	/** 프로필 이미지 수정 */
	@PostMapping("/user/profile/image/update/{uNum}")
	@ResponseBody
	public Map<String, Object> updateUserProfileImage(@PathVariable Long uNum,
			@RequestParam MultipartFile profileImageFile, HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		User sessionUser = (User) session.getAttribute("loginUser");
		if (sessionUser == null || !sessionUser.getuNum().equals(uNum)) {
			response.put("success", false);
			response.put("message", "프로필 이미지 변경 권한이 없습니다.");
			return response;
		}

		if (profileImageFile.isEmpty()) {
			response.put("success", false);
			response.put("message", "업로드된 파일이 없습니다.");
			return response;
		}

		try {
			String originalFilename = profileImageFile.getOriginalFilename();
			System.out.println("원래 파일 이름 : " + originalFilename);

			String extension = "";
			if (originalFilename != null && originalFilename.contains(".")) {
				extension = originalFilename.substring(originalFilename.lastIndexOf("."));
			}

			if (!extension.matches("\\.(?i)(jpg|jpeg|png|gif)$")) {
				response.put("success", false);
				response.put("message", "지원되지 않는 이미지 파일 형식입니다. (jpg, png, gif만 가능)");
				return response;
			}

			String uniqueFileName = UUID.randomUUID().toString() + "_" + uNum + extension;
			Path uploadPath = Paths.get(profileUploadDir);
			Path filePath = uploadPath.resolve(uniqueFileName);

			if (!Files.exists(uploadPath)) {
				Files.createDirectories(uploadPath);
			}

			Files.copy(profileImageFile.getInputStream(), filePath);

			String webAccessiblePath = "/uploads/profile_images/" + uniqueFileName;
			System.out.println("서버 반환 이미지 경로 : " + webAccessiblePath);

			boolean updateSuccess = userService.updateUserProfileImagePath(uNum, webAccessiblePath);

			if (updateSuccess) {
				response.put("success", true);
				response.put("message", "프로필 이미지가 성공적으로 업데이트되었습니다.");
				response.put("newImagePath", webAccessiblePath);

				sessionUser.setuProfile(webAccessiblePath);
				session.setAttribute("loginUser", sessionUser);
			} else {
				response.put("success", false);
				response.put("message", "데이터베이스 업데이트에 실패했습니다.");
				Files.deleteIfExists(filePath);
			}

		} catch (IOException e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "파일 저장 중 오류가 발생했습니다: " + e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "이미지 업데이트 중 알 수 없는 오류가 발생했습니다: " + e.getMessage());
		}
		return response;
	}

}
