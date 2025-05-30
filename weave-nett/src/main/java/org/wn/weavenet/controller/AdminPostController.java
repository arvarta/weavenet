package org.wn.weavenet.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wn.weavenet.config.UserDisplayHelper;
import org.wn.weavenet.dto.CommentResponseDTO;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.Pile;
import org.wn.weavenet.entity.Post;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.BoardType;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.DepartmentRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;
import org.wn.weavenet.service.BoardService;
import org.wn.weavenet.service.CommentService;
import org.wn.weavenet.service.FileService;
import org.wn.weavenet.service.PostService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/admin/posts")
public class AdminPostController {

	@Autowired
	private UserDisplayHelper udh;

	@Autowired
	private BoardService bs;

	@Autowired
	private PostService ps;

	@Autowired
	private CommentService cs;

	@Autowired
	private EmployeeRepository er;

	@SuppressWarnings("unused")
	@Autowired
	private UserRepository ur;

	@Autowired
	private BoardRepository br;

	@Autowired
	private DepartmentRepository dr;

	@Autowired
	private FileService fileService;

	private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	@GetMapping("/postList")
	public String goPostList(Model model, Long bNum, HttpSession session) {
		List<Post> posts;
		Board board = null;

		if (bNum == null) {
			posts = ps.findAllActive();
		} else {
			board = br.findByBNum(bNum);
			posts = ps.findAllActiveByBoard(bNum);
		}

		int activePostCount = posts.size();
		model.addAttribute("activePostCount", activePostCount);

		List<String> writerNames = new ArrayList<>();
		Map<Long, String> deptNamesMap = new HashMap<>(); // 부서 이름 맵 추가
		Map<Long, String> bTypeMap = new HashMap<>(); // 게시판 타입 맵 추가

		for (Post p : posts) {
			writerNames.add(udh.getDisplayName(p.getuNum()));

			Board postBoard = br.findByBNum(p.getbNum());
			if (postBoard != null) {
				bTypeMap.put(postBoard.getbNum(), postBoard.getbType().name());

				if ("DEPARTMENT".equals(postBoard.getbType().name()) && postBoard.getDeptNum() != null) {
					String deptName = dr.findById(postBoard.getDeptNum()).map(d -> d.getDeptName()).orElse("-");
					deptNamesMap.put(postBoard.getbNum(), deptName);
				} else {
					deptNamesMap.put(postBoard.getbNum(), "-");
				}
			} else {
				bTypeMap.put(p.getbNum(), "-");
				deptNamesMap.put(p.getbNum(), "-");
			}
		}

		List<Board> boards = bs.getActiveBoards();
		Map<Long, String> boardTitlesMap = new HashMap<>();
		for (Board b : boards) {
			boardTitlesMap.put(b.getbNum(), b.getbTitle());
		}

		session.setAttribute("deptNamesMap", deptNamesMap); // 세션에 추가
		model.addAttribute("boards", boards);
		model.addAttribute("board", board);
		model.addAttribute("postList", posts);
		model.addAttribute("writerNames", writerNames);
		model.addAttribute("boardTitlesMap", boardTitlesMap);
		model.addAttribute("contentPage", "pages/adminPostList.jsp");

		return "admin_layout";
	}

	@GetMapping("/boards/{bNum}")
	public String goBoardPosts(@PathVariable Long bNum, Model model, HttpSession session) {
		return goPostList(model, bNum, session);
	}

	@GetMapping("/postWrite")
	public String goPostWrite(Model model, Long bNum, HttpServletRequest request) {
		List<Board> boards = bs.getActiveBoards();
		Board findBoard = br.findByBNum(bNum);

		StringBuilder sb = new StringBuilder("[");
		for (int i = 0; i < boards.size(); i++) {
			Board b = boards.get(i);
			sb.append("{\"bNum\":").append(b.getbNum()).append(",\"bTitle\":\"")
					.append(b.getbTitle().replace("\"", "\\\"")).append("\"}");
			if (i != boards.size() - 1)
				sb.append(",");
		}
		sb.append("]");
		model.addAttribute("boardListJson", sb.toString());

		model.addAttribute("board", findBoard);
		model.addAttribute("boards", boards);
		model.addAttribute("contentPage", "pages/adminPostWrite.jsp");

		boolean isAdminPage = request.getRequestURI().contains("/api/admin");
		model.addAttribute("isAdminPage", isAdminPage);

		return "admin_layout";
	}

