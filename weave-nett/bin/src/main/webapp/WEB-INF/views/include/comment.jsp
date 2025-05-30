<!-- /WEB-INF/views/layout.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>WeaveNet</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=1300">
    <link href="${pageContext.request.contextPath}/css/comment.css" rel="stylesheet" type="text/css">
    <script src="${pageContext.request.contextPath}/js/comment.js"></script>
	<script>
    	const loginUserName = "${loginUser.uAuth != 'USER' ? 'admin' : employee.eName}";
    	 console.log("employee.eName = ", "${employee.eName}");
    	const loginUserId = '${loginUser.uNum}';
    	const loginUserAuth = '${loginUser.uAuth}';
	    const contextPath = '${pageContext.request.contextPath}';
	    const postWriterId = "${post.writerId}";
	</script>
</head>
<body>
	<div class="cmt_wrap">
		<!-- 댓글 입력창 -->
		<div class="cmt_write_wrap">
			<form id="commentForm">

    			<input type="hidden" name="pNum" value="${p.pNum}"/>
    			<input type="hidden" name="uNum" value="${sessionScope.loginUser.uNum}"/>
				
				<div class="cmt_text_area">	
					<textarea name="cContent" id="cContent" placeholder="댓글을 입력해 주세요."></textarea>
				</div>
				<div class="cmt_btn_area">
					<span class="btnBc solid medium"><input type="submit" value="입력"></span>
				</div>
			</form>
		</div>
		<!-- // 댓글 입력창 -->
		
		<!-- 정렬 옵션-->
		<div class="cmt_list_option">
			<input type="radio" id="sort_recent" name="sortOption" class="check_box2" value="recent" checked>
			<label for="sort_recent"><span>최신순</span></label>
			<input type="radio" id="sort_oldest" name="sortOption" class="check_box2" value="oldest">
			<label for="sort_oldest"><span>등록순</span></label>
		</div>  

		<!-- 댓글 목록 -->
		<div id="cmt_content_wrap">
			<ul class="cmt_list">
				<c:forEach var="comment" items="${commentList}">
				<li class="cmt_set">
					<!--			
					<li class="cmt_set" data-comment-id="${comment.cNum}">
					-->
						<!-- 회원 활동 내역 페이지 이동 -->
						<a href="#" class="photo">
							<!-- 프로필 이미지 -->
					        <div class="thumb">
								<span class="initial_profile">
									<img id="profileImg" class="img_thumb" alt="프로필" src="${pageContext.request.contextPath}/img/profile_default.png">
								</span>
							</div>
						</a> 
						<div class="cmt_box">
							<div class="user">
								<a href="#">
									<strong class="name">${comment.writerName}</strong>
								</a>
								<span class="date">
									<fmt:formatDate value="${comment.cRegDate}" pattern="yyyy. MM. dd. HH:mm"/>
								</span>
								<span class="pin"><img src="${pageContext.request.contextPath}/img/ico_pin.svg"></span> 
								<div class="cmt_task">
									<button type="button" class="btn_more">
										<span class="blind">메뉴 더보기</span>
									</button> 
									<div class="ly_context">
										<ul>
											<li>
												<button type="button">고정</button>
					              			</li>
					              			<li>
												<button type="button">수정</button>
					              			</li>
					              			<li>
												<button type="button">신고</button>
					              			</li>
					              			<li>
												<button type="button">삭제</button>
					              			</li> 
				              			</ul>
			              			</div>
		              			</div>
		              		</div> 
		              		<p class="cmt_area">
								<span><c:out value="${comment.cContent}"/></span>
							</p>
		              		<div class="cmt_reply_area">
		      					<span class="btnBc outline small btn_reply">
		      						<input type="button" value="답글">
		      					</span>  
		      				</div>
		      			</div>
	      			</li>
	      			<!--  
	      			<li class="cmt_set reply" data-comment-id="${comment.cNum}">
						<a href="#" class="photo">
					        <div class="thumb">
								<span class="initial_profile">
									<img id="profileImg" class="img_thumb" alt="프로필" src="${pageContext.request.contextPath}/img/profile_default.png">
								</span>
							</div>
						</a> 
						<div class="cmt_box">
							<div class="user">
								<a href="#">
									<strong class="name">${comment.writerName}</strong>
								</a>
								<span class="date">
									<fmt:formatDate value="${comment.cRegDate}" pattern="yyyy. MM. dd. HH:mm"/>
								</span> 
								<div class="cmt_task">
									<button type="button" class="btn_more">
										<span class="blind">메뉴 더보기</span>
									</button> 
									<div class="ly_context">
										<ul>
											<li>
												<button type="button">고정</button>
					              			</li>
					              			<li>
												<button type="button">수정</button>
					              			</li>
					              			<li>
												<button type="button">삭제</button>
					              			</li> 
				              			</ul>
			              			</div>
		              			</div>
		              		</div> 
		              		<p class="cmt_area">
								<span><c:out value="${comment.cContent}"/></span>
							</p>
		              		<div class="cmt_reply_area">
		      					<span class="btnBc outline small btn_reply">
		      						<input type="button" value="답글">
		      					</span>  
		      				</div>
		      			</div>
	      			</li>
	      			<li class="cmt_set write_ver" data-comment-id="${comment.cNum}">
						<div class="cmt_box">
							<div class="user">
								<a href="#">
									<strong class="name">${comment.writerName}</strong>
								</a>
		              		</div> 
		              		<div class="register_box">
			              		<div class="cmt_write_wrap">
									<form>
										<div class="cmt_text_area">
											<textarea id="comment" placeholder="답글을 입력해 주세요."></textarea>		
										</div>
										<div class="cmt_btn_area">
											<span class="btnBc cancel small"><input type="button" value="취소"></span>
											<span class="btnBc solid small"><input type="button" value="입력"></span>
										</div>
									</form>
								</div>
		              		</div>
		      			</div>
	      			</li>
	      			-->
      			</c:forEach>
      		</ul>
		</div>
		<!-- // 댓글 목록 -->
	</div>
</body>
</html>