<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <link href="${pageContext.request.contextPath}/css/base.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/layout.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet" type="text/css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="form-section">
        <h1><p class="form-title">비밀번호 재설정</p></h1>
        <p class="form-description">
            ${ message }<br>
            (보안을 위해 로그인 후 비밀번호를 변경하는 것을 권장합니다.)
        </p>
        <form id="resetPasswordForm" class="login-form">
            <div class="form-group">
                <label for="eEmailReset">EMAIL</label>
                <div class="inputBox">
                    <div class="input_set">
                        <input class="email" name="eEmail" id="eEmailReset" placeholder="이메일을 입력하세요" value="${eEmail}" required readonly>
                        <div class="rt">
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="currentPassword">CURRENT PW</label>
                <div class="inputBox">
                    <div class="input_set">
                        <input type="password" class="password" name="currentPassword" id="currentPassword" placeholder="현재 비밀번호를 입력하세요" required>
                        <div class="rt">
                            <button type="button" class="btnDel">삭제</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="newPassword">NEW PW</label>
                <div class="inputBox">
                    <div class="input_set">
                        <input type="password" class="password" name="newPassword" id="newPassword" placeholder="새 비밀번호를 입력하세요" required>
                        <div class="rt">
                            <button type="button" class="btnDel">삭제</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="confirmPassword">CONFIRM PASSWORD</label>
                <div class="inputBox">
                    <div class="input_set">
                        <input type="password" class="password" name="confirmPassword" id="confirmPassword" placeholder="새 비밀번호를 다시 입력하세요" required>
                        <div class="rt">
                            <button type="button" class="btnDel">삭제</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="message_box">
                <p id="resetMessage" style="color: blue;"></p>
                <%-- 에러 메시지 표시 영역 --%>
                <p id="resetErrorMessage" style="color: red;"></p>
            </div>
            <div class="btn_wrap">
                <span class="btnBc cancel large">
                    <button type="button" onclick="location.href='${pageContext.request.contextPath}/api/user/myPage/${uNum}'">취소</button>
                </span>
                <span class="btnBc solid large">
                    <button type="submit">비밀번호 변경</button>
                </span>
            </div>
        </form>
    </div>

<script>
$(document).ready(function() {
    $('#resetPasswordForm').submit(function(e) {
        e.preventDefault();
        const email = $('#eEmailReset').val().trim(); 
        const currentPassword = $('#currentPassword').val(); 
        const newPassword = $('#newPassword').val();
        const confirmPassword = $('#confirmPassword').val();

        $('#resetMessage').text('');
        $('#resetErrorMessage').text(''); // 기존 메시지 초기화

        if (!currentPassword) {
            $('#resetErrorMessage').text('현재 비밀번호를 입력해주세요.');
            return;
        }
        if (!newPassword) {
            $('#resetErrorMessage').text('새 비밀번호를 입력해주세요.');
            return;
        }
        if (newPassword !== confirmPassword) {
            $('#resetErrorMessage').text('새 비밀번호가 일치하지 않습니다.');
            return;
        }

        // --- 👇 여기부터 추가된 코드 ---
        if (newPassword && currentPassword === newPassword) {
            $('#resetErrorMessage').text('현재 비밀번호와 새 비밀번호는 같을 수 없습니다.');
            return; // 전송 중단
        }
        // --- 👆 여기까지 추가된 코드 ---

        // TODO: 비밀번호 정책 확인 (길이, 특수문자 등)

        $.ajax({
            url: '${pageContext.request.contextPath}/api/user/password/reset', 
            method: 'POST',
            data: { 
                eEmail: email,
                currentPassword: currentPassword, 
                newPassword: newPassword 
            },
            success: function(response) {
                if (response.success) {
                    alert(response.message || "비밀번호가 변경되었습니다.");
                    window.location.href = '${pageContext.request.contextPath}/api/user/myPage/${uNum}';
                } else {
                    $('#resetErrorMessage').text(response.message);
                }
            },
            error: function() {
                $('#resetErrorMessage').text('서버 요청 중 오류가 발생했습니다.');
            }
        });
    });

    // 입력 필드 삭제 버튼
    $('.btnDel').on('click', function() {
        $(this).closest('.input_set').find('input').val('').focus();
    });
});
</script>
</body>
</html>