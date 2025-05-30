<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>관리자 게시판 목록</title>
    <style>
        .sidebar { width: 260px; padding: 20px; background: #f8f9fa; border-right: 1px solid #ddd; }
        .sidebar button { width: 100%; padding: 10px; margin-bottom: 20px; border: none; border-radius: 4px; cursor: pointer; background: #343a40; color: white; }
        .category { font-weight: bold; margin-top: 20px; color: #333; }
        .board-link { margin: 8px 0; display: flex; align-items: center; color: #555; }
    </style>
</head>
<body>
<div class="sidebar">

    <!-- ADMIN_ONLY 게시판 (상단 고정) -->
    <div class="category">▾ 전체 게시판 관리</div>
    <c:forEach var="board" items="${adminOnlyBoards}">
        <div class="board-link"><span>${board.bTitle}</span></div>
    </c:forEach>

    <!-- 공지/일반 게시판 (b_status = ACTIVE) -->
    <c:forEach var="board" items="${normalBoards}">
        <c:if test="${board.bType eq 'NOTICE' || board.bType eq 'GENERAL'}">
            <div class="board-link"><span>${board.bTitle}</span></div>
        </c:if>
    </c:forEach>

    <!-- 부서 게시판 (b_status = ACTIVE) -->
    <div class="category">▾ 부서 게시판 관리</div>
    <c:forEach var="board" items="${normalBoards}">
        <c:if test="${board.bType eq 'DEPARTMENT'}">
            <div class="board-link"><span>${board.bTitle}</span></div>
        </c:if>
    </c:forEach>

    <!-- 프로젝트 게시판 (b_status = ACTIVE) -->
    <div class="category">▾ 프로젝트 게시판 관리</div>
    <c:forEach var="board" items="${normalBoards}">
        <c:if test="${board.bType eq 'PROJECT'}">
            <div class="board-link"><span>${board.bTitle}</span></div>
        </c:if>
    </c:forEach>

</div>
</body>
</html>
