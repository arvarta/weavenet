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
</head>

<body>
	<div class="core_button">
		<span class="btnBc solid medium">
			<a id="writeBtn" href="${pageContext.request.contextPath}/api/admin/posts/postWrite?bNum=${board.bNum}">글쓰기</a>
		</span>
	</div>

	<div class="menu_box separator">

		<div class="head_bar">
			<button type="button" class="btn_fold active" data-role="toggle-all">
				<span class="text">전체 게시판</span>
			</button>
		</div>

		<ul class="lnb_tree active" data-role="all-menu">
			<li class="board">
			<c:choose>
					<c:when test="${ loginUser.uAuth == 'SUPER_ADMIN' || loginUser.uAuth == 'EMPLOYEE_MANAGER' }">
				<div class="menu_item">
					<a class="item_txt ic_u" title="사원 관리" href="/api/admin/user">
						<span class="text">사원 관리</span>
					</a>
				</div>
				</c:when>
				</c:choose>
			</li>

			<li class="groups">
				<div class="head_bar">
					<button type="button" class="btn_fold active" data-role="group-toggle">
						<span class="text">게시판 관리</span>
					</button>
				</div>
				<ul class="lnb_tree active">
				<c:choose>
					<c:when test="${ loginUser.uAuth == 'SUPER_ADMIN' || loginUser.uAuth == 'BOARD_MANAGER' }">
						<li class="board">
							<div class="menu_item">
								<a class="item_txt ic_b" title="요청 관리" href="/api/admin/boards/request">
									<span class="text">요청 관리</span>
								</a>
							</div>
						</li>
						<li class="board">
							<div class="menu_item">
								<a class="item_txt ic_b" title="목록 관리" href="/api/admin/boards">
									<span class="text">목록 관리</span>
								</a>
							</div>
						</li>
						<li class="board">
							<div class="menu_item">
								<a class="item_txt ic_b" title="관리자 1:1 문의" href="/api/admin/supports/supportList">
									<span class="text">관리자 1:1 문의</span>
								</a>
							</div>
						</li>
						<c:forEach var="board" items="${boards}">
							<c:if test="${board.bType eq 'NOTICE'}">
								<li class="board">
									<div class="menu_item">
										<a class="item_txt" title="${board.bTitle}" href="/api/admin/boards/${board.bNum}">
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
										<a class="item_txt" title="${board.bTitle}" href="/api/admin/boards/${board.bNum}">
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
												<a class="item_txt" title="${board.bTitle}" href="/api/admin/boards/${board.bNum}">
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
												<a class="item_txt" title="${board.bTitle}" href="/api/admin/boards/${board.bNum}">
													<span class="text">${board.bTitle}</span>
												</a>
											</div>
										</li>
									</c:if>
								</c:forEach>
							</ul>
						</li>
					</c:when>
					<c:otherwise>
						<c:forEach var="board" items="${boards}">
							<c:if test="${board.bType eq 'NOTICE'}">
								<li class="board">
									<div class="menu_item">
										<a class="item_txt" title="${board.bTitle}" href="/api/admin/boards/${board.bNum}">
											<span class="text">${board.bTitle}</span>
										</a>
									</div>
								</li>
							</c:if>
						</c:forEach>
						<li class="board">
							<div class="menu_item">
								<a class="item_txt ic_b" title="관리자 1:1 문의" href="/api/admin/supports/supportList">
									<span class="text">관리자 1:1 문의</span>
								</a>
							</div>
						</li>
					</c:otherwise>
				</c:choose>
				</ul>
			</li>
			<!-- 			
				<li class="board">
					<div class="menu_item">
						<a class="item_txt ic_r" title="신고" href="">
							<span class="text">신고</span>
						</a>
					</div>
				</li>
				<li class="board">
					<div class="menu_item">
						<a class="item_txt ic_l" title="로그" href="">
							<span class="text">로그</span>
						</a>
					</div>
				</li>
				<li class="board">
					<div class="menu_item">
						<a class="item_txt ic_g" title="휴지통" href="">
							<span class="text">휴지통</span>
						</a>
					</div>
				</li>
			 -->
		</ul>
	</div>
	<script>
        window.addEventListener("DOMContentLoaded", function () {
            const path = window.location.pathname;
            const writeBtn = document.getElementById("writeBtn");

            // 관리자 1:1 문의 게시판일 경우 링크 수정
            if (path.includes("/supports/supportList")) {
                writeBtn.setAttribute("href", "${pageContext.request.contextPath}/api/admin/supports/supportWrite");
            }
        });
    </script>
</body>
</html>