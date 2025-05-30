package org.wn.weavenet.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wn.weavenet.repository.EmployeeRepository;

@Service
public class EmployeeService {

	@Autowired
	private EmployeeRepository employeeRepository;

	/** 사원번호로 이메일 불러오기 */
	public String findEEmailByENum(String eNum) {
		return employeeRepository.findEEmailByENum(eNum);
	}
}
