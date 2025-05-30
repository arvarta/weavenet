package org.wn.weavenet.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
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
import org.wn.weavenet.dto.PagingInfo;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Department; // 추가됨
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.Pile;
import org.wn.weavenet.entity.Post;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.BoardType;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.DepartmentRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository; // 추가됨
import org.wn.weavenet.service.BoardService;
import org.wn.weavenet.service.CommentService;
import org.wn.weavenet.service.FileService;
import org.wn.weavenet.service.PostService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/posts")
public class UserPostController {

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

	@Autowired
	private BoardRepository br;

	@Autowired
	private DepartmentRepository dr;

	@Autowired
	private FileService fileService;

	private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	@GetMapping("/postList")
    public String goPostList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long bNum,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String condition,
            Model model,
            HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/api/user";
        }

        Board board = null;
        Page<Post> postPage;

        boolean isSearching = keyword != null && !keyword.isBlank() && condition != null;

        if (isSearching) {
            if (bNum != null && bNum > 0) {
                board = br.findByBNum(bNum);
                postPage = ps.searchPostsByBoard(keyword, condition, bNum, page, size);
            } else {
                postPage = ps.searchPosts(keyword, condition, page, size);
            }
        } else {
            if (bNum != null && bNum > 0) {
                board = br.findByBNum(bNum);
                postPage = ps.findPageOfActivePostsByBoardNum(bNum, page, size);
            } else {
                postPage = ps.findPageOfActivePosts(page, size);
            }
        }

        if (page >= postPage.getTotalPages() && postPage.getTotalPages() > 0) {
            page = postPage.getTotalPages() - 1;
            if (isSearching) {
                if (bNum != null && bNum > 0) {
                    postPage = ps.searchPostsByBoard(keyword, condition, bNum, page, size);
                } else {
                    postPage = ps.searchPosts(keyword, condition, page, size);
                }
            } else {
                if (bNum != null && bNum > 0) {
                    postPage = ps.findPageOfActivePostsByBoardNum(bNum, page, size);
                } else {
                    postPage = ps.findPageOfActivePosts(page, size);
                }
            }
        }

        PagingInfo pagingInfo = new PagingInfo(postPage);
        model.addAttribute("paging", pagingInfo);

        String eNum = loginUser.geteNum();
        if (eNum != null) {
            Employee employee = er.findById(eNum).orElse(null);
            session.setAttribute("eName", (employee != null) ? employee.geteName() : "");
            Long deptNum = er.getDeptNumByEmployeeNum(eNum);
            session.setAttribute("deptNum", deptNum);
        }

        List<Post> posts = postPage.getContent();
        model.addAttribute("activePostCount", postPage.getTotalElements());

        List<String> writerNames = new ArrayList<>();
        Map<Long, String> deptNamesMap = new HashMap<>();
        Map<Long, String> bTypeMap = new HashMap<>(); // bTypeMap 추가

        for (Post p : posts) {
            writerNames.add(udh.getDisplayName(p.getuNum()));
            Board postBoard = br.findByBNum(p.getbNum());
            if (postBoard != null) {
                bTypeMap.put(postBoard.getbNum(), postBoard.getbType().name()); // bType 추가

                if (BoardType.DEPARTMENT.equals(postBoard.getbType()) && postBoard.getDeptNum() != null) {
                    String deptName = dr.findById(postBoard.getDeptNum())
                            .map(Department::getDeptName)
                            .orElse("-");
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
        Map<Long, String> boardTitlesMap = boards.stream().collect(Collectors.toMap(Board::getbNum, Board::getbTitle));

        session.setAttribute("deptNamesMap", deptNamesMap);
        model.addAttribute("bTypeMap", bTypeMap); 
        model.addAttribute("boards", boards);
        model.addAttribute("board", board);
        model.addAttribute("postList", posts);
        model.addAttribute("writerNames", writerNames);
        model.addAttribute("boardTitlesMap", boardTitlesMap);
        model.addAttribute("contentPage", "pages/userPostList.jsp");

        model.addAttribute("keyword", keyword);
        model.addAttribute("condition", condition);

        return "user_layout";
    }

	@GetMapping("/boards/{bNum}")
	public String goBoardPosts(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size,
			@PathVariable Long bNum, @RequestParam(required = false) String keyword,
			@RequestParam(required = false) String condition, Model model, HttpSession session) {
		return goPostList(page, size, bNum, keyword, condition, model, session);
	}

	@GetMapping("/postWrite")
	public String goPostWrite(Model model, @RequestParam(required = false) Long bNum, RedirectAttributes rttr,
			HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/api/user";
		}

		List<Board> boards = bs.getActiveBoards();
		Board findBoard = (bNum != null) ? br.findByBNum(bNum) : null;

		// 공지사항 작성 권한 체크
		if (findBoard != null && findBoard.getbType().equals(BoardType.NOTICE)
				&& !(loginUser.getuAuth().equals(UserAuth.SUPER_ADMIN)
						|| loginUser.getuAuth().equals(UserAuth.BOARD_MANAGER))) {
			rttr.addFlashAttribute("error", "공지사항에는 관리자만 글을 작성할 수 있습니다.");
			return "redirect:/api/posts/boards/" + bNum;
		}

		// 게시판 목록 JSON 생성
		StringBuilder sb = new StringBuilder("[");
		for (int i = 0; i < boards.size(); i++) {
			Board b = boards.get(i);
			sb.append("{\"bNum\":").append(b.getbNum()).append(",\"bTitle\":\"")
					.append(b.getbTitle().replace("\"", "\\\"")).append("\"}");
			if (i < boards.size() - 1)
				sb.append(",");
		}
		sb.append("]");
		model.addAttribute("boardListJson", sb.toString());

		// 프로젝트 게시판 정보 (두 번째 코드 기능)
		List<Long> projectBoardNums = bs.getProjectBoardNumsByUser(loginUser.getuNum());
		String projectBoardNumsStr = projectBoardNums.stream().map(String::valueOf).collect(Collectors.joining(","));
		model.addAttribute("projectBoardNumsStr", projectBoardNumsStr);

		model.addAttribute("board", findBoard);
		model.addAttribute("boards", boards);
		model.addAttribute("contentPage", "pages/userPostWrite.jsp");
		return "user_layout";
	}

	@GetMapping("/{pNum}")
	public String goPostView(@PathVariable Long pNum, Model model, HttpSession session,
			RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
		
		Long findDeptNum = er.getDeptNumByEmployeeNum(loginUser.geteNum());
		Post p = ps.findByNum(pNum);

		if (p == null) {
			redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않는 게시글입니다.");
			return "redirect:/api/posts/postList";
		}

		Board postBoard = bs.getBoardByBNum(p.getbNum());

		if (postBoard == null) {
			redirectAttributes.addFlashAttribute("errorMessage", "게시판 정보를 찾을 수 없습니다.");
			return "redirect:/api/posts/postList";
		}

		boolean canView = false;

		if (postBoard.getbType() != BoardType.DEPARTMENT) {
			canView = true;
		} else {
			if (loginUser != null) {
				String userAuthString = loginUser.getuAuth().name();

				if (UserAuth.SUPER_ADMIN.name().equals(userAuthString)
						|| UserAuth.BOARD_MANAGER.name().equals(userAuthString)
						|| findDeptNum == postBoard.getDeptNum()) {
					canView = true;
				}
			}
		}

		if (!canView) {
			redirectAttributes.addFlashAttribute("contentPage", "pages/access_controll.jsp");
			return "redirect:/api/error";
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
		}

		List<CommentResponseDTO> commentList = cs.getCommentsByPNum(pNum, "recent");
		List<Board> boards = bs.getActiveBoards();
		List<Pile> filesList = fileService.getFilesByPost(pNum);

		model.addAttribute("filesList", filesList);
		model.addAttribute("boards", boards);
		model.addAttribute("commentList", commentList != null ? commentList : new ArrayList<>());
		model.addAttribute("pNum", pNum);
		model.addAttribute("p", p);
		model.addAttribute("writer", writerName);
		model.addAttribute("formattedDate", p.getpRegDate() != null ? p.getpRegDate().format(formatter) : "");
		model.addAttribute("loginUser", loginUser);
		model.addAttribute("contentPage", "pages/userPostView.jsp");

		return "user_layout";
	}

	@GetMapping("/{pNum}/edit")
	public String goSupportEdit(@PathVariable Long pNum, Model model, HttpSession session,
			RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			redirectAttributes.addFlashAttribute("error", "로그인이 필요합니다.");
			return "redirect:/api/user";
		}

		Post p = ps.findByNum(pNum);

		if (p == null) {
			redirectAttributes.addFlashAttribute("error", "게시글을 찾을 수 없습니다.");
			return "redirect:/api/posts/postList";
		}

		// 작성자 또는 관리자만 수정 페이지 접근 허용 (권한 체크 강화)
		boolean isAuthor = loginUser.getuNum().equals(p.getuNum());
		boolean isAdmin = loginUser.getuAuth() == UserAuth.SUPER_ADMIN
				|| loginUser.getuAuth() == UserAuth.BOARD_MANAGER;

		if (!isAuthor && !isAdmin) {
			redirectAttributes.addFlashAttribute("error", "수정 권한이 없습니다.");
			return "redirect:/api/posts/" + pNum;
		}

		List<Board> boards = bs.getActiveBoards();
		List<Pile> existingFiles = fileService.getFilesByPost(pNum); // 기존 파일 목록

		model.addAttribute("boards", boards);
		model.addAttribute("existingFiles", existingFiles); // 기존 파일 목록 추가
		model.addAttribute("p", p);
		model.addAttribute("board", br.findByBNum(p.getbNum()));
		model.addAttribute("contentPage", "pages/userPostEdit.jsp");
		return "user_layout";
	}

	@PostMapping("/{pNum}/update")
	@ResponseBody
	public String updatePost(@PathVariable Long pNum, @RequestParam String pTitle, @RequestParam String pContent,
			@RequestParam(required = false) Long bNum, @RequestParam(required = false) List<MultipartFile> newFiles,
			@RequestParam(required = false) List<Long> deletedFileIds, HttpSession session) { // RedirectAttributes는
																								// @ResponseBody와 함께 의미
																								// 없음

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

		// 파일 삭제
		if (deletedFileIds != null && !deletedFileIds.isEmpty()) {
			deletedFileIds.forEach(fileService::deleteFile);
		}

		// 새 파일 추가
		if (newFiles != null && !newFiles.isEmpty() && !(newFiles.size() == 1 && newFiles.get(0).isEmpty())) {
			try {
				fileService.storeFiles(newFiles, updatedPost);
			} catch (IOException e) {
				e.printStackTrace(); // 로깅 필요
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

		if (original == null) {
			return "notFound"; // 게시글 없음
		}
		if (loginUser == null) {
			return "unauthorized"; // 로그인 안됨
		}

		boolean isAuthor = loginUser.getuNum().equals(original.getuNum());
		boolean isAdmin = loginUser.getuAuth() == UserAuth.SUPER_ADMIN
				|| loginUser.getuAuth() == UserAuth.BOARD_MANAGER;

		if (!isAuthor && !isAdmin) {
			return "unauthorized"; // 권한 없음
		}

		ps.softDelete(pNum); // 파일은 softDelete 시 삭제하지 않음 (정책에 따라 변경 가능)
		return "success";
	}

	@GetMapping
	@ResponseBody
	public List<Post> getAllPost() {
		// 이 API는 페이징 없이 모든 글을 반환하므로, 사용 목적에 따라 유지하거나 삭제/수정 필요
		return ps.findAllActive();
	}

	@Transactional
	@PostMapping
	public String writePost(Post post, @RequestParam(required = false) List<MultipartFile> files, HttpSession session,
			RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/api/user";
		}

		// 게시판 선택 유효성 검사
		if (post.getbNum() == null) {
			redirectAttributes.addFlashAttribute("error", "게시판을 선택해주세요.");
			return "redirect:/api/posts/postWrite";
		}

		// 공지사항 작성 권한 재확인
		Board targetBoard = br.findByBNum(post.getbNum());
		if (targetBoard != null && targetBoard.getbType().equals(BoardType.NOTICE)
				&& !(loginUser.getuAuth().equals(UserAuth.SUPER_ADMIN)
						|| loginUser.getuAuth().equals(UserAuth.BOARD_MANAGER))) {
			redirectAttributes.addFlashAttribute("error", "공지사항에는 관리자만 글을 작성할 수 있습니다.");
			return "redirect:/api/posts/postWrite?bNum=" + post.getbNum();
		}

		post.setuNum(loginUser.getuNum());
		Post savedPost = ps.save(post);

		// 파일 저장 (파일이 없어도 오류 나지 않도록 처리)
		if (files != null && !files.isEmpty() && !(files.size() == 1 && files.get(0).isEmpty())) {
			try {
				fileService.storeFiles(files, savedPost);
			} catch (IOException e) {
				e.printStackTrace(); // 로깅 필요
				redirectAttributes.addFlashAttribute("error", "파일 업로드 중 오류가 발생했습니다.");
				// 게시글은 저장되었으므로, 게시글 보기로 이동하거나,
				// 트랜잭션 처리를 통해 게시글 저장도 롤백하는 것이 더 안전할 수 있음.
				return "redirect:/api/posts/" + savedPost.getpNum();
			}
		}

		return "redirect:/api/posts/" + savedPost.getpNum(); // 작성된 게시글 보기로 이동
	}

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

			} catch (MalformedURLException ex) {
				return ResponseEntity.status(500).body(null);
			} catch (IOException ex) {
				// 파일 로드 실패 (파일이 없을 수 있음)
				return ResponseEntity.notFound().build();
			} catch (RuntimeException ex) {
				// loadFileAsResource에서 파일이 없을 때 RuntimeException 발생 시
				return ResponseEntity.notFound().build();
			}
		} else {
			return ResponseEntity.notFound().build();
		}
	}
}