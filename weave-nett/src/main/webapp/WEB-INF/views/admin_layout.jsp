<!-- /WEB-INF/views/main.jsp -->
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
    <script src="${pageContext.request.contextPath}/js/admin_header.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
</head>

<body>
<div id="wrap">
    <!-- 헤더 영역 -->
    <jsp:include page="include/admin_header.jsp" />
    <!-- //헤더 영역 -->

    <div id="container">
        <!-- 레프트 메뉴 -->
        <div class="nav_lnb">
            <jsp:include page="include/admin_leftMenu.jsp" />
        </div>
        <!-- //레프트 메뉴 -->

        <!-- 콘텐츠 영역 -->
        <div id="section_cen">
            <div id="content">
                <jsp:include page="${contentPage}" />
            </div>
        </div>
        <!-- //콘텐츠 영역 -->
    </div>
</div>
</body>
</html>