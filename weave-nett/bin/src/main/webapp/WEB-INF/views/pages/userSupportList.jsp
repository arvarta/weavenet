<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 1:1 문의</title>
<link href="${pageContext.request.contextPath}/css/cursor.css" rel="stylesheet" type="text/css">
</head>
<body>
	<h1 class="title">
		관리자 1:1 문의
	</h1> 
	<form>
		<table class="listTypeA">
			<colgroup>
				<col style="width: 124px;">
				<col style="width: 124px;">
				<col>
				<col style="width: 124px;">
				<col style="width: 124px;">
				<col style="width: 124px;">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">분류</th>
					<th scope="col">제목</th>
					<th scope="col">작성자</th>
					<th scope="col">작성일</th>
					<th scope="col">답변여부</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${ empty supportList}">
						<tr>
							<td colspan="6">
								<div class="nodata img">
								    <p class="board_no">
								    	<b>문의 게시글이 없습니다.</b>
								    	문의사항이 있다면 게시글을 작성해 주세요!
								    </p> 
							    </div>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="sb" items="${supportList}" varStatus="status">
							<tr>
								<td>${ sb.sbNum }</td>
								<td>${ sb.sbType }</td>
								<td class="subject"><a href="/api/supports/${ sb.sbNum }">${ sb.sbTitle }</a></td>
								<td>${ writerNames[status.index] }</td>
								<td class="date">${ formattedDates[status.index] }</td>
								<c:choose>
									<c:when test="${sb.sbStatus == 'WAIT_ANSWER'}"><td class="ans">답변 대기</td></c:when>
									<c:when test="${sb.sbStatus == 'COMPLETED_ANSWER'}"><td class="ans done">답변 완료</td></c:when>
								</c:choose>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		<jsp:include page="../include/pagenation.jsp">
   			<jsp:param name="pageUrl" value="/api/supports/supportList" />
		</jsp:include>
	</form>
</body>
</html>