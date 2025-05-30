<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 1:1 문의 작성</title>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Summernote -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/post.css">
    <link rel="stylesheet" href="/css/modal.css">
</head>
<body>

    <form id="writeForm" action="/api/supports" method="post">
        <input type="hidden" name="sbType" id="hiddenTypeInput">
        <input type="hidden" name="sbTitle" id="hiddenTitleInput">
        <input type="hidden" name="sbContent" id="hiddenContentInput">
        <input type="hidden" name="uNum" value="${loginUser.uNum}">

        <div id="button">
            <span class="btnBc cancel small"><input type="button" value="취소" onclick="location.href='/api/supports/supportList';"></span>
            <span class="btnBc solid small"><input type="button" value="등록" id="writeButton" /></span>
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
            </td>
            <td><span id="selectedBoardText">관리자 1:1 문의</span></td>
        </tr>
        <tr>
            <td>제목</td>
            <td>
                <div class="selectBox" id="supportTypeBox">
                    <input type="text" class="txtBox" value="분류선택" readonly id="supportTypeInput">
                    <ul class="option" id="supportTypeOptions" style="display:none;">
                        <li><a href="#" data-value="사원">사원</a></li>
                        <li><a href="#" data-value="게시판">게시판</a></li>
                    </ul>
                </div>
            </td>
            <td>
                <div class="inputBox">
                    <div class="input_set">
                        <input class="inpt" type="text" value="" id="titleInput" placeholder="제목을 입력하세요." required="required">
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

    <!-- Summernote 에디터 -->
    <br>
    <div>
        <textarea id="summernote"></textarea>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            // Summernote 초기화
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요.',
                height: 300
            });

            // 분류 셀렉트 박스 열기/닫기
            const supportTypeInput = document.getElementById("supportTypeInput");
            const options = document.getElementById("supportTypeOptions");

            supportTypeInput.addEventListener("click", function () {
                options.style.display = options.style.display === "none" ? "block" : "none";
            });

            // 분류 항목 선택 처리
            document.querySelectorAll('#supportTypeOptions a').forEach(function (option) {
                option.addEventListener('click', function (e) {
                    e.preventDefault();
                    const value = this.getAttribute("data-value");
                    supportTypeInput.value = value;
                    options.style.display = "none";
                });
            });

            // 등록 버튼 클릭 처리
            document.getElementById('writeButton').addEventListener('click', function () {
                const type = supportTypeInput.value.trim();
                const title = document.getElementById('titleInput').value.trim();
                const content = $('#summernote').summernote('code');
                const board = document.getElementById('selectedBoardText').textContent.trim();

                if (!title) {
                    alert("제목을 입력해주세요.");
                    return;
                }

                if (!type || type === '분류선택') {
                    alert("분류를 선택해주세요.");
                    return;
                }

                if (!content || content === '<p><br></p>') {
                    alert("내용을 입력해주세요.");
                    return;
                }

                document.getElementById('hiddenTypeInput').value = type;
                document.getElementById('hiddenTitleInput').value = title;
                document.getElementById('hiddenContentInput').value = content;

                document.getElementById('writeForm').submit();
            });
        });
    </script>
	<script src="/js/selectBoardModal.js"></script>
</body>
</html>
