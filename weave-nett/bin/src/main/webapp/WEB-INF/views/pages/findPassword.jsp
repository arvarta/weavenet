<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>비밀번호 찾기</title>
    <link href="${pageContext.request.contextPath}/css/base.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/join.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet" type="text/css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
</head>
<body>
    <div class="main-form">
        <div class="right-panel">
        	<h1 class="top_logo"><span class="blind">WEAVENET</span></h1>
            <!-- <h1 class="title">비밀번호 찾기</h1> -->
			<div class="message">
				<p>${message}</p>
			</div>
            <form id="findPasswordForm" class="login-form">
                <div class="form-group">
                    <label for="eEmail">EMAIL</label>
                    <div class="inputBox">
						<div class="input_set">
							<input class="email" name="eEmail" id="eEmail" placeholder="이메일을 입력하세요" required>
							<div class="rt">
								<button type="button" class="btnDel">삭제</button>
							</div>
						</div>
					</div>
		            <div class="errorMessage">
		                <p id="errorMessage"></p>
		            </div>
		            <div>
		                <p id="message">${message}</p>
		            </div>
                </div>
                <div class="btn_wrap">
                	<span class="btnBc solid large">
						<button type="submit">임시 비밀번호 전송</button>
					</span>
                </div>
	            <ul class="find_wrap except">
	               <li><a class="find_text" onclick="location.href='/api/users'">회원가입</a></li>
				</ul>
            </form>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        $('#findPasswordForm').submit(function(e) {
            e.preventDefault();
            const email = $('#eEmail').val().trim();

            if (!email) {
                $('#errorMessage').text('이메일을 입력해주세요.');
                return;
            }

            $.ajax({
                url: '/api/user/password',
                method: 'POST',
                data: { eEmail: email },
                success: function(response) {
                    if (response.success) {
                        $('#message').text(response.message);
                        $('#errorMessage').text('');
                    } else {
                        $('#message').text('');
                        $('#errorMessage').text(response.message);
                    }
                },
                error: function() {
                    $('#message').text('');
                    $('#errorMessage').text('서버 요청 중 오류가 발생했습니다.');
                }
            });
        });
    });
    </script>
</body>
</html>
