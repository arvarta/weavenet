<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:url var="garbageMainUrl" value="/api/admin/garbage/garbageMain" />
	<div>
		<span class="btnBc outline small">
	    	<button onclick="location.href='${garbageMainUrl}?view=board'">게시판</button>
	    </span>
	    <span class="btnBc outline small">
	    	<button onclick="location.href='${garbageMainUrl}?view=post'">게시글</button>
	    </span>
	    <span class="btnBc outline small">
			<button onclick="location.href='${garbageMainUrl}?view=comment'">댓글</button>
		</span>
	</div>
</body>
</html>