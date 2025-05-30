package org.wn.weavenet.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wn.weavenet.config.UserDisplayHelper;
import org.wn.weavenet.dto.BoardDto;
import org.wn.weavenet.dto.BoardListDto;
import org.wn.weavenet.dto.BoardRequestViewDto;
import org.wn.weavenet.dto.BoardUpdateRequestDto;
import org.wn.weavenet.entity.AddMember;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Department;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.Post;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.BoardType;
import org.wn.weavenet.repository.AddMemberRepository;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.DepartmentRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;
import org.wn.weavenet.service.BoardRequestService;
import org.wn.weavenet.service.BoardService;
import org.wn.weavenet.service.PostService;

import jakarta.servlet.http.HttpSession;

//관리자 게시판 등록 컨트롤러
@Controller
@RequestMapping("/api/admin/boards")
public class AdminBoardController {

	@Autowired
	private BoardService boardService;
	
	@Autowired
	private BoardRequestService boardRequestService;
	
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	@Autowired
	private AddMemberRepository addMemberRepository;
	
	@Autowired
	private DepartmentRepository departmentRepository;
	
	@Autowired
	private PostService ps;
	
	@Autowired
	private UserDisplayHelper udh;
	
	@PostMapping
	public String addBoard(@ModelAttribute BoardDto boardDto, 
							@RequestParam(required = false) String fromAdminPage,
							HttpSession session, RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
		if (boardDto.getType() == BoardType.DEPARTMENT) {
	        Long deptNum = boardDto.getDeptNum();
	        if (deptNum == null) {
	            redirectAttributes.addFlashAttribute("error", "부서를 선택해주세요.");
	            if ("true".equals(fromAdminPage)) {
	            	redirectAttributes.addFlashAttribute("contentPage", "pages/admin_boardList.jsp");
	                return "redirect:/api/admin/main";
	            } else {
	                return "redirect:/api/user/main";
	            }
	        } else if (boardRepository.countByDeptNum(deptNum) > 0) {
	            redirectAttributes.addFlashAttribute("error", "해당 부서에는 이미 게시판이 존재합니다.");
	            if ("true".equals(fromAdminPage)) {
	            	redirectAttributes.addFlashAttribute("contentPage", "pages/admin_boardList.jsp");
	                return "redirect:/api/admin/main";
	            } else {
	                return "redirect:/api/user/main";
	            }
	        } else {
	            boardDto.setDeptNum(deptNum); // 유효할 경우만 설정
	        }
	        
	    } else {
	        boardDto.setDeptNum(null); // 부서형이 아니면 무조건 null
	    }

	    // 게시판 생성 시도
	    try {
	        boardService.createBoard(boardDto, loginUser);
	        redirectAttributes.addFlashAttribute("success", "게시판이 성공적으로 추가되었습니다.");
	    } catch (Exception e) {
	        redirectAttributes.addFlashAttribute("error", "게시판 생성 중 오류가 발생했습니다.");
	    }
	    
	    if ("true".equals(fromAdminPage)) {
	    	redirectAttributes.addFlashAttribute("contentPage", "pages/admin_boardList.jsp");
	        return "redirect:/api/admin/main";
	    }

	    return "redirect:/api/user/main";
	}
	
	@GetMapping
	public String boardList(Model model) {
		
		List<Board> boards = boardService.getActiveBoards();
	    model.addAttribute("boards", boards);
		
	    List<BoardListDto> boardList = boardService.getBoardList();
		model.addAttribute("boardList", boardList);
		model.addAttribute("contentPage", "pages/admin_boardList.jsp");
		return "admin_layout";
	}
	
	@GetMapping("/request")
	public String requestBoardList(Model model) {
		
		List<Board> boards = boardService.getActiveBoards();
	    model.addAttribute("boards", boards);
		
	    List<BoardRequestViewDto> requestBoards = boardRequestService.getPendingRequestBoards();
		model.addAttribute("requestBoards", requestBoards);
		model.addAttribute("contentPage", "pages/admin_requestBoardList.jsp");
		return "admin_layout";
	}
	
	@PostMapping("/request/approve")
	@ResponseBody
	public Map<String, Object> approveBoardRequest(@RequestParam Long brNum) {
		Map<String, Object> response = new HashMap<>();
		
		String errorMsg = boardRequestService.approveRequest(brNum);
		
		if (errorMsg == null) {
	        response.put("success", true);
	        response.put("message", "요청이 승인되었습니다.");
	    } else {
	        response.put("success", false);
	        response.put("message", errorMsg);
	    }
	    return response;
	} 
	
	@PostMapping("/request/reject")
	@ResponseBody
	public Map<String, Object> rejectBoardRequest(@RequestParam Long brNum) {
		Map<String, Object> response = new HashMap<>();
		
		boolean result = boardRequestService.rejectRequest(brNum);
		
		if(result) {
			response.put("success", true);
			response.put("message", "요청이 거부되었습니다.");
		} else {
			response.put("success", false);
			response.put("message", "이미 처리된 요청입니다.");
		}
		return response;
	} 
	
