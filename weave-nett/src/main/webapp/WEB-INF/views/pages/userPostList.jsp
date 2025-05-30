<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판</title>
<link href="${pageContext.request.contextPath}/css/base.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css">
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
				<col style="width: 200px;">
				<col>
				<col style="width: 124px;">
				<col style="width: 124px;">
			</colgroup>
            <thead>
                <tr>
                    <th scope="col" class="sortable-header" data-sort-column="type">구분<span class="sort-arrow"></span></th>
                    <th scope="col" class="sortable-header" data-sort-column="title">제목<span class="sort-arrow"></span></th>
                    <th scope="col" class="sortable-header" data-sort-column="writer">작성자<span class="sort-arrow"></span></th>
                    <th scope="col" class="sortable-header" data-sort-column="views">조회수<span class="sort-arrow"></span></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${ empty postList }">
                        <tr>
                            <td colspan="4">
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
	                            <tr <c:if test="${bTypeMap[post.bNum] == 'NOTICE'}">class="notice-post"</c:if>>
	                                <td>${boardTitlesMap[post.bNum]}</td>
	                                <td class="subject">
	                                	<c:choose>
	                                	
	                                		<c:when test="${ board.bType eq 'NOTICE' }">
	                                			<a href="${pageContext.request.contextPath}/api/posts/${ post.pNum }">
			                                		<span class="noti_badge">공지</span>${ post.pTitle }
			                                	</a>
	                                		</c:when>
	                                		<c:when test="${ bTypeMap[post.bNum] eq 'NOTICE' }">
	                                			<a href="${pageContext.request.contextPath}/api/posts/${ post.pNum }">
			                                		<span class="noti_badge">공지</span>${ post.pTitle }
			                                	</a>
	                                		</c:when>
	                                		<c:otherwise>
	                                			<a href="${pageContext.request.contextPath}/api/posts/${ post.pNum }">
			                                		${ post.pTitle }
			                                	</a>
	                                		</c:otherwise>
	                                	</c:choose>	
	                                </td>
	                                <td>${ writerNames[status.index] }</td>
	                                <td>${ post.pViews }</td>
	                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

		<c:set var="queryParams" value="" />
		<c:if test="${not empty param.keyword}">
		    <c:set var="queryParams" value="${queryParams}&keyword=${fn:escapeXml(param.keyword)}" />
		</c:if>
		<c:if test="${not empty param.condition}">
		    <c:set var="queryParams" value="${queryParams}&condition=${fn:escapeXml(param.condition)}" />
		</c:if>

        <c:choose>
		    <c:when test="${not empty board}">
		        <c:set var="paginationUrl" value="/api/boards/${board.bNum}" />
		    </c:when>
		    <c:when test="${not empty param.bNum}">
		        <c:set var="paginationUrl" value="/api/boards/${param.bNum}" />
		    </c:when>
		    <c:otherwise>
		        <c:set var="paginationUrl" value="/api/posts/postList" />
		    </c:otherwise>
		</c:choose>

		<jsp:include page="../include/pagenation.jsp">
		    <jsp:param name="pageUrl" value="${paginationUrl}" />
		    <jsp:param name="queryParams" value="${queryParams}" />
		</jsp:include>

    </form>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        let sortDirections = {
            type: 'asc',
            title: 'asc',
            writer: 'asc',
            views: 'asc'
        };

        document.querySelectorAll('table.listTypeA thead th.sortable-header').forEach(header => {
            header.addEventListener('click', function() {
                const column = this.dataset.sortColumn;
                const direction = sortDirections[column];
                const tableBody = this.closest('table').querySelector('tbody');
                const rows = Array.from(tableBody.querySelectorAll('tr'));
                const currentArrowSpan = this.querySelector('.sort-arrow');

                const dataRows = rows.filter(row => !row.querySelector('.nodata'));

                if (dataRows.length === 0) return;

                dataRows.sort((rowA, rowB) => {
                    let valA, valB;
                    let isNoticeA = false;
                    let isNoticeB = false;

                    switch (column) {
                        case 'type':
                            valA = rowA.querySelector('td:nth-child(1)').textContent.trim();
                            valB = rowB.querySelector('td:nth-child(1)').textContent.trim();
                            isNoticeA = (valA === '공지사항');
                            isNoticeB = (valB === '공지사항');
                            break;
                        case 'title':
                            valA = rowA.querySelector('td:nth-child(2) a').textContent.replace('공지', '').trim();
                            valB = rowB.querySelector('td:nth-child(2) a').textContent.replace('공지', '').trim();
                            break;
                        case 'writer':
                            valA = rowA.querySelector('td:nth-child(3)').textContent.trim();
                            valB = rowB.querySelector('td:nth-child(3)').textContent.trim();
                            break;
                        case 'views':
                            valA = parseInt(rowA.querySelector('td:nth-child(4)').textContent.trim(), 10);
                            valB = parseInt(rowB.querySelector('td:nth-child(4)').textContent.trim(), 10);
                            break;
                        default:
                            return 0;
                    }

                    let comparison = 0;

                    if (column === 'type') {
                        if (isNoticeA && !isNoticeB) {
                            comparison = -1;
                        } else if (!isNoticeA && isNoticeB) {
                            comparison = 1;
                        } else {
                            comparison = String(valA).localeCompare(String(valB), 'ko-KR');
                        }
                    } else if (column === 'views') {
                        comparison = valA - valB;
                    } else {
                        comparison = String(valA).localeCompare(String(valB), 'ko-KR');
                    }

                    return direction === 'asc' ? comparison : -comparison;
                });

                sortDirections[column] = direction === 'asc' ? 'desc' : 'asc';

                document.querySelectorAll('th.sortable-header .sort-arrow').forEach(arrow => {
                    if (arrow !== currentArrowSpan) {
                        arrow.innerHTML = '';
                    }
                });
                currentArrowSpan.innerHTML = direction === 'asc' ? ' &#9660;' : ' &#9650;';

                dataRows.forEach(row => tableBody.appendChild(row));
                rows.filter(row => row.querySelector('.nodata')).forEach(row => tableBody.appendChild(row));
            });
        });
    });
    </script>
</body>
</html>