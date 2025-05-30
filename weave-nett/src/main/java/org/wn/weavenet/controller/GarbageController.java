package org.wn.weavenet.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.wn.weavenet.service.GarbageService;

@Controller
@RequestMapping("/api/admin/garbage")
public class GarbageController {
    
    @Autowired
    private GarbageService gs; 
    
    @GetMapping("/garbageMain")
    public String garbageMain(@RequestParam(defaultValue = "board") String view, Model model) {
        String contentPage = "pages/garbageMain.jsp";
        String includePage;

        switch (view) {
            case "post":
                includePage = "garbagePostList.jsp";
                break;
            case "comment":
                includePage = "garbageCommentList.jsp";
                break;
            case "board":
            default:
                includePage = "garbageBoardList.jsp";
                break;
        }

        model.addAttribute("includePage", includePage);
        model.addAttribute("contentPage", contentPage);
        return "admin_layout";
    }

}
