<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Summernote -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/post.css">
    <link rel="stylesheet" href="/css/modal.css"> <!-- 모달 전용 CSS (이미 구성되어 있다고 가정) -->
</head>
<body>

    <form id="writeForm" action="/api/posts" method="post">
        <input type="hidden" name="bNum" value="${board.bNum}" />
        <input type="hidden" name="pTitle" id="hiddenTitleInput">
        <input type="hidden" name="pContent" id="hiddenContentInput">
        <input type="hidden" name="uNum" value="${loginUser.uNum}">

        <div id="button">
            <span class="btnBc cancel small">
                <input type="button" value="취소" onclick="location.href='/api/posts/postList';">
            </span>
            <span class="btnBc solid small">
                <input type="button" value="등록" id="writeButton" />
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
                        <input class="inpt" type="text" id="titleInput" placeholder="제목을 입력하세요." required="required">
                        <div class="rt">
                            <button type="button" class="btnDel" onclick="document.getElementById('titleInput').value=''">삭제</button>
                        </div>
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

    <br>

    <!-- Summernote 에디터 -->
    <div>
        <textarea id="summernote"></textarea>
    </div>

    <!-- JS 로직 -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요.',
                height: 300
            });

            const savedTitle = sessionStorage.getItem('postTitle');
            const savedContent = sessionStorage.getItem('postContent');
            if (savedTitle) {
                document.getElementById('titleInput').value = savedTitle;
            }
            if (savedContent) {
                $('#summernote').summernote('code', savedContent);
            }

            document.getElementById('writeButton').addEventListener('click', function () {
                const title = document.getElementById('titleInput').value.trim();
                const content = $('#summernote').summernote('code');
                const bNumInput = document.querySelector('input[name="bNum"]');

                if (!bNumInput.value || bNumInput.value === 'null') {
                    alert("게시판을 선택해 주세요.");
                    return;
                }

                if (!title) {
                    alert("제목을 입력해주세요.");
                    return;
                }
                if (!content || content === '<p><br></p>') {
                    alert("내용을 입력해주세요.");
                    return;
                }

                document.getElementById('hiddenTitleInput').value = title;
                document.getElementById('hiddenContentInput').value = content;

                sessionStorage.removeItem('postTitle');
                sessionStorage.removeItem('postContent');

                document.getElementById('writeForm').submit();
            });

            
        });
    </script>
    <script src="/js/selectBoardModal.js"></script>
</body>
</html>
