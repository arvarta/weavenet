package org.wn.weavenet.dto;

import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.enums.UserRank;

public class UserRoleUpdateRequest {
	private UserRank uRank;
	private UserAuth uAuth;

	public UserRoleUpdateRequest() {
	}

	public UserRoleUpdateRequest(UserRank uRank, UserAuth uAuth) {
		this.uRank = uRank;
		this.uAuth = uAuth;
	}

	public UserAuth getuAuth() {
		return uAuth;
	}

	public UserRank getuRank() {
		return uRank;
	}

	public void setuAuth(UserAuth uAuth) {
		this.uAuth = uAuth;
	}

	public void setuRank(UserRank uRank) {
		this.uRank = uRank;
	}
}
