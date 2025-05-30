package org.wn.weavenet.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.wn.weavenet.entity.SupportComment;

@Repository
public interface SupportCommentRepository extends JpaRepository<SupportComment, Long>{
	Optional<SupportComment> findBySbNum(Long sbNum);
}
