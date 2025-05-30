package org.wn.weavenet.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="department")
public class Department {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="dept_num", nullable = false, length= 30)
	private Long deptNum;
	
	@Column(name="dept_name", length = 30, nullable = false)
	private String deptName;
	
	public Department() {}

	public Department(Long deptNum, String deptName) {
		super();
		this.deptNum = deptNum;
		this.deptName = deptName;
	}

	public Long getDeptNum() {
		return deptNum;
	}

	public void setDeptNum(Long deptNum) {
		this.deptNum = deptNum;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	@Override
	public String toString() {
		return "Department [deptNum=" + deptNum + ", deptName=" + deptName + "]";
	}
}
