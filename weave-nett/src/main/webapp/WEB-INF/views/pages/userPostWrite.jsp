<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.js"></script>
    <link rel="stylesheet" href="/css/post.css">
</head>
<body>
    <form id="writeForm" action="/api/posts" method="post" enctype="multipart/form-data">
        <input type="hidden" name="bNum" id="bNumInput" value="${board.bNum}" /> 
        <input type="hidden" name="pTitle" id="hiddenTitleInput">
        <input type="hidden" name="pContent" id="hiddenContentInput">
        <input type="hidden" name="uNum" value="${loginUser.uNum}">

        <div id="button" class="btn_top">
            <span class="btnBc cancel medium">
                <input type="button" value="취소" onclick="location.href='/api/posts/postList';">
            </span>
            <span class="btnBc solid medium">
                <input type="button" value="등록" id="writeButton" />
            </span>
        </div>
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
		                <span class="text" id="selectedBoardText">${not empty board.bTitle ? board.bTitle : '게시판을 선택하세요.'}</span>
		            </td>
				</tr>
				<tr>
					<th scope="row">제목</th>
					<td>
						<div class="inputBox small">
		                    <div class="input_set">
		                        <input class="inpt" type="text" id="titleInput" placeholder="제목을 입력하세요." required="required">
		                        <div class="rt">
		                            <button type="button" class="btnDel" onclick="document.getElementById('titleInput').value=''">삭제</button>
		                        </div>
		                    </div>
		                </div>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일</th>
					<td>
						<div class="filebox">
						    <label for="fileInput">파일찾기</label> 
						    <input type="file" id="fileInput" name="files" multiple>
						    <div id="fileListDisplay" class="upload-name"> </div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
        
         <!-- 게시판 선택 모달 -->
    	<jsp:include page="../include/select_board_modal.jsp"/>
        
        <div id="boardSelectModal" class="modal">
            <div class="modal-content">
                <span class="close" id="closeBoardModalBtn">&times;</span>
                <h3>게시판 선택</h3>
                <ul>
                    <c:forEach var="b" items="${boards}" varStatus="status">
                        <c:if test="${not empty b.bNum}">
                            <c:set var="isManager" value="${loginUser.uAuth == 'SUPER_ADMIN' or loginUser.uAuth == 'BOARD_MANAGER'}" />
                            <c:set var="isMyDeptBoard" value="${b.bType == 'DEPARTMENT' and deptNum == b.deptNum}" /> 
                            <c:set var="isGeneralBoard" value="${b.bType != 'DEPARTMENT'}" />
                            <c:if test="${isManager or isMyDeptBoard or isGeneralBoard}">
                                <li>
                                    <c:set var="inputId" value="board_write_${b.bNum}" />
                                    <input type="radio" id="${inputId}" name="boardRadio" class="radio_box small"
                                           data-bnum="${b.bNum}" value="${b.bTitle}" />
                                    <label for="${inputId}"><span>${b.bTitle}</span></label>
                                </li>
                            </c:if>
                        </c:if>
                    </c:forEach>
                </ul>
                <div style="text-align:right; margin-top: 10px;" id="confirmButtonWrapper">
                    <span class="btnBc disabled small" id="confirmButtonSpan">
                        <input type="button" value="확인" disabled>
                    </span>
                </div>
            </div>
        </div>
    </form> 

    <div>
        <textarea id="summernote"></textarea>
    </div>

    <script>
        // DataTransfer 객체를 전역으로 선언
        let dataTransfer = new DataTransfer();

        // 파일 목록 표시 및 X 버튼 추가 함수
        function updateFileListDisplay() {
            const fileListDisplay = $('#fileListDisplay');
            fileListDisplay.html(''); 
            const ul = $('<ul>');
            
            // 현재 DataTransfer의 파일들로 목록 생성
            const files = dataTransfer.files;
            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                const li = $('<li>');
                const span = $('<span>').text(file.name);
                // X 버튼에 data-index 속성으로 현재 인덱스(i)를 저장
                const xButton = $(`
				  <button type="button" class="delete-new-file-btn">
				    <img class="close" alt="닫기" src="${pageContext.request.contextPath}/img/ico_close.svg">
				  </button>
				`)
                    .attr('data-index', i); // attr로 변경하여 명확성 확보
                li.append(span).append(xButton);
                ul.append(li);
            }
            fileListDisplay.append(ul);
        }

        $(document).ready(function () {
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요.',
                height: 300
            });

            // 모달 JS
            const boardModal = $('#boardSelectModal');
            const openModalBtn = $('#boardSelectBtn');
            const closeModalBtn = $('#closeBoardModalBtn');

            openModalBtn.click(() => boardModal.addClass('show'));
            closeModalBtn.click(() => boardModal.removeClass('show'));
            $(window).click((e) => {
                if (e.target === boardModal[0]) {
                    boardModal.removeClass('show');
                }
            });
            
            boardModal.on('change', 'input[name="boardRadio"]', function() {
                $('#confirmButtonWrapper').html(`
                    <span class="btnBc solid small" id="confirmButtonSpan">
                         <input type="button" value="확인" id="confirmBoardBtn">
                    </span>
                `);
            });

            boardModal.on('click', '#confirmBoardBtn', function() {
                const selected = $('input[name="boardRadio"]:checked');
                if (selected.length > 0) {
                    $('#bNumInput').val(selected.data('bnum'));
                    $('#selectedBoardText').text(selected.val());
                    boardModal.removeClass('show');
                } else {
                    alert("게시판을 선택해주세요.");
                }
            });

            // 파일 입력 변경 JS
            $('#fileInput').on('change', function() {
                const addedFiles = this.files;
                for(let i=0; i < addedFiles.length; i++){
                    let exists = false;
                    for(let j=0; j < dataTransfer.files.length; j++){
                        if(dataTransfer.files[j].name === addedFiles[i].name){
                            exists = true; break;
                        }
                    }
                    if(!exists){ dataTransfer.items.add(addedFiles[i]); }
                }
                updateFileListDisplay(); 
                $(this).val(''); // 입력 필드 초기화
            });

            // 새 파일 X 버튼 JS (수정됨)
            $('#fileListDisplay').on('click', '.delete-new-file-btn', function() {
                // 클릭된 버튼에서 index 가져오기 (문자열일 수 있으므로 숫자로 변환)
                const indexToRemove = parseInt($(this).attr('data-index'), 10); 
                
                const newFiles = new DataTransfer(); // 새 DataTransfer 생성
                
                // 기존 DataTransfer에서 삭제할 인덱스를 제외하고 새 DataTransfer로 복사
                for (let i = 0; i < dataTransfer.files.length; i++) {
                    if (i !== indexToRemove) {
                        newFiles.items.add(dataTransfer.files[i]);
                    }
                }
                
                dataTransfer = newFiles; // 전역 DataTransfer를 새 것으로 교체
                updateFileListDisplay(); // 목록 다시 그리기
            });

            // 등록 버튼 JS (FormData 사용 방식으로 변경 - 더 안정적)
            $('#writeButton').click(function () {
                const title = $('#titleInput').val().trim();
                const content = $('#summernote').summernote('code');
                const bNumInput = $('#bNumInput'); 

                if (!bNumInput.val()) { alert('게시판을 선택해 주세요.'); openModalBtn.focus(); return; }
                if (!title) { alert("제목을 입력해주세요."); return; }
                if (!content || content === '<p><br></p>') { alert("내용을 입력해주세요."); return; }

                // FormData 객체 생성
                const formData = new FormData($('#writeForm')[0]); 
                // FormData에서 기본 files 필드 삭제 (DataTransfer로 대체)
                formData.delete('files'); 

                // DataTransfer에 있는 최종 파일 목록을 FormData에 추가
                for (let i = 0; i < dataTransfer.files.length; i++) {
                    formData.append('files', dataTransfer.files[i]);
                }
                
                // Summernote 내용 다시 설정 (FormData는 hidden input을 읽지 않음)
                formData.set('pTitle', title);
                formData.set('pContent', content);

                // Fetch API를 사용하여 폼 제출
                fetch('/api/posts', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    // 서버 응답 처리 (리다이렉트 또는 성공/실패 메시지)
                    if (response.ok) {
                        // 성공 시, 서버에서 리다이렉트를 했다면 브라우저가 따름.
                        // 만약 서버가 JSON 등을 반환하면 여기서 처리 후 리다이렉트.
                        // 여기서는 리다이렉트를 가정하고, 성공 시 목록으로 이동.
                        alert("게시글이 등록되었습니다.");
                        // 서버 응답 URL 확인 후 이동하거나 고정 URL로 이동
                        if(response.redirected) {
                            window.location.href = response.url;
                        } else {
                            // 리다이렉트가 없다면 목록 페이지로 이동
                             window.location.href = '/api/posts/postList';
                        }
                    } else {
                         // 서버에서 에러 응답이 온 경우
                         alert("게시글 등록에 실패했습니다. (서버 오류)");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert("게시글 등록 중 오류가 발생했습니다.");
                });
            });

            $('.btnDel').click(() => $('#titleInput').val('')); 
        });
    </script>
    <script src="/js/selectBoardModal.js"></script>
</body>
</html>