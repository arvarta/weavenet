<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 1:1 문의</title>
</head>
<body>
	<h1 class="title">
		휴지통
	</h1> 
	
	<!-- 버튼 영역 include -->
	<jsp:include page="../include/garbageButton.jsp" />
	
	<br>
	
	<!-- 콘텐츠 영역 include -->
	<jsp:include page="${includePage}" />
</body>
</html>