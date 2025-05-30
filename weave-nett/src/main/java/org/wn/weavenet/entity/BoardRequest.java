package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import org.wn.weavenet.enums.BoardType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="board_request")
public class BoardRequest {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="br_num", nullable = false)
	private Long brNum; // 게시판 식별 번호

	@Column(name="br_title", length = 50, nullable = false)
	private String brTitle; // 게시판 제목
	
	@Enumerated(EnumType.STRING)
	@Column(name="br_type", length = 100, nullable = false)
	private BoardType brType; // 게시판 타입 (공지사항, 일반, 부서 , 프로젝트)
	
	@Column(name="br_status", length = 20, nullable = false)
	private String brStatus;
	
	@Column(name="u_num", nullable = false)
	private Long uNum;
	
	@Column(name="dept_num", nullable = true)
	private Long deptNum;
	
	@Column(name="br_reg_date", nullable = false)
	private LocalDateTime brRegDate;

	public BoardRequest() {}

	public BoardRequest(String brTitle, BoardType brType, String brStatus, Long uNum, Long deptNum,
			LocalDateTime brRegDate) {
		super();
		this.brTitle = brTitle;
		this.brType = brType;
		this.brStatus = brStatus;
		this.uNum = uNum;
		this.deptNum = deptNum;
		this.brRegDate = brRegDate;
	}

	public BoardRequest(Long brNum, String brTitle, BoardType brType, String brStatus, Long uNum, Long deptNum,
			LocalDateTime brRegDate) {
		super();
		this.brNum = brNum;
		this.brTitle = brTitle;
		this.brType = brType;
		this.brStatus = brStatus;
		this.uNum = uNum;
		this.deptNum = deptNum;
		this.brRegDate = brRegDate;
	}
	
	public Long getBrNum() {
		return brNum;
	}

	public void setBrNum(Long brNum) {
		this.brNum = brNum;
	}

	public String getBrTitle() {
		return brTitle;
	}

	public void setBrTitle(String brTitle) {
		this.brTitle = brTitle;
	}

	public BoardType getBrType() {
		return brType;
	}

	public void setBrType(BoardType brType) {
		this.brType = brType;
	}

	public String getBrStatus() {
		return brStatus;
	}

	public void setBrStatus(String brStatus) {
		this.brStatus = brStatus;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	public Long getDeptNum() {
		return deptNum;
	}

	public void setDeptNum(Long deptNum) {
		this.deptNum = deptNum;
	}

	public LocalDateTime getBrRegDate() {
		return brRegDate;
	}

	public void setBrRegDate(LocalDateTime brRegDate) {
		this.brRegDate = brRegDate;
	}

	@Override
	public String toString() {
		return "BoardRequest [brNum=" + brNum + ", brTitle=" + brTitle + ", brType=" + brType + ", brStatus=" + brStatus
				+ ", uNum=" + uNum + ", deptNum=" + deptNum + ", brRegDate=" + brRegDate + "]";
	}
	
}