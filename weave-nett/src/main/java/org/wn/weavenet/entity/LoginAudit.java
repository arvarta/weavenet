package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "login_audit")
public class LoginAudit {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "la_num", nullable = false)
	private Long laNum;				// 로그인 로그 식별 번호

	@Column(name = "la_desc", nullable = false, length = 50)
	private String laDesc;			// 로그인 로그 설명

	@Column(name = "la_status_date", nullable = false)
	private LocalDateTime laStatusDate;		// 로그 기록 시간

	@Column(name = "u_num", nullable = false)
	private Long uNum;						// 유저테이블 FK

	public LoginAudit() {

	}

	public LoginAudit(Long laNum) {
		this.laNum = laNum;
	}

	public LoginAudit(String laDesc, LocalDateTime laStatusDate, Long uNum) {
		this.laDesc = laDesc;
		this.laStatusDate = laStatusDate;
		this.uNum = uNum;
	}

	public LoginAudit(Long laNum, String laDesc, LocalDateTime laStatusDate, Long uNum) {
		this.laNum = laNum;
		this.laDesc = laDesc;
		this.laStatusDate = laStatusDate;
		this.uNum = uNum;
	}

	public Long getLaNum() {
		return laNum;
	}

	public void setLaNum(Long laNum) {
		this.laNum = laNum;
	}

	public String getLaDesc() {
		return laDesc;
	}

	public void setLaDesc(String laDesc) {
		this.laDesc = laDesc;
	}

	public LocalDateTime getLaStatusDate() {
		return laStatusDate;
	}

	public void setLaStatusDate(LocalDateTime laStatusDate) {
		this.laStatusDate = laStatusDate;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	@Override
	public String toString() {
		return "LoginLog [laNum=" + laNum + ", laDesc=" + laDesc + ", laStatusDate=" + laStatusDate + ", uNum=" + uNum
				+ "]";
	}

}
