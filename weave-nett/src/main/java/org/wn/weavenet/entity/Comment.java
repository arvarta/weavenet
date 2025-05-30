package org.wn.weavenet.entity;

import java.time.LocalDateTime;
import java.util.Date;

import org.wn.weavenet.enums.DeletedStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "comment")
public class Comment {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "c_num", nullable = false)
	private Long cNum;				// 댓글번호

	@Column(name="c_content", length = 1000, nullable = false)
	private String cContent;		// 댓글 내용

	@Column(name="c_reg_date", nullable = false)
	private Date cRegDate; // 댓글 등록일

	@Enumerated(EnumType.STRING)
	@Column(name="c_status", length = 20, nullable = false)
	private DeletedStatus cStatus;  // 댓글 상태 (숨김, 삭제 여부)

	@Column(name="u_num", nullable = false)
	private Long uNum;				// 댓글 작성자

	@Column(name="p_num", nullable = false)
	private Long pNum;				// 게시글 번호
	
	@Column(name = "parent_id")
    private Long parentId; 			// 부모 댓글 ID (null이면 최상위 댓글)

	public Comment() {}

	public Comment(String cContent, Date cRegDate, DeletedStatus cStatus, Long uNum, Long pNum, Long parentId) {
        this.cContent = cContent;
        this.cRegDate = cRegDate;
        this.cStatus = cStatus;
        this.uNum = uNum;
        this.pNum = pNum;
        this.parentId = parentId;
    }

	public Comment(Long cNum, String cContent, Date cRegDate, DeletedStatus cStatus, Long uNum, Long pNum) {
		this.cNum = cNum;
		this.cContent = cContent;
		this.cRegDate = cRegDate;
		this.cStatus = cStatus;
		this.uNum = uNum;
		this.pNum = pNum;
	}

	public Long getcNum() {
		return cNum;
	}

	public void setcNum(Long cNum) {
		this.cNum = cNum;
	}

	public String getcContent() {
		return cContent;
	}

	public void setcContent(String cContent) {
		this.cContent = cContent;
	}

	public Date getcRegDate() {
		return cRegDate;
	}

	public void setcRegDate(Date cRegDate) {
		this.cRegDate = cRegDate;
	}

	public DeletedStatus getcStatus() {
		return cStatus;
	}

	public void setcStatus(DeletedStatus cStatus) {
		this.cStatus = cStatus;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	public Long getpNum() {
		return pNum;
	}

	public void setpNum(Long pNum) {
		this.pNum = pNum;
	}
	
	public Long getParentId() {
		return parentId;
	}

	public void setParentId(Long parentId) {
		this.parentId = parentId;
	}

	@Override
	public String toString() {
		return "Comment [cNum=" + cNum + ", cContent=" + cContent + ", cRegDate=" + cRegDate + ", cStatus=" + cStatus
				+ ", uNum=" + uNum + ", pNum=" + pNum + ", parentId=" + parentId + "]";
	}
}
