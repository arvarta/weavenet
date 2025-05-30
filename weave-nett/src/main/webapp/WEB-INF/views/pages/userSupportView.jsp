<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>1:1문의 상세보기</title>
	<!-- Custom CSS -->
	<link rel="stylesheet" href="/css/post.css">
	<link rel="stylesheet" href="/css/comment.css">
</head>
<body>
	<div class="btn_top">
        <span class="btnBc outline medium">
			<input type="button" value="목록" onclick="location.href='/api/supports/supportList';">
		</span>
    </div>
    <div class="viewTypeA">
		<h2><span class="tit_q">Q</span>${ sb.sbTitle }</h2>
		<div class="info">
			<span class="writer"><strong>${ writer }</strong></span>
			<span class="date"> ${ formattedDate }</span>
		</div>
		<div class="con">
			<c:out value="${sb.sbContent}" escapeXml="false" />
		</div>
		
		<!-- 수정 / 삭제 버튼 -->
		<div class="post_actions">
			<c:choose>
				<c:when test="${ loginUserName == writer }">
					<span class="btnBc outline medium">
						<input type="button" value="수정" onclick="location.href='/api/supports/${sb.sbNum}/edit'" /> 
					</span>
					<span class="btnBc outline medium">
						<input type="button" value="삭제" onclick="showConfirmModal('delete')" />
					</span>
				</c:when>
				<c:otherwise>
					<c:if test="${
						  userAuth == 'SUPER_ADMIN' or 
		                  userAuth == 'BOARD_MANAGER'}">
						<span class="btnBc outline medium">
							<input type="button" value="삭제" onclick="showConfirmModal('delete')" />
						</span>
					</c:if>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	
	<!-- 관리자 답변 영역 -->
	<div id="supportCommentArea">
		<c:if test="${not empty sc}">
			<h2 class="support_tit">
	        	<span class="tit_q">A</span>관리자 답변
	        	<span class="date">${formattedScDate}</span>
	        </h2>
			<div class="cmt_write_wrap" id="commentArea">
		    
		        <!-- 답변 보여주는 영역 (기본 보임) -->
		        <div id="commentDisplay">
		            <div id="commentContent">${sc.scContent}</div>
		        </div>
		
		        <!-- 답변 수정 폼 (기본 숨김) -->
		        <div id="commentEdit" style="display:none;">
		            <textarea id="editScContent">${sc.scContent}</textarea>
		            <div class="cmt_btn_area">
		                <span class="btnBc outline medium">
		                    <input type="button" value="취소" id="cancelEditButton">
		                </span>
		                <span class="btnBc solid medium">
		                    <input type="button" value="등록" id="saveEditButton">
		                </span>
		            </div>
		        </div>
		
		        <!-- 수정 버튼 -->
		        <c:if test="${ loginUser.uAuth != 'USER' }">
			        <div class="cmt_btn_area" id="editBtnArea">
			            <span class="btnBc solid medium">
			                <input type="button" value="답변 수정" id="updateButton">
			            </span>
			        </div>
		        </c:if>
			</div>
		</c:if>

		<c:if test="${ empty sc and loginUser.uAuth != 'USER' }">
			<div class="cmt_write_wrap">
				<form id="commentForm" onsubmit="return false;">
					<div class="cmt_text_area">
						<textarea name="scContent" id="scContent" placeholder="답변을 입력해 주세요." rows="4" cols="50"></textarea>
					</div>
					<div class="cmt_btn_area">
						<span class="btnBc solid medium"><input type="button" value="등록" id="writeButton"></span>
					</div>
				</form>
			</div>
		</c:if>

		<c:if test="${ empty sc and loginUser.uAuth == 'USER' }">
			<div class="repl">
				등록된 답변이 없습니다.<br>
				빠른 시일 내 답변 드리겠습니다.
			</div>
		</c:if>
	</div>
	
	<!-- 모달 오버레이 -->
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

	<!-- 모달 및 답변 스크립트 -->
	<script>
		// 모달 처리
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
			deleteSupport('${sb.sbNum}');
		};

		function deleteSupport(sbNum) {
			fetch('/api/supports/' + sbNum, {
				method: 'DELETE'
			})
			.then(function(response) {
				if (response.ok) {
					alert('삭제되었습니다.');
					location.href = '/api/supports/supportList';
				} else {
					alert('삭제 실패: ' + response.statusText);
				}
			})
			.catch(function(error) {
				alert('오류가 발생했습니다: ' + error);
			});
		}

		// 답변 등록 기능 (신규 답변)
		const writeButton = document.getElementById('writeButton');
		if(writeButton) {
			writeButton.addEventListener('click', function () {
				const content = document.getElementById('scContent').value;

				if (!content.trim()) {
					alert('답변을 입력해 주세요.');
					return;
				}

				fetch('/api/admin/supports/comment/${sb.sbNum}', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded'
					},
					body: 'scContent=' + encodeURIComponent(content)
				})
				.then(response => {
					if (!response.ok) throw new Error('답변 등록 실패');
					return response.json();
				})
				.then(data => {
					const commentArea = document.getElementById('supportCommentArea');
					commentArea.innerHTML =
						'<div>' +
							'A: 관리자 답변 (' + data.regDate + ')<br>' +
							'<pre style="white-space: pre-wrap;">' + data.scContent + '</pre>' +
						'</div>';
				})
				.catch(error => {
					alert('에러 발생: ' + error.message);
				});
			});
		}

		// 답변 수정 기능 (기존 답변 수정)
		const updateButton = document.getElementById('updateButton');
		const commentDisplay = document.getElementById('commentDisplay');
		const commentEdit = document.getElementById('commentEdit');
		const saveEditButton = document.getElementById('saveEditButton');
		const cancelEditButton = document.getElementById('cancelEditButton');
		const commentContent = document.getElementById('commentContent');

		if(updateButton) {
			updateButton.addEventListener('click', function() {
				// 수정 모드로 변경
				commentDisplay.style.display = 'none';
				updateButton.style.display = 'none';
				commentEdit.style.display = 'block';
			});
		}

		if(cancelEditButton) {
			cancelEditButton.addEventListener('click', function() {
				// 수정 모드 취소 후 원래 상태로 복구
				commentEdit.style.display = 'none';
				commentDisplay.style.display = 'block';
				updateButton.style.display = 'inline-block';
			});
		}

		if(saveEditButton) {
			saveEditButton.addEventListener('click', function() {
				const editedContent = document.getElementById('editScContent').value.trim();

				if(!editedContent) {
					alert('답변 내용을 입력해 주세요.');
					return;
				}

				fetch('/api/admin/supports/comment/${sb.sbNum}', {
					method: 'PUT',
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded'
					},
					body: 'scContent=' + encodeURIComponent(editedContent)
				})
				.then(response => {
					if(!response.ok) throw new Error('답변 수정 실패');
					return response.json();
				})
				.then(data => {
					// 수정 완료 후 화면에 반영
					commentContent.textContent = data.scContent;
					commentEdit.style.display = 'none';
					commentDisplay.style.display = 'block';
					updateButton.style.display = 'inline-block';
				})
				.catch(error => {
					alert('에러 발생: ' + error.message);
				});
			});
		}
	</script>

</body>
</html>
