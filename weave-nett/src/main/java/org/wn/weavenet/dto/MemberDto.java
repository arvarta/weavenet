package org.wn.weavenet.dto;

public class MemberDto {
    private Long uNum;
    private String eName;
    private String ePosition;
    
	public MemberDto(Long uNum, String eName, String ePosition) {
		super();
		this.uNum = uNum;
		this.eName = eName;
		this.ePosition = ePosition;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	public String geteName() {
		return eName;
	}

	public void seteName(String eName) {
		this.eName = eName;
	}

	public String getePosition() {
		return ePosition;
	}

	public void setePosition(String ePosition) {
		this.ePosition = ePosition;
	}

}



