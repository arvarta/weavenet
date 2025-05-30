<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>게시글 상세보기</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/post.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/comment.css">
</head>
<body>
	<div class="btn_top">
		<span class="btnBc outline medium">
			<input type="button" value="목록"
				onclick="location.href='${pageContext.request.contextPath}/api/posts/postList';">
		</span>
	</div>

	<div class="viewTypeA">
		<h2>${ p.pTitle }</h2>
		<div class="info">
			<span class="writer"><strong>${ writer }</strong></span>
			<span class="date">${ formattedDate }</span>
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
										(${String.format("%.2f MB", file.fSize / (1024.0 * 1024.0))})
									</span>
									<a href="${pageContext.request.contextPath}/api/posts/download/${file.f_num}">
										<img alt="다운로드" src="${pageContext.request.contextPath}/img/ico_download.svg"> 다운로드
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

		<c:if test="${(loginUser.uNum == p.uNum) or (userAuth == 'SUPER_ADMIN' or userAuth == 'BOARD_MANAGER')}">
			<div class="post_actions">
				<c:if test="${loginUser.uNum == p.uNum}">
					<span class="btnBc outline medium">
						<input type="button" value="수정"
							onclick="location.href='${pageContext.request.contextPath}/api/posts/${p.pNum}/edit'" />
					</span>
				</c:if>
				<c:if test="${userAuth == 'SUPER_ADMIN' or userAuth == 'BOARD_MANAGER' or (loginUser.uNum == p.uNum)}">
					<span class="btnBc outline medium">
						<input type="button" value="삭제" onclick="showConfirmModal('delete')" />
					</span>
				</c:if>
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
			fetch('${pageContext.request.contextPath}/api/posts/' + pNum, {
				method: 'DELETE'
			})
			.then(function(response) {
				if (response.ok) {
					alert('삭제되었습니다.');
					location.href = '${pageContext.request.contextPath}/api/posts/postList';
				} else {
					response.text().then(text => {
						alert('삭제 실패: ' + (text || response.statusText));
					});
				}
			})
			.catch(function(error) {
				alert('오류가 발생했습니다: ' + error);
			});
		}
	</script>
</body>
</html>
