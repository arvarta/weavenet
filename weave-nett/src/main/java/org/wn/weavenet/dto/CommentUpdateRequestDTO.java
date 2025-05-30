package org.wn.weavenet.dto;

import java.util.Date;

public class CommentUpdateRequestDTO {
	private String cContent; 	// 댓글 내용
	private Date cRegDate;
	
	public CommentUpdateRequestDTO() {}

	public CommentUpdateRequestDTO(String cContent) {
		this.cContent = cContent;
	}
	
	public CommentUpdateRequestDTO(String cContent, Date cRegDate) {
		this.cContent = cContent;
		this.cRegDate = cRegDate;
	}

	public String getcContent() {
		return cContent;
	}

	public void setcContent(String cContent) {
		this.cContent = cContent;
	}
	
}
