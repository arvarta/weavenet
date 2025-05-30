package org.wn.weavenet.dto;

public class DepartmentDto {

    private Long deptId;  // Long 타입으로 변경
    private String deptName;

    // Constructor
    public DepartmentDto(Long deptId, String deptName) {
        this.deptId = deptId;
        this.deptName = deptName;
    }

    // Getters and Setters
    public Long getDeptId() {
        return deptId;
    }

    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }
}



