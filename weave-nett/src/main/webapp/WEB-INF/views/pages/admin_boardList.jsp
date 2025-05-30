<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<title>WeaveNet</title>
	<meta charset="UTF-8">
	<link href="/css/admin_board.css" rel="stylesheet" type="text/css">
	<link href="/css/addBoardModal.css" rel="stylesheet" type="text/css">
	<link href="/css/editBoardModal.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div class="request_title">	
		<h1>목록 관리</h1>
		<span class="btnBc outline small"><input type="button" value="추가" onclick="openModal('admin')"></span>
	</div>
	
	<table class="listTypeA">
		<colgroup>
			<col style="width: 25%;">
			<col style="width: 25%;">
			<col style="width: 35%;">
			<col style="width: 15%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">구분</th>
				<th scope="col">게시판명</th>
				<th scope="col">게시글 수</th>
				<th scope="col">관리</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${ empty boardList }">
					<tr>
						<td colspan="4">
							<div class="nodata img">
							    <p class="board_no"><b>게시판이 없습니다.</b></p> 
						    </div>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="board" items="${boardList}">
						<tr>
							<td>${board.bType == 'DEPARTMENT' ? '부서 게시판' 
							: board.bType == 'PROJECT' ? '프로젝트 게시판' : '전체 게시판'}</td>
							<td>${board.bTitle}</td>
							<td>${board.postCount}</td>
							<td>
								<div class="cmt_task">
									<button type="button" class="btn_more"><span class="blind">메뉴 더보기</span></button>
									<div class="ly_context">
										<ul>
											<li><button type="button" class="edit-btn" onclick="openEditModal(${board.bNum})">수정</button></li>
											<li><button type="button" class="delete-btn" onclick="deleteBoard(${board.bNum})">삭제</button></li>
										</ul>
									</div>
								</div>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
	
	<script>
	    // 더보기 버튼
	    document.querySelectorAll('.btn_more').forEach(btn => {
	        const cmtTasklist = btn.nextElementSibling;
	        if (!cmtTasklist) return;

	        btn.onclick = e => {
	            e.stopPropagation();
	            cmtTasklist.classList.toggle('active');
	            document.querySelectorAll('.ly_context').forEach(ctx => {
	                if (ctx !== cmtTasklist) ctx.classList.remove('active');
	            });
	        };
	    });

	    function deleteBoard(bNum) {
	        if (!confirm("정말 삭제하시겠습니까?")) return;

	        fetch('/api/admin/boards/' + bNum, {
	            method: 'DELETE'
	        })
	        .then(res => res.json())
	        .then(data => {
	            alert(data.message);
	            if (data.success) location.reload();
	        });
	    }
		
	</script>
<jsp:include page="../include/admin_board_modal.jsp" />
<jsp:include page="../include/edit_boardModal.jsp" />
</body>
</html>