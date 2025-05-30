<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<script>
		const isAdminPage = '${isAdminPage}' === 'true';
	</script>
	<div id="boardSelectModal" class="modal">
	    <div class="modal-content">
	        <span class="close">&times;</span>
	        <h3>게시판 선택</h3>
	        <ul>
	            <c:forEach var="b" items="${boards}" varStatus="status">
	                <c:if test="${ not empty b.bNum }">
	                	<c:choose>
				            <c:when test="${loginUser.uAuth == 'SUPER_ADMIN' || loginUser.uAuth == 'BOARD_MANAGER'}">
				                <li>
				                    <c:set var="inputId" value="board_${status.index}" />
				                    <input type="radio" id="${inputId}" name="boardRadio" class="radio_box small"
				                           data-bnum="${b.bNum}" value="${b.bTitle}" />
				                    <label for="${inputId}"><span>${b.bTitle}</span></label>
				                </li>
				            </c:when>
				
				            <c:when test="${loginUser.uAuth == 'USER'}">
				            	<c:if test="${deptNum == b.deptNum || b.bType == 'GENERAL' || (b.bType == 'PROJECT' && fn:contains(projectBoardNumsStr, b.bNum))}">			            	
					                <li>
					                    <c:set var="inputId" value="board_${status.index}" />
					                    <input type="radio" id="${inputId}" name="boardRadio" class="radio_box small"
					                           data-bnum="${b.bNum}" value="${b.bTitle}" />
					                    <label for="${inputId}"><span>${b.bTitle}</span></label>
					                </li>
				            	</c:if>
				            </c:when>
				
				        </c:choose>
				        
	                </c:if>
	            </c:forEach>
	
	            <c:if test="${ loginUser.uRank == 'HONOR' }">
	                <li>
	                    <input type="radio" id="board_admin_qna" name="boardRadio" class="radio_box small"
	                           data-bnum="" value="관리자 1:1 문의" />
	                    <label for="board_admin_qna"><span>관리자 1:1 문의</span></label>
	                </li>
	            </c:if>
	        </ul>
	
	        <div style="text-align:right; margin-top: 10px;" id="confirmButtonWrapper">
	            <span class="btnBc disabled small" id="confirmButtonSpan">
	                <input type="button" value="확인" disabled>
	            </span>
	        </div>
	        
	    </div>
	</div>
</body>
</html>