package org.wn.weavenet.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.wn.weavenet.dto.EmployeeAddRequest;
import org.wn.weavenet.dto.UserRoleUpdateRequest;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.repository.AdminUserRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;

@Service
public class AdminUserService {
	
	@Autowired
    private AdminUserRepository adminUserRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private EmployeeRepository employeeRepository;

    public List<User> getUserList() {
    	List<User> users = adminUserRepository.findAll();
    	System.out.println("users: " + users);
    	return users;
    }

    public void approveUser(Long uNum) {
        adminUserRepository.updateApproval(uNum); 
    }

    public void getUserInfo(Long uNum) {
        adminUserRepository.selectUserDetail(uNum);
    }

    public List<String> getUserPenalties(Long uNum) {
        return adminUserRepository.selectPenalties(uNum);
    }

    public void updateUserRole(Long uNum, UserRoleUpdateRequest request) {
        adminUserRepository.updateUserRole(
        		uNum,
	            request.getuRank().name(),
	            request.getuAuth().name()
	           );
    }

    public void markUserAsDeleted(Long uNum) {
        adminUserRepository.markAsDeleted(uNum);
    }
    
    public void restoreUser(Long uNum) {
        adminUserRepository.restoreUser(uNum);
    }
    
    /** 영구삭제 및 거부 */
    @Transactional
    public void permanentlyDeleteUser(Long uNum) {
        Optional<User> userOptional = userRepository.findById(uNum);

        if (userOptional.isPresent()) {
            User userToDelete = userOptional.get();
            String eNum = userToDelete.geteNum(); 
            if (eNum != null) {
                employeeRepository.deleteById(eNum);
            }

            adminUserRepository.permanentlyDeleteUser(uNum);
        } else {
            System.out.println("삭제할 사용자(uNum: " + uNum + ")를 찾을 수 없습니다.");
            adminUserRepository.permanentlyDeleteUser(uNum); 
        }
    }

    public User findUserByUNum(Long uNum) {
        if (uNum == null) {
            throw new IllegalArgumentException("사용자 번호를 조회 할 수 없습니다");
        }

        Optional<User> userOptional = userRepository.findByUNum(uNum);
        return userOptional.orElse(null); 
    }
    
    @Transactional
    public Employee addEmployee(EmployeeAddRequest request) {
        // 사원번호 중복 확인
        if (employeeRepository.existsById(request.geteNum())) {
            throw new IllegalArgumentException("이미 존재하는 사원번호입니다: " + request.geteNum());
        }

        Employee newEmployee = new Employee();
        newEmployee.seteNum(request.geteNum());
        newEmployee.seteName(request.geteName());
        newEmployee.seteEmail(request.geteEmail());
        newEmployee.setePosition(request.getePosition());
        
        newEmployee.seteAddress(request.geteAddress());
        
        newEmployee.seteJoinDate(request.geteJoinDate().atStartOfDay()); 
        
        newEmployee.setDeptNum(request.getDeptNum()); 


        // Employee 저장
        Employee savedEmployee = employeeRepository.save(newEmployee);

        return savedEmployee;
    }
}
