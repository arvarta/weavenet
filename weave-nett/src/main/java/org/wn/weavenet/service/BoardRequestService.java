package org.wn.weavenet.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wn.weavenet.dto.BoardRequestDto;
import org.wn.weavenet.dto.BoardRequestViewDto;
import org.wn.weavenet.entity.AddMember;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.BoardRequest;
import org.wn.weavenet.entity.Department;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.BoardStatus;
import org.wn.weavenet.enums.BoardType;
import org.wn.weavenet.repository.AddMemberRepository;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.BoardRequestRepository;
import org.wn.weavenet.repository.DepartmentRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.repository.UserRepository;

import jakarta.transaction.Transactional;

//BoardRequestService.java
@Service
public class BoardRequestService {

	@Autowired
	private BoardRequestRepository boardRequestRepository;
	
	@Autowired
	private BoardRepository boardRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	@Autowired
	private AddMemberRepository addMemberRepository;
	
	@Autowired
	private DepartmentRepository departmentRepository;

	@Transactional
	public boolean saveBoardRequest(BoardRequestDto boardRequestDto, User loginUser) {
		try {
			BoardRequest request = new BoardRequest();
			
			request.setBrTitle(boardRequestDto.getTitle());
			request.setBrType(boardRequestDto.getType());
			request.setBrStatus("PENDING");
			request.setDeptNum(boardRequestDto.getDeptNum());
			request.setuNum(loginUser.getuNum());
			request.setBrRegDate(LocalDateTime.now());
			
			boardRequestRepository.save(request);
			
			List<Long> memberIds = boardRequestDto.getMemberIds() != null ? new ArrayList<>(boardRequestDto.getMemberIds()) : new ArrayList<>();
			
			if (boardRequestDto.getType() == BoardType.PROJECT) {
				// 선택된 사원 저장
				for (Long userId : memberIds) {
					addMemberRepository.save(new AddMember(userId, null, request.getBrNum()));
				}
				
				if (!memberIds.contains(loginUser.getuNum())) {
					addMemberRepository.save(new AddMember(loginUser.getuNum(), null, request.getBrNum()));
				}
			}
			
			return true;
		} catch(Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public List<BoardRequestViewDto> getPendingRequestBoards() {
		List<BoardRequest> requests = boardRequestRepository.findByBrStatus("PENDING");
		
		Set<Long> uNumSet = new HashSet<>();
		Set<Long> deptNumSet = new HashSet<>();
		for(BoardRequest req : requests) {
			uNumSet.add(req.getuNum());
			deptNumSet.add(req.getDeptNum());
		}
		
		List<User> users = userRepository.findByUNumIn(new ArrayList<>(uNumSet));
		Map<Long, User> userMap = new HashMap<>();		
		Set<String> eNumSet = new HashSet<>();
		for(User user : users) {
			userMap.put(user.getuNum(), user);
			if(user.geteNum() != null) {				
				eNumSet.add(user.geteNum());
			}
		}
		
		List<Employee> employees = employeeRepository.findByENumIn(new ArrayList<>(eNumSet));
		Map<String, Employee> empMap = new HashMap<>();
		for(Employee emp : employees) {
			empMap.put(emp.geteNum(), emp);
		}
		
		List<Department> departments = departmentRepository.findByDeptNumIn(new ArrayList<>(deptNumSet));
	    Map<Long, String> deptNameMap = new HashMap<>();
	    for (Department dept : departments) {
	        deptNameMap.put(dept.getDeptNum(), dept.getDeptName());
	    }
		
		List<BoardRequestViewDto> result = new ArrayList<>();
		for(BoardRequest req : requests) {
			User user = userMap.get(req.getuNum());
			Employee emp = (user != null) ? empMap.get(user.geteNum()) : null;
			String requesterName = (emp != null) ? emp.geteName() : "알 수 없음";
			String deptName = deptNameMap.getOrDefault(req.getDeptNum(), "-");
			
			BoardRequestViewDto dto = new BoardRequestViewDto(
				req.getBrNum(), 
				req.getBrTitle(), 
				req.getBrType(), 
				deptName,
				req.getBrStatus(), 
				req.getuNum(),
				requesterName
			);
			result.add(dto);
		}
		
	    return result;
	}
	
	@Transactional
	public String approveRequest(Long brNum) {
		Optional<BoardRequest> optionalRequest = boardRequestRepository.findById(brNum);
		if(optionalRequest.isEmpty()) return "이미 처리된 요청입니다.";
		
		BoardRequest boardRequest = optionalRequest.get();
		
		if(!boardRequest.getBrStatus().equals(BoardStatus.PENDING.name())) return "이미 처리된 요청입니다.";
		
		if (boardRequest.getBrType() == BoardType.DEPARTMENT) {
	        Long deptNum = boardRequest.getDeptNum();
	        if (deptNum != null && boardRepository.countByDeptNum(deptNum) > 0) {
	            return "해당 부서에는 이미 게시판이 존재합니다.";
	        }
	    }
		
		boardRequest.setBrStatus(BoardStatus.APPROVED.name());
		
		Board board = new Board();
		board.setbTitle(boardRequest.getBrTitle());
		board.setbType(boardRequest.getBrType());
		board.setbStatus("ACTIVE");
		board.setuNum(boardRequest.getuNum());
		board.setDeptNum(boardRequest.getDeptNum());
		board.setbRegDate(LocalDateTime.now());
		
		boardRepository.save(board);
		
		List<AddMember> requestMembers = addMemberRepository.findByBrNum(brNum);
		addMemberRepository.deleteByBrNum(brNum);
		
		for(AddMember am : requestMembers) {
			AddMember newAm = new AddMember();
			newAm.setuNum(am.getuNum());
			newAm.setbNum(board.getbNum());
			newAm.setBrNum(null);
			addMemberRepository.save(newAm);
		}
		
		return null;
	}
	
	@Transactional
	public boolean rejectRequest(Long brNum) {
		Optional<BoardRequest> optionalRequest = boardRequestRepository.findById(brNum);
		
		if(optionalRequest.isEmpty()) {
			return false;
		}
		
		BoardRequest boardRequest = optionalRequest.get();
		
		if(!boardRequest.getBrStatus().equals(BoardStatus.PENDING.name())) {
			return false;
		}
		boardRequest.setBrStatus(BoardStatus.REJECTED.name());
		
		return true;
	}
}