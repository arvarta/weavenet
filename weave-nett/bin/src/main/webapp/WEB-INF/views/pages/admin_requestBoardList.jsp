<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<title>WeaveNet</title>
	<meta charset="UTF-8">
	<link href="/css/admin_board.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div class="request_title">	
		<h1>요청 관리</h1>
	</div>
	
	<table class="listTypeA">
		<colgroup>
			<col style="width: 15%;">
			<col style="width: 20%;">
			<col style="width: 20%;">
			<col style="width: 30%;">
			<col style="width: 15%;">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">요청자</th>
				<th scope="col">구분</th>
				<th scope="col">소속</th>
				<th scope="col">게시판명</th>
				<th scope="col">관리</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${ empty requestBoards }">
					<tr>
						<td colspan="4">
							<div class="nodata img">
							    <p class="board_no"><b>요청된 게시판이 없습니다.</b></p> 
						    </div>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="requestBoard" items="${requestBoards}">
						<tr>
							<td>${requestBoard.requesterName}</td>
							<td>${requestBoard.brType eq 'DEPARTMENT' ? '부서 게시판' 
							: requestBoard.brType eq 'PROJECT' ? '프로젝트 게시판' : '전체 게시판'}</td>
							<td>${ requestBoard.deptName }</td>
							<td>${requestBoard.brTitle}</td>
							<td>
								<div class="cmt_task">
									<button type="button" class="btn_more"><span class="blind">메뉴 더보기</span></button>
									<div class="ly_context">
										<ul>
											<li><button type="button" class="approve-btn" data-brnum="${ requestBoard.brNum }">승인</button></li>
											<li><button type="button" class="reject-btn" data-brnum="${ requestBoard.brNum }">거부</button></li>
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
		
		document.querySelectorAll('.approve-btn').forEach(btn => {
			btn.onclick = () => {
				const brNum = btn.dataset.brnum;
				fetch('/api/admin/boards/request/approve', {
					method: 'POST',
					headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
					body: 'brNum=' + brNum
				})
				.then(res => res.json())
				.then(data => {
					alert(data.message);
					if(data.success) location.reload();
				});
			};
		});
		
		document.querySelectorAll('.reject-btn').forEach(btn => {
		    btn.onclick = () => {
		        const brNum = btn.dataset.brnum;
		        fetch('/api/admin/boards/request/reject', {
		            method: 'POST',
		            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		            body: 'brNum=' + brNum
		        })
		        .then(res => res.json())
				.then(data => {
					alert(data.message);
					if(data.success) location.reload();
				});
		    };
		});
	</script>
</body>

</html>