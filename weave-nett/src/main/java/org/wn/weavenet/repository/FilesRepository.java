package org.wn.weavenet.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.wn.weavenet.entity.Pile;

public interface FilesRepository extends JpaRepository<Pile, Long>{
	List<Pile> findByPNum(Long pNum); 
}
