package org.wn.weavenet.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.wn.weavenet.entity.Garbage;
import org.wn.weavenet.enums.DeletedStatus;

public interface GarbageRepository extends JpaRepository<Garbage, Long> {
    List<Garbage> findByGStatusAndGType(DeletedStatus status, String gType);
}

