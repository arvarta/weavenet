package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import org.wn.weavenet.enums.DeletedStatus;
import org.wn.weavenet.enums.SupportBoardStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "support_board")
public class SupportBoard {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "sb_num", nullable = false)
	private Long sbNum;

	@Column(name = "sb_type", nullable = false, length = 20)
	private String sbType;

	@Column(name = "sb_title", nullable = false, length = 50)
	private String sbTitle;

	@Column(name = "sb_content", nullable = false)
	private String sbContent;

	@Column(name = "sb_reg_date", nullable = false)
	private LocalDateTime sbRegDate;

	@Enumerated(EnumType.STRING)
	@Column(name = "sb_status", nullable = false)
	private SupportBoardStatus sbStatus;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "sb_deleted", nullable = false)
	private DeletedStatus sbDeleted;

	@Column(name = "u_num", nullable = false)
	private Long uNum;

	public SupportBoard() {

	}

	public SupportBoard(Long sbNum) {
		this.sbNum = sbNum;
	}
	
	public SupportBoard(String sbType, String sbTitle, String sbContent, LocalDateTime sbRegDate,
			SupportBoardStatus sbStatus, DeletedStatus sbDeleted, Long uNum) {
		this.sbType = sbType;
		this.sbTitle = sbTitle;
		this.sbContent = sbContent;
		this.sbRegDate = sbRegDate;
		this.sbStatus = sbStatus;
		this.sbDeleted = sbDeleted;
		this.uNum = uNum;
	}
	
	public SupportBoard(Long sbNum, String sbType, String sbTitle, String sbContent, LocalDateTime sbRegDate,
			SupportBoardStatus sbStatus, DeletedStatus sbDeleted, Long uNum) {
		this.sbNum = sbNum;
		this.sbType = sbType;
		this.sbTitle = sbTitle;
		this.sbContent = sbContent;
		this.sbRegDate = sbRegDate;
		this.sbStatus = sbStatus;
		this.sbDeleted = sbDeleted;
		this.uNum = uNum;
	}

	public Long getSbNum() {
		return sbNum;
	}

	public void setSbNum(Long sbNum) {
		this.sbNum = sbNum;
	}

	public String getSbType() {
		return sbType;
	}

	public void setSbType(String sbType) {
		this.sbType = sbType;
	}

	public String getSbTitle() {
		return sbTitle;
	}

	public void setSbTitle(String sbTitle) {
		this.sbTitle = sbTitle;
	}

	public String getSbContent() {
		return sbContent;
	}

	public void setSbContent(String sbContent) {
		this.sbContent = sbContent;
	}

	public LocalDateTime getSbRegDate() {
		return sbRegDate;
	}

	public void setSbRegDate(LocalDateTime sbRegDate) {
		this.sbRegDate = sbRegDate;
	}

	public SupportBoardStatus getSbStatus() {
		return sbStatus;
	}

	public void setSbStatus(SupportBoardStatus sbStatus) {
		this.sbStatus = sbStatus;
	}

	public DeletedStatus getSbDeleted() {
		return sbDeleted;
	}

	public void setSbDeleted(DeletedStatus sbDeleted) {
		this.sbDeleted = sbDeleted;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	@Override
	public String toString() {
		return "SupportBoard [sbNum=" + sbNum + ", sbType=" + sbType + ", sbTitle=" + sbTitle + ", sbContent="
				+ sbContent + ", sbRegDate=" + sbRegDate + ", sbStatus=" + sbStatus + ", sbDeleted=" + sbDeleted
				+ ", uNum=" + uNum + "]";
	}

}
