<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>WeaveNet - 마이페이지</title> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=1300">
    <link href="${pageContext.request.contextPath}/css/cursor.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/myPage.css" rel="stylesheet" type="text/css">
</head>
<body>
        <div class="section_cen">
            <h1 class="title">${not empty empDto.eName ? empDto.eName : '???'}님의 마이페이지</h1>

            <div class="profile-container">
                <div class="profile-header">
                    <div class="profile-image-container">
                        <img src="${pageContext.request.contextPath}${not empty empDto.uProfile ? empDto.uProfile : '/img/profile_default.png'}" alt="프로필 이미지" class="profile-image">
                        <div class="profile-image-edit-btn">+</div>
                        <input type="file" id="profileImageUpload" accept="image/*" style="display: none;">
                    </div>
                    <div class="profile-info">
                        <h2>${empDto.eName}</h2>
                        <p>${empDto.deptName} / ${empDto.ePosition}</p>
                    </div>
                    <div class="profile-actions-top">
                        <button type="button" id="settingsBtn" title="설정" style="font-size: 1.5em; padding: 5px 10px;">
                          <img src="${pageContext.request.contextPath}/img/ico_setting.svg" alt="설정 아이콘" />
						</button>
                    </div>
                </div>

                <div class="details-grid">
                   <%-- ... (기존 정보 표시는 동일) ... --%>
                   <div class="detail-label">사원 번호</div> <div class="detail-value">${empDto.eNum}</div>
                    <div class="detail-label">이메일</div>   <div class="detail-value">${empDto.eEmail}</div>
                    <div class="detail-label">부서</div>     <div class="detail-value">${empDto.deptName}</div>
                    <div class="detail-label">직급</div>     <div class="detail-value">${empDto.ePosition}</div>
                    <div class="detail-label">입사일</div>   <div class="detail-value"><fmt:formatDate value="${empDto.geteJoinDateAsDate()}" pattern="yyyy-MM-dd"/></div>
                    <div class="detail-label">주소</div>     <div class="detail-value">${empDto.eAddress}</div>
                    <div class="detail-label">권한</div>
                    <div class="detail-value">
                         <c:choose>
                            <c:when test="${empDto.uAuth == 'EMPLOYEE_MANAGER'}">사원관리자</c:when>
                            <c:when test="${empDto.uAuth == 'BOARD_MANAGER'}">게시판관리자</c:when>
                            <c:when test="${empDto.uAuth == 'USER'}">일반</c:when>
                            <c:when test="${empDto.uAuth == 'ADMIN' || empDto.uAuth == 'SUPER_ADMIN'}">최고관리자</c:when>
                            <c:otherwise>${empDto.uAuth}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="detail-label">등급</div>
                    <div class="detail-value">
                         <c:choose>
                            <c:when test="${empDto.uRank == 'GENERAL'}">일반</c:when>
                            <c:when test="${empDto.uRank == 'REGULAR'}">정식</c:when>
                            <c:when test="${empDto.uRank == 'ELITE'}">우수</c:when>
                            <c:when test="${empDto.uRank == 'HONOR'}">명예</c:when>
                            <c:otherwise>${empDto.uRank}</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="profile-actions-bottom" style="display: none;">
                    <span class="btnBc cancel medium">
                   		<button type="button" class="btn-cancel">취소</button>
                   	</span>
                   	<span class="btnBc solid medium">
                    	<button type="button" class="btn-save">저장</button>
					</span>
                </div>
            </div>
        </div>

    <div id="settingsModal" class="modal-overlay">
        <div class="modal-content" id="modalContent"> <%-- ID 추가 --%>
            <button type="button" id="modalEditProfileBtn">프로필 수정</button>
            <button type="button" id="modalChangePasswordBtn">비밀번호 변경</button>
        </div>
    </div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const settingsBtn = document.getElementById('settingsBtn');
    const settingsModal = document.getElementById('settingsModal');
    const modalContent = document.getElementById('modalContent'); // 모달 콘텐츠 요소 선택
    const modalEditProfileBtn = document.getElementById('modalEditProfileBtn');
    const modalChangePasswordBtn = document.getElementById('modalChangePasswordBtn');
    
    // ... (다른 변수 선언은 동일) ...
    const profileActionsBottom = document.querySelector('.profile-actions-bottom');
    const profileImageEditBtn = document.querySelector('.profile-image-edit-btn');
    const profileImage = document.querySelector('.profile-image');
    const profileImageUploadInput = document.getElementById('profileImageUpload');
    let originalImageSrc = profileImage ? profileImage.src : ''; 
    const btnCancel = document.querySelector('.btn-cancel');
    const btnSave = document.querySelector('.btn-save');
    const pathSegments = window.location.pathname.split('/');
    const uNum = pathSegments.pop() || pathSegments.pop(); 

    if (profileImageEditBtn) profileImageEditBtn.style.display = 'none';
    if (profileImage) profileImage.classList.remove('editable');

    // --- 👇 모달 위치 계산 및 표시 로직 수정 ---
    if (settingsBtn) {
        settingsBtn.addEventListener('click', function(event) {
            console.log("톱니바퀴 아이콘 클릭됨!"); 
            if (settingsModal && modalContent) {
                const btnRect = settingsBtn.getBoundingClientRect(); // 버튼 위치 정보

                // 모달 위치 계산
                let top = btnRect.bottom + window.scrollY + 5; // 버튼 아래 5px
                let right = window.innerWidth - btnRect.right - window.scrollX; // 버튼 오른쪽 끝에 맞춤
                
                // 모달 위치 설정
                modalContent.style.top = top + 'px';
                modalContent.style.right = right + 'px';
                modalContent.style.left = 'auto'; // left는 자동으로
                
                settingsModal.style.display = 'block'; // 이제 flex 대신 block 사용
                console.log("모달 display를 block으로 변경, 위치 설정 완료.");
                
                event.stopPropagation(); // 이벤트 버블링 방지 (선택 사항)
            } else {
                console.error("settingsModal 또는 modalContent 요소를 찾을 수 없습니다!");
            }
        });
    } else {
        console.error("settingsBtn 요소를 찾을 수 없습니다!");
    }

    function closeModal() {
        if (settingsModal) {
            settingsModal.style.display = 'none';
            console.log("모달 닫힘."); 
        }
    }
    
    // 모달 오버레이 클릭 시 닫기
    if (settingsModal) {
        settingsModal.addEventListener('click', function(event) {
            // modal-content 내부를 클릭한 경우는 닫지 않음
            if (event.target === settingsModal) {
                closeModal();
            }
        });
    }

    // --- 👆 모달 위치 계산 및 표시 로직 수정 ---

    if (modalEditProfileBtn) {
        modalEditProfileBtn.addEventListener('click', function() {
            console.log("프로필 수정 버튼 클릭됨."); 
            closeModal();
            enableEditMode();
        });
    }

    if (modalChangePasswordBtn) {
        modalChangePasswordBtn.addEventListener('click', function() {
            console.log("비밀번호 변경 버튼 클릭됨.");
            window.location.href = '${pageContext.request.contextPath}/api/user/password/reset';
        });
    }

    // --- (이하 나머지 JavaScript 코드는 동일) ---
    function enableEditMode() {
        console.log("수정 모드 활성화 중..."); 
        if (profileActionsBottom) profileActionsBottom.style.display = 'block'; 
        if (profileImageEditBtn) profileImageEditBtn.style.display = 'flex';  
        if (profileImage) profileImage.classList.add('editable');      
        if (settingsBtn) settingsBtn.style.display = 'none'; 
    }

    function openImageFileChooser() {
        if (profileImageEditBtn && profileImageEditBtn.style.display !== 'none') {
            profileImageUploadInput.click();
        }
    }

    if (profileImageEditBtn) {
        profileImageEditBtn.addEventListener('click', openImageFileChooser);
    }
    if (profileImage) {
        profileImage.addEventListener('click', openImageFileChooser);
    }

    if (profileImageUploadInput) {
        profileImageUploadInput.addEventListener('change', function(event) {
             if (event.target.files && event.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    profileImage.src = e.target.result;
                }
                reader.readAsDataURL(event.target.files[0]);
            }
        });
    }

    function resetToViewMode() {
        console.log("보기 모드로 리셋 중...");
        if (profileActionsBottom) profileActionsBottom.style.display = 'none';
        if (profileImageEditBtn) profileImageEditBtn.style.display = 'none';
        if (profileImage) {
            profileImage.classList.remove('editable');
            profileImage.src = originalImageSrc; 
        }
        if (profileImageUploadInput) profileImageUploadInput.value = null;  
        if (settingsBtn) settingsBtn.style.display = 'inline-block';
    }

    if (btnCancel) {
        btnCancel.addEventListener('click', function() {
            resetToViewMode();
        });
    }

    if (btnSave) {
        btnSave.addEventListener('click', function() { 
            console.log("저장 버튼 클릭됨.");
            if (profileImageUploadInput.files && profileImageUploadInput.files[0]) {
                const formData = new FormData();
                formData.append('profileImageFile', profileImageUploadInput.files[0]);
                btnSave.disabled = true;
                btnSave.textContent = '저장 중...';
                fetch('${pageContext.request.contextPath}/api/user/profile/image/update/' + uNum, {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message || '프로필 이미지가 저장되었습니다.');
                        if (data.newImagePath) {
                            profileImage.src = '${pageContext.request.contextPath}' + data.newImagePath;
                            originalImageSrc = profileImage.src; 
                        }
                        resetToViewMode();
                    } else {
                        alert(data.message || '이미지 저장 실패');
                    }
                })
                .catch(error => {
                    console.error('Error during image save:', error);
                    alert('이미지 저장 중 오류: ' + error.message);
                })
                .finally(() => {
                    btnSave.disabled = false;
                    btnSave.textContent = '저장';
                });
            } else {
                alert("프로필 정보가 저장되었습니다."); 
                resetToViewMode(); 
            }
        });
    }
    console.log("스크립트 실행 완료.");
});
</script>
</body>
</html>