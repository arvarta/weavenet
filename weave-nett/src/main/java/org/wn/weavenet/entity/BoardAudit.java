package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "board_audit")
public class BoardAudit {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ba_num", nullable = false)
	private Long baNum;					// 게시판 로그 식별 번호

	@Column(name = "ba_task", nullable = false, length = 50)
	private String baTask;				// 게시판 과업

	@Column(name = "ba_status_date", nullable =  false)
	private LocalDateTime baStatusDate;	// 로그 기록 시간

	@Column(name = "b_num", nullable = false)
	private Long bNum;					// 게시판 FK (게시판 제목)

	@Column(name = "u_num", nullable = false)
	private Long uNum;					// 유저 FK (작성자)

	public BoardAudit() {

	}

	public BoardAudit(Long baNum) {
		this.baNum = baNum;
	}

	public BoardAudit(String baTask, LocalDateTime baStatusDate, Long bNum, Long uNum) {
		this.baTask = baTask;
		this.baStatusDate = baStatusDate;
		this.bNum = bNum;
		this.uNum = uNum;
	}

	public BoardAudit(Long baNum, String baTask, LocalDateTime baStatusDate, Long bNum, Long uNum) {
		this.baNum = baNum;
		this.baTask = baTask;
		this.baStatusDate = baStatusDate;
		this.bNum = bNum;
		this.uNum = uNum;
	}

	public Long getBaNum() {
		return baNum;
	}

	public void setBaNum(Long baNum) {
		this.baNum = baNum;
	}

	public String getBaTask() {
		return baTask;
	}

	public void setBaTask(String baTask) {
		this.baTask = baTask;
	}

	public LocalDateTime getBaStatusDate() {
		return baStatusDate;
	}

	public void setBaStatusDate(LocalDateTime baStatusDate) {
		this.baStatusDate = baStatusDate;
	}

	public Long getbNum() {
		return bNum;
	}

	public void setbNum(Long bNum) {
		this.bNum = bNum;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	@Override
	public String toString() {
		return "BoardAudit [baNum=" + baNum + ", baTask=" + baTask + ", baStatusDate=" + baStatusDate + ", bNum=" + bNum
				+ ", uNum=" + uNum + "]";
	}


}
