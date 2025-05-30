package org.wn.weavenet.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.wn.weavenet.entity.BoardRequest;

public interface BoardRequestRepository extends JpaRepository<BoardRequest, Long> {
	List<BoardRequest> findByBrStatus(String brStatus);
	
}
