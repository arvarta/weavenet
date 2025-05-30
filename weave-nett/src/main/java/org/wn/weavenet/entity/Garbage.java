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
@Table(name = "garbage")
public class Garbage {
	
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "g_num", nullable = false)
    private Long gNum;

    @Column(name = "g_reason", nullable = false, length = 200)
    private String gReason;

    @Column(name = "g_item_id", nullable = false)
    private Long gItemId;

    @Column(name = "g_type", nullable = false, length = 50)
    private String gType;

    @Enumerated(EnumType.STRING)
    @Column(name = "g_status", nullable = false, length = 20)
    private DeletedStatus gStatus;

    @Column(name = "g_deleted_date", nullable = false)
    private LocalDateTime gDeletedDate;

    @Column(name = "u_num", nullable = false)
    private Long uNum;
	
	Garbage() {}

	Garbage(Long gNum) {
		this.gNum = gNum;
	}

	public Garbage(String gReason, Long gItemId, String gType, DeletedStatus gStatus,
			LocalDateTime gDeletedDate, Long uNum) {
		this.gReason = gReason;
		this.gItemId = gItemId;
		this.gType = gType;
		this.gStatus = gStatus;
		this.gDeletedDate = gDeletedDate;
		this.uNum = uNum;
	}
	
	public Garbage(Long gNum, String gReason, Long gItemId, String gType, DeletedStatus gStatus,
			LocalDateTime gDeletedDate, Long uNum) {
		this.gNum = gNum;
		this.gReason = gReason;
		this.gItemId = gItemId;
		this.gType = gType;
		this.gStatus = gStatus;
		this.gDeletedDate = gDeletedDate;
		this.uNum = uNum;
	}

	public Long getgNum() {
		return gNum;
	}

	public void setgNum(Long gNum) {
		this.gNum = gNum;
	}

	public String getgReason() {
		return gReason;
	}

	public void setgReason(String gReason) {
		this.gReason = gReason;
	}

	public Long getgItemId() {
		return gItemId;
	}

	public void setgItemId(Long gItemId) {
		this.gItemId = gItemId;
	}

	public String getgType() {
		return gType;
	}

	public void setgType(String gType) {
		this.gType = gType;
	}

	public DeletedStatus getgStatus() {
		return gStatus;
	}

	public void setgStatus(DeletedStatus gStatus) {
		this.gStatus = gStatus;
	}

	public LocalDateTime getgDeletedDate() {
		return gDeletedDate;
	}

	public void setgDeletedDate(LocalDateTime gDeletedDate) {
		this.gDeletedDate = gDeletedDate;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	@Override
	public String toString() {
		return "Garbage [gNum=" + gNum + ", gReason=" + gReason + ", gItemId=" + gItemId + ", gType=" + gType
				+ ", gStatus=" + gStatus + ", gDeletedDate=" + gDeletedDate + ", uNum=" + uNum + "]";
	}

}

