package org.wn.weavenet.enums;

public enum BoardStatus {
	PENDING, 		// 대기중
	APPROVED,		// 승인됨
	REJECTED, 		// 거절됨
	ACTIVE,			// 정상
	SOFT_DELETED,	// 소프트 삭제
	RESTORE,		// 복구
}