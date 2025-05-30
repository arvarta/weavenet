package org.wn.weavenet.dto;

import java.util.List;

import org.wn.weavenet.enums.BoardType;

//BoardRequestDto.java (사용자 요청용 DTO)
public class BoardRequestDto {

	private String title;
	private BoardType type;
	private Long deptNum; // 부서 게시판일 경우
	private List<Long> memberIds; // 프로젝트 또는 부서 게시판일 경우 선택된 사원들
	private String status; // 요청 상태 (예: PENDING, APPROVED 등)

	public BoardRequestDto() {
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
