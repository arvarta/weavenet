package org.wn.weavenet.dto;

public class CommentRequestDTO {
    private String cContent; 	// 댓글 내용
    private Long parentId; 		// 답글

    public CommentRequestDTO() {}
    
    public CommentRequestDTO(String cContent, Long parentId) {
		this.cContent = cContent;
		this.parentId = parentId;
	}

    public String getcContent() {
        return cContent;
    }

    public void setcContent(String cContent) {
        this.cContent = cContent;
    }

	public Long getParentId() {
		return parentId;
	}

	public void setParentId(Long parentId) {
		this.parentId = parentId;
	}
}
