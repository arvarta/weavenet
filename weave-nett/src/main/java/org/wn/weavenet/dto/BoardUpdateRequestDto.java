package org.wn.weavenet.dto;

import java.util.List;

public class BoardUpdateRequestDto {
	private String boardName;
	private String type;
	private String deptNum;
	private List<Long> memberIds;
	
	public BoardUpdateRequestDto(String boardName, String type, String deptNum, List<Long> memberIds) {
		this.boardName = boardName;
		this.type = type;
		this.deptNum = deptNum;
		this.memberIds = memberIds;
	}
	
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getDeptNum() {
		return deptNum;
	}
	public void setDeptNum(String deptNum) {
		this.deptNum = deptNum;
	}
	public List<Long> getMemberIds() {
		return memberIds;
	}
	public void setMemberIds(List<Long> memberIds) {
		this.memberIds = memberIds;
	}
	
}
