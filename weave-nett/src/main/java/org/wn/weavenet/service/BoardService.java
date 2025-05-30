package org.wn.weavenet.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wn.weavenet.dto.BoardDto;
import org.wn.weavenet.dto.BoardListDto;
import org.wn.weavenet.dto.BoardUpdateRequestDto;
import org.wn.weavenet.entity.AddMember;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.BoardStatus;
import org.wn.weavenet.enums.BoardType;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.repository.AddMemberRepository;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.PostRepository;
import org.wn.weavenet.repository.UserRepository;

import jakarta.transaction.Transactional;

//BoardService.java
@Service
public class BoardService {

	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private AddMemberRepository addMemberRepository;
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private PostRepository postRepository;

	public void createBoard(BoardDto boardDto, User loginUser) {
		Board board = new Board();
		board.setbType(boardDto.getType());
		board.setbTitle(boardDto.getTitle());
		board.setbStatus("ACTIVE");
		board.setuNum(loginUser.getuNum());
		board.setDeptNum(boardDto.getDeptNum());
		board.setbRegDate(LocalDateTime.now());
		boardRepository.save(board);
		
		List<Long> memberIds = boardDto.getMemberIds() != null ? new ArrayList<>(boardDto.getMemberIds()) : new ArrayList<>();

		if (boardDto.getType() == BoardType.PROJECT) {
			for (Long userId : memberIds) {
				addMemberRepository.save(new AddMember(userId, board.getbNum(), null));
			}
			// 게시판 생성자도 접근 가능하게 추가
		    addMemberRepository.save(new AddMember(loginUser.getuNum(), board.getbNum(), null));
		}
	}
	
	public boolean canAccessBoard(Long bNum, Long uNum) {
	    Optional<User> userOpt = userRepository.findById(uNum);
	    if (userOpt.isEmpty()) {
	        return false; // 사용자 정보 없으면 접근 불가
	    }

	    User user = userOpt.get();

	    // 1) 총관리자 또는 게시판 관리자 권한이면 무조건 접근 가능
	    if (user.getuAuth() == UserAuth.SUPER_ADMIN || user.getuAuth() == UserAuth.BOARD_MANAGER) {
	        return true;
	    }

	    Optional<Board> boardOpt = boardRepository.findById(bNum);
	    if (boardOpt.isEmpty() || !"ACTIVE".equals(boardOpt.get().getbStatus())) {
	        return false;
	    }

	    Board board = boardOpt.get();

	    // 2) 일반 게시판은 누구나 접근 가능
	    if (board.getbType() == BoardType.GENERAL || board.getbType() == BoardType.NOTICE) {
	        return true;
	    }

	    // 3) 부서 게시판 접근 체크: 유저 부서번호와 게시판 부서번호 일치해야 함
	    if (board.getbType() == BoardType.DEPARTMENT) {
	        // User 엔티티에 eNum이 사원번호라면, 그걸로 부서 조회
	        Long userDeptNum = employeeRepository.getDeptNumByEmployeeNum(user.geteNum());
	        if(userDeptNum == null) {
	        	return false;
	        }
	        return userDeptNum.equals(board.getDeptNum());
	    }

	    // 4) 프로젝트 게시판은 addMember에 등록된 사용자만 접근 가능
	    if (board.getbType() == BoardType.PROJECT) {
	        return addMemberRepository.existsByBNumAndUNum(bNum, uNum);
	    }

	    // 그 외는 접근 불가
	    return false;
	}
	
	public boolean existsBoardName(String title) {
		String normalizedTitle = title.replaceAll("\\s+", "");
	    return boardRepository.existsByBTitle(normalizedTitle);
	}

	// ACTIVE 상태 게시판 조회
	public List<Board> getActiveBoards() {
	    return boardRepository.findByBStatus("ACTIVE");
	}

	// SOFT_DELETED 상태 게시판 조회
	public List<Board> getSoftDeletedBoard() {
		return boardRepository.findByBStatus("SOFT_DELETED");
	}
	
	public List<Employee> getAllMembers() {
		return employeeRepository.findAll();
	}
	
	public List<BoardListDto> getBoardList() {
	    List<Board> boards = boardRepository.findByBStatus("ACTIVE");
	    List<BoardListDto> dtoList = new ArrayList<>();
	    
	    for(Board board : boards) {
	    	int postCount = postRepository.countByBNum(board.getbNum());
	    	
	    	dtoList.add(new BoardListDto(
	    		board.getbNum(),
	    		board.getbTitle(),
	    		board.getbType(),
	    		postCount
	    	));
	    }
	    return dtoList;
	}
	
	@Transactional
	public void updateBoard(Long bNum, BoardUpdateRequestDto dto) {
		Board findBoard = boardRepository.findById(bNum).orElseThrow(() -> new IllegalArgumentException("게시판이 존재하지 않습니다."));
		findBoard.setbTitle(dto.getBoardName());
		boardRepository.save(findBoard);
		
		addMemberRepository.deleteByBNum(bNum);
		
		List<AddMember> newMembers = dto.getMemberIds().stream().map(uNum -> new AddMember(uNum, bNum, null)).collect(Collectors.toList());
		
		addMemberRepository.saveAll(newMembers);
	};
	
	@Transactional
	public boolean deleteBoard(Long bNum) {
	    Optional<Board> optionalBoard = boardRepository.findById(bNum);
	    if (optionalBoard.isEmpty()) return false;

	    Board board = optionalBoard.get();
	    board.setbStatus(BoardStatus.SOFT_DELETED.name()); // 소프트 삭제

	    return true;
	}
	
	public List<Long> getProjectBoardNumsByUser(Long uNum) {
		return addMemberRepository.findBNumsByUNum(uNum);
	}

	public Board getBoardByBNum(Long bNum) {
        if (bNum == null) {
            return null;
        }
        return boardRepository.findById(bNum).orElse(null);
    }
	
}
