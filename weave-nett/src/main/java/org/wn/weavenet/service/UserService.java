package org.wn.weavenet.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.wn.weavenet.dto.EmployeeMyInformationDto;
import org.wn.weavenet.entity.Department;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.enums.UserRank;
import org.wn.weavenet.enums.UserRole;
import org.wn.weavenet.enums.UserStatus;
import org.wn.weavenet.repository.DepartmentRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;

import jakarta.transaction.Transactional;

@Service
public class UserService { // implements UserDetailsService

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	@Autowired
	private DepartmentRepository departmentRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private EmailService emailService;

	// 이메일 중복 확인
	public boolean existsByEmail(String email) {
		return userRepository.existsByUEmail(email);
	}

	public Optional<User> findUserByEEmail(String email) {
		return userRepository.findByEmail(email);
	}

	public Optional<User> findUserByENum(String eNum) {
		return userRepository.findByENum(eNum);
	}

	private String generateTempPassword() {
		return UUID.randomUUID().toString().substring(0, 8);
	}

	// e_num을 통해 이메일을 찾는 메서드
	public Optional<String> getEEmailByENum(String eNum) {
		return userRepository.findEEmailByENum(eNum);
	}

	/** 로그인 검증 */
	public boolean login(String eEmail, String uPassword) {
		Optional<User> userOptional = userRepository.findByUEmail(eEmail);

		if (userOptional.isEmpty()) {
			return false;
		}

		User user = userOptional.get();
		String encodedPasswordFromDB = user.getuPassword();

		if (encodedPasswordFromDB == null || encodedPasswordFromDB.isBlank()) {
			return false;
		}

		// 비밀번호만 검증
		return passwordEncoder.matches(uPassword, encodedPasswordFromDB);
	}

