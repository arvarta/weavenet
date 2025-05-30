package org.wn.weavenet.dto;

public class WriterDTO {
	
	private String eNum;
	private String eName;
	private Long uNum;
	
	public WriterDTO() {
	
	}
	
	public WriterDTO(String eName, Long uNum) {
		this.eName = eName;
		this.uNum = uNum;
	}


	public WriterDTO(String eNum, String eName, Long uNum) {
		this.eNum = eNum;
		this.eName = eName;
		this.uNum = uNum;
	}

	public String geteNum() {
		return eNum;
	}

	public void seteNum(String eNum) {
		this.eNum = eNum;
	}

	public String geteName() {
		return eName;
	}

	public void seteName(String eName) {
		this.eName = eName;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}
	
	
	
}
