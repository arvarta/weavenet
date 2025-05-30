package org.wn.weavenet.service;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wn.weavenet.entity.SupportBoard;
import org.wn.weavenet.entity.SupportComment;
import org.wn.weavenet.enums.SupportBoardStatus;
import org.wn.weavenet.repository.SupportBoardRepository;
import org.wn.weavenet.repository.SupportCommentRepository;

import jakarta.transaction.Transactional;

@Service
public class SupportCommentService {
	
	@Autowired
	private SupportCommentRepository scr;
	
	@Autowired
	private SupportBoardRepository sbr;

	@Transactional
	public SupportComment save(SupportComment supportComment) {
		Optional<SupportComment> existing = scr.findBySbNum(supportComment.getSbNum());
		if (existing.isPresent()) {
			throw new IllegalStateException("해당 문의글에는 이미 답변이 등록되어 있습니다.");
		}

		if (supportComment.getScRegDate() == null) {
			supportComment.setScRegDate(LocalDateTime.now());
		}

		SupportComment savedComment = scr.save(supportComment);

		Optional<SupportBoard> supportBoardOpt = sbr.findById(supportComment.getSbNum());
		if (supportBoardOpt.isPresent()) {
			SupportBoard supportBoard = supportBoardOpt.get();
			supportBoard.setSbStatus(SupportBoardStatus.COMPLETED_ANSWER);
			sbr.save(supportBoard);
		}

		return savedComment;
	}

	@Transactional
	public SupportComment update(Long sbNum, String newContent) {
		Optional<SupportComment> existingOpt = scr.findBySbNum(sbNum);
		if (!existingOpt.isPresent()) {
			throw new IllegalStateException("해당 문의글에는 답변이 없습니다.");
		}

		SupportComment existing = existingOpt.get();
		existing.setScContent(newContent);
		existing.setScRegDate(LocalDateTime.now());

		return scr.save(existing);
	}

	public SupportComment findBySbNum(Long sbNum) {
		Optional<SupportComment> commentOpt = scr.findById(sbNum);
		if (commentOpt.isPresent()) {
			return commentOpt.get();
		}
		return null;
	}
	
	@Transactional
    public void permanentlyDelete(Long scNum) {
        if (!scr.existsById(scNum)) {
            throw new IllegalArgumentException("해당 문의 게시글이 존재하지 않습니다. ID: " + scNum);
        }
        scr.deleteById(scNum);

    }
}
