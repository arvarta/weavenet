package org.wn.weavenet.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.wn.weavenet.entity.SupportBoard;
import org.wn.weavenet.enums.DeletedStatus;
import org.wn.weavenet.enums.SupportBoardStatus;
import org.wn.weavenet.repository.SupportBoardRepository;

import jakarta.transaction.Transactional;

@Service
public class SupportBoardService {
	private final SupportBoardRepository sbr;

	public SupportBoardService(SupportBoardRepository sbr) {
		this.sbr = sbr;
	}
	
	@Transactional
	public SupportBoard save(SupportBoard supportBoard) {
		if(supportBoard.getSbRegDate() == null) {
			supportBoard.setSbRegDate(LocalDateTime.now());
		}
	    if(supportBoard.getSbDeleted() == null) {
	        supportBoard.setSbDeleted(DeletedStatus.ACTIVE);  
	    }
	    if(supportBoard.getSbStatus() == null) {
	    	supportBoard.setSbStatus(SupportBoardStatus.WAIT_ANSWER);
	    }
		return sbr.save(supportBoard);
	}
	
	@Transactional
	public SupportBoard update(SupportBoard supportBoard) {
		Optional<SupportBoard> optionalBoard = sbr.findById(supportBoard.getSbNum());
		
		if(optionalBoard.isEmpty()) {
			throw new IllegalArgumentException("해당 문의 게시글이 존재하지 않습니다.");
		}
		SupportBoard savedSupportBoard = optionalBoard.get();
		savedSupportBoard.setSbTitle(supportBoard.getSbTitle());
		savedSupportBoard.setSbType(supportBoard.getSbType());
		savedSupportBoard.setSbContent(supportBoard.getSbContent());
		return savedSupportBoard;
	}
	
	@Transactional
    public void permanentlyDelete(Long sbNum) {
        if (!sbr.existsById(sbNum)) {
            throw new IllegalArgumentException("해당 문의 게시글이 존재하지 않습니다. ID: " + sbNum);
        }
        sbr.deleteById(sbNum);

    }
	
	public List<SupportBoard> findAllActive() {
		return sbr.findBySbDeletedOrderBySbRegDateDesc(DeletedStatus.ACTIVE);
	}
	
	public SupportBoard findByNum(Long sbNum) {
		Optional<SupportBoard> sBoard = sbr.findById(sbNum);
		return sBoard.orElse(null);
	}
}
