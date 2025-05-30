<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>회원가입</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta name="viewport" content="width=1300">
	<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet" type="text/css">
	<link href="${pageContext.request.contextPath}/css/join.css" rel="stylesheet" type="text/css">
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
            <!-- <h1 class="title">회원가입</h1> -->
		<div class="message">
			<p>${message}</p>
		</div>
		
		<form id="joinForm" action="${pageContext.request.contextPath}/api/users/signup" method="post" class="login-form" onsubmit="return validateForm(event)">
			<div class="form-group">
			  <label for="number">사원번호</label>
			  <div class="group_wrap">
			    <div class="inputBox">
					<div class="input_set">
						<input class="inpt" type="text" name="number" id="number" placeholder="등록된 사원번호 기입"" required>
						<div class="rt">
							<button type="button" class="btnDel">삭제</button>
						</div>
					</div>
				</div>
			    <span class="btnBc outline large">
				    <button type="button" class="number-btn" onclick="loadNumber()">불러오기</button>
				</span>
			  </div>
			  <div class="errorMessage" id="numberError"></div>
			</div>
			
			<div class="form-group">
			  <label for="email">EMAIL</label>
			  <div class="group_wrap">
			    <div class="inputBox">
					<div class="input_set">
						<input class="inpt" type="email" name="email" id="email" readonly required>
						<div class="rt">
							<button type="button" class="btnDel">삭제</button>
						</div>
					</div>
				</div>
			    <span class="btnBc outline large">
				    <button type="button" class="email-btn" id="sendVerificationBtn" onclick="sendVerification()" disabled>인증번호 전송</button>
				</span>
			  </div>
			  <div class="errorMessage" id="emailError"></div>
			  <div class="errorMessage">${errorMessage}</div>
			</div>
            
            <div class="form-group">
			  <label for="code">인증번호</label>
			  <div class="group_wrap">
			    <div class="inputBox">
					<div class="input_set">
						<input class="inpt" type="text" name="code" id="code" placeholder="메일로 받은 인증번호 입력" required>
						<div class="rt">
							<button type="button" class="btnDel">삭제</button>
						</div>
					</div>
				</div>
			    <span class="btnBc outline large">
				    <button type="button" class="email-btn" id="verifyCodeBtn" onclick="verifyEmailCodeNow()">인증 확인</button>
				</span>
			  </div>
			  <div class="errorMessage" id="codeError"></div>
                <div class="successMessage" id="codeSuccess" style="color: green; font-size: 0.9em; margin-top: 5px;"></div>
			</div>
			
			<div class="form-group">
                <label for="password">PW</label>
                <div class="inputBox">
                    <div class="input_set">
                        <input class="inpt" type="password" name="password" id="password" placeholder="특수문자와 숫자 조합 6~12자" required>
                        <div class="rt">
                            <button type="button" class="btnDel">삭제</button>
                        </div>
                    </div>
                </div>
                <div class="errorMessage" id="passwordError"></div>
            </div>
			
			<div class="form-group">
                <label for="retryPassword">RETRY</label>
                <div class="inputBox">
                    <div class="input_set">
                        <input class="inpt" type="password" name="retryPassword" id="retryPassword" placeholder="비밀번호 재확인" required>
                        <div class="rt">
                            <button type="button" class="btnDel">삭제</button>
                        </div>
                    </div>
                </div>
                <div class="errorMessage" id="retryPasswordError"></div>
            </div>

            <div class="form-group">
                <div class="errorMessage" id="finalVerificationError"></div>
            </div>
			
			<div class="btn_wrap">
				<span class="btnBc cancel large">
					<button type="button" onclick="location.href='${pageContext.request.contextPath}/api/user'">취소</button>
				</span>
				<span class="btnBc solid large">
					<button type="submit" id="joinSubmitBtn">가입신청</button>
				</span>
			</div>
		</form>
	</div>
	</div>

	<script>
	let isEmailCodeVerifiedByButton = false; 
    const sendVerificationButton = document.getElementById('sendVerificationBtn');
    const emailInputGlobal = document.getElementById("email");
    const emailErrorGlobal = document.getElementById("emailError");
    const codeInputGlobal = document.getElementById("code");
    const verifyCodeButtonGlobal = document.getElementById("verifyCodeBtn");
    const codeSuccessGlobal = document.getElementById("codeSuccess");
    const codeErrorGlobal = document.getElementById("codeError");

    function resetAllVerificationStates() {
        isEmailCodeVerifiedByButton = false;
        
        emailInputGlobal.value = '';
        emailErrorGlobal.innerText = "";
        emailErrorGlobal.style.color = 'red'; 
        sendVerificationButton.disabled = true; 

        codeInputGlobal.value = '';
        codeInputGlobal.readOnly = false;
        codeErrorGlobal.innerText = "";
        codeSuccessGlobal.innerText = "";
        
        verifyCodeButtonGlobal.style.display = 'inline-block'; 
        verifyCodeButtonGlobal.disabled = false;
        verifyCodeButtonGlobal.textContent = '인증 확인';

        document.getElementById("finalVerificationError").innerText = "";
    }

    function resetEmailField() {
        resetAllVerificationStates(); 
    }

	function loadNumber() {
		const numberInput = document.getElementById("number");
		const number = numberInput.value.trim();
		const numberError = document.getElementById("numberError");
		
		numberError.innerText = '';
        resetAllVerificationStates(); 

		if (!number) {
			numberError.innerText = "사원번호를 입력해주세요.";
			return;
		}

		fetch('${pageContext.request.contextPath}/api/users/email?number=' + encodeURIComponent(number))
			.then(res => {
                if (!res.ok) {
                    return res.text().then(text => { throw new Error(text || '서버 응답 오류'); });
                }
                return res.text();
            })
			.then(emailStr => {
				if (emailStr && emailStr.trim() !== "") {
					emailInputGlobal.value = emailStr.trim();
					checkEmailAvailability(emailStr.trim());
				} else {
					numberError.innerText = "해당 사원번호에 대한 이메일을 찾을 수 없습니다.";
                    sendVerificationButton.disabled = true;
				}
			})
			.catch(error => {
				console.error("Error loading email by number:", error);
				numberError.innerText = error.message || "이메일 불러오기 중 오류 발생.";
                sendVerificationButton.disabled = true;
			});
	}

    function checkEmailAvailability(email) {
        emailErrorGlobal.innerText = '이메일 사용 가능 여부 확인 중...';
        emailErrorGlobal.style.color = 'orange'; 
        sendVerificationButton.disabled = true; 

        fetch('${pageContext.request.contextPath}/api/users/email/exists?email=' + encodeURIComponent(email))
            .then(res => {
                if (!res.ok) { return res.json().then(err => { throw err; }); }
                return res.json();
            })
            .then(data => {
                if (data.exists) {
                    emailErrorGlobal.style.color = 'red';
                    emailErrorGlobal.innerText = data.message || "이미 가입된 이메일입니다.";
                    sendVerificationButton.disabled = true; 
                } else {
                    emailErrorGlobal.style.color = 'green';
                    emailErrorGlobal.innerText = data.message || "사용 가능한 이메일입니다.";
                    sendVerificationButton.disabled = false; 
                }
            })
            .catch(error => {
                console.error("Error checking email availability:", error);
                emailErrorGlobal.style.color = 'red';
                emailErrorGlobal.innerText = error.message || "이메일 사용 가능 여부 확인 중 오류 발생.";
                sendVerificationButton.disabled = true;
            });
    }

	function sendVerification() {
		const email = emailInputGlobal.value.trim();
		const number = document.getElementById("number").value.trim();
        
        codeInputGlobal.value = '';
        codeInputGlobal.readOnly = false;
        codeErrorGlobal.innerText = "";
        codeSuccessGlobal.innerText = "";
        verifyCodeButtonGlobal.style.display = 'inline-block';
        verifyCodeButtonGlobal.disabled = false;
        verifyCodeButtonGlobal.textContent = '인증 확인';
        isEmailCodeVerifiedByButton = false;

		if (!email) { 
			emailErrorGlobal.innerText = "이메일 정보를 먼저 불러와주세요.";
			return;
		}
		if (!number) {
			document.getElementById("numberError").innerText = "사원번호를 먼저 입력하고 이메일을 불러와주세요.";
            return;
        }

		const params = new URLSearchParams();
		params.append('eNum', number);

		sendVerificationButton.disabled = true;
		sendVerificationButton.textContent = '전송중...';

		fetch('${pageContext.request.contextPath}/api/users/email/send', {
			method: 'POST',
			headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
			body: params.toString()
		})
		.then(res => {
            if (!res.ok) { return res.json().then(err => { throw err; }); }
            return res.json();
        })
		.then(result => {
			if (result.success) {
                codeSuccessGlobal.innerText = "인증번호가 전송되었습니다. 이메일을 확인해주세요.";
			} else {
				emailErrorGlobal.style.color = 'red';
                emailErrorGlobal.innerText = result.message || "인증번호 전송에 실패했습니다.";
			}
		})
		.catch(error => {
			console.error("Error sending verification code:", error);
            emailErrorGlobal.style.color = 'red';
			emailErrorGlobal.innerText = error.message || "인증번호 전송 중 서버 오류가 발생했습니다.";
		})
		.finally(() => {
            if (!emailErrorGlobal.innerText.includes("이미 가입된")) {
			    sendVerificationButton.disabled = false;
            }
			sendVerificationButton.textContent = '인증번호 전송';
		});
	}

	function verifyEmailCodeNow() {
        const email = emailInputGlobal.value.trim();
        const code = codeInputGlobal.value.trim();
        
        codeErrorGlobal.innerText = "";
        codeSuccessGlobal.innerText = "";
		isEmailCodeVerifiedByButton = false; 

        if (!email) {
            codeErrorGlobal.innerText = "이메일 정보를 먼저 불러와주세요.";
            return;
        }
        if (!code) {
            codeErrorGlobal.innerText = "인증번호를 입력해주세요.";
            return;
        }

		verifyCodeButtonGlobal.disabled = true;
		verifyCodeButtonGlobal.textContent = '확인중...';

        fetch('${pageContext.request.contextPath}/api/users/email/verify?eEmail=' 
            + encodeURIComponent(email) + '&code=' + encodeURIComponent(code))
        .then(response => {
             if (!response.ok) { return response.json().then(err => { throw err; });}
            return response.json();
        })
        .then(data => {
            if (data.verified) {
                codeSuccessGlobal.innerText = "이메일 인증이 완료되었습니다.";
                isEmailCodeVerifiedByButton = true;
				codeInputGlobal.readOnly = true; 
				verifyCodeButtonGlobal.disabled = true;
				verifyCodeButtonGlobal.textContent = '인증 완료';
            } else {
                codeErrorGlobal.innerText = data.message || "인증번호가 잘못되었거나 만료되었습니다.";
            }
        })
        .catch(error => {
            console.error("Error verifying email code:", error);
            codeErrorGlobal.innerText = error.message || "인증 코드 검증 중 오류가 발생했습니다.";
        })
		.finally(() => {
			if (!isEmailCodeVerifiedByButton) { 
				verifyCodeButtonGlobal.disabled = false;
				verifyCodeButtonGlobal.textContent = '인증 확인';
			}
		});
    }

	function validateForm(event) {
		event.preventDefault(); 

		const form = document.getElementById("joinForm"); 
		const passwordInput = document.getElementById("password");
		const retryPasswordInput = document.getElementById("retryPassword");
		
		const password = passwordInput.value;
		const retryPassword = retryPasswordInput.value;

		const passwordError = document.getElementById("passwordError");
		const retryPasswordError = document.getElementById("retryPasswordError");
		const finalVerificationError = document.getElementById("finalVerificationError"); 
		
		passwordError.innerText = '';
		retryPasswordError.innerText = '';
		finalVerificationError.innerText = '';

		const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,12}$/;
		if (!passwordRegex.test(password)) {
			passwordError.innerText = "비밀번호는 특수문자와 숫자를 포함한 6~12자여야 합니다.";
			passwordInput.focus();
			return false;
		}

		if (password !== retryPassword) {
			retryPasswordError.innerText = "비밀번호가 일치하지 않습니다.";
			retryPasswordInput.focus();
			return false;
		}

		if (!isEmailCodeVerifiedByButton) {
			finalVerificationError.innerText = "이메일 인증을 먼저 완료해주세요. ('인증 확인' 버튼 클릭)";
			codeInputGlobal.focus();
			return false;
		}
		form.submit(); 
	}
	/*
	document.querySelectorAll('.btnDel').forEach(button => {
        button.addEventListener('click', function() {
            const inputSet = this.closest('.input_set');
            if (inputSet) {
                const inputField = inputSet.querySelector('.inpt');
                if (inputField && !inputField.readOnly) { 
                    inputField.value = '';
                    inputField.focus();
                    if (inputField.id === 'number') { 
                        resetAllVerificationStates();
                    } else if (inputField.id === 'email') { 
                        resetAllVerificationStates(); 
                    }
                }
            }
        });
    });
	*/
    
    resetAllVerificationStates();
	</script>
</body>
</html>