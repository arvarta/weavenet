package org.wn.weavenet.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.wn.weavenet.entity.Comment;
import org.wn.weavenet.enums.DeletedStatus;

public interface CommentRepository extends JpaRepository<Comment, Long> {
	// 게시글 번호로 댓글 조회
	List<Comment> findByPNum(Long pNum); 
	
	// 댓글 정렬 - 최신순
	List<Comment> findByPNumOrderByCRegDateDesc(Long pNum);  
	// 댓글 정렬 - 등록순  
	List<Comment> findByPNumOrderByCRegDateAsc(Long pNum);
	
	// 댓글 고정 여부
	
	// 답글(부모댓글)
	List<Comment> findByParentIdOrderByCRegDateAsc(Long parentId);
	
	// 댓글 삭제(SOFT_DELETED)
	List<Comment> findByPNumAndCStatusNot(Long pNum, DeletedStatus excludedStatus);
	
	/** 방금 추가 함*/
	Long countByCRegDateBetween(LocalDateTime start, LocalDateTime end);
}
