package org.wn.weavenet.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.wn.weavenet.entity.Department;

@Repository
public interface DepartmentRepository extends JpaRepository<Department, Long>{

	Optional<Department> findByDeptNum(Long deptNum);
	List<Department> findByDeptNumIn(Collection<Long> deptNums);
}
