<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>WeaveNet</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=1300">
    <link href="${pageContext.request.contextPath}/css/base.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/layout.css" rel="stylesheet" type="text/css">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css">
    <script src="${pageContext.request.contextPath}/js/menu.js"></script>
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
</head>

<body>
<div id="header">
    <h1 class="weavenet_logo">
		<a href="/api/posts/postList"><img src="${pageContext.request.contextPath}/img/logo01.svg"></a>
	</h1>

    <form id="searchForm" method="get">
	    <div class="search_area">
	        <label for="header_search_id"><i class="blind">게시글 검색</i></label>
	        <input id="header_search_id" name="keyword" type="text" placeholder="게시글 검색" class="search_input">
	
	        <!-- 검색 조건 hidden input -->
	        <input type="hidden" name="condition" id="conditionInput" value="title">
	
	        <button type="submit" class="btn_search_submit"><i class="blind">검색</i></button>
	
	        <div class="ly_simple_search">
	            <div class="scroll_area">
	                <ul class="condition_list">
	                    <li class="condition_item">
	                        <a href="#" class="condition_item_inner icon_contents" data-condition="title">
	                            <span class="text">제목으로 찾기 <strong class="keyword">가나다</strong></span>
	                        </a>
	                    </li>
	                    <li class="condition_item">
	                        <a href="#" class="condition_item_inner icon_member" data-condition="writer">
	                            <span class="text">작성자로 찾기 <strong class="keyword">가나다</strong></span>
	                        </a>
	                    </li>
	                </ul>
	            </div>
	        </div>
	    </div>
	</form>

    <div class="setting_area">
        <c:if test="${sessionScope.loginUser.uAuth == 'SUPER_ADMIN' || sessionScope.loginUser.uAuth == 'EMPLOYEE_MANAGER'|| sessionScope.loginUser.uAuth == 'BOARD_MANAGER'}">
    		<span class="btnBc outline small"><a href="${pageContext.request.contextPath}/api/admin/main">관리자</a></span>
		</c:if>

        <div class="profile_area">
            <div class="gnbMemberInfo">
                <div class="thumb">
                    <span class="initial_profile">
                        <c:set var="profileImagePath" value="${pageContext.request.contextPath}/img/profile_default.png" />
                        <c:if test="${not empty sessionScope.loginUser && not empty sessionScope.loginUser.uProfile}">
                            <c:set var="profileImagePath" value="${pageContext.request.contextPath}${sessionScope.loginUser.uProfile}" />
                        </c:if>
                        <img id="profileImg" class="img_thumb" alt="프로필" src="${profileImagePath}"/>
                    </span>
                </div>
            </div>

            <div class="gnb_user">
                <ul class="profile_list">
<!--                     <li class="item"><a href="#">활동 내역</a></li> -->
                    <c:if test="${not empty sessionScope.loginUser && not empty sessionScope.loginUser.uNum}">
                        <li class="item"><a href="${pageContext.request.contextPath}/api/user/myPage/${sessionScope.loginUser.uNum}" class="btn myinfo">내 정보</a></li>
                    </c:if>
                    <li class="line"></li>
                    <li class="item"><a href="${pageContext.request.contextPath}/api/user/logout" class="btn logout">로그아웃</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
	document.addEventListener("DOMContentLoaded", function() {
		document.getElementById('searchForm').action = window.location.pathname;
	    document.querySelectorAll('.condition_item_inner').forEach(function(elem) {
	        elem.addEventListener('click', function(e) {
	            e.preventDefault();
	
	            const keyword = this.querySelector('.keyword').textContent.trim();
	            const condition = this.getAttribute('data-condition');
	
	            document.getElementById('header_search_id').value = keyword;
	            document.getElementById('conditionInput').value = condition;
	
	            document.querySelectorAll('.condition_item_inner').forEach(function(el) {
	                el.classList.remove('active');
	            });
	            this.classList.add('active');
	
	            document.getElementById('searchForm').submit();
	        });
	    });
	
	    document.querySelector('.btn_search_submit').addEventListener('click', function(e) {
	        const keyword = document.getElementById('header_search_id').value.trim();
	        if (!keyword) {
	            e.preventDefault();
	        }
	        // 기본 condition은 'title'이라 별도 처리 필요 없음
	    });
	});

</script>

</body>
</html>