	@GetMapping("/{pNum}")
	public String goPostView(@PathVariable Long pNum, Model model, HttpSession session,
			RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
		Post p = ps.findByNum(pNum);

		if (p == null) {
			redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않는 게시글입니다.");
			return "redirect:/api/admin/error";
		}

		Board postBoard = bs.getBoardByBNum(p.getbNum());

		if (postBoard == null) {
			redirectAttributes.addFlashAttribute("errorMessage", "게시판 정보를 찾을 수 없습니다.");
			return "redirect:/api/admin/error";
		}

		boolean canView = false;
		boolean isNoticeBoard = postBoard.getbType() == BoardType.NOTICE;
		boolean isDepartmentBoard = postBoard.getbType() == BoardType.DEPARTMENT;

		if (loginUser != null) {
			String userAuthString = loginUser.getuAuth().name();
			Long findDeptNum = (loginUser.geteNum() != null) ? er.getDeptNumByEmployeeNum(loginUser.geteNum()) : null;

			boolean isAdmin = UserAuth.SUPER_ADMIN.name().equals(userAuthString)
					|| UserAuth.BOARD_MANAGER.name().equals(userAuthString)
					|| UserAuth.EMPLOYEE_MANAGER.name().equals(userAuthString);

			boolean isInMyDepartment = isDepartmentBoard && findDeptNum != null
					&& findDeptNum.equals(postBoard.getDeptNum());

			if (isAdmin || isNoticeBoard || isInMyDepartment || (!isDepartmentBoard && !isNoticeBoard)) {
				canView = true;
			}
		} else {
			if (isNoticeBoard) {
				canView = true;
			}
		}

		if (!canView) {
			model.addAttribute("contentPage", "pages/access_controll.jsp");
			return "admin_layout";
		}

		ps.increaseViews(pNum);
		String writerName = udh.getDisplayName(p.getuNum());

		if (loginUser != null) {
			String userAuthString = loginUser.getuAuth().name();
			model.addAttribute("userAuth", userAuthString);

			if (UserAuth.SUPER_ADMIN.name().equals(userAuthString)) {
				model.addAttribute("loginUserName", "admin");
			} else if (loginUser.geteNum() != null) {
				er.findById(loginUser.geteNum()).ifPresentOrElse(
						emp -> model.addAttribute("loginUserName", emp.geteName()),
						() -> model.addAttribute("loginUserName", udh.getDisplayName(loginUser.getuNum())));
			} else {
				model.addAttribute("loginUserName", udh.getDisplayName(loginUser.getuNum()));
			}
		} else {
			model.addAttribute("loginUserName", "");
			model.addAttribute("userAuth", "");
		}

		List<CommentResponseDTO> commentList = cs.getCommentsByPNum(pNum, "recent");
		List<Pile> filesList = fileService.getFilesByPost(pNum);
		List<Board> boards = bs.getActiveBoards();

		model.addAttribute("filesList", filesList);
		model.addAttribute("boards", boards);
		model.addAttribute("board", postBoard);
		model.addAttribute("commentList", commentList != null ? commentList : new ArrayList<>());
		model.addAttribute("pNum", pNum);
		model.addAttribute("p", p);
		model.addAttribute("writer", writerName);
		model.addAttribute("formattedDate", p.getpRegDate() != null ? p.getpRegDate().format(formatter) : "");
		model.addAttribute("loginUser", loginUser);
		model.addAttribute("contentPage", "pages/adminPostView.jsp");

		return "admin_layout";
	}

	@GetMapping("/{pNum}/edit")
	public String goSupportEdit(@PathVariable Long pNum, Model model, HttpSession session,
			RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			redirectAttributes.addFlashAttribute("error", "로그인이 필요합니다.");
			return "redirect:/api/user"; // 로그인 페이지로 리다이렉트 (관리자 로그인 페이지로 변경 가능)
		}

		Post p = ps.findByNum(pNum);

		if (p == null) {
			redirectAttributes.addFlashAttribute("error", "게시글을 찾을 수 없습니다.");
			return "redirect:/api/admin/posts/postList";
		}

		// 관리자만 수정 페이지 접근 허용 (SUPER_ADMIN 또는 BOARD_MANAGER)
		boolean isAdmin = loginUser.getuAuth() == UserAuth.SUPER_ADMIN
				|| loginUser.getuAuth() == UserAuth.BOARD_MANAGER;

		if (!isAdmin && !loginUser.getuNum().equals(p.getuNum())) { // 작성자도 수정 가능하도록 추가
			redirectAttributes.addFlashAttribute("error", "수정 권한이 없습니다.");
			return "redirect:/api/admin/posts/" + pNum;
		}

		List<Board> boards = bs.getActiveBoards();
		model.addAttribute("boards", boards);

		List<Pile> existingFiles = fileService.getFilesByPost(pNum); // 기존 파일 목록 조회
		model.addAttribute("existingFiles", existingFiles); // 모델에 추가

