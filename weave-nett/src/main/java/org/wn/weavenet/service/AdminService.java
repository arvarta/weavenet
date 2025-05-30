package org.wn.weavenet.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wn.weavenet.dto.AdminMainRequestDto;
import org.wn.weavenet.enums.UserStatus;
import org.wn.weavenet.repository.CommentRepository;
import org.wn.weavenet.repository.PostRepository;
import org.wn.weavenet.repository.UserRepository;

@Service
public class AdminService {

	@Autowired
	UserRepository userRepository;

	@Autowired
	PostRepository postRepository;

	@Autowired
	CommentRepository commentRepository;

	public AdminMainRequestDto getDashboardData() {
		AdminMainRequestDto dto = new AdminMainRequestDto();

		dto.setActiveEmployees(
				userRepository.countByUserStatusEnum(
						UserStatus.APPROVED));
		
		dto.setPendingEmployees(
				userRepository.countByUserStatusEnum(
						UserStatus.PENDING));
		
		dto.setInactiveEmployees(
				userRepository.countByUserStatusEnum(
						UserStatus.INACTIVE));
		
		long total = dto.getActiveEmployees() 
				+ dto.getPendingEmployees() 
				+ dto.getInactiveEmployees();
		
		dto.setTotalEmployees(total);

		LocalDateTime startOfDay = LocalDateTime.of(
				LocalDate.now(), 
				LocalTime.MIN);
		
		LocalDateTime endOfDay = LocalDateTime.of(
				LocalDate.now(), 
				LocalTime.MAX);

		dto.setTodayPosts(postRepository.countByPRegDateBetween(startOfDay, endOfDay));
		dto.setTodayComments(commentRepository.countByCRegDateBetween(startOfDay, endOfDay));

		return dto;
	}
}
