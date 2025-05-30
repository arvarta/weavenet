<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <title>관리자 게시글 작성</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.js"></script>
    <link rel="stylesheet" href="/css/post.css">
</head>
<body>
    <form id="writeForm" action="/api/admin/posts" method="post" enctype="multipart/form-data">
        <input type="hidden" name="bNum" id="bNumInput" value="${board.bNum}" />
        <input type="hidden" name="pTitle" id="hiddenTitleInput">
        <input type="hidden" name="pContent" id="hiddenContentInput">
        <input type="hidden" name="uNum" value="${loginUser.uNum}">

        <div id="button" class="btn_top">
            <span class="btnBc cancel medium">
                <input type="button" value="취소" onclick="location.href='/api/admin/posts/postList';">
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
	                                <c:set var="inputId" value="board_admin_write_${b.bNum}" />
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
        let currentFiles = [];

        function updateFileListDisplay() {
            const fileListDisplay = $('#fileListDisplay');
            const fileInput = $('#fileInput')[0];
            const newDataTransfer = new DataTransfer();

            fileListDisplay.html('');
            const ul = $('<ul>');

            currentFiles.forEach((file, index) => {
                const li = $('<li>');
                const span = $('<span>').text(file.name);
                const xButton = $(`
   				  <button type="button" class="delete-new-file-btn">
   				    <img class="close" alt="닫기" src="${pageContext.request.contextPath}/img/ico_close.svg">
   				  </button>
   				`)
                    .attr('data-index', index);
                li.append(span).append(xButton);
                ul.append(li);
                newDataTransfer.items.add(file);
            });

            fileListDisplay.append(ul);
            fileInput.files = newDataTransfer.files;
        }

        $(document).ready(function () {
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요.',
                height: 300
            });

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

            $('#fileInput').on('change', function() {
                const newFiles = this.files;
                for(let i=0; i < newFiles.length; i++){
                    let exists = false;
                    for(let j=0; j < currentFiles.length; j++){
                        if(currentFiles[j].name === newFiles[i].name){
                            exists = true; break;
                        }
                    }
                    if(!exists){ currentFiles.push(newFiles[i]); }
                }
                updateFileListDisplay();
                $(this).val('');
            });

            $('#fileListDisplay').on('click', '.delete-new-file-btn', function() {
                const indexToRemove = parseInt($(this).attr('data-index'), 10);
                currentFiles.splice(indexToRemove, 1);
                updateFileListDisplay();
            });

            $('#writeButton').click(function () {
                const title = $('#titleInput').val().trim();
                const content = $('#summernote').summernote('code');
                const bNumInput = $('#bNumInput'); 

                if (!bNumInput.val()) { alert('게시판을 선택해 주세요.'); openModalBtn.focus(); return; }
                if (!title) { alert("제목을 입력해주세요."); return; }
                if (!content || content === '<p><br></p>') { alert("내용을 입력해주세요."); return; }

                $('#hiddenTitleInput').val(title);
                $('#hiddenContentInput').val(content);
                $('#writeForm').submit();
            });

            $('.btnDel').click(() => $('#titleInput').val(''));
        });
    </script>
    <script src="/js/selectBoardModal.js"></script>
</body>
</html>
