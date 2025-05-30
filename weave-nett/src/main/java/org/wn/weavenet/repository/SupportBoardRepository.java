package org.wn.weavenet.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.wn.weavenet.entity.SupportBoard;
import org.wn.weavenet.enums.DeletedStatus;

@Repository
public interface SupportBoardRepository extends JpaRepository<SupportBoard, Long> {

    // 삭제 상태 기준 정렬
    List<SupportBoard> findBySbDeletedOrderBySbRegDateDesc(DeletedStatus deletedStatus);
    
    
}
