package org.wn.weavenet.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "file")
public class Pile {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "f_num", nullable = true)
	private Long f_num; // 파일 식별 번호

	@Column(name = "f_name", nullable = true, length = 200)
	private String fName; // 파일 이름

	@Column(name = "f_size", nullable = true)
	private Long fSize; // 파일 용량

	@Column(name = "stored_file_name", nullable = false, length = 255)
	private String storedFileName; // 파일 저장소

	@Column(name = "p_num", nullable = false)
	private Long pNum; // 게시글 식별 번호

	public Pile() {
	}

	public Pile(Long f_num, String fName, Long fSize, String storedFileName, Long pNum) {
		this.f_num = f_num;
		this.fName = fName;
		this.fSize = fSize;
		this.storedFileName = storedFileName;
		this.pNum = pNum;
	}

	public Pile(String fName, Long fSize, String storedFileName, Long pNum) {
		this.fName = fName;
		this.fSize = fSize;
		this.storedFileName = storedFileName;
		this.pNum = pNum;
	}

	public Long getF_num() {
		return f_num;
	}

	public String getfName() {
		return fName;
	}

	public Long getfSize() {
		return fSize;
	}

	public Long getpNum() {
		return pNum;
	}

	public String getStoredFileName() {
		return storedFileName;
	}

	public void setF_num(Long f_num) {
		this.f_num = f_num;
	}

	public void setfName(String fName) {
		this.fName = fName;
	}

	public void setfSize(Long fSize) {
		this.fSize = fSize;
	}

	public void setpNum(Long pNum) {
		this.pNum = pNum;
	}

	public void setStoredFileName(String storedFileName) {
		this.storedFileName = storedFileName;
	}

}
