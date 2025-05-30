package org.wn.weavenet.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DeletedBoardSummaryDTO {
    private String boardName;        // Board.bTitle
    private String deletedReason;    // Garbage.gReason
    private String formattedDate;    // gDeletedDate 포맷 문자열

    public DeletedBoardSummaryDTO(String boardName, String deletedReason, LocalDateTime deletedDate) {
        this.boardName = boardName;
        this.deletedReason = deletedReason;
        this.formattedDate = deletedDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }

    public String getBoardName() {
        return boardName;
    }

    public String getDeletedReason() {
        return deletedReason;
    }

    public String getFormattedDate() {
        return formattedDate;
    }
}
