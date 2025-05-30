package org.wn.weavenet.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wn.weavenet.dto.DeletedBoardSummaryDTO;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Garbage;
import org.wn.weavenet.enums.DeletedStatus;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.GarbageRepository;

@Service
public class GarbageService {

    @Autowired
    private GarbageRepository garbageRepository;

    @Autowired
    private BoardRepository boardRepository;

    public List<DeletedBoardSummaryDTO> getDeletedBoards() {
        List<Garbage> garbageList = garbageRepository.findByGStatusAndGType(DeletedStatus.SOFT_DELETED, "board");
        List<DeletedBoardSummaryDTO> result = new ArrayList<>();

        for (Garbage g : garbageList) {
            Board board = boardRepository.findById(g.getgItemId()).orElse(null);
            if (board != null) {
                result.add(new DeletedBoardSummaryDTO(
                    board.getbTitle(),
                    g.getgReason(),
                    g.getgDeletedDate()
                ));
            }
        }
        return result;
    }
}

