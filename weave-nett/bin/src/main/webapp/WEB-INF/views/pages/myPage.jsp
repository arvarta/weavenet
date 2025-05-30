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
    <link href="${pageContext.request.contextPath}/css/management.css" rel="stylesheet" type="text/css">
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
                        <button type="button" id="editProfileBtn" title="프로필 수정" style="font-size: 1.5em; padding: 5px 10px;">
						  <img src="/img/ico_setting.svg" alt="프로필 수정 아이콘" style="width: 1em; height: 1em;" />
						</button>
                    </div>
                </div>

                <div class="details-grid">
                    <div class="detail-label">사원 번호</div> <div class="detail-value">${empDto.eNum}</div>
                    <div class="detail-label">이메일</div>   <div class="detail-value">${empDto.eEmail}</div>
                    <div class="detail-label">부서</div>     <div class="detail-value">${empDto.deptName}</div>
<%--                     <div class="detail-label">직급</div>     <div class="detail-value">${empDto.eGrade}</div> --%>
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

                <div class="profile-actions-bottom">
                    <button type="button" class="btn-cancel">취소</button>
                    <button type="button" class="btn-save">저장</button>
                </div>
            </div>
        </div>
    </div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const editProfileBtn = document.getElementById('editProfileBtn');
    // const activityHistoryBtn = document.getElementById('activityHistoryBtn'); // 활동 내역 버튼 관련 변수 삭제
    
    const profileActionsBottom = document.querySelector('.profile-actions-bottom');
    const profileImageEditBtn = document.querySelector('.profile-image-edit-btn');
    const profileImage = document.querySelector('.profile-image');
    const profileImageUploadInput = document.getElementById('profileImageUpload');
    
    let originalImageSrc = profileImage.src; 

    const btnCancel = document.querySelector('.btn-cancel');
    const btnSave = document.querySelector('.btn-save');

    const pathSegments = window.location.pathname.split('/');
    const uNum = pathSegments.pop() || pathSegments.pop(); 

    profileActionsBottom.style.display = 'none';
    profileImageEditBtn.style.display = 'none';
    profileImage.classList.remove('editable');


    if (editProfileBtn) {
        editProfileBtn.addEventListener('click', function() {
            profileActionsBottom.style.display = 'block'; 
            profileImageEditBtn.style.display = 'flex';  
            profileImage.classList.add('editable');      
            
            this.style.display = 'none';
        });
    }

    function openImageFileChooser() {
        if (profileImageEditBtn.style.display !== 'none') {
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
        profileActionsBottom.style.display = 'none';
        profileImageEditBtn.style.display = 'none';
        profileImage.classList.remove('editable');
        
        profileImage.src = originalImageSrc; 
        profileImageUploadInput.value = null;  

        if (editProfileBtn) editProfileBtn.style.display = 'inline-block'; 
    }

    if (btnCancel) {
        btnCancel.addEventListener('click', function() {
            resetToViewMode();
        });
    }

    if (btnSave) {
        btnSave.addEventListener('click', function() {
            if (profileImageUploadInput.files && profileImageUploadInput.files[0]) {
                const formData = new FormData();
                formData.append('profileImageFile', profileImageUploadInput.files[0]);
                
                btnSave.disabled = true;
                btnSave.textContent = '저장 중...';

                fetch('${pageContext.request.contextPath}/api/user/profile/image/update/' + uNum, {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(err => { throw new Error(err.message || '서버 응답 오류'); });
                    }
                    return response.json(); 
                })
                .then(data => {
                    if (data.success) {
                        alert(data.message || '프로필 이미지가 저장되었습니다.');
                        if (data.newImagePath) {
                            profileImage.src = '${pageContext.request.contextPath}' + data.newImagePath;
                        }
                        originalImageSrc = profileImage.src; 
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
                resetToViewMode(); 
            }
        });
    }
});
</script>
</body>
</html>