package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "post_audit")
public class PostAudit {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "pa_num", nullable = false)
	private Long paNum;					// 게시글 로그 식별 번호

	@Column(name = "pa_task", nullable = false, length = 50)
	private String paTask;				// 게시글 과업

	@Column(name = "pa_status_date", nullable = false)
	private LocalDateTime paStatusDate;	// 로그 기록 시간

	@Column(name = "b_num", nullable = false)
	private Long bNum;					// 게시판 FK

	@Column(name = "p_num", nullable = false)
	private Long pNum;					// 게시글 FK

	@Column(name = "u_num", nullable = false)
	private Long uNum;					// 유저 FK

	public PostAudit() {

	}

	public PostAudit(Long paNum) {
		this.paNum = paNum;
	}

	public PostAudit(String paTask, LocalDateTime paStatusDate, Long bNum, Long pNum, Long uNum) {
		this.paTask = paTask;
		this.paStatusDate = paStatusDate;
		this.bNum = bNum;
		this.pNum = pNum;
		this.uNum = uNum;
	}

	public PostAudit(Long paNum, String paTask, LocalDateTime paStatusDate, Long bNum, Long pNum, Long uNum) {
		this.paNum = paNum;
		this.paTask = paTask;
		this.paStatusDate = paStatusDate;
		this.bNum = bNum;
		this.pNum = pNum;
		this.uNum = uNum;
	}

	public Long getPaNum() {
		return paNum;
	}

	public void setPaNum(Long paNum) {
		this.paNum = paNum;
	}

	public String getPaTask() {
		return paTask;
	}

	public void setPaTask(String paTask) {
		this.paTask = paTask;
	}

	public LocalDateTime getPaStatusDate() {
		return paStatusDate;
	}

	public void setPaStatusDate(LocalDateTime paStatusDate) {
		this.paStatusDate = paStatusDate;
	}

	public Long getbNum() {
		return bNum;
	}

	public void setbNum(Long bNum) {
		this.bNum = bNum;
	}

	public Long getpNum() {
		return pNum;
	}

	public void setpNum(Long pNum) {
		this.pNum = pNum;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	@Override
	public String toString() {
		return "PostAudit [paNum=" + paNum + ", paTask=" + paTask + ", paStatusDate=" + paStatusDate + ", bNum=" + bNum
				+ ", pNum=" + pNum + ", uNum=" + uNum + "]";
	}


}
