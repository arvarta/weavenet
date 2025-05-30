<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="pagenation">
    <!-- pageUrl 변수가 외부에서 넘어오지 않으면 기본값 지정 -->
    <c:choose>
	    <c:when test="${not empty param.pageUrl}">
	        <c:set var="finalPageUrl" value="${param.pageUrl}" />
	    </c:when>
	    <c:otherwise>
	        <c:set var="finalPageUrl" value="${request.getContextPath()}/api/posts/postList" />
	    </c:otherwise>
	</c:choose>
	
	<!-- queryParams 변수 처리 (검색 조건 등) -->
    <c:set var="extraQuery" value="" />
    <c:if test="${not empty param.queryParams}">
        <!-- queryParams 값이 &keyword=...&condition=... 형태로 넘어온다고 가정 -->
        <c:set var="extraQuery" value="${param.queryParams}" />
    </c:if>

    <c:set var="currentPage" value="${paging.currentPage}" />
    <c:set var="startPage" value="${paging.startPage}" />
    <c:set var="endPage" value="${paging.endPage}" />
    <c:set var="totalPage" value="${paging.totalPage}" />

    <!-- 처음 페이지 -->
    <c:choose>
        <c:when test="${currentPage > 1}">
            <a href="${finalPageUrl}?page=0&size=10${extraQuery}">
                <img src="${pageContext.request.contextPath}/img/ico_page_first.svg" alt="처음페이지" />
            </a>
        </c:when>
        <c:otherwise>
            <a href="#"><img src="${pageContext.request.contextPath}/img/ico_page_first.svg" alt="처음페이지" /></a>
        </c:otherwise>
    </c:choose>

    <!-- 이전 블럭 -->
    <c:choose>
        <c:when test="${currentPage > 1}">
            <a href="${finalPageUrl}?page=${currentPage - 2}&size=10${extraQuery}">
                <img src="${pageContext.request.contextPath}/img/ico_page_before.svg" alt="이전" />
            </a>
        </c:when>
        <c:otherwise>
            <a href="#"><img src="${pageContext.request.contextPath}/img/ico_page_before.svg" alt="이전" /></a>
        </c:otherwise>
    </c:choose>

    <!-- 페이지 번호 출력 -->
    <c:forEach var="i" begin="${startPage}" end="${endPage}">
        <c:choose>
            <c:when test="${i == currentPage}">
                <a href="#" class="on">${i}</a>
            </c:when>
            <c:otherwise>
                <a href="${finalPageUrl}?page=${i - 1}&size=10${extraQuery}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <!-- 다음 블럭 -->
    <c:choose>
        <c:when test="${currentPage < totalPage}">
            <a href="${finalPageUrl}?page=${currentPage}&size=10${extraQuery}">
                <img src="${pageContext.request.contextPath}/img/ico_page_next.svg" alt="다음" />
            </a>
        </c:when>
        <c:otherwise>
            <a href="#"><img src="${pageContext.request.contextPath}/img/ico_page_next.svg" alt="다음" /></a>
        </c:otherwise>
    </c:choose>

    <!-- 마지막 페이지 -->
    <c:choose>
        <c:when test="${currentPage < totalPage}">
            <a href="${finalPageUrl}?page=${totalPage - 1}&size=10${extraQuery}">
                <img src="${pageContext.request.contextPath}/img/ico_page_last.svg" alt="끝페이지" />
            </a>
        </c:when>
        <c:otherwise>
            <a href="#"><img src="${pageContext.request.contextPath}/img/ico_page_last.svg" alt="끝페이지" /></a>
        </c:otherwise>
    </c:choose>
</div>
