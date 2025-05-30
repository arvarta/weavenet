<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<title>WeaveNet</title>
	<meta charset="UTF-8">
</head>
<body>
	<h1 class="title">전체 게시판<span class="btnBc outline small"><input type="button" value="추가"></span></h1>
	<div class="topSearchA">
	    <div class="selectBox"><!-- 펼침 on추가 -->
	        <input type="text" class="txtBox" value="유형" readonly="">
	        <ul class="option">
	            <li><a href="#">게시판</a></li>
	            <li><a href="#">신고자</a></li>
	        </ul>
	    </div>
		<div class="inputBox">
			<div class="input_set">
				<input class="inpt" type="text" value="" id="input-large-name1" placeholder="검색어를 입력하세요.">
				<div class="rt"><button type="button" class="btnDel">삭제</button></div>
				<button type="button" class="btn_search_submit"><i class="blind">검색</i></button>
			</div>
		</div>
    </div>
	<table class="listTypeA">
		<colgroup>
			<col style="width: 124px;">
			<col>
			<col style="width: 124px;">
			<col style="width: 124px;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">분류</th>
				<th scope="col">제목</th>
				<th scope="col">작성일</th>
				<th scope="col">답변여부</th>
			</tr>
		</thead>
		<tbody>
			<tr class="notice">
				<td>공지사항</td>
				<td class="subject"><a href="#"><em class="noti_badge">필독</em>게시판 추가 요청 문의 드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr class="notice">
				<td>공지사항</td>
				<td class="subject"><a href="#"><em class="noti_badge">필독</em>프로젝트 게시판에 사원 추가 관련 문의드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr class="notice">
				<td>공지사항</td>
				<td class="subject"><a href="#">프로젝트 게시판에 사원 추가 관련 문의드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
		</tbody>
		<tbody>
			<tr>
				<td>게시판</td>
				<td class="subject"><a href="#">게시판 추가 요청 문의 드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr>
				<td>게시판</td>
				<td class="subject"><a href="#">프로젝트 게시판에 사원 추가 관련 문의드립니다.</a></td>
				<td class="date">25.06.28</td>
				<td class="ans">답변대기</td>
			</tr>
			<tr>
				<td>사원</td>
				<td class="subject"><a href="#">사원 등급 관련 문의</a></td>
				<td class="date">25.06.28</td>
				<td class="ans done">답변완료</td>
			</tr>
			<tr>
				<td>사원</td>
				<td class="subject"><a href="#">사원 등급 관련 문의</a></td>
				<td class="date">25.06.28</td>
				<td class="ans done">답변완료</td>
			</tr>
		</tbody>
	</table>
	<jsp:include page="/WEB-INF/views/include/pagenation.jsp" />
</body>
</html>