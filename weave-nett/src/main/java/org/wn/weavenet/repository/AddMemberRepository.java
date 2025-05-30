package org.wn.weavenet.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.wn.weavenet.entity.AddMember;

public interface AddMemberRepository extends JpaRepository<AddMember, Long> {
	boolean existsByBNumAndUNum(Long bNum, Long uNum);
	
	boolean existsByBrNumAndUNum(Long brNum, Long uNum);
	
	List<AddMember> findByBrNum(Long brNum);
	
    void deleteByBrNum(Long brNum);
    
    List<AddMember> findByBNum(Long bNum);
    
    void deleteByBNum(Long bNum);
    
    @Query("SELECT DISTINCT am.bNum FROM AddMember am WHERE am.uNum = :uNum AND am.bNum IS NOT NULL")
    List<Long> findBNumsByUNum(@Param("uNum") Long uNum);
}
