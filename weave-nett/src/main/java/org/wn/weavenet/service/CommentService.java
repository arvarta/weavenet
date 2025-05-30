package org.wn.weavenet.service;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.wn.weavenet.config.UserDisplayHelper;
import org.wn.weavenet.dto.CommentRequestDTO;
import org.wn.weavenet.dto.CommentResponseDTO;
import org.wn.weavenet.dto.CommentUpdateRequestDTO;
import org.wn.weavenet.entity.Comment;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.DeletedStatus;
import org.wn.weavenet.repository.CommentRepository;
import org.wn.weavenet.repository.UserRepository;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

@Service
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserDisplayHelper userDisplayHelper;
    private final UserRepository userRepository;

	public CommentService(CommentRepository commentRepository, UserDisplayHelper userDisplayHelper,
			UserRepository userRepository) {
		this.commentRepository = commentRepository;
		this.userDisplayHelper = userDisplayHelper;
		this.userRepository = userRepository;
	}

	// 게시글 번호로 댓글 조회
    public List<CommentResponseDTO> getCommentsByPNum(Long pNum, String sort) {
        List<Comment> comments;

        if ("oldest".equals(sort)) {
            comments = commentRepository.findByPNumOrderByCRegDateAsc(pNum); 	// 등록순
        } else {
            comments = commentRepository.findByPNumOrderByCRegDateDesc(pNum); 	// 최신순
        }

        return comments.stream()
                .filter(comment -> comment.getcStatus() == DeletedStatus.ACTIVE)
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    // Comment 엔티티를 CommentResponseDTO로 변환, 작성자 이름 조회 포함
    private CommentResponseDTO mapToDto(Comment comment) {
        String writerName = userDisplayHelper.getDisplayName(comment.getuNum());
        User user = userRepository.findById(comment.getuNum()).orElse(null);
        String profileUrl = (user != null && user.getuProfile() != null)
                         ? user.getuProfile()
                         : "/img/profile_default.png";
        
        return new CommentResponseDTO(
            comment.getcNum(),
            comment.getcContent(),
            comment.getcRegDate(),
            comment.getcStatus(),
            profileUrl,
            writerName,
            comment.getParentId(),
            comment.getuNum()
        );
    }

    // 댓글 작성
    @Transactional
    public CommentResponseDTO addComment(Long pNum, CommentRequestDTO request, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }

        Comment comment = new Comment();
        comment.setpNum(pNum);
        comment.setuNum(user.getuNum());
        comment.setcContent(request.getcContent());
        comment.setcStatus(DeletedStatus.ACTIVE);
        comment.setcRegDate(new Date());
        comment.setParentId(request.getParentId());  // 답글일 경우 부모 댓글 ID, 아니면 null

        Comment savedComment = commentRepository.save(comment);

        String finalWriterName = userDisplayHelper.getDisplayName(savedComment.getuNum());
        
        return new CommentResponseDTO(
            savedComment.getcNum(),
            savedComment.getcContent(),
            savedComment.getcRegDate(),
            savedComment.getcStatus(),
            finalWriterName,
            savedComment.getParentId(),
            savedComment.getcNum()
        );
    }

    // 답글 조회 (SOFT_DELETED 제외)
    public List<CommentResponseDTO> getRepliesByParentId(Long parentId) {
        List<Comment> replies = commentRepository.findByParentIdOrderByCRegDateAsc(parentId);

        // SOFT_DELETED 상태 제외
        return replies.stream()
            .filter(reply -> reply.getcStatus() == DeletedStatus.ACTIVE)
            .map(this::mapToDto)
            .collect(Collectors.toList());
    }
    
    // 댓글 삭제
    @Transactional
    public void softDeleteComment(Long cNum) {
        Comment comment = commentRepository.findById(cNum)
            .orElseThrow(() -> new EntityNotFoundException("댓글이 존재하지 않습니다."));
        
        // 부모 댓글 SOFT_DELETED 처리
        comment.setcStatus(DeletedStatus.SOFT_DELETED);

        // 답글 목록 가져오기
        List<Comment> replies = commentRepository.findByParentIdOrderByCRegDateAsc(cNum);

        // 답글들도 함께 SOFT_DELETED 처리
        for (Comment reply : replies) {
            reply.setcStatus(DeletedStatus.SOFT_DELETED);
        }
    }
    
    // 댓글 수정
    @Transactional
    public CommentResponseDTO updateComment(Long cNum, CommentUpdateRequestDTO request, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }

        Comment comment = commentRepository.findById(cNum)
            .orElseThrow(() -> new EntityNotFoundException("댓글이 존재하지 않습니다."));
        
        System.out.println("로그인 사용자 번호: " + user.getuNum());
        System.out.println("댓글 작성자 번호: " + comment.getuNum());
        System.out.println("로그인 사용자 권한: " + user.getuRole());


        // 작성자 본인인지 체크 (또는 관리자인지)
        if (!comment.getuNum().equals(user.getuNum()) && !isAdmin(user)) {
            throw new RuntimeException("댓글 수정 권한이 없습니다.");
        }

        comment.setcContent(request.getcContent());

        String writerName = userDisplayHelper.getDisplayName(comment.getuNum());

        return new CommentResponseDTO(
            comment.getcNum(),
            comment.getcContent(),
            comment.getcRegDate(),
            comment.getcStatus(),
            writerName,
            comment.getParentId(),
            comment.getuNum()
        );
    }

    @SuppressWarnings("unlikely-arg-type")
	private boolean isAdmin(User user) {
        return user.getuAuth() != null && (
            user.getuAuth().equals("SUPER_ADMIN") ||
            user.getuAuth().equals("BOARD_MANAGER") ||
            user.getuAuth().equals("EMPLOYEE_MANAGER")
        );
    }

}
