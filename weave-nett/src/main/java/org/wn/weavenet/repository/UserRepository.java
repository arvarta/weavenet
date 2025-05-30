package org.wn.weavenet.repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserStatus;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

	List<User> findByUNumIn(Collection<Long> uNums); // uNum 컬렉션에 포함된 사용자 목록 조회

	Optional<User> findByUEmail(String uEmail); // 이메일로 사용자 조회

	boolean existsByUEmail(String uEmail); // 이메일 존재 여부 확인

	@Query("SELECT u.uEmail FROM User u WHERE u.eNum = :eNum")
	Optional<String> findEEmailByENum(@Param("eNum") String eNum);

	Optional<User> findByENum(String eNum);

	@Query("SELECT u FROM User u WHERE u.uEmail = :email")
	Optional<User> findByEmail(@Param("email") String email);

	Optional<User> findByENumAndUStatus(String eNum, UserStatus uStatus);

	Optional<User> findByUNum(Long uNum);

	/** 방금 추가 함 */
	@Query("SELECT COUNT(u) FROM User u WHERE u.uStatus = :status")
	long countByUserStatusEnum(@Param("status") UserStatus status);
	
	List<User> findByENumIn(List<String> eNums);
}