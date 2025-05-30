package org.wn.weavenet.dto;

import java.util.List;

import org.wn.weavenet.enums.BoardType;

//BoardDto.java (관리자 등록용 DTO)
public class BoardDto {

	private String title;
	private BoardType type;
	private Long deptNum;
	private List<Long> memberIds;
	private String status; // 게시판 상태 (예: ACTIVE, INACTIVE 등)

	public BoardDto() {
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public BoardType getType() {
		return type;
	}

	public void setType(BoardType type) {
		this.type = type;
	}

	public Long getDeptNum() {
		return deptNum;
	}

	public void setDeptNum(Long deptNum) {
		this.deptNum = deptNum;
	}

	public List<Long> getMemberIds() {
		return memberIds;
	}

	public void setMemberIds(List<Long> memberIds) {
		this.memberIds = memberIds;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
