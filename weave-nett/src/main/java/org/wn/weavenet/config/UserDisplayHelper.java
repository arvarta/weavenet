package org.wn.weavenet.config;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import org.wn.weavenet.dto.WriterDTO;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;

@Component
public class UserDisplayHelper {

    private final UserRepository userRepository;
    private final EmployeeRepository employeeRepository;

    public UserDisplayHelper(UserRepository userRepository, EmployeeRepository employeeRepository) {
        this.userRepository = userRepository;
        this.employeeRepository = employeeRepository;
    }

    public String getDisplayName(Long uNum) {
        if (uNum == null) return "알 수 없음";

        Optional<User> userOpt = userRepository.findById(uNum);
        if (userOpt.isEmpty()) return "알 수 없음";

        User user = userOpt.get();

        WriterDTO writer = new WriterDTO();
        
        System.out.println("유저 번호 : " + uNum);
        
        if (user.getuAuth() == UserAuth.SUPER_ADMIN) {
        	System.out.println("현재 사용자 권한 : " + user.getuAuth());
            writer.seteName("admin");
            return writer.geteName();
        } else if (user.getuAuth() == UserAuth.BOARD_MANAGER) {
        	System.out.println("현재 사용자 권한 : " + user.getuAuth());
            writer.seteName("admin");
            return writer.geteName();
        } else if (user.getuAuth() == UserAuth.EMPLOYEE_MANAGER) {
        	System.out.println("현재 사용자 권한 : " + user.getuAuth());
            writer.seteName("admin");
            return writer.geteName();
        } else {
            Optional<Employee> empOpt = employeeRepository.findById(user.geteNum());
            writer.seteName(empOpt.map(Employee::geteName).orElse("알 수 없음"));
            return writer.geteName();
        }
    }
    
    public List<String> findUNumsByWriterName(String keyword) {
        // 1. 이름으로 Employee 목록 검색
        List<Employee> employees = employeeRepository.findByENameContaining(keyword);
        List<String> eNums = employees.stream()
                                      .map(Employee::geteNum)
                                      .collect(Collectors.toList());

        if (eNums.isEmpty()) return Collections.emptyList();

        // 2. eNum으로 User 목록 검색
        List<User> users = userRepository.findByENumIn(eNums);

        // 3. uNum 리스트 추출
        return users.stream()
                    .map(u -> String.valueOf(u.getuNum()))
                    .collect(Collectors.toList());
    }

}


					/**
					if ("USER".equals(user.getuAuth())) {
					    return user.geteName();
					}
					*/