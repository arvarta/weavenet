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

	<!-- 제목 및 뒤로가기 -->
	<table>
		<tr>
			<td><h3 class="title">관리자 1:1 문의 게시판</h3></td>
			<td class="subject">
				<span class="btnBc solid small">
					<input type="button" value="목록" onclick="location.href='/api/supports/supportList';">
				</span>
			</td>
		</tr>
	</table>

	<br>

	<!-- 문의 제목/작성자/날짜 -->
	<table>
		<tr>
			<td colspan="2" class="subject"><h1>${ sb.sbTitle }</h1></td>
		</tr>
		<tr>
			<td>${ writer }</td>
			<td class="date">${ formattedDate }</td>
		</tr>
	</table>

	<br>

	<!-- 본문/첨부파일 -->
	<table>
		<tr>
			<td>첨부파일 영역</td>
		</tr>
		<tr>
			<td><br></td>
		</tr>
		<tr>
			<td>
				Q : 문의 내용<br>
				${sb.sbContent}
			</td>
		</tr>
	</table>

	<br>

	<!-- 관리자 답변 영역 -->
	<div id="supportCommentArea">
		<c:if test="${not empty sc}">
			<div class="cmt_write_wrap" id="commentArea">
		    
		        <!-- 답변 보여주는 영역 (기본 보임) -->
		        <div id="commentDisplay">
		            A : 관리자 답변 (${formattedScDate})<br>
		            <div id="commentContent">${sc.scContent}</div>
		        </div>
		
		        <!-- 답변 수정 폼 (기본 숨김) -->
		        <div id="commentEdit" style="display:none;">
		            <textarea id="editScContent" rows="4" cols="50">${sc.scContent}</textarea>
		            <div class="cmt_btn_area">
		                <span class="btnBc solid small">
		                    <input type="button" value="저장" id="saveEditButton">
		                </span>
		                <span class="btnBc outline small">
		                    <input type="button" value="취소" id="cancelEditButton">
		                </span>
		            </div>
		        </div>
		
		        <!-- 수정 버튼 -->
		        <c:if test="${ loginUser.uAuth != 'USER' }">
			        <div class="cmt_btn_area" id="editBtnArea">
			            <span class="btnBc outline small">
			                <input type="button" value="수정" id="updateButton">
			            </span>
			        </div>
		        </c:if>
			</div>
		</c:if>


		<c:if test="${ empty sc and loginUser.uAuth != 'USER' }">
			<div class="cmt_write_wrap">
				<form id="commentForm" onsubmit="return false;">
					<div class="cmt_text_area">
						<textarea name="scContent" id="scContent" placeholder="답글을 입력해 주세요." rows="4" cols="50"></textarea>
					</div>
					<div class="cmt_btn_area">
						<span class="btnBc solid medium"><input type="button" value="등록" id="writeButton"></span>
					</div>
				</form>
			</div>
		</c:if>

		<c:if test="${ empty sc and loginUser.uAuth == 'USER' }">
			<div>
				등록된 답변이 없습니다.<br>
				빠른 시일 내 답변 드리겠습니다.
			</div>
		</c:if>
	</div>

	<br>
	

	<!-- 수정 / 삭제 버튼 -->
	<c:if test="${ loginUserName == writer }">
		<span class="btnBc outline small">
			<input type="button" value="수정" onclick="location.href='/api/supports/${sb.sbNum}/edit'" />
		</span>
		<c:if test="${ loginUserName == writer or 
				  userAuth == 'SUPER_ADMIN' or 
                  userAuth == 'BOARD_MANAGER' or 
                  userAuth == 'EMPLOYEE_MANAGER' }">
		<span class="btnBc outline small">
			<input type="button" value="삭제" onclick="showConfirmModal('delete')" />
		</span>
		</c:if>
	</c:if>
	
	<!-- 모달 오버레이 -->
	<div id="modalOverlay">
		<div id="confirmModal">
			<div class="checkmodal-content">
				<p id="modalMessage">정말 삭제하시겠습니까?</p>
				<div class="modal-buttons">
					<button id="btnConfirm" type="button">삭제</button>
					<button id="btnCancel" type="button">취소</button>
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
					alert('답글을 입력해 주세요.');
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
