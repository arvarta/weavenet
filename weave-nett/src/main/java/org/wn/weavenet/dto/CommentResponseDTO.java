package org.wn.weavenet.dto;


import java.util.Date;
import java.util.List;

import org.wn.weavenet.enums.DeletedStatus;
import org.wn.weavenet.enums.UserAuth;

public class CommentResponseDTO {
    private Long cNum;
    private String cContent;
    private Date cRegDate;
    private DeletedStatus cStatus;
    private String writerProfile;
    private Long writerId;            			// 댓글 작성자 uNum
    private String writerName; 					// Employee.eName
    private UserAuth writerRole;         		// "ADMIN" or "USER"
    private String loginUserId;
    private String loginUserRole;
    private Long parentId; 						// 부모 댓글 ID
    private List<CommentResponseDTO> replies;	// 답글

    public CommentResponseDTO(Long cNum, String cContent, Date cRegDate, DeletedStatus cStatus, String writerName) {
    	this.cNum = cNum;
    	this.cContent = cContent;
        this.cRegDate = cRegDate;
        this.cStatus = cStatus;
        this.writerName = writerName;
    }

	public CommentResponseDTO(Long cNum, String cContent, Date cRegDate, DeletedStatus cStatus, String writerName,
			Long parentId, Long writerId) {
		this.cNum = cNum;
		this.cContent = cContent;
		this.cRegDate = cRegDate;
		this.cStatus = cStatus;
		this.writerName = writerName;
		this.parentId = parentId;
		this.writerId = writerId;
	}

	public CommentResponseDTO(Long cNum, String cContent, Date cRegDate, DeletedStatus cStatus, String writerProfile,
			String writerName, Long parentId, Long writerId) {
		this.cNum = cNum;
		this.cContent = cContent;
		this.cRegDate = cRegDate;
		this.cStatus = cStatus;
		this.writerProfile = writerProfile;
		this.writerName = writerName;
		this.parentId = parentId;
		this.writerId = writerId;
	}

	// getter, setter
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
	
	public String getWriterProfile() {
		return writerProfile;
	}

	public Long getWriterId() {
		return writerId;
	}

	public void setWriterId(Long writerId) {
		this.writerId = writerId;
	}

	public String getWriterName() {
		return writerName;
	}

	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}

	public UserAuth getWriterRole() {
		return writerRole;
	}

	public void setWriterRole(UserAuth writerRole) {
		this.writerRole = writerRole;
	}

	public String getLoginUserId() {
		return loginUserId;
	}

	public void setLoginUserId(String loginUserId) {
		this.loginUserId = loginUserId;
	}

	public String getLoginUserRole() {
		return loginUserRole;
	}

	public void setLoginUserRole(String loginUserRole) {
		this.loginUserRole = loginUserRole;
	}

	public Long getParentId() {
		return parentId;
	}

	public void setParentId(Long parentId) {
		this.parentId = parentId;
	}

	public List<CommentResponseDTO> getReplies() {
		return replies;
	}

	public void setReplies(List<CommentResponseDTO> replies) {
		this.replies = replies;
	}
   
}
