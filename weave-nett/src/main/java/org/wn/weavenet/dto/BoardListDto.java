package org.wn.weavenet.dto;

import org.wn.weavenet.enums.BoardType;

public class BoardListDto {

	private Long bNum;
    private String bTitle;
    private BoardType bType;
    private int postCount;
    
	public BoardListDto(Long bNum, String bTitle, BoardType bType, int postCount) {
		this.bNum = bNum;
		this.bTitle = bTitle;
		this.bType = bType;
		this.postCount = postCount;
	}

	public Long getbNum() {
		return bNum;
	}

	public void setbNum(Long bNum) {
		this.bNum = bNum;
	}

	public String getbTitle() {
		return bTitle;
	}

	public void setbTitle(String bTitle) {
		this.bTitle = bTitle;
	}

	public BoardType getbType() {
		return bType;
	}

	public void setbType(BoardType bType) {
		this.bType = bType;
	}

	public int getPostCount() {
		return postCount;
	}

	public void setPostCount(int postCount) {
		this.postCount = postCount;
	}

}