	@PutMapping("/{bNum}")	
	@ResponseBody
	public Map<String, Object> updateBoard(@PathVariable Long bNum, @RequestBody BoardUpdateRequestDto boardUpdateRequestDto) {
		Map<String, Object> result = new HashMap<>();
		
		boardService.updateBoard(bNum, boardUpdateRequestDto);
		
		result.put("success", true);
		
		return result;
	}
	
	@DeleteMapping("/{bNum}")
	@ResponseBody
	public Map<String, Object> deleteBoard(@PathVariable Long bNum) {
	    Map<String, Object> result = new HashMap<>();

	    boolean deleted = boardService.deleteBoard(bNum);

	    result.put("success", deleted);
	    result.put("message", deleted ? "삭제 완료" : "삭제 실패");
	    return result;
	}
	
	@GetMapping("/{bNum}/data")
	@ResponseBody
	public ResponseEntity<?> getBoardData(@PathVariable Long bNum) {
	    Optional<Board> boardOpt = boardRepository.findById(bNum);
	    if (boardOpt.isEmpty()) {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND)
	                .body(Map.of("success", false, "message", "게시판을 찾을 수 없습니다."));
	    }

	    Board board = boardOpt.get();

	    // 1. 게시판에 속한 사용자들 조회
	    List<AddMember> addMembers = addMemberRepository.findByBNum(bNum);
	    List<Long> uNums = addMembers.stream().map(AddMember::getuNum).toList();

	    List<User> users = userRepository.findByUNumIn(uNums);

	    // 2. eNum으로 Employee 조회
	    List<String> eNums = users.stream()
	        .map(User::geteNum)
	        .filter(Objects::nonNull)
	        .toList();

	    List<Employee> employees = employeeRepository.findByENumIn(eNums);
	    Map<String, Employee> employeeMap = employees.stream()
	        .collect(Collectors.toMap(Employee::geteNum, e -> e));

	    // 3. 부서명까지 조립
	    List<Map<String, Object>> members = new ArrayList<>();
	    for (User user : users) {
	        String eNum = user.geteNum();
	        Employee emp = employeeMap.get(eNum);

	        if (emp != null) {
	            String deptName = null;
	            if (emp.getDeptNum() != null) {
	                Department dept = departmentRepository.findById(emp.getDeptNum()).orElse(null);
	                if (dept != null) deptName = dept.getDeptName();
	            }

	            Map<String, Object> m = new HashMap<>();
	            m.put("id", user.getuNum());
	            m.put("name", emp.geteName());
	            m.put("dept", deptName);
	            members.add(m);
	        }
	    }

	    // 4. JSON 구성
	    Map<String, Object> response = new HashMap<>();
	    
	    if (board.getDeptNum() != null) {
	        response.put("deptNum", board.getDeptNum());
	        Department dept = departmentRepository.findById(board.getDeptNum()).orElse(null);
	        if (dept != null) {
	            response.put("deptName", dept.getDeptName());
	        }
	    }
	    
	    response.put("bNum", board.getbNum());
	    response.put("bTitle", board.getbTitle());
	    response.put("bType", board.getbType().name());
	    response.put("members", members);
	    response.put("success", true);

	    return ResponseEntity.ok(response);
	}

	
	@GetMapping("/{bNum}")
	public String viewBoard(@PathVariable Long bNum, Model model, HttpSession session,
			RedirectAttributes redirectAttributes) {
	    User loginUser = (User) session.getAttribute("loginUser");
	    
		String eNum = loginUser.geteNum();

	    if (eNum != null) {
	        Long deptNum = employeeRepository.getDeptNumByEmployeeNum(eNum);
	        model.addAttribute("deptNum", deptNum);
	    }
	    
	    List<Board> boards = boardService.getActiveBoards();
	    model.addAttribute("boards", boards);
	   
	    // ===== [변경사항] ===========================================
	    List<Post> posts = ps.findAllActiveByBoard(bNum); 
	    model.addAttribute("postList", posts);  
	    // ============================================================
	    Map<Long, String> boardTitlesMap = new HashMap<>();
	    for (Board b : boards) {
	        boardTitlesMap.put(b.getbNum(), b.getbTitle());
	    }
	    model.addAttribute("boardTitlesMap", boardTitlesMap);
	    
	    List<String> writerNames = new ArrayList<>();
	    for (Post p : posts) {
	        writerNames.add(udh.getDisplayName(p.getuNum()));
	    }
	    model.addAttribute("writerNames", writerNames);
	   
	    
	    Board findBoard = boardRepository.findByBNum(bNum);
	    model.addAttribute("board", findBoard);
	    
	    if (loginUser == null || !boardService.canAccessBoard(bNum, loginUser.getuNum())) {
	    	model.addAttribute("contentPage", "pages/access_controll.jsp");
	    	return "user_layout";
	    }
	    
	    model.addAttribute("contentPage", "pages/adminPostList.jsp");
	    return "admin_layout";
	}
	
}
