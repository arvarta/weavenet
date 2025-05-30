<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>WeaveNet</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=1300">
    <link href="${pageContext.request.contextPath}/css/base.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/admin_layout.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css">
    <script src="${pageContext.request.contextPath}/js/menu.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
</head>

<body>
	<div id="admin_header">
		<h1 class="weavenet_logo">
			<a href="/api/admin/main"><img src="${pageContext.request.contextPath}/img/logo_admin.svg"> <span>Admin</span></a>
		</h1>
		<div class="setting_area">
			<span class="btnBc outline small"><a href="${pageContext.request.contextPath}/api/posts/postList">게시판</a></span>
			<div class="profile_area">
				<div class="gnbMemberInfo">
					<div class="thumb">
						<span class="initial_profile">
                            <c:set var="profileImagePath" value="${pageContext.request.contextPath}/img/profile_default.png" />
                            <c:if test="${not empty sessionScope.loginUser && not empty sessionScope.loginUser.uProfile}">
                                <c:set var="profileImagePath" value="${pageContext.request.contextPath}${sessionScope.loginUser.uProfile}" />
                            </c:if>
							<img id="profileImg" class="img_thumb" alt="프로필" src="${profileImagePath}"/>
						</span>
					</div>
				</div>
				<div class="gnb_user">
					<ul class="profile_list">
                        <c:if test="${not empty sessionScope.loginUser && not empty sessionScope.loginUser.uNum}">
						    <li class="item"><a href="${pageContext.request.contextPath}/api/user/myPage/${sessionScope.loginUser.uNum}" class="btn myinfo">내 정보</a></li>
                        </c:if>
                        <li class="line"></li>
						<li class="item"><a href="${pageContext.request.contextPath}/api/user/logout" class="btn logout">로그아웃</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	</body>
</html>