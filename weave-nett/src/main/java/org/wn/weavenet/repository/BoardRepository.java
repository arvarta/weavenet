package org.wn.weavenet.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.wn.weavenet.entity.Board;

public interface BoardRepository extends JpaRepository<Board, Long> {
	List<Board> findByBStatus(String bStatus);
	
	@Query("SELECT CASE WHEN COUNT(b) > 0 THEN true ELSE false END FROM Board b WHERE REPLACE(b.bTitle, ' ', '') = :titleNoSpace")
	boolean existsByBTitle(@Param("titleNoSpace") String titleNoSpace);

	@Query("SELECT COUNT(b) FROM Board b WHERE b.bType = 'DEPARTMENT' AND b.deptNum = :deptNum AND b.bStatus = 'ACTIVE'")
	Long countByDeptNum(@Param("deptNum") Long deptNum);
	
	Board findByBNum(Long bNum);
}
