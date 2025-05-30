<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판</title>
<link href="${pageContext.request.contextPath}/css/cursor.css" rel="stylesheet" type="text/css">
</head>
<body>
	<c:choose>
	    <c:when test="${ board != null }">
	        <h1 class="title">
	        	${board.bTitle}
	       	</h1>
	    </c:when>
	    <c:otherwise>
	        <h1 class="title">전체 게시글</h1>
	       	<div class="listTop">
				<p>총 게시물 <b>${activePostCount}</b></p>
			</div>
	    </c:otherwise>
	</c:choose>


    <form>
        <table class="listTypeA">
        	<colgroup>
				<col style="width: 124px;">
				<col style="width: 100px;">
				<col>
				<col style="width: 124px;">
				<col style="width: 124px;">
			</colgroup>
            <thead>
                <tr>
                    <th scope="col">구분</th>
                    <th scope="col">소속</th>
                    <th scope="col">제목</th>
                    <th scope="col">작성자</th>
                    <th scope="col">조회수</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${ empty postList }">
                        <tr>
                            <td colspan="6">
                                <div class="nodata img">
                                    <p class="board_no">
                                        <b>게시글이 없습니다.</b>
                                        처음으로 게시글을 작성해 보세요!
                                    </p> 
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="post" items="${postList}" varStatus="status">
                            <tr>
                                <td>${boardTitlesMap[post.bNum]}</td>
								    <td>${ deptNamesMap[post.bNum] }</td>
                                <td class="subject">
                                	<a href="${pageContext.request.contextPath}/api/posts/${ post.pNum }">${ post.pTitle }</a>
                                </td>
                                <td>${ writerNames[status.index] }</td>
                                <td>20</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        <c:choose>
		    <c:when test="${board != null}">
		        <c:set var="paginationUrl" value="/api/boards/${board.bNum}" />
		    </c:when>
		    <c:otherwise>
		        <c:set var="paginationUrl" value="/api/posts/postList" />
		    </c:otherwise>
		</c:choose>

		<jsp:include page="../include/pagenation.jsp">
		    <jsp:param name="pageUrl" value="${paginationUrl}" />
		    <jsp:param name="bNum" value="${board.bNum}" />
		</jsp:include>

    </form>
</body>
</html>
