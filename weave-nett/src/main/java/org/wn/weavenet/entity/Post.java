package org.wn.weavenet.entity;

import java.time.LocalDateTime;

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
@Table(name = "post")
public class Post {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "p_num", nullable = false)
	private Long pNum;					
	
	@Column(name = "p_title", nullable = false, length = 200)
	private String pTitle;
	
	@Column(name = "p_content", nullable = false, length = 1000)
	private String pContent;	
	
	@Column(name = "p_views", nullable = false)
	private int pViews;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "p_status", nullable = false, length = 20)
	private DeletedStatus pStatus;
	
	@Column(name = "p_reg_date", nullable = false)
 	private LocalDateTime pRegDate;	

 	@Column(name = "u_num")
 	private	Long uNum;					
 	
 	@Column(name = "b_num")
 	private Long bNum;		
 	
	public Post() {
		
	}
	
	public Post(Long pNum) {
		this.pNum = pNum;
	}

	public Post(String pTitle, String pContent, int pViews, DeletedStatus pStatus, LocalDateTime pRegDate,
			Long uNum, Long bNum) {
		this.pTitle = pTitle;
		this.pContent = pContent;
		this.pViews = pViews;
		this.pStatus = pStatus;
		this.pRegDate = pRegDate;
		this.uNum = uNum;
		this.bNum = bNum;
	}
	
	public Post(Long pNum, String pTitle, String pContent, int pViews, DeletedStatus pStatus, LocalDateTime pRegDate,
			Long uNum, Long bNum) {
		this.pNum = pNum;
		this.pTitle = pTitle;
		this.pContent = pContent;
		this.pViews = pViews;
		this.pStatus = pStatus;
		this.pRegDate = pRegDate;
		this.uNum = uNum;
		this.bNum = bNum;
	}



	public Long getpNum() {
		return pNum;
	}

	public void setpNum(Long pNum) {
		this.pNum = pNum;
	}

	public String getpTitle() {
		return pTitle;
	}

	public void setpTitle(String pTitle) {
		this.pTitle = pTitle;
	}

	public String getpContent() {
		return pContent;
	}

	public void setpContent(String pContent) {
		this.pContent = pContent;
	}

	public int getpViews() {
		return pViews;
	}

	public void setpViews(int pViews) {
		this.pViews = pViews;
	}

	public DeletedStatus getpStatus() {
		return pStatus;
	}

	public void setpStatus(DeletedStatus pStatus) {
		this.pStatus = pStatus;
	}

	public LocalDateTime getpRegDate() {
		return pRegDate;
	}

	public void setpRegDate(LocalDateTime pRegDate) {
		this.pRegDate = pRegDate;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	public Long getbNum() {
		return bNum;
	}

	public void setbNum(Long bNum) {
		this.bNum = bNum;
	}

	@Override
	public String toString() {
		return "Post [pNum=" + pNum + ", pTitle=" + pTitle + ", pContent=" + pContent + ", pViews=" + pViews
				+ ", pStatus=" + pStatus + ", pRegDate=" + pRegDate + ", uNum=" + uNum + ", bNum=" + bNum + "]";
	}
	
	
	
}
