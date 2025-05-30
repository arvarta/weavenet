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
        <input type="hidden" name="pTitle" id="hiddenTitleInput">
        <input type="hidden" name="pContent" id="hiddenContentInput">
        <input type="hidden" name="uNum" value="${loginUser.uNum}">
        <input type="hidden" id="pNum" value="${p.pNum}" /> <!-- 문의 번호 -->
    
        <div id="button">
            <span class="btnBc outline small">
                <input type="button" value="취소" onclick="location.href='/api/posts/postList';" />
            </span>
            <span class="btnBc outline small">
                <input type="button" value="수정" id="updateButton" />
            </span>
        </div>
    </form>
    <br>
    <table>
        <tr>
            <td>게시판</td>
            <td>
                <span class="btnBc outline small">
                    <button type="button" id="boardSelectBtn">게시판 선택</button>
                </span>        
	            <span id="selectedBoardText">${ board.bTitle }</span>
            </td>
                
        </tr>
        <tr>
            <td>제목</td>
            <td>
                <div class="inputBox">
                    <div class="input_set">
                        <input class="inpt" type="text" value="${ p.pTitle }" id="titleInput" required="required">
                        <div class="rt"><button type="button" class="btnDel" onclick="document.getElementById('titleInput').value=''">삭제</button></div>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>첨부파일</td>
            <td colspan="2">로직 미구현</td>
        </tr>
    </table>


    <!-- 게시판 선택 모달 -->
    <jsp:include page="../include/select_board_modal.jsp"/>
    
    <!-- 수정 모달 오버레이 -->
    <div id="modalOverlay">
        <div id="confirmModal">
            <div class="checkmodal-content">
                <p id="modalMessage">정말 수정하시겠습니까?</p>
                <div class="modal-buttons" id="confirmButtons">
                    <button id="btnConfirm" type="button">수정</button>
                    <button id="btnCancel" type="button">취소</button>
                </div>
                <div class="modal-buttons" id="errorButtons" style="display:none;">
                    <button id="btnErrorConfirm" type="button">확인</button>
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
            // Summernote 초기화 및 기존 내용 셋팅
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요.',
                height: 300,
            });
            $('#summernote').summernote('code', `${p.pContent}`);



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
                const pNum = $('#pNum').val();

                // hidden input에 값 넣기 (필요시)
                $('#hiddenTypeInput').val(type);
                $('#hiddenTitleInput').val(title);
                $('#hiddenContentInput').val(content);

                // fetch로 PUT 요청
                fetch(`/api/posts/${pNum}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        pTitle: title,
                        pContent: content,
                        uNum: 1
                    })
                })
                .then(response => response.text())
                .then(result => {
                    if (result === "success") {
                        location.href = "/api/posts/postList";
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
