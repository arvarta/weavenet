package org.wn.weavenet.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "add_member")
public class AddMember {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "am_num", nullable = false)
	private Long amNum;
	
	@Column(name = "u_num" , nullable = false)
	private Long uNum;

	@Column(name = "b_num" , nullable = true)
	private Long bNum;
	
	@Column(name = "br_num" , nullable = true)
	private Long brNum;

	public AddMember() {}

	public AddMember(Long uNum, Long bNum, Long brNum) {
		super();
		this.uNum = uNum;
		this.bNum = bNum;
		this.brNum = brNum;
	}

	public AddMember(Long amNum, Long uNum, Long bNum, Long brNum) {
		super();
		this.amNum = amNum;
		this.uNum = uNum;
		this.bNum = bNum;
		this.brNum = brNum;
	}

	public Long getAmNum() {
		return amNum;
	}

	public void setAmNum(Long amNum) {
		this.amNum = amNum;
	}

	public Long getuNum() {
		return uNum;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	public Long getbNum() {
		return bNum;
	}

	public void setbNum(Long bNum) {
		this.bNum = bNum;
	}

	public Long getBrNum() {
		return brNum;
	}

	public void setBrNum(Long brNum) {
		this.brNum = brNum;
	}
	
}
