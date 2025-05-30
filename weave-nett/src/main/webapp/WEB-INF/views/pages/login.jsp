<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>로그인</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta name="viewport" content="width=1300">
	<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/base.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/cursor.css" rel="stylesheet" type="text/css">
	<script src="${pageContext.request.contextPath}/js/menu.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin_header.js"></script>
	<script src="${pageContext.request.contextPath}/js/common.js"></script>
</head>
<body>
	<div class="main-container">
    	<div class="right-panel">
    		<h1 class="top_logo"><span class="blind">WEAVENET</span></h1>
            <!-- <h1 class="title">로그인</h1> -->
			<div class="message">
				<p>${message}</p>
			</div>
			<form action="/api/user/login" method="post" class="login-form">
				<div class="form-group">
					<label for="email">EMAIL</label>
					<div class="inputBox">
						<div class="input_set">
							<input class="inpt" type="email" name="eEmail" placeholder="이메일을 입력하세요" required>
							<div class="rt">
								<button type="button" class="btnDel">삭제</button>
							</div>
						</div>
					</div>
					<div class="errorMessage">
						<p>${errorMessage}</p>
					</div>
				</div>
				<div class="form-group">
					<label for="password">PW</label>
					<div class="inputBox">
						<div class="input_set">
							<input class="inpt" type="password" name="uPassword" placeholder="비밀번호를 입력하세요" required>
							<div class="rt">
								<button type="button" class="btnDel">삭제</button>
							</div>
						</div>
					</div>
				</div>
				<div class="button-group">
					<span class="btnBc solid large">
						<button type="submit">로그인</button>
					</span>
				</div>
			</form>
			<ul class="find_wrap">
	               <li><a class="find_text" href="/api/user/password">비밀번호 찾기</a></li>
	               <li><a class="find_text" onclick="submitSignup()">회원가입</a></li>
			</ul>
		</div>
	</div>
</body>
<script>
function submitSignup() {
	  window.location.href = "/api/users";
	}
</script>
</html>