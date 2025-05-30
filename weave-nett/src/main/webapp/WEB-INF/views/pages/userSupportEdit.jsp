<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <title>관리자 1:1 문의 수정</title>
    
    <!-- jQuery (필수) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Summernote CSS & JS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.js"></script>
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/post.css">
</head>
<body>
    <form id="writeForm">
        <input type="hidden" name="sbType" id="hiddenTypeInput">
        <input type="hidden" name="sbTitle" id="hiddenTitleInput">
        <input type="hidden" name="sbContent" id="hiddenContentInput">
        <input type="hidden" name="uNum" value="${loginUser.uNum}">
        <input type="hidden" id="sbNum" value="${sb.sbNum}" /> <!-- 문의 번호 -->
    
		<c:if test="${loginUser.uNum eq sb.uNum}">
	        <div id="button" class="btn_top">
	            <span class="btnBc cancel medium">
	                <input type="button" value="취소" onclick="window.history.back();" />
	            </span>
	            <span class="btnBc solid medium">
	                <input type="button" value="수정" id="updateButton" />
	            </span>
	        </div>
        </c:if>
    </form>
	<table class="writeTypeA">
		<colgroup>
			<col style="width:160px">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">게시판</th>
				<td class="select">
	                <span class="btnBc outline small">
	                    <button type="button" id="boardSelectBtn">게시판 선택</button>
	                </span>
	                <span class="text" id="selectedBoardText">관리자 1:1 문의</span>
	            </td>
			</tr>
			<tr>
				<th scope="row">제목</th>
				<td class="wrap">
					<div class="selectBox small" id="customSelectBox">
	                    <input type="text" class="txtBox" value="${sb.sbType}" readonly id="select-name1">
	                    <ul class="option" style="display:none;">
	                        <li><a href="#">사원</a></li>
	                        <li><a href="#">게시판</a></li>
	                    </ul>
	                </div>
					<div class="inputBox small">
	                    <div class="input_set">
	                        <input class="inpt" type="text" value="${sb.sbTitle}" id="titleInput" maxlength="50" required="required">
	                        <div class="rt">
	                            <button type="button" class="btnDel" onclick="document.getElementById('titleInput').value=''">삭제</button>
	                        </div>
	                    </div>
	                </div>
				</td>
			</tr>
		</tbody>
	</table>

    <!-- 게시판 선택 모달창 -->
	<jsp:include page="../include/select_board_modal.jsp"/>	
    <!-- 수정 모달 오버레이 -->
    <div id="modalOverlay">
        <div id="confirmModal">
            <div class="checkmodal-content">
                <p id="modalMessage">정말 수정하시겠습니까?</p>
                <div class="modal-buttons" id="confirmButtons">
                    <span class="btnBc cancel small">
		                <input type="button" value="취소" id="btnCancel" />
		            </span>
                    <span class="btnBc solid small">
		                <input type="button" value="수정" id="btnConfirm" />
		            </span>
                </div>
                <div class="modal-buttons" id="errorButtons" style="display:none;">
                    <span class="btnBc solid small">
		                <input type="button" value="확인" id="btnErrorConfirm" />
		            </span>
                </div>
            </div>
        </div>
    </div>
    <br>
    <!-- Summernote 에디터 -->
    <div>
        <textarea id="summernote"></textarea>
    </div>
    
    <script>
        $(document).ready(function () {

            // 커스텀 셀렉트 박스 토글
            $('#customSelectBox .txtBox').click(function(e) {
                e.stopPropagation();
                $('#customSelectBox .option').toggle();
            });

            // 옵션 클릭 시 값 변경
            $('#customSelectBox .option li a').click(function(e) {
                e.preventDefault();
                var selectedText = $(this).text();
                $('#select-name1').val(selectedText);
                $('#customSelectBox .option').hide();
            });

            // 클릭 외 영역 클릭 시 옵션 닫기
            $(document).click(function() {
                $('#customSelectBox .option').hide();
            });

            // Summernote 초기화 및 기존 내용 셋팅
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요.',
                height: 300,
            });
            $('#summernote').summernote('code', `${sb.sbContent}`);

            // 모달 관련 요소
            const overlay = $('#modalOverlay');
            const modalMessage = $('#modalMessage');
            const confirmButtons = $('#confirmButtons');
            const errorButtons = $('#errorButtons');

            // 수정 버튼 클릭 시 모달 열기
            $('#updateButton').click(function () {
                const title = $('#titleInput').val().trim();
                const content = $('#summernote').summernote('code').trim();

                if (!title) {
                    alert("제목을 입력해주세요.");
                    return;
                }
                if (!content || content === '<p><br></p>') {
                    alert("내용을 입력해주세요.");
                    return;
                }

                modalMessage.text('정말 수정하시겠습니까?');
                confirmButtons.show();
                errorButtons.hide();
                overlay.css('display', 'flex');
            });

            // 모달 취소 버튼
            $('#btnCancel').click(function () {
                overlay.hide();
            });

            // 모달 수정 확인 버튼
            $('#btnConfirm').click(function () {
                overlay.hide();

                const type = $('#select-name1').val();
                const title = $('#titleInput').val().trim();
                const content = $('#summernote').summernote('code').trim();
                const sbNum = $('#sbNum').val();

                // hidden input에 값 넣기 (필요시)
                $('#hiddenTypeInput').val(type);
                $('#hiddenTitleInput').val(title);
                $('#hiddenContentInput').val(content);

                // fetch로 PUT 요청
                fetch(`/api/supports/${sbNum}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        sbType: type,
                        sbTitle: title,
                        sbContent: content,
                        //sbStatus: '대기',
                        uNum: 1
                    })
                })
                .then(response => response.text())
                .then(result => {
                    if (result === "success") {
                        location.href = "/api/supports/supportList";
                    } else {
                        // 오류 모달 띄우기
                        modalMessage.text('오류가 발생했습니다.');
                        confirmButtons.hide();
                        errorButtons.show();
                        overlay.show();
                    }
                })
                .catch(() => {
                    modalMessage.text('오류가 발생했습니다.');
                    confirmButtons.hide();
                    errorButtons.show();
                    overlay.show();
                });
            });

            // 오류 모달 확인 버튼
            $('#btnErrorConfirm').click(function () {
                overlay.hide();
            });

            // 삭제 버튼 클릭 시 제목 입력창 내용 삭제
            $('.btnDel').click(function () {
                $('#titleInput').val('');
            });
        });
    </script>
	<script src="/js/selectBoardModal.js"></script>
</body>
</html>
