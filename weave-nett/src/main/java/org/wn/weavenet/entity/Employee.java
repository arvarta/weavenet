package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "employee")
public class Employee {

	@Id
	@Column(name="e_num", nullable = false, length= 30)
	private String eNum;					// 사원번호

	@Column(name="e_name", nullable = false, length = 50)
	private String eName; 					// 사원이름

	@Column(name="e_email", nullable = false, length = 100)
	private String eEmail; 				// 이메일

	@Column(name="e_position", nullable = false, length = 20)
	private String ePosition; 				// 직책

	@Column(name="e_grade", nullable = true, length = 20)
	private String eGrade; 				// 직급

	@Column(name="e_address", nullable = false)
	private String eAddress; 				// 주소

	@Column(name="e_join_date", nullable = false)
	private LocalDateTime eJoinDate; 		// 입사일

	@Column(name="dept_num", nullable = true)
	private Long deptNum;		// 부서 테이블 FK

	public Employee() {}
	
	public Employee(String eName, String eEmail, String ePosition, String eGrade, String eAddress,
			LocalDateTime eJoinDate, Long deptNum) {
		super();
		this.eName = eName;
		this.eEmail = eEmail;
		this.ePosition = ePosition;
		this.eGrade = eGrade;
		this.eAddress = eAddress;
		this.eJoinDate = eJoinDate;
		this.deptNum = deptNum;
	}

	public Employee(String eNum, String eName, String eEmail, String ePosition, String eGrade, String eAddress,
			LocalDateTime eJoinDate, Long deptNum) {
		super();
		this.eNum = eNum;
		this.eName = eName;
		this.eEmail = eEmail;
		this.ePosition = ePosition;
		this.eGrade = eGrade;
		this.eAddress = eAddress;
		this.eJoinDate = eJoinDate;
		this.deptNum = deptNum;
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

	public String getePosition() {
		return ePosition;
	}

	public void setePosition(String ePosition) {
		this.ePosition = ePosition;
	}

	public String geteGrade() {
		return eGrade;
	}

	public void seteGrade(String eGrade) {
		this.eGrade = eGrade;
	}

	public String geteAddress() {
		return eAddress;
	}

	public void seteAddress(String eAddress) {
		this.eAddress = eAddress;
	}

	public LocalDateTime geteJoinDate() {
		return eJoinDate;
	}

	public void seteJoinDate(LocalDateTime eJoinDate) {
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
		return "Employee [eNum=" + eNum + ", eName=" + eName + ", eEmail=" + eEmail + ", ePosition=" + ePosition
				+ ", eGrade=" + eGrade + ", eAddress=" + eAddress + ", eJoinDate=" + eJoinDate + ", deptNum=" + deptNum
				+ "]";
	}
}
