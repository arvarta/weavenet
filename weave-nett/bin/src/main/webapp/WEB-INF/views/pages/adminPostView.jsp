<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>게시글 상세보기</title>
	<!-- Custom CSS -->
	<link rel="stylesheet" href="/css/post.css">
	<link rel="stylesheet" href="/css/comment.css">
</head>
<body>

	<!-- 제목 및 뒤로가기 -->
	<table>
		<tr>
		<!-- 
			<td><h3 class="title">${ board.bTitle }</h3></td>
		 -->
			<td class="subject">
				<span class="btnBc outline small">
					<input type="button" value="목록" onclick="location.href='/api/admin/posts/postList';">
				</span>
			</td>
		</tr>
	</table>

	<br>

	<!-- 제목/작성자/날짜 -->
	<table>
		<tr>
			<td class="subject"><h1>${ p.pTitle }</h1></td>
		</tr>
		<tr>
			<td>${ writer } ${ formattedDate }</td>
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
				${p.pContent}
			</td>
		</tr>
	</table>

	<br>
	
	<!-- 수정 / 삭제 버튼 -->
	<c:if test="${ loginUserName == writer }">
		<span class="btnBc outline small">
			<input type="button" value="수정" onclick="location.href='/api/admin/posts/${p.pNum}/edit'" />
		</span>
		<span class="btnBc outline small">
			<input type="button" value="삭제" onclick="showConfirmModal('delete')" />
		</span>
	</c:if>
	
	<!--  댓글 테스트 -->
	<jsp:include page="../include/comment.jsp" />
	
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
			deletePost('${p.pNum}');
		};

		function deletePost(pNum) {
			fetch('/api/admin/posts/' + pNum, {
				method: 'DELETE'
			})
			.then(function(response) {
				if (response.ok) {
					alert('삭제되었습니다.');
					location.href = '/api/admin/posts/postList';
				} else {
					alert('삭제 실패: ' + response.statusText);
				}
			})
			.catch(function(error) {
				alert('오류가 발생했습니다: ' + error);
			});
		}
	</script>

</body>
</html>
