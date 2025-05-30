package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "support_comment")
public class SupportComment {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "sc_num", nullable = false, length = 20)
	private Long scNum;

	@Column(name = "sc_content", nullable = true)
	private String scContent;

	@Column(name = "sc_reg_date", nullable = false)
	private LocalDateTime scRegDate;

	@Column(name = "sb_num", nullable = false)
    private Long sbNum;

	@Column(name = "u_num", nullable = false, length = 30)
	private Long uNum;

	public SupportComment() {

	}

	public SupportComment(Long scNum) {
		this.scNum = scNum;
	}

	public SupportComment(String scContent, LocalDateTime scRegDate, Long sbNum, Long uNum) {
		this.scContent = scContent;
		this.scRegDate = scRegDate;
		this.sbNum = sbNum;
		this.uNum = uNum;
	}
	
	public SupportComment(Long scNum, String scContent, LocalDateTime scRegDate, Long sbNum, Long uNum) {
		this.scNum = scNum;
		this.scContent = scContent;
		this.scRegDate = scRegDate;
		this.sbNum = sbNum;
		this.uNum = uNum;
	}

	public Long getScNum() {
		return scNum;
	}

	public void setScNum(Long scNum) {
		this.scNum = scNum;
	}

	public String getScContent() {
		return scContent;
	}

	public void setScContent(String scContent) {
		this.scContent = scContent;
	}

	public LocalDateTime getScRegDate() {
		return scRegDate;
	}

	public void setScRegDate(LocalDateTime scRegDate) {
		this.scRegDate = scRegDate;
	}

	public Long getSbNum() {
		return sbNum;
	}

	public void setSbNum(Long sbNum) {
		this.sbNum = sbNum;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	@Override
	public String toString() {
		return "SupportComment [scNum=" + scNum + ", scContent=" + scContent + ", scRegDate=" + scRegDate + ", sbNum="
				+ sbNum + ", uNum=" + uNum + "]";
	}

}