	@Transactional
	public boolean registerUser(User user) {
		try {
			System.out.println("registerUser 시작, 이메일: " + user.getuEmail());
			boolean exists = userRepository.existsByUEmail(user.getuEmail());
			System.out.println("existsByUEmail 결과: " + exists);
			if (exists) {
				System.out.println("[ERROR] 이미 가입된 이메일입니다: " + user.getuEmail());
				return false;
			}

			System.out.println("비밀번호 인코딩 전: " + user.getuPassword());
			user.setuPassword(passwordEncoder.encode(user.getuPassword()));
			System.out.println("비밀번호 인코딩 후: " + user.getuPassword());

			user.setuAuth(UserAuth.USER);
			user.setuRegDate(LocalDateTime.now());
			user.setuStatus(UserStatus.PENDING);
			user.setuRank(UserRank.GENERAL);
			user.setuRole(UserRole.MEMBER);

			User savedUser = userRepository.save(user);
			System.out.println("[REGISTER] 저장된 사용자 ID: " + savedUser.getuNum());

			return true;
		} catch (Exception e) {
			System.out.println("[ERROR] 회원가입 중 예외 발생: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}
	
	/** 실제 비밀번호 검사 */
	@Transactional 
    public Map<String, Object> changePassword(String eEmail, String currentPassword, String newPassword) {
        Map<String, Object> response = new HashMap<>();
        Optional<User> userOptional = userRepository.findByUEmail(eEmail);

        if (userOptional.isEmpty()) {
            response.put("success", false);
            response.put("message", "등록된 이메일이 아닙니다.");
            return response;
        }

        User user = userOptional.get();

        // --- 👇 현재 비밀번호 검증 로직 ---
        if (!passwordEncoder.matches(currentPassword, user.getuPassword())) {
            response.put("success", false);
            response.put("message", "현재 비밀번호가 일치하지 않습니다."); 
            return response;
        }
        // --- 👆 현재 비밀번호 검증 로직 ---

        if (passwordEncoder.matches(newPassword, user.getuPassword())) {
             response.put("success", false);
             response.put("message", "현재 비밀번호와 새 비밀번호는 같을 수 없습니다.");
             return response;
        }

        user.setuPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        response.put("success", true);
        response.put("message", "비밀번호가 변경되었습니다.");
        return response;
    }
	
	/** 비밀번호 변경 */
	public boolean resetPassword(String eEmail, String newPassword) {
		User user = userRepository.findByUEmail(eEmail).orElse(null);
		if (user != null) {
			user.setuPassword(passwordEncoder.encode(newPassword)); 
			userRepository.save(user);
			return true;
		}
		return false;
	}

	/** 비밀번호 찾기 */
	public boolean sendTempPassword(String eEmail) {
		Optional<User> optionalUser = userRepository.findByUEmail(eEmail);
		if (optionalUser.isPresent()) {
			User user = optionalUser.get();
			String tempPwd = generateTempPassword();
			user.setuPassword(passwordEncoder.encode(tempPwd));
			userRepository.save(user);
			emailService.sendMail(eEmail, "임시 비밀번호 안내", "임시 비밀번호: " + tempPwd);
			System.out.println("[임시] " + tempPwd);
			return true;
		}
		return false;
	}
	
	public EmployeeMyInformationDto getEmployeeDetailsForMyPage(Long uNum) {
	    Optional<User> userOptional = userRepository.findByUNum(uNum);

	    if (userOptional.isEmpty()) {
	        return null;
	    }
	    User user = userOptional.get();

	    EmployeeMyInformationDto dto = new EmployeeMyInformationDto();

	    dto.setuNum(user.getuNum());
	    dto.setuProfile(user.getuProfile());
	    dto.seteNum(user.geteNum());
	    dto.seteEmail(user.getuEmail());
	    if (user.getuRank() != null) {
	        dto.setuRank(user.getuRank().name());
	    }
	    if (user.getuAuth() != null) {
	        dto.setuAuth(user.getuAuth().name());
	    }

	    String employeeNumber = user.geteNum();
	    Employee employee = null;
	    if (employeeNumber != null && !employeeNumber.isBlank()) {
	        employee = employeeRepository.findByeNum(employeeNumber).orElse(null);
	    }

	    if (employee != null) { 
	        dto.seteName(employee.geteName());
	        dto.seteGrade(employee.geteGrade());
	        dto.setePosition(employee.getePosition());
	        dto.seteAddress(employee.geteAddress());
	        dto.seteJoinDate(employee.geteJoinDate()); 

	        if (employee.getDeptNum() != null) {
	            Department department = departmentRepository.findById(employee.getDeptNum()).orElse(null);
	            if (department != null) {
	                dto.setDeptName(department.getDeptName());
	            } else {
	                dto.setDeptName("부서 정보 없음");
	            }
	        } else {
	            dto.setDeptName("소속 부서 없음");
	        }
	    } else { 
	        if (user.getuAuth() == UserAuth.SUPER_ADMIN) {

	            dto.seteName("ADMIN"); 
	            dto.seteNum("-");
	            dto.setDeptName("-"); 
	            dto.seteGrade("-");
	            dto.setePosition("-"); 
	            dto.seteAddress("-");
	            dto.setuRank("-");
	            dto.seteJoinDate(user.getuRegDate() != null ? user.getuRegDate() : null);
	        } else {
	            dto.seteName(user.getuEmail()); 
	            dto.setDeptName("소속 없음");
	        }
	    }
	    return dto;
	}
	
	@Transactional
	public boolean updateUserProfileImagePath(Long uNum, String imagePath) {
	    Optional<User> userOptional = userRepository.findById(uNum); // JpaRepository 사용 시 findById
	    if (userOptional.isPresent()) {
	        User user = userOptional.get();
	        user.setuProfile(imagePath);
	        System.out.println("UserService.updateUserProfileImagePath : " + uNum + "\n" + imagePath);
	        userRepository.save(user);
	        return true;
	    }
	    return false;
	}



//	public User findUserByUNum(Long uNum) {
//        if (uNum == null) {
//            throw new IllegalArgumentException("사용자 번호를 조회 할 수 없습니다");
//        }
//
//        Optional<User> userOptional = userRepository.findByUNum(uNum);
//        return userOptional.orElse(null); 
//    }

}
