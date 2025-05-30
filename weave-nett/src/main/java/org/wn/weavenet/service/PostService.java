package org.wn.weavenet.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.wn.weavenet.config.UserDisplayHelper;
import org.wn.weavenet.entity.Post;
import org.wn.weavenet.enums.DeletedStatus;
import org.wn.weavenet.repository.PostRepository;

import jakarta.transaction.Transactional;

@Service
public class PostService {
	
	@Autowired
	private PostRepository pr;
	
	@Autowired
    private UserDisplayHelper udh;

	@Transactional
	public Post save(Post post) {
		if(post.getpRegDate() == null) {
			post.setpRegDate(LocalDateTime.now());
		}
		if(post.getpStatus() == null) {
	    	post.setpStatus(DeletedStatus.ACTIVE);  
	    }
		
		return pr.save(post);
	}
	
	@Transactional
	public Post update(Post post) {
		Optional<Post> optionalBoard = pr.findById(post.getpNum());
		
		if(optionalBoard.isEmpty()) {
			throw new IllegalArgumentException("해당 게시글이 존재하지 않습니다.");
		}
		Post savedPost = optionalBoard.get();
		savedPost.setpTitle(post.getpTitle());
		savedPost.setpContent(post.getpContent());
		return savedPost;
	}
	
	@Transactional
	public void softDelete(Long pNum) {
		Post post = pr.findById(pNum).orElse(null);
		if(post == null) {
			throw new IllegalArgumentException("해당 문의 게시글이 존재하지 않습니다.");
			
		}
		post.setpStatus(DeletedStatus.SOFT_DELETED);
	}
	
	public List<Post> findAllActive() {
		return pr.findByPStatusOrderByPRegDateDesc(DeletedStatus.ACTIVE);
	}
	
	public List<Post> findAllActiveByBoard(Long bNum) {
		if (bNum == null) {
			return findAllActive();
		}
		return pr.findByBNumAndPStatusOrderByPRegDateDesc(bNum, DeletedStatus.ACTIVE);
	}
	
	public Post findByNum(Long pNum) {
		Optional<Post> post = pr.findById(pNum);
		return post.orElse(null);
	}
	
	// 페이징 처리된 전체 게시글 조회
    public Page<Post> findPageOfActivePosts(int page, int size) {
    	Pageable pageable = PageRequest.of(page, size, Sort.by("pRegDate").descending());
        return pr.findByPStatusOrderByPRegDateDesc(DeletedStatus.ACTIVE, pageable);
    }
    
    public Page<Post> findPageOfActivePostsByBoardNum(Long bNum, int page, int size) {
    	Pageable pageable = PageRequest.of(page, size, Sort.by("pRegDate").descending());
        return pr.findByBNumAndPStatusOrderByPRegDateDesc(bNum, DeletedStatus.ACTIVE, pageable);
    }

    // 특정 게시판 게시글 페이징 조회
    public Page<Post> findPageOfActivePostsByBoard(Long bNum, Pageable pageable) {
        return pr.findByBNumAndPStatusOrderByPRegDateDesc(bNum, DeletedStatus.ACTIVE, pageable);
    }
    
    public Page<Post> searchPosts(String keyword, String condition, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("pRegDate").descending());
        
        if ("title".equals(condition)) {
            return pr.findByPTitleContainingAndPStatus(keyword, DeletedStatus.ACTIVE, pageable);
        } else if ("writer".equals(condition)) {
        	if ("admin".equalsIgnoreCase(keyword)) {
                // admin 키워드면 uNum == 1 인 게시글만 조회
                return pr.findByUNumAndPStatus(1L, DeletedStatus.ACTIVE, pageable);
            }
        	
            List<String> uNums = udh.findUNumsByWriterName(keyword); // 별도 구현 필요
            return pr.findByUNumInAndPStatus(uNums, DeletedStatus.ACTIVE, pageable);
        }
        return Page.empty();
    }

    public Page<Post> searchPostsByBoard(String keyword, String condition, Long bNum, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("pRegDate").descending());
        
        if ("title".equals(condition)) {
            return pr.findByBNumAndPTitleContainingAndPStatus(bNum, keyword, DeletedStatus.ACTIVE, pageable);
        } else if ("writer".equals(condition)) {
        	if ("admin".equalsIgnoreCase(keyword)) {
                // admin 키워드면 uNum == 1 인 게시글만 조회
                return pr.findByBNumAndUNumAndPStatus(bNum, 1L, DeletedStatus.ACTIVE, pageable);
            }
        	
            List<String> uNums = udh.findUNumsByWriterName(keyword);
            return pr.findByBNumAndUNumInAndPStatus(bNum, uNums, DeletedStatus.ACTIVE, pageable);
        }
        return Page.empty();
    }
    
    @Transactional
	public void increaseViews(Long pNum) {
	    Post post = pr.findById(pNum).orElse(null);
		if(post == null) {
			throw new IllegalArgumentException("해당 게시글이 존재하지 않습니다.");
		}
	    post.setpViews(post.getpViews() + 1);
	}

    
}
