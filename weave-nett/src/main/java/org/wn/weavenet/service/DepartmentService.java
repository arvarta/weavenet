package org.wn.weavenet.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wn.weavenet.dto.DepartmentDto;
import org.wn.weavenet.dto.MemberDto;
import org.wn.weavenet.entity.Department;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserStatus;
import org.wn.weavenet.repository.DepartmentRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;

@Service
public class DepartmentService {
	
	@Autowired
    private DepartmentRepository departmentRepository;
	
	@Autowired
    private UserRepository userRepository;
	
	@Autowired
    private EmployeeRepository employeeRepository;

    // 모든 부서 목록을 반환
    public List<DepartmentDto> getAllDepartments() {
        List<Department> departments = departmentRepository.findAll();
        return departments.stream()
                .map(department -> new DepartmentDto(department.getDeptNum(), department.getDeptName()))
                .collect(Collectors.toList());
    }
    
    public List<MemberDto> getMembersByDepartment(Long deptId) {
        List<Employee> employeesInDept = employeeRepository.findByDeptNum(deptId);

        return employeesInDept.stream()
                .map(emp -> {
                    Optional<User> userOpt = userRepository.findByENumAndUStatus(emp.geteNum(), UserStatus.APPROVED);
                    return userOpt.map(user -> new MemberDto(user.getuNum(), emp.geteName(), emp.getePosition()));
                })
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList());
    }
}


