package org.wn.weavenet.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.wn.weavenet.entity.SupportComment;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.service.SupportCommentService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api/admin/supports/comment")
public class SupportCommentController {
	
	@Autowired
	private SupportCommentService scs;
	
    @PostMapping("/{sbNum}")
    @ResponseBody
    public ResponseEntity<Map<String, String>> writeSupportComment(
            @PathVariable Long sbNum, @RequestParam(required = false) String scContent, HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        SupportComment supportComment = new SupportComment();
        supportComment.setSbNum(sbNum);
        supportComment.setScContent(scContent);
        supportComment.setuNum(loginUser.getuNum()); 
        supportComment.setScRegDate(LocalDateTime.now());

        SupportComment saved = scs.save(supportComment);

        Map<String, String> response = new HashMap<>();
        response.put("regDate", saved.getScRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        response.put("scContent", saved.getScContent());

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
    
    @PutMapping("/{sbNum}")
    @ResponseBody
    public ResponseEntity<Map<String, String>> updateSupportComment(
           @PathVariable Long sbNum, @RequestParam(required = false) String scContent, HttpSession session) {

        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        if (loginUser.getuAuth() == UserAuth.USER) {
            return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }

        SupportComment existingComment = scs.findBySbNum(sbNum);
        if (existingComment == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        SupportComment updated;
        try {
            updated = scs.update(sbNum, scContent);
        } catch (IllegalStateException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        Map<String, String> response = new HashMap<>();
        response.put("regDate", updated.getScRegDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        response.put("scContent", updated.getScContent());

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}

