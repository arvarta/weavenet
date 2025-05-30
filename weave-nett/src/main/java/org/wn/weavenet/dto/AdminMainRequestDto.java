package org.wn.weavenet.dto;

public class AdminMainRequestDto {

	private long activeEmployees; 
	private long pendingEmployees; 
	private long inactiveEmployees; 
	private long totalEmployees; 

	private long todayPosts; 
	private long todayComments;

	public AdminMainRequestDto() {
	}

	public AdminMainRequestDto(long activeEmployees, long pendingEmployees, long inactiveEmployees, long totalEmployees,
			long todayPosts, long todayComments) {
		this.activeEmployees = activeEmployees;
		this.pendingEmployees = pendingEmployees;
		this.inactiveEmployees = inactiveEmployees;
		this.totalEmployees = totalEmployees;
		this.todayPosts = todayPosts;
		this.todayComments = todayComments;
	}

	public long getActiveEmployees() {
		return activeEmployees;
	}

	public long getInactiveEmployees() {
		return inactiveEmployees;
	}

	public long getPendingEmployees() {
		return pendingEmployees;
	}

	public long getTodayComments() {
		return todayComments;
	}

	public long getTodayPosts() {
		return todayPosts;
	}

	public long getTotalEmployees() {
		return totalEmployees;
	}

	public void setActiveEmployees(long activeEmployees) {
		this.activeEmployees = activeEmployees;
	}

	public void setInactiveEmployees(long inactiveEmployees) {
		this.inactiveEmployees = inactiveEmployees;
	}

	public void setPendingEmployees(long pendingEmployees) {
		this.pendingEmployees = pendingEmployees;
	}

	public void setTodayComments(long todayComments) {
		this.todayComments = todayComments;
	}

	public void setTodayPosts(long todayPosts) {
		this.todayPosts = todayPosts;
	}

	public void setTotalEmployees(long totalEmployees) {
		this.totalEmployees = totalEmployees;
	}

}