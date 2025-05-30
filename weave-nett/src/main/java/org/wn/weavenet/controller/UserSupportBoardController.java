package org.wn.weavenet.controller;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.wn.weavenet.config.UserDisplayHelper;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.SupportBoard;
import org.wn.weavenet.entity.SupportComment;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.enums.UserRank;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;
import org.wn.weavenet.service.BoardService;
import org.wn.weavenet.service.SupportBoardService;
import org.wn.weavenet.service.SupportCommentService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/supports")
public class UserSupportBoardController {

	@Autowired
	private UserDisplayHelper udh;
	
    @Autowired 
    private SupportBoardService sbs;
    
    @Autowired 
    private SupportCommentService scs;
    
	@Autowired
	private BoardService bs;
    
    @Autowired 
    private EmployeeRepository er;

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @GetMapping("/supportList")
    public String goSupportList(Model model, HttpSession session) {
    	User loginUser = (User) session.getAttribute("loginUser");
    	
        List<SupportBoard> supportBoards = sbs.findAllActive();
        List<String> formattedDates = new ArrayList<>();
        List<String> writerNames = new ArrayList<>();

        for (SupportBoard sb : supportBoards) {
            formattedDates.add(sb.getSbRegDate() != null ? sb.getSbRegDate().format(formatter) : "");
            writerNames.add(udh.getDisplayName(sb.getuNum()));
        }
        
        List<Board> boards = bs.getActiveBoards();
        Map<Long, String> boardTitlesMap = new HashMap<>();
        for (Board b : boards) {
            boardTitlesMap.put(b.getbNum(), b.getbTitle());
        }        
        
        if (loginUser.getuRank() == UserRank.GENERAL || loginUser.getuRank() == UserRank.REGULAR || loginUser.getuRank() == UserRank.ELITE) {
        	model.addAttribute("boards", boards);
	    	model.addAttribute("contentPage", "pages/access_controll.jsp");
	    	return "user_layout";
	    }

        model.addAttribute("boards", boards);
        model.addAttribute("supportList", supportBoards);
        model.addAttribute("formattedDates", formattedDates);
        model.addAttribute("writerNames", writerNames);
        model.addAttribute("contentPage", "pages/userSupportList.jsp");

        return "user_layout";
    }

    @GetMapping("/supportWrite")
    public String goSupportWrite(Model model) {
    	List<Board> boards = bs.getActiveBoards();
	    model.addAttribute("boards", boards);
        model.addAttribute("contentPage", "pages/userSupportWrite.jsp");
        return "user_layout";
    }

    @GetMapping("/{sbNum}")
    public String goSupportView(@PathVariable Long sbNum, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        SupportBoard sb = sbs.findByNum(sbNum);

        String writerName = udh.getDisplayName(sb.getuNum());
        SupportComment sc = scs.findBySbNum(sbNum);
        
        if (loginUser != null) {
            String userAuthString = loginUser.getuAuth().name(); 
            model.addAttribute("userAuth", userAuthString); 

            if (UserAuth.SUPER_ADMIN.name().equals(userAuthString)) {
                model.addAttribute("loginUserName", "admin"); 
                System.out.println("총 관리자 로그인 확인: " + loginUser.getuNum()); 
            } else {
                Optional<Employee> empOpt = er.findById(loginUser.geteNum()); 
                if (empOpt.isPresent()) {
                    model.addAttribute("loginUserName", empOpt.get().geteName());
                } else {
                    model.addAttribute("loginUserName", udh.getDisplayName(loginUser.getuNum())); 
                }
            }
        } else {
            model.addAttribute("loginUserName", "");
            model.addAttribute("userAuth", ""); 
        }
        
        List<Board> boards = bs.getActiveBoards();
        Map<Long, String> boardTitlesMap = new HashMap<>();
        for (Board b : boards) {
            boardTitlesMap.put(b.getbNum(), b.getbTitle());
        }
        
        model.addAttribute("boards", boards);
        model.addAttribute("sb", sb);
        model.addAttribute("writer", writerName);
        model.addAttribute("sc", sc);
        model.addAttribute("formattedScDate", sc != null && sc.getScRegDate() != null ? sc.getScRegDate().format(formatter) : "");
        model.addAttribute("formattedDate", sb.getSbRegDate() != null ? sb.getSbRegDate().format(formatter) : "");
        model.addAttribute("loginUser", loginUser);
        model.addAttribute("contentPage", "pages/userSupportView.jsp");

        return "user_layout";
    }

    @GetMapping("/{sbNum}/edit")
    public String goSupportEdit(@PathVariable Long sbNum, Model model) {
        SupportBoard sb = sbs.findByNum(sbNum);
        List<Board> boards = bs.getActiveBoards();
	    model.addAttribute("boards", boards);
        model.addAttribute("sb", sb);
        model.addAttribute("contentPage", "pages/userSupportEdit.jsp");
        return "user_layout";
    }

    @PutMapping("/{sbNum}")
    @ResponseBody
    public String updateSupport(@PathVariable Long sbNum, @RequestBody SupportBoard supportBoard, HttpSession session, Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        SupportBoard original = sbs.findByNum(sbNum);

        if (original == null || loginUser == null || !loginUser.getuNum().equals(original.getuNum())) {
            return "unauthorized";
        }
        
        supportBoard.setSbNum(sbNum);
        supportBoard.setuNum(loginUser.getuNum());
        sbs.update(supportBoard);
        return "success";
    }

    @DeleteMapping("/{sbNum}")
    @ResponseBody
    public String deleteSupport(@PathVariable Long sbNum, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        SupportBoard original = sbs.findByNum(sbNum);

        if (original == null || loginUser == null || !loginUser.getuNum().equals(original.getuNum())) {
            return "unauthorized";
        }

        sbs.permanentlyDelete(sbNum);
        return "success";
    }

    @GetMapping
    @ResponseBody
    public List<SupportBoard> getAllSupportBoard() {
        return sbs.findAllActive();
    }

    @PostMapping
    public String writeSupportPost(SupportBoard supportBoard) {
        sbs.save(supportBoard);
        return "redirect:/api/supports/supportList";
    }
}
