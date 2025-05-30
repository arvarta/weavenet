<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <title>게시글 수정</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.js"></script>
    <link rel="stylesheet" href="/css/post.css">
</head>
<body>
    <form id="writeForm">
        <input type="hidden" name="uNum" value="${loginUser.uNum}">
        <input type="hidden" id="pNum" value="${p.pNum}" />
        <input type="hidden" id="bNumInput" name="bNum" value="${board.bNum}"> 
    
        <div id="button" class="btn_top">
            <span class="btnBc outline medium">
                <input type="button" value="취소" onclick="location.href='/api/posts/${p.pNum}';" />
            </span>
            <span class="btnBc solid medium">
                <input type="button" value="수정" id="updateButton" />
            </span>
        </div>
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
	                <span class="text" id="selectedBoardText">${ board.bTitle }</span>
	            </td>
			</tr>
			<tr>
			<tr>
				<th scope="row">제목</th>
				<td>
					<div class="inputBox small">
	                    <div class="input_set">
	                        <input class="inpt" type="text" value="${ p.pTitle }" id="titleInput" required="required">
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
					<%-- 새 파일 첨부 섹션 --%>
					<div id="newFileSection">
						<div class="filebox">
						    <label for="newFileInput">파일찾기</label> 
						    <input type="file" id="newFileInput" name="files" multiple>
						    <div id="newFileListDisplay" class="upload-name"> </div>
						</div>
					</div>

                    <%-- 기존 파일 목록 섹션 --%>
					<div id="existingFilesSection">
	                    <%-- ★★★ 수정된 부분 시작 ★★★ --%>
	                    <c:if test="${not empty existingFiles}">
	                        <ul class="existing-files-list">
	                            <c:forEach var="file" items="${existingFiles}">
	                                <li id="file-item-${file.f_num}">
	                                    <%-- 실제 삭제 처리를 위해 값을 넘길 숨김 체크박스 --%>
	                                    <input type="checkbox" name="deletedFileIds" value="${file.f_num}" id="del-file-${file.f_num}" style="display:none;">
	                                    <%-- 파일 이름 및 크기 (MB 단위로 수정) --%>
	                                    <span>${file.fName} (${String.format("%.2f", file.fSize / 1024.0 / 1024.0)} MB)</span>
	                                    <%-- 삭제 버튼 (JS에서 위 체크박스를 체크하고 li를 숨김) --%>
	                                    <button type="button" class="delete-existing-file-btn" data-fid="${file.f_num}">
	                                        <img class="close" alt="닫기" src="${pageContext.request.contextPath}/img/ico_close.svg">
	                                    </button>
	                                </li>
	                            </c:forEach>
	                        </ul>
	                    </c:if>
	                    <%-- ★★★ 수정된 부분 끝 ★★★ --%>
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
                                <c:set var="inputId" value="board_user_edit_${b.bNum}" />
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
    <div>
        <textarea id="summernote"></textarea>
    </div>
    
    <script>
        // 새 파일 관리를 위한 DataTransfer 객체
        let dataTransfer = new DataTransfer();

        // 새 파일 목록 표시 및 X 버튼 추가 함수 (수정됨)
        function updateNewFileListDisplay() {
            const fileListDisplay = $('#newFileListDisplay');
            fileListDisplay.html(''); 
            const ul = $('<ul>');
            
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
					.attr('data-index', i); // attr 사용
                li.append(span).append(xButton);
                ul.append(li);
            }
            fileListDisplay.append(ul);
        }


        $(document).ready(function () {
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요.',
                height: 300,
            });
            $('#summernote').summernote('code', `<c:out value="${p.pContent}" escapeXml="false"/>`);

            const overlay = $('#modalOverlay'); 
            const modalMessage = $('#modalMessage');
            const confirmButtons = $('#confirmButtons');
            const errorButtons = $('#errorButtons');

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


            // 새 파일 입력 변경 JS
            $('#newFileInput').on('change', function() {
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
                updateNewFileListDisplay();
                $(this).val(''); 
            });

            // 새 파일 X 버튼 JS (수정됨: parseInt 추가)
            $('#newFileListDisplay').on('click', '.delete-new-file-btn', function() {
                const indexToRemove = parseInt($(this).attr('data-index'), 10); 

                if (isNaN(indexToRemove)) return; // 인덱스가 유효하지 않으면 중단

                const newFiles = new DataTransfer();
                for (let i = 0; i < dataTransfer.files.length; i++) {
                    if (i !== indexToRemove) { 
                        newFiles.items.add(dataTransfer.files[i]); 
                    }
                }
                dataTransfer = newFiles; 
                updateNewFileListDisplay(); 
            });

            // 기존 파일 X 버튼 JS
            $('#existingFilesSection').on('click', '.delete-existing-file-btn', function() {
                const fileId = $(this).data('fid');
                const listItem = $('#file-item-' + fileId);
                const checkbox = $('#del-file-' + fileId);
                checkbox.prop('checked', true);
                listItem.fadeOut('fast'); 
            });

            // 수정 버튼 JS
            $('#updateButton').click(function () {
                const title = $('#titleInput').val().trim();
                const content = $('#summernote').summernote('code').trim();
                const bNum = $('#bNumInput').val();

                if (!bNum) { alert("게시판을 선택해주세요."); return; }
                if (!title) { alert("제목을 입력해주세요."); return; }
                if (!content || content === '<p><br></p>') { alert("내용을 입력해주세요."); return; }

                modalMessage.text('정말 수정하시겠습니까?');
                confirmButtons.show(); errorButtons.hide();
                overlay.css('display', 'flex');
            });

            $('#btnCancel').click(() => overlay.hide());
            $('#btnErrorConfirm').click(() => overlay.hide());
            $('.btnDel').click(() => $('#titleInput').val(''));

            // Fetch JS (FormData 업데이트)
            $('#btnConfirm').click(function () {
                overlay.hide();

                const pNum = $('#pNum').val();
                const title = $('#titleInput').val().trim();
                const content = $('#summernote').summernote('code'); 
                const uNum = $('input[name="uNum"]').val(); 
                const bNum = $('#bNumInput').val(); 

                const formData = new FormData();
                formData.append('pTitle', title);
                formData.append('pContent', content);
                formData.append('uNum', uNum); 
                if (bNum) { formData.append('bNum', bNum); }

                // 삭제할 파일 ID들 추가
                $('input[name="deletedFileIds"]:checked').each(function() {
                    formData.append('deletedFileIds', $(this).val());
                });

                // 새 파일들 추가 (DataTransfer 사용)
                const newFiles = dataTransfer.files;
                if (newFiles.length > 0) {
                    for (let i = 0; i < newFiles.length; i++) {
                        formData.append('newFiles', newFiles[i]);
                    }
                }
                
                fetch(`${pageContext.request.contextPath}/api/posts/${pNum}/update`, {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.text()) 
                .then(result => {
                    if (result === "success") {
                        alert("게시글이 수정되었습니다.");
                        location.href = "${pageContext.request.contextPath}/api/posts/" + pNum; 
                    } else {
                         let msg = '수정 중 오류: ' + result;
                         if (result === "postNotFound") msg = '게시글을 찾을 수 없습니다.';
                         else if (result === "unauthorized_login" || result === "unauthorized_permission") msg = '수정 권한이 없습니다.';
                         else if (result === "fileUploadError") msg = '파일 업로드 오류. 내용만 수정되었을 수 있습니다.';
                         modalMessage.text(msg);
                         confirmButtons.hide(); errorButtons.show();
                         overlay.show();
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    modalMessage.text('네트워크 또는 서버 오류가 발생했습니다.');
                    confirmButtons.hide(); errorButtons.show();
                    overlay.show();
                });
            });
        });
	</script>
	<script src="/js/selectBoardModal.js"></script>
</body>
</html>