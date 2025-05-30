package org.wn.weavenet.entity;

import java.time.LocalDateTime;

import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.enums.UserRank;
import org.wn.weavenet.enums.UserRole;
import org.wn.weavenet.enums.UserStatus;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "`user`")
public class User {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "u_num", nullable = false)
	private Long uNum;

	@Column(name = "u_password", nullable = false, length = 512)
	private String uPassword;

	@Enumerated(EnumType.STRING)
	@Column(name = "u_auth", nullable = false, length = 20)
	private UserAuth uAuth;

	@Enumerated(EnumType.STRING)
	@Column(name = "u_rank", nullable = true, length = 20)
	private UserRank uRank;

	@Enumerated(EnumType.STRING)
	@Column(name = "u_role", nullable = true, length = 20)
	private UserRole uRole;
	
	@Enumerated(EnumType.STRING)
	@Column(name = "u_status", nullable = false, length = 30)
	private UserStatus uStatus;

	@Column(name = "u_profile", nullable = true)
	private String uProfile;

	@Column(name = "u_reg_date", nullable = false)
	private LocalDateTime uRegDate;
	
	@Column(name = "u_email", nullable = false, length = 91, unique = true)
	private String uEmail;
	
	@Column(name = "e_num", nullable = true, length = 30)
	private String eNum;

	public User() {}

	public User(Long uNum, String uPassword, UserAuth uAuth, UserRank uRank, UserRole uRole, UserStatus uStatus,
			String uProfile, LocalDateTime uRegDate, String uEmail, String eNum) {
		this.uNum = uNum;
		this.uPassword = uPassword;
		this.uAuth = uAuth;
		this.uRank = uRank;
		this.uRole = uRole;
		this.uStatus = uStatus;
		this.uProfile = uProfile;
		this.uRegDate = uRegDate;
		this.uEmail = uEmail;
		this.eNum = eNum;
	}

	public User(String uPassword, UserAuth uAuth, UserRank uRank, UserRole uRole, UserStatus uStatus,
			String uProfile, LocalDateTime uRegDate,String uEmail, String eNum) {
		this.uPassword = uPassword;
		this.uAuth = uAuth;
		this.uRank = uRank;
		this.uRole = uRole;
		this.uStatus = uStatus;
		this.uProfile = uProfile;
		this.uRegDate = uRegDate;
		this.uEmail = uEmail;
		this.eNum = eNum;
	}
	
	public String getuEmail() {
		return uEmail;
	}
	
	public void setuEmail(String uEmail) {
		this.uEmail = uEmail;
	}
	public String geteNum() {
		return eNum;
	}

	public UserAuth getuAuth() {
		return uAuth;
	}

	public Long getuNum() {
		return uNum;
	}

	public String getuPassword() {
		return uPassword;
	}

	public String getuProfile() {
		return uProfile;
	}

	public UserRank getuRank() {
		return uRank;
	}

	public LocalDateTime getuRegDate() {
		return uRegDate;
	}

	public UserRole getuRole() {
		return uRole;
	}

	public UserStatus getuStatus() {
		return uStatus;
	}

	public void seteNum(String eNum) {
		this.eNum = eNum;
	}

	public void setuAuth(UserAuth uAuth) {
		this.uAuth = uAuth;
	}

	public void setuNum(Long uNum) {
		this.uNum = uNum;
	}

	public void setuPassword(String uPassword) {
		this.uPassword = uPassword;
	}

	public void setuProfile(String uProfile) {
		this.uProfile = uProfile;
	}

	public void setuRank(UserRank uRank) {
		this.uRank = uRank;
	}

	public void setuRegDate(LocalDateTime uRegDate) {
		this.uRegDate = uRegDate;
	}

	public void setuRole(UserRole uRole) {
		this.uRole = uRole;
	}

	public void setuStatus(UserStatus uStatus) {
		this.uStatus = uStatus;
	}


	
}
