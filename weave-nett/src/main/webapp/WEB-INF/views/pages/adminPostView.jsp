<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/post.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/comment.css">
</head>
<body>
	<div class="btn_top">
        <span class="btnBc outline medium">
			<input type="button" value="목록" onclick="location.href='${pageContext.request.contextPath}/api/admin/posts/postList';">
		</span>
    </div>
	<div class="viewTypeA">
		<h2>${ p.pTitle }</h2>
		<div class="info">
			<span class="writer"><strong>${ writer }</strong></span>
			<span class="date"> ${ formattedDate }</span>
		</div>
		<c:if test="${not empty filesList}">
            <tr>
                <td>
                    <div class="attachment-button-area">
                        <span class="btnBc outline small">
                            <input type="button" class="btnBc outline small" id="toggleAttachmentBtn" 
                                   value="첨부파일(${fn:length(filesList)}개)" 
                                   onclick="toggleAttachments()">
                        </span>
                    </div>
                    <div id="attachmentSection" style="display: none;">
                        <ul class="attachment-list">
                            <c:forEach var="file" items="${filesList}">
                                <li>            
                                    ${file.fName} 
                                    <span class="info">
                                        (${String.format("%.2f", file.fSize / 102.4 / 102.4)} MB)
                                    </span>
                                    <a href="${pageContext.request.contextPath}/api/admin/posts/download/${file.f_num}">
                                    	<img alt="다운로드" src="${pageContext.request.contextPath}/img/ico_download.svg">
                                    	다운로드
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </td>
            </tr>
        </c:if>
		<div class="con">
			<c:out value="${p.pContent}" escapeXml="false" />
		</div>
		<c:if test="${ loginUser.uNum == p.uNum or 
	                   userAuth == 'SUPER_ADMIN' or 
	                   userAuth == 'BOARD_MANAGER' or 
	                   userAuth == 'EMPLOYEE_MANAGER' }">
			<div class="post_actions">
				<span class="btnBc outline medium">
					<input type="button" value="수정" onclick="location.href='${pageContext.request.contextPath}/api/admin/posts/${p.pNum}/edit'" /> 
				</span>
				<span class="btnBc outline medium">
					<input type="button" value="삭제" onclick="showConfirmModal('delete')" />
				</span>
			</div>
		</c:if>
	</div>
	
	<jsp:include page="../include/comment.jsp" />
	
	<div id="modalOverlay">
		<div id="confirmModal">
			<div class="checkmodal-content">
				<p id="modalMessage">정말 삭제하시겠습니까?</p>
				<div class="modal-buttons">
					<span class="btnBc solid small">
		                <input type="button" value="삭제" id="btnConfirm" />
		            </span>
					<span class="btnBc cancel small">
		                <input type="button" value="취소" id="btnCancel" />
		            </span>
				</div>
			</div>
		</div>
	</div>

	<script>
        // 첨부파일 토글 스크립트 추가
        function toggleAttachments() {
            const attachmentSection = document.getElementById('attachmentSection');
            const toggleButton = document.getElementById('toggleAttachmentBtn');
            const fileCount = parseInt("${fn:length(filesList)}", 10) || 0; 

            if (attachmentSection.style.display === 'none') {
                attachmentSection.style.display = 'block'; 
                toggleButton.value = '첨부파일'; 
            } else {
                attachmentSection.style.display = 'none';
                toggleButton.value = '첨부파일(' + fileCount + '개)';
            }
        }

		const overlay = document.getElementById('modalOverlay');
		const modalMessage = document.getElementById('modalMessage');
		const btnConfirm = document.getElementById('btnConfirm');
		const btnCancel = document.getElementById('btnCancel');

		function showConfirmModal(action) {
			if (action === 'delete') {
				modalMessage.textContent = '정말 삭제하시겠습니까?';
				btnConfirm.textContent = '삭제';
			}
			overlay.style.display = 'flex';
		}

		btnCancel.onclick = function () {
			overlay.style.display = 'none';
		};

		btnConfirm.onclick = function () {
			overlay.style.display = 'none';
			deletePost('${p.pNum}');
		};

		function deletePost(pNum) {
            // 삭제 URL 수정
			fetch('${pageContext.request.contextPath}/api/admin/posts/' + pNum, {
				method: 'DELETE'
			})
			.then(function(response) {
				if (response.ok) {
                    return response.text(); // 성공 응답 처리
				} else {
					return response.text().then(text => { // 실패 응답 처리
                         throw new Error(text || response.statusText);
                    });
				}
			})
            .then(function(result) {
                if(result === 'success') {
                    alert('삭제되었습니다.');
                    location.href = '${pageContext.request.contextPath}/api/admin/posts/postList';
                } else {
                    alert('삭제 실패: ' + result);
                }
            })
			.catch(function(error) {
				alert('오류가 발생했습니다: ' + error.message);
			});
		}
	</script>

</body>
</html>