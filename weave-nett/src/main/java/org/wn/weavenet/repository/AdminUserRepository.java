package org.wn.weavenet.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.wn.weavenet.dto.UserRoleUpdateRequest;
import org.wn.weavenet.entity.User;

import jakarta.transaction.Transactional;

@Repository
public interface AdminUserRepository extends JpaRepository<User, Long> {

    // 2. 승인 상태 변경
    @Modifying
    @Transactional
    @Query(value = "UPDATE user SET u_status = 'APPROVED' WHERE u_num = :uNum", nativeQuery = true)
    void updateApproval(@Param("uNum") Long uNum);
    
//    // 2.1 승인 거절
//    @Modifying
//    @Transactional
//    @Query(value = "UPDATE user SET u_status = 'REJECTED' WHERE u_num = :uNum", nativeQuery = true)
//    void updateRejected(@Param("uNum") Long uNum);

    // 9. 유저 영구 삭제 / 거절
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM user WHERE u_num = :uNum", nativeQuery = true)
    void permanentlyDeleteUser(@Param("uNum") Long uNum);

	// 7. 유저 삭제 상태로 변경
	@Modifying
	@Transactional
	@Query(value = "UPDATE user SET u_status = 'INACTIVE' WHERE u_num = :uNum", nativeQuery = true)
	void markAsDeleted(@Param("uNum") Long uNum);

	// 8. 유저 삭제 취소
	@Modifying
	@Transactional
	@Query(value = "UPDATE user SET u_status = 'APPROVED' WHERE u_num = :uNum", nativeQuery = true)
	void restoreUser(@Param("uNum") Long uNum);

    // 3. 사원번호로 삭제
    @Modifying
    @Transactional
    @Query(value = "DELETE FROM user WHERE u_num = :uNum", nativeQuery = true)
    void deleteByEmployeeNumber(@Param("uNum") Long uNum);

    // 4. 사용자 상세 조회
    @Query(value = "SELECT * FROM user WHERE u_num = :uNum", nativeQuery = true)
    void selectUserDetail(@Param("uNum") Long uNum);

    // 5. 사용자 패널티 사유 조회
    @Query(value = "SELECT p.reason FROM penalty p WHERE p.u_num = :uNum", nativeQuery = true)
    List<String> selectPenalties(@Param("uNum") Long uNum);

    // 6. 역할/직급/권한 업데이트
    @Modifying
    @Transactional
    @Query(value = "UPDATE user SET u_rank = :uRank, u_auth = :uAuth WHERE u_num = :uNum", nativeQuery = true)
    void updateUserRole(@Param("uNum") Long uNum,
                        @Param("uRank") String uRank,
                        @Param("uAuth") String uAuth);
}
