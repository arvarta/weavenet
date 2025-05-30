package org.wn.weavenet.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.wn.weavenet.entity.Post;
import org.wn.weavenet.enums.DeletedStatus;

public interface PostRepository extends JpaRepository<Post, Long> {
	int countByBNum(Long bNum);
	List<Post> findByBNum(Long bNum);
	
	@Query()
	List<Post> findByPStatusOrderByPRegDateDesc(DeletedStatus deletedStatus);
	List<Post> findByBNumAndPStatusOrderByPRegDateDesc(Long bNum, DeletedStatus status);
	
	
	// 페이징 처리된 게시글 전체 조회 (삭제 상태 제외)
    Page<Post> findByPStatusOrderByPRegDateDesc(DeletedStatus deletedStatus, Pageable pageable);

    // 특정 게시판(bNum) 게시글 페이징 조회
    Page<Post> findByBNumAndPStatusOrderByPRegDateDesc(Long bNum, DeletedStatus deletedStatus, Pageable pageable);
    
    Page<Post> findByPTitleContainingAndPStatus(String keyword, DeletedStatus status, Pageable pageable);
    
    Page<Post> findByUNumInAndPStatus(List<String> uNums, DeletedStatus status, Pageable pageable);
    
    Page<Post> findByUNumAndPStatus(Long uNums, DeletedStatus status, Pageable pageable);
    
    Page<Post> findByBNumAndUNumAndPStatus(Long bNum, Long uNum, DeletedStatus status, Pageable pageable);
    
    Page<Post> findByBNumAndPTitleContainingAndPStatus(Long bNum, String keyword, DeletedStatus status, Pageable pageable);
    
    Page<Post> findByBNumAndUNumInAndPStatus(Long bNum, List<String> uNums, DeletedStatus status, Pageable pageable);
    
	/** 방금 추가 함 */
	Long countByPRegDateBetween(LocalDateTime start, LocalDateTime end);
	

}

