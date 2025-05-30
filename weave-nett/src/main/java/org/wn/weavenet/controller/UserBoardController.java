package org.wn.weavenet.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wn.weavenet.config.UserDisplayHelper;
import org.wn.weavenet.dto.BoardRequestDto;
import org.wn.weavenet.dto.PagingInfo;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Post;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.BoardType;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.service.BoardRequestService;
import org.wn.weavenet.service.BoardService;
import org.wn.weavenet.service.PostService;

import jakarta.servlet.http.HttpSession;

//사용자 게시판 요청 컨트롤러
@Controller
@RequestMapping("/api/boards")
public class UserBoardController {

	@Autowired
	private BoardRequestService boardRequestService;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private PostService ps;
	
	@Autowired
	private UserDisplayHelper udh;

	@PostMapping
	public String requestBoard(@ModelAttribute BoardRequestDto boardRequestDto, 
			HttpSession session, RedirectAttributes redirectAttributes) {
		User loginUser = (User) session.getAttribute("loginUser");
	    
		if(boardRequestDto.getType() == BoardType.DEPARTMENT) {			
			Long deptNum = employeeRepository.getDeptNumByEmployeeNum(loginUser.geteNum());  // DB에서 부서 번호 조회
			Long existing = boardRepository.countByDeptNum(deptNum);
			
			if (existing > 0) {
	            redirectAttributes.addFlashAttribute("error", "해당 부서에는 이미 게시판이 존재합니다.");
	            return "redirect:/api/user/main";
	        }
			
			boardRequestDto.setDeptNum(deptNum);
		} else {
			boardRequestDto.setDeptNum(null);
		}
		
		boolean saved = boardRequestService.saveBoardRequest(boardRequestDto, loginUser);

		if (saved) {
		    redirectAttributes.addFlashAttribute("success", "게시판이 성공적으로 요청되었습니다.");
		} else {
		    redirectAttributes.addFlashAttribute("error", "게시판 요청 중 오류가 발생했습니다.");
		}
		return "redirect:/api/user/main";

	}
	
	@GetMapping("/{bNum}")
	public String viewBoard(
			@RequestParam(defaultValue = "0") int page,
    		@RequestParam(defaultValue = "10") int size,
    		@PathVariable Long bNum, 
    		@RequestParam(required = false) String keyword,
            @RequestParam(required = false) String condition,
    		Model model, HttpSession session,
			RedirectAttributes redirectAttributes) {
		
	    User loginUser = (User) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/api/user"; // 로그인 체크
	    }
	    
		String eNum = loginUser.geteNum();
	    if (eNum != null) {
	        Long deptNum = employeeRepository.getDeptNumByEmployeeNum(eNum);
	        model.addAttribute("deptNum", deptNum);
	    }
	    
	    boolean isSearching = (keyword != null && !keyword.isBlank()) && (condition != null && !condition.isBlank());

	    Page<Post> postPage;
	    
	    if (isSearching) {
	        postPage = ps.searchPostsByBoard(keyword, condition, bNum, page, size);
	    } else {
	    	// 페이징 처리된 게시글 목록 가져오기
	        postPage = ps.findPageOfActivePostsByBoardNum(bNum, page, size);
	    }
	    
	    // 페이징 보정
	    if (page >= postPage.getTotalPages() && postPage.getTotalPages() > 0) {
	        page = postPage.getTotalPages() - 1;
	        if (isSearching) {
	            postPage = ps.searchPostsByBoard(keyword, condition, bNum, page, size);
	        } else {
	            postPage = ps.findPageOfActivePostsByBoardNum(bNum, page, size);
	        }
	    }
	    
	 
	    model.addAttribute("postList", postPage.getContent());

	    // 페이징 정보 모델에 추가
	    PagingInfo pagingInfo = new PagingInfo(postPage);
	    model.addAttribute("paging", pagingInfo);
	   
	    List<Board> boards = boardService.getActiveBoards();
	    model.addAttribute("boards", boards);
	    
	    /*
	    // ===== [변경사항] ===========================================
	    List<Post> posts = ps.findAllActiveByBoard(bNum); 
	    model.addAttribute("postList", posts);  
	    */
	    // ============================================================
	    Map<Long, String> boardTitlesMap = new HashMap<>();
	    for (Board b : boards) {
	        boardTitlesMap.put(b.getbNum(), b.getbTitle());
	    }
	    model.addAttribute("boardTitlesMap", boardTitlesMap);
	    
	    List<String> writerNames = new ArrayList<>();
	    for (Post p : postPage.getContent()) {
	        writerNames.add(udh.getDisplayName(p.getuNum()));
	    }
	    model.addAttribute("writerNames", writerNames);
	   
	    
	    Board findBoard = boardRepository.findByBNum(bNum);
	    model.addAttribute("board", findBoard);
	    
	    if (!boardService.canAccessBoard(bNum, loginUser.getuNum())) {
	    	model.addAttribute("contentPage", "pages/access_controll.jsp");
	    	return "user_layout";
	    }
	    
	    // 검색어, 조건 뷰에 유지
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("condition", condition);
	    
	    model.addAttribute("contentPage", "pages/userPostList.jsp");
	    return "user_layout";
	}
	
	@GetMapping("/check-name")
	@ResponseBody
	public Map<String, Boolean> checkBoardName(@RequestParam String title) {
		String normalizedTitle = title.replaceAll("\\s+", "");

	    // 금지어 리스트도 공백 제거하여 준비
	    List<String> forbiddenWords = List.of("공지", "관리자").stream()
	        .map(s -> s.replaceAll("\\s+", ""))
	        .toList();

	    boolean hasForbidden = forbiddenWords.stream()
	        .anyMatch(normalizedTitle::contains);

	    boolean exists = boardService.existsBoardName(normalizedTitle);

	    return Map.of(
	    	"forbidden", hasForbidden,
	    	"exists", exists
	    );
	}
}
