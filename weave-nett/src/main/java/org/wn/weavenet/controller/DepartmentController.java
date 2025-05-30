package org.wn.weavenet.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.wn.weavenet.dto.DepartmentDto;
import org.wn.weavenet.dto.MemberDto;
import org.wn.weavenet.service.DepartmentService;

@RestController
@RequestMapping("/api/departments")
public class DepartmentController {
	
	private final DepartmentService departmentService;

    public DepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    // 모든 부서 목록 조회
    @GetMapping
    public List<DepartmentDto> getAllDepartments() {
    	System.out.println("data: " + departmentService.getAllDepartments());
        return departmentService.getAllDepartments();
    }
    
    // 특정 부서에 속한 사원 목록 조회
    @GetMapping("/members")
    public ResponseEntity<List<MemberDto>> getMembersByDepartment(@RequestParam Long deptId) {
    	System.out.println("deptId" + deptId);
        List<MemberDto> members = departmentService.getMembersByDepartment(deptId);
        return ResponseEntity.ok(members);
    }

}
