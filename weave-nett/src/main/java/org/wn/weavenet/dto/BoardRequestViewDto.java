package org.wn.weavenet.dto;

import org.wn.weavenet.enums.BoardType;

public class BoardRequestViewDto {

	private Long brNum;
    private String brTitle;
    private BoardType brType;
    private String deptName;
    private String brStatus;
    private Long uNum;
    private String requesterName;
    
	public BoardRequestViewDto(Long brNum, String brTitle, BoardType brType, String deptName, String brStatus,
			Long uNum, String requesterName) {
		super();
		this.brNum = brNum;
		this.brTitle = brTitle;
		this.brType = brType;
		this.deptName = deptName;
		this.brStatus = brStatus;
		this.uNum = uNum;
		this.requesterName = requesterName;
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
	public String getDeptName() {
		return deptName;
	}
	public void setDeptName(String deptName) {
		this.deptName = deptName;
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
	public String getRequesterName() {
		return requesterName;
	}
	public void setRequesterName(String requesterName) {
		this.requesterName = requesterName;
	}

}
