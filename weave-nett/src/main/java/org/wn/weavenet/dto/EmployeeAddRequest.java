package org.wn.weavenet.dto;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

public class EmployeeAddRequest {
    private String eNum;
    private String eName;
    private String eEmail;
    private String eAddress;

    @DateTimeFormat(pattern = "yyyy-MM-dd") 
    private LocalDate eJoinDate;
    
    private Long deptNum;
   
    private String ePosition; 

    public String geteNum() {
        return eNum;
    }

    public void seteNum(String eNum) {
        this.eNum = eNum;
    }

    public String geteName() {
        return eName;
    }

    public void seteName(String eName) {
        this.eName = eName;
    }

    public String geteEmail() {
        return eEmail;
    }

    public void seteEmail(String eEmail) {
        this.eEmail = eEmail;
    }

    public String getePosition() { 
        return ePosition;
    }

    public void setePosition(String ePosition) { 
        this.ePosition = ePosition;
    }

    public String geteAddress() {
        return eAddress;
    }

    public void seteAddress(String eAddress) {
        this.eAddress = eAddress;
    }

    public LocalDate geteJoinDate() {
        return eJoinDate;
    }

    public void seteJoinDate(LocalDate eJoinDate) {
        this.eJoinDate = eJoinDate;
    }

    public Long getDeptNum() {
        return deptNum;
    }

    public void setDeptNum(Long deptNum) {
        this.deptNum = deptNum;
    }

    @Override
    public String toString() {
        return "EmployeeAddRequest [eNum=" + eNum + ", eName=" + eName + ", eEmail=" + eEmail + ", ePosition="
                + ePosition + ", eAddress=" + eAddress + ", eJoinDate=" + eJoinDate
                + ", deptNum=" + deptNum + "]";
    }
}