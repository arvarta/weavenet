<!-- /WEB-INF/views/layout.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>WeaveNet</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=1300">
    <link href="/css/addBoardModal.css" rel="stylesheet" type="text/css">
</head>

<body>
	<c:if test="${not empty error}">
	    <script>alert('${error}');</script>
	</c:if>
	<div class="core_button">
		<span class="btnBc solid medium">
		<c:if test="${not empty board.bNum}">
			<a id="writeBtn" href="${pageContext.request.contextPath}/api/posts/postWrite?bNum=${board.bNum}">글쓰기</a>
		</c:if>
		<c:if test="${empty board.bNum}">
			<a id="writeBtn" href="${pageContext.request.contextPath}/api/posts/postWrite">글쓰기</a>
		</c:if>
		</span>
		<c:choose>
			<c:when test="${loginUser != null && (loginUser.uAuth eq 'SUPER_ADMIN' || loginUser.uAuth eq 'BOARD_MANAGER')}">
				<span class="btnBc outline medium">
					<button type="button" onclick="openModal('admin')">+ 게시판 추가</button>
				</span>
			</c:when>
			<c:when test="${loginUser != null && ( loginUser.uAuth ne 'EMPLOYEE_MANAGER' && (loginUser.uRank eq 'REGULAR' || loginUser.uRank eq 'ELITE' || loginUser.uRank eq 'HONOR'))}">
				<span class="btnBc outline medium">
					<button type="button" onclick="openModal('user')">+ 게시판 추가 요청</button>
				</span>
			</c:when>
		</c:choose>
	</div>
	
	<div class="menu_box separator">
	
		<div class="head_bar">
			<button type="button" class="btn_fold active" data-role="toggle-all">
				<span class="text">전체 게시판</span>
			</button>
			<c:choose>
				<c:when test="${loginUser != null && (loginUser.uAuth eq 'SUPER_ADMIN' || loginUser.uAuth eq 'BOARD_MANAGER' || loginUser.uAuth eq 'EMPLOYEE_MANAGER')}">
					<span class="btnBc outline xsmall"><a href="/api/admin/main">관리</a></span>
				</c:when>
			</c:choose>
		</div>
	
		<ul class="lnb_tree active" data-role="all-menu">
			<c:forEach var="board" items="${boards}">
				<c:if test="${board.bType eq 'NOTICE'}">
					<li class="board">
						<div class="menu_item">
							<a class="item_txt" title="${board.bTitle}" href="/api/boards/${board.bNum}">
								<span class="text">${board.bTitle}</span>
							</a>
						</div>
					</li>
				</c:if>
			</c:forEach>
			<c:forEach var="board" items="${boards}">
				<c:if test="${board.bType eq 'GENERAL'}">
					<li class="board">
						<div class="menu_item">
							<a class="item_txt" title="${board.bTitle}" href="/api/boards/${board.bNum}">
								<span class="text">${board.bTitle}</span>
							</a>
						</div>
					</li>
				</c:if>
			</c:forEach>
	
			<li class="groups">
				<div class="head_bar">
					<button type="button" class="btn_fold active" data-role="group-toggle">
						<span class="text">부서 게시판</span>
					</button>
				</div>
				<ul class="lnb_tree active">
					<c:forEach var="board" items="${boards}">
						<c:if test="${board.bType eq 'DEPARTMENT'}">
							<li class="board">
								<div class="menu_item">
									<a class="item_txt" title="${board.bTitle}" href="/api/boards/${board.bNum}">
										<span class="text">${board.bTitle}</span>
									</a>
								</div>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</li>
	
			<li class="groups">
				<div class="head_bar">
					<button type="button" class="btn_fold active" data-role="group-toggle">
						<span class="text">프로젝트 게시판</span>
					</button>
				</div>
				<ul class="lnb_tree active">
					<c:forEach var="board" items="${boards}">
						<c:if test="${board.bType eq 'PROJECT'}">
							<li class="board">
								<div class="menu_item">
									<a class="item_txt" title="${board.bTitle}" href="/api/boards/${board.bNum}">
										<span class="text">${board.bTitle}</span>
									</a>
								</div>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</li>
	
			<li class="board">
				<div class="menu_item">
					<a class="item_txt" title="관리자 1:1문의" href="/api/supports/supportList">
						<span class="text">관리자 1:1 문의</span>
					</a>
				</div>
			</li>
		</ul>
	</div>
	<script>
        window.addEventListener("DOMContentLoaded", function () {
            const path = window.location.pathname;
            const writeBtn = document.getElementById("writeBtn");

            // 관리자 1:1 문의 게시판일 경우 링크 수정
            if (path.includes("/supports/supportList")) {
                writeBtn.setAttribute("href", "${pageContext.request.contextPath}/api/supports/supportWrite");
            }
        });
    </script>
</body>
</html>