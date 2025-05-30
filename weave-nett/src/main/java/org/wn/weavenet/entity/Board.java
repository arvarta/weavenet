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
@Table(name="board")
public class Board {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="b_num", nullable = false)
	private Long bNum; // 게시판 식별 번호

	@Enumerated(EnumType.STRING)
	@Column(name="b_type", length = 100, nullable = false)
	private BoardType bType; // 게시판 타입 (공지사항, 일반, 부서 , 프로젝트)
	
	@Column(name="b_title", length = 50, nullable = false)
	private String bTitle; // 게시판 제목
	
	@Column(name="b_status",  length = 20, nullable = false)
	private String bStatus;
	
	@Column(name="u_num", nullable = false)
	private Long uNum;
	
	@Column(name="dept_num", nullable = true)
	private Long deptNum;
	
	@Column(name="b_reg_date", nullable = false)
	private LocalDateTime bRegDate;

	public Board() {}

	public Board(BoardType bType, String bTitle, String bStatus, Long uNum, Long deptNum, LocalDateTime bRegDate) {
		super();
		this.bType = bType;
		this.bTitle = bTitle;
		this.bStatus = bStatus;
		this.uNum = uNum;
		this.deptNum = deptNum;
		this.bRegDate = bRegDate;
	}

	public Board(Long bNum, BoardType bType, String bTitle, String bStatus, Long uNum, Long deptNum,
			LocalDateTime bRegDate) {
		super();
		this.bNum = bNum;
		this.bType = bType;
		this.bTitle = bTitle;
		this.bStatus = bStatus;
		this.uNum = uNum;
		this.deptNum = deptNum;
		this.bRegDate = bRegDate;
	}

	public Long getbNum() {
		return bNum;
	}

	public void setbNum(Long bNum) {
		this.bNum = bNum;
	}

	public BoardType getbType() {
		return bType;
	}

	public void setbType(BoardType bType) {
		this.bType = bType;
	}

	public String getbTitle() {
		return bTitle;
	}

	public void setbTitle(String bTitle) {
		this.bTitle = bTitle;
	}

	public String getbStatus() {
		return bStatus;
	}

	public void setbStatus(String bStatus) {
		this.bStatus = bStatus;
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

	public LocalDateTime getbRegDate() {
		return bRegDate;
	}

	public void setbRegDate(LocalDateTime bRegDate) {
		this.bRegDate = bRegDate;
	}

	@Override
	public String toString() {
		return "Board [bNum=" + bNum + ", bType=" + bType + ", bTitle=" + bTitle + ", bStatus=" + bStatus + ", uNum="
				+ uNum + ", deptNum=" + deptNum + ", bRegDate=" + bRegDate + "]";
	}
	
}