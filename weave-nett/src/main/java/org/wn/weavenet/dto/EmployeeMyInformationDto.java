package org.wn.weavenet.dto;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class EmployeeMyInformationDto {
	private String eNum;
    private String eName;
    private String eEmail;
    private String deptName;
    private String eGrade;
    private String ePosition;
    private String eAddress;
    private LocalDateTime eJoinDate;
    
    
    private String uRank;
    private String uAuth;
    private Long uNum;
    private String uProfile;
    
	public EmployeeMyInformationDto() {}
	
	public EmployeeMyInformationDto(String eNum, String eName, String eEmail, String deptName, String eGrade,
			String ePosition, String eAddress, LocalDateTime eJoinDate, String uRank, String uAuth, Long uNum,
			String uProfile) {
		this.eNum = eNum;
		this.eName = eName;
		this.eEmail = eEmail;
		this.deptName = deptName;
		this.eGrade = eGrade;
		this.ePosition = ePosition;
		this.eAddress = eAddress;
		this.eJoinDate = eJoinDate;
		this.uRank = uRank;
		this.uAuth = uAuth;
		this.uNum = uNum;
		this.uProfile = uProfile;
	}
	
	public EmployeeMyInformationDto(String eName, String eEmail, String deptName, String eGrade,
			String ePosition, String eAddress, LocalDateTime eJoinDate, String uRank, String uAuth, Long uNum,
			String uProfile) {
		this.eName = eName;
		this.eEmail = eEmail;
		this.deptName = deptName;
		this.eGrade = eGrade;
		this.ePosition = ePosition;
		this.eAddress = eAddress;
		this.eJoinDate = eJoinDate;
		this.uRank = uRank;
		this.uAuth = uAuth;
		this.uNum = uNum;
		this.uProfile = uProfile;
	}
	
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
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	public String geteGrade() {
		return eGrade;
	}
	public void seteGrade(String eGrade) {
		this.eGrade = eGrade;
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
	public LocalDateTime getOriginaleJoinDate() {
        return eJoinDate;
    }
    
    public Date geteJoinDateAsDate() {
    	if(this.eJoinDate == null) {
    		return null;
    	}
    	return Date.from(this.eJoinDate.atZone(ZoneId.systemDefault()).toInstant());
    }

	public void seteJoinDate(LocalDateTime eJoinDate) {
		this.eJoinDate = eJoinDate;
	}
	public String getuRank() {
		return uRank;
	}
	public void setuRank(String uRank) {
		this.uRank = uRank;
	}
	public String getuAuth() {
		return uAuth;
	}
	public void setuAuth(String uAuth) {
		this.uAuth = uAuth;
	}
	public Long getuNum() {
		return uNum;
	}
	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}
	public String getuProfile() {
		return uProfile;
	}
	public void setuProfile(String uProfile) {
		this.uProfile = uProfile;
	}
}
