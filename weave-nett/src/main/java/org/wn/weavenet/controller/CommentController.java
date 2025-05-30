package org.wn.weavenet.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.wn.weavenet.dto.CommentRequestDTO;
import org.wn.weavenet.dto.CommentResponseDTO;
import org.wn.weavenet.dto.CommentUpdateRequestDTO;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.service.CommentService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api")
public class CommentController {

    private final CommentService commentService;

    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

   // 게시글에 대한 댓글 조회
   @GetMapping("/posts/{pNum}/comments")
    public List<CommentResponseDTO> getCommentsByPost(
    		@PathVariable Long pNum,
    		@RequestParam(defaultValue = "recent") String sort) {
    	return commentService.getCommentsByPNum(pNum, sort);
    }
    
   	// 댓글 작성
    @PostMapping("/posts/{pNum}/comments")
    public CommentResponseDTO addComment(@PathVariable Long pNum, @RequestBody CommentRequestDTO request, HttpSession session) {
    	User loginUser = (User) session.getAttribute("loginUser");
    	System.out.println("loginUser" + loginUser);
    	System.out.println(pNum);
    	System.out.println(request);
    	return commentService.addComment(pNum, request, session);
    }
    
    // 댓글 삭제
    @DeleteMapping("/comments/{id}")
    public ResponseEntity<Void> deleteComment(@PathVariable Long id) {
        commentService.softDeleteComment(id);
        return ResponseEntity.ok().build();
    }
    
    // 댓글 수정
    @PutMapping("/comments/{id}")
    public ResponseEntity<CommentResponseDTO> updateComment(
            @PathVariable("id") Long cNum,
            @RequestBody CommentUpdateRequestDTO request,
            HttpSession session) {
        CommentResponseDTO updated = commentService.updateComment(cNum, request, session);
        return ResponseEntity.ok(updated);
    }

      
}