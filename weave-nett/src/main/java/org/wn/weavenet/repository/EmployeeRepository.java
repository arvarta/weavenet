package org.wn.weavenet.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.wn.weavenet.entity.Employee;

import io.lettuce.core.dynamic.annotation.Param;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, String> {

    @Query(value = "SELECT e_email FROM employee e WHERE e.e_num = :eNum", nativeQuery = true)
    String findEEmailByENum(@Param("eNum") String eNum);
    
    List<Employee> findByENumIn(Collection<String> eNums);
    
    List<Employee> findByDeptNum(Long deptNum);
	//Long findDeptNumById(String eNum);  // eNum을 기준으로 deptNum을 조회
	
	// 사원 번호를 기반으로 부서 번호를 조회하는 메서드
    @Query("SELECT e.deptNum FROM Employee e WHERE e.eNum = :eNum")
    Long getDeptNumByEmployeeNum(@Param("eNum") String eNum);
    
    Employee findByENum(String eNum);

	Optional<Employee> findByeNum(String eNum);
	
	List<Employee> findByENameContaining(String eName);
	
	 @Modifying
     @Transactional
     void deleteByENum(String eNum);
}
  