		model.addAttribute("p", p);
		model.addAttribute("board", br.findByBNum(p.getbNum())); // 현재 게시판 정보 추가
		model.addAttribute("contentPage", "pages/adminPostEdit.jsp");
		return "admin_layout";
	}

	@PostMapping("/{pNum}/update") // @PutMapping -> @PostMapping, @RequestBody 제거
	@ResponseBody
	public String updatePost(@PathVariable Long pNum, @RequestParam String pTitle, @RequestParam String pContent,
			@RequestParam(required = false) Long bNum, @RequestParam(required = false) List<MultipartFile> newFiles,
			@RequestParam(required = false) List<Long> deletedFileIds, HttpSession session) { // 파라미터 변경

		User loginUser = (User) session.getAttribute("loginUser");
		Post originalPost = ps.findByNum(pNum);

		if (originalPost == null) {
			return "postNotFound";
		}
		if (loginUser == null) {
			return "unauthorized_login";
		}

		boolean isAuthor = loginUser.getuNum().equals(originalPost.getuNum());
		boolean isAdmin = loginUser.getuAuth() == UserAuth.SUPER_ADMIN
				|| loginUser.getuAuth() == UserAuth.BOARD_MANAGER;

		if (!isAuthor && !isAdmin) {
			return "unauthorized_permission";
		}

		originalPost.setpTitle(pTitle);
		originalPost.setpContent(pContent);
		if (bNum != null) {
			originalPost.setbNum(bNum);
		}

		Post updatedPost = ps.update(originalPost);

		// 기존 파일 삭제
		if (deletedFileIds != null && !deletedFileIds.isEmpty()) {
			for (Long fileId : deletedFileIds) {
				fileService.deleteFile(fileId);
			}
		}

		// 새 파일 추가
		if (newFiles != null && !newFiles.isEmpty()) {
			try {
				if (!(newFiles.size() == 1 && newFiles.get(0).isEmpty())) {
					fileService.storeFiles(newFiles, updatedPost);
				}
			} catch (IOException e) {
				System.err.println("Admin File Upload Error: " + e.getMessage());
				return "fileUploadError";
			}
		}
		return "success";
	}

	@DeleteMapping("/{pNum}")
	@ResponseBody
	public String deletePost(@PathVariable Long pNum, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		Post original = ps.findByNum(pNum);

		if (original == null || loginUser == null) {
			return "unauthorized";
		}

		boolean isAuthor = loginUser.getuNum().equals(original.getuNum());
		boolean isAdmin = loginUser.getuAuth() == UserAuth.SUPER_ADMIN
				|| loginUser.getuAuth() == UserAuth.BOARD_MANAGER;

		if (!isAuthor && !isAdmin) {
			return "unauthorized";
		}

		ps.softDelete(pNum);
		return "success";
	}

	@GetMapping
	@ResponseBody
	public List<Post> getAllPost() {
		return ps.findAllActive();
	}

	@PostMapping
	public String writePost(Post post, @RequestParam List<MultipartFile> files, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/api/user";
		}

		@SuppressWarnings("unused")
		boolean isAdmin = loginUser.getuAuth() == UserAuth.SUPER_ADMIN
				|| loginUser.getuAuth() == UserAuth.BOARD_MANAGER;

		post.setuNum(loginUser.getuNum());

		Post savedPost = ps.save(post);

		// 파일 저장
		try {
			fileService.storeFiles(files, savedPost);
		} catch (IOException e) {
			e.printStackTrace();
			return "redirect:/api/admin/posts/postWrite?error=fileUploadFailed";
		}

		return "redirect:/api/admin/posts/" + savedPost.getpNum();
	}

	// 파일 다운로드 핸들러 추가
	@GetMapping("/download/{fileId}")
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@PathVariable Long fileId, HttpServletRequest request)
			throws UnsupportedEncodingException {
		Optional<Pile> fileOptional = fileService.getFileById(fileId);

		if (fileOptional.isPresent()) {
			Pile pile = fileOptional.get();
			try {
				Resource resource = fileService.loadFileAsResource(pile.getStoredFileName());

				String contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
				if (contentType == null) {
					contentType = "application/octet-stream";
				}

				String originalFileName = pile.getfName();
				String encodedFileName = URLEncoder.encode(originalFileName, StandardCharsets.UTF_8.toString())
						.replaceAll("\\+", "%20");

				return ResponseEntity.ok().contentType(MediaType.parseMediaType(contentType))
						.header(HttpHeaders.CONTENT_DISPOSITION,
								"attachment; filename=\"" + encodedFileName + "\"; filename*=UTF-8''" + encodedFileName)
						.body(resource);
			} catch (IOException ex) {
				System.err.println("File Download IO Error: " + ex.getMessage());
				return ResponseEntity.status(500).body(null);
			} catch (RuntimeException ex) {
				System.err.println("File Download Runtime Error: " + ex.getMessage());
				return ResponseEntity.notFound().build();
			}
		} else {
			return ResponseEntity.notFound().build();
		}
	}
}
