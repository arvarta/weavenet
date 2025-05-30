<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>WeaveNet - 사원관리</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta name="viewport" content="width=1300">
<link href="${pageContext.request.contextPath}/css/base.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/admin_layout.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/management.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/cursor.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/css/addEmployee.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/js/menu.js"></script>
<script src="${pageContext.request.contextPath}/js/admin_header.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />

	<div id="container">
		<div class="nav_lnb">
			<jsp:include page="/WEB-INF/views/include/admin_leftMenu.jsp" />
		</div>
		<div id="section_cen">
			<h1 class="title">사원관리</h1>
			<div class="btn_web">
	            <c:if test="${sessionScope.loginAuth.name() == 'EMPLOYEE_MANAGER' || sessionScope.loginAuth.name() == 'SUPER_ADMIN'}">
	                <button type="button" class="btn_add_employee" id="btnAddEmployee">사원 추가</button>
	            </c:if>
			</div>
			<c:if test="${not empty alertMsg}">
				    <script>
				        alert('${alertMsg}');
				    </script>
				</c:if>
			<form method="get" action="${pageContext.request.contextPath}/api/admin/user" class="topSearchA">
<!-- 				<div class="selectBox"> -->
<!-- 					<input type="text" class="txtBox" value="전체 부서" readonly -->
<!-- 						data-target-select="department"> -->
<!-- 					<ul class="option"> -->
<!-- 						<li data-value="">전체부서</li> -->
<!-- 						<li data-value="개발팀">개발팀</li> -->
<!-- 						<li data-value="고객지원팀">고객지원팀</li> -->
<!-- 						<li data-value="기획팀">기획팀</li> -->
<!-- 						<li data-value="디자인팀">디자인팀</li> -->
<!-- 						<li data-value="마케팅팀">마케팅팀</li> -->
<!-- 						<li data-value="영업팀">영업팀</li> -->
<!-- 						<li data-value="운영팀">운영팀</li> -->
<!-- 						<li data-value="재무회계팀">재무회계팀</li> -->
<!-- 					</ul> -->
<!-- 					<select name="department" class="hidden-select" -->
<!-- 						style="display: none;"> -->
<!-- 						<option value="">전체부서</option> -->
<!-- 						<option value="개발팀">개발팀</option> -->
<!-- 						<option value="고객지원팀">고객지원팀</option> -->
<!-- 						<option value="기획팀">기획팀</option> -->
<!-- 						<option value="디자인팀">디자인팀</option> -->
<!-- 						<option value="마케팅팀">마케팅팀</option> -->
<!-- 						<option value="영업팀">영업팀</option> -->
<!-- 						<option value="운영팀">운영팀</option> -->
<!-- 						<option value="재무회계팀">재무회계팀</option> -->
<!-- 					</select> -->
<!-- 				</div> -->
<!-- 				<div class="selectBox"> -->
<!-- 					<input type="text" class="txtBox" value="전체 상태" readonly -->
<!-- 						data-target-select="status"> -->
<!-- 					<ul class="option"> -->
<!-- 						<li data-value="">전체상태</li> -->
<!-- 						<li data-value="APPROVED">사용가능</li> -->
<!-- 						<li data-value="INACTIVE">삭제대기</li> -->
<!-- 						<li data-value="PENDING">승인대기</li> -->
<!-- 						<li data-value="REJECTED">거절됨</li> -->
<!-- 					</ul> -->
<!-- 					<select name="status" class="hidden-select" style="display: none;"> -->
<!-- 						<option value="">전체 상태</option> -->
<!-- 						<option value="APPROVED">사용가능</option> -->
<!-- 						<option value="INACTIVE">삭제대기</option> -->
<!-- 						<option value="PENDING">승인대기</option> -->
<!-- 						<option value="REJECTED">거절됨</option> -->
<!-- 					</select> -->
<!-- 				</div> -->
<!-- 				<div class="inputBox"> -->
<!-- 					<div class="input_set"> -->
<!-- 						<input class="inpt" type="text" name="keyword" -->
<%-- 							placeholder="검색어를 입력하세요." value="${param.keyword}"> --%>
<!-- 						<div class="rt"> -->
<!-- 							<button type="reset" class="btnDel">삭제</button> -->
<!-- 						</div> -->
<!-- 						<button type="submit" class="btn_search_submit"> -->
<!-- 							<i class="blind">검색</i> -->
<!-- 						</button> -->
<!-- 					</div> -->
<!-- 				</div> -->
			</form>
			<table class="listTypeA">
				<thead>
					<tr>
						<th style="width: 25%;" class="sortable-header" data-sort-column="name">이름 / 부서<span class="sort-arrow"></span></th>
						<th style="width: 25%;" class="sortable-header" data-sort-column="status">상태<span class="sort-arrow"></span></th>
						<th style="width: 25%;" class="sortable-header" data-sort-column="roleRank">권한 / 등급<span class="sort-arrow"></span></th>
						<th style="width: 25%;">관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="dto" items="${empDtos}">
						<c:if test="${dto.uAuth != 'SUPER_ADMIN'}">
							<tr <c:if test="${dto.uStatus == 'INACTIVE'}">class="row-inactive"</c:if>>
								<td>
									<div>
                                        <a href="${pageContext.request.contextPath}/api/admin/user/detail/${dto.uNum}" class="link-user-detail" data-unum="${dto.uNum}" title="${dto.eName} 상세 보기">${dto.eName}</a>
										<div class="dept-style" style="color:#118DFF; margin-left:15px; font-size:12px;">
										${dto.deptName}
										</div>
									</div>
								</td>
								<td>
									<c:choose>
										<c:when test="${dto.uStatus == 'APPROVED'}">사용가능</c:when>
										<c:when test="${dto.uStatus == 'PENDING'}">승인대기</c:when>
										<c:when test="${dto.uStatus == 'INACTIVE'}">삭제대기</c:when>
										<c:when test="${dto.uStatus == 'REJECTED'}">거절됨</c:when>
										<c:otherwise>알 수 없음</c:otherwise>
									</c:choose>
								</td>
								<td>
									<form method="post" action="${pageContext.request.contextPath}/api/admin/user/${dto.uNum}/role" class="role-rank-form">
									    <select name="uAuth" class="hidden-select user-auth-select" style="display:none;">
                                            <c:forEach var="authName" items="${userAuthList}">
                                                <c:if test="${authName != 'SUPER_ADMIN'}">
                                                    <option value="${authName}" <c:if test="${dto.uAuth == authName}">selected</c:if>>
                                                        <c:choose>
                                                            <c:when test="${authName == 'EMPLOYEE_MANAGER'}">사원관리자</c:when>
                                                            <c:when test="${authName == 'BOARD_MANAGER'}">게시판관리자</c:when>
                                                            <c:when test="${authName == 'USER'}">일반</c:when>
                                                            <c:otherwise>${authName}</c:otherwise>
                                                        </c:choose>
                                                    </option>
                                                </c:if>
                                            </c:forEach>
									    </select>
									    <select name="uRank" class="hidden-select user-rank-select" style="display:none;">
                                            <c:forEach var="rankName" items="${userRankList}">
                                                <option value="${rankName}" <c:if test="${dto.uRank == rankName}">selected</c:if>>
                                                    <c:choose>
                                                        <c:when test="${rankName == 'GENERAL'}">일반</c:when>
                                                        <c:when test="${rankName == 'REGULAR'}">정식</c:when>
                                                        <c:when test="${rankName == 'ELITE'}">우수</c:when>
                                                        <c:when test="${rankName == 'HONOR'}">명예</c:when>
                                                        <c:otherwise>${rankName}</c:otherwise>
                                                    </c:choose>
                                                </option>
                                            </c:forEach>
									    </select>
									    <div class="role-rank-display-area">
									        <span class="current-role-rank role-rank-text-trigger" title="권한/등급 변경"
                                                  <c:if test="${dto.uStatus == 'INACTIVE'}">style="color: #BFBFBF;"</c:if>>
									            <c:set var="currentAuthText">
									                <c:choose>
									                    <c:when test="${dto.uAuth == 'EMPLOYEE_MANAGER'}">사원관리자</c:when>
									                    <c:when test="${dto.uAuth == 'BOARD_MANAGER'}">게시판관리자</c:when>
                                                        <c:when test="${dto.uAuth == 'USER'}">일반</c:when>
									                    <c:otherwise>일반</c:otherwise>
									                </c:choose>
									            </c:set>
									            <c:set var="currentRankText">
									                <c:choose>
									                    <c:when test="${dto.uRank == 'GENERAL'}">일반</c:when>
									                    <c:when test="${dto.uRank == 'REGULAR'}">정식</c:when>
									                    <c:when test="${dto.uRank == 'ELITE'}">우수</c:when>
									                    <c:when test="${dto.uRank == 'HONOR'}">명예</c:when>
									                    <c:otherwise>일반</c:otherwise>
									                </c:choose>
									            </c:set>
									            ${currentAuthText} / ${currentRankText}
									        </span>
									    </div>
									</form>
								</td>
								<td class="management-actions-cell"> 
                                    <div class="cmt_task">
                                        <button type="button" class="btn_more">&#8942;<span class="blind">메뉴 더보기</span></button>
                                        <div class="ly_context">
                                            <ul>
                                                <c:choose>
                                                    <c:when test="${dto.uStatus == 'PENDING'}">
                                                        <li>
                                                            <form method="post" action="${pageContext.request.contextPath}/api/admin/user/${dto.uNum}">
                                                                <button type="submit">승인</button>
                                                            </form>
                                                        </li>
                                                        <li>
                                                            <form method="post" action="${pageContext.request.contextPath}/api/admin/user/${dto.uNum}/rejected">
															    <button type="submit" class="action-destructive">거부</button>
															</form>
                                                        </li>
                                                    </c:when>
                                                    <c:when test="${dto.uStatus == 'APPROVED'}">
                                                        <li>
                                                            <form method="post" action="${pageContext.request.contextPath}/api/admin/user/${dto.uNum}/inactive">
                                                                <button type="submit" class="action-destructive" onclick="setTimeout(() => { location.reload(); }, 300);">삭제</button>
                                                            </form>
                                                        </li>
                                                    </c:when>
                                                    <c:when test="${dto.uStatus == 'INACTIVE'}">
                                                        <li>
                                                            <form method="post" action="${pageContext.request.contextPath}/api/admin/user/${dto.uNum}/restore">
                                                                <button type="submit">복구</button>
                                                            </form>
                                                        </li>
                                                        <li>
                                                            <form method="post" action="${pageContext.request.contextPath}/api/admin/user/${dto.uNum}/delete">
                                                                <button type="submit" class="action-destructive">영구삭제</button>
                                                            </form>
                                                        </li>
                                                    </c:when>
                                                </c:choose>
                                            </ul>
                                        </div>
                                    </div>
                                </td>
							</tr>
						</c:if>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

    <div id="roleRankModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2>권한 및 등급 선택</h2>
                <button type="button" class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="modal-select-group">
                    <label for="modalAuthSelect">권한</label>
                    <select id="modalAuthSelect">
                        <c:forEach var="auth" items="${userAuthList}">
                            <c:if test="${auth != 'SUPER_ADMIN'}">
                                <c:set var="isAuthToAssignAdminPrivilege" value="${auth == 'EMPLOYEE_MANAGER' || auth == 'BOARD_MANAGER'}" />
                                <c:set var="isLoggedInAdminNonSuperAdminManager" value="${sessionScope.loginAuth.name() == 'EMPLOYEE_MANAGER' || sessionScope.loginAuth.name() == 'BOARD_MANAGER'}" />
                                
                                <option value="${auth}" <c:if test="${isAuthToAssignAdminPrivilege && isLoggedInAdminNonSuperAdminManager}">disabled</c:if>>
                                    <c:choose>
                                        <c:when test="${auth == 'EMPLOYEE_MANAGER'}">사원관리자</c:when>
                                        <c:when test="${auth == 'BOARD_MANAGER'}">게시판관리자</c:when>
                                        <c:when test="${auth == 'USER'}">일반</c:when>
                                        <c:otherwise>${auth}</c:otherwise>
                                    </c:choose>
                                </option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                <div class="modal-select-group">
                    <label for="modalRankSelect">등급</label>
                    <select id="modalRankSelect">
                        <c:forEach var="rank" items="${userRankList}">
                            <option value="${rank}">
                                <c:choose>
                                    <c:when test="${rank == 'GENERAL'}">일반</c:when>
                                    <c:when test="${rank == 'REGULAR'}">정식</c:when>
                                    <c:when test="${rank == 'ELITE'}">우수</c:when>
                                    <c:when test="${rank == 'HONOR'}">명예</c:when>
                                    <c:otherwise>${rank}</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-confirm-selection">확인</button>
                <button type="button" class="btn-cancel-selection">취소</button>
            </div>
        </div>
    </div>

    <div id="userDetailModal" class="modal-overlay">
        <div class="modal-content user-detail-modal-content">
            <div class="modal-header">
                <h2>사원 상세 정보</h2>
                <button type="button" class="close-user-detail-modal">&times;</button>
            </div>
            <div class="modal-body" id="userDetailModalBody">
                <p>정보를 가져오는 중...</p>
            </div>
        </div>
    </div>

    <div id="addEmployeeModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2>사원 추가</h2>
                <button type="button" class="close-add-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="addEmployeeForm" method="post" action="${pageContext.request.contextPath}/api/admin/employees">
                    <div class="form-group">
                        <label for="eNum">사원번호</label>
                        <input type="text" id="eNum" name="eNum" required>
                    </div>
                    <div class="form-group">
                        <label for="eName">사원이름</label>
                        <input type="text" id="eName" name="eName" required>
                    </div>
                    <div class="form-group">
                        <label for="eEmail">이메일</label>
                        <input type="email" id="eEmail" name="eEmail" required>
                    </div>
                    <div class="form-group">
                        <label for="ePosition">직급</label>
                        <select id="ePosition" name="ePosition" required>
                            <option value="">직급 선택</option>
                            <option value="사원">사원</option>
                            <option value="대리">대리</option>
                            <option value="과장">과장</option>
                            <option value="차장">차장</option>
                            <option value="부장">부장</option>
                            <option value="사장">사장</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="eAddress">주소</label>
                        <input type="text" id="eAddress" name="eAddress" required>
                    </div>
                    <div class="form-group">
                        <label for="eJoinDate">입사일</label>
                        <input type="date" id="eJoinDate" name="eJoinDate" required>
                    </div>
                    <div class="form-group">
                        <label for="deptNum">부서</label>
                        <select id="deptNum" name="deptNum">
                            <option value="">부서 선택</option>
                            <c:forEach var="dept" items="${departmentList}">
                                <option value="${dept.deptNum}">${dept.deptName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-confirm-add">추가</button>
                <button type="button" class="btn-cancel-add">취소</button>
            </div>
        </div>
    </div>
</body>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const roleRankModal = document.getElementById('roleRankModal');
    const roleRankTriggerSpans = document.querySelectorAll('.role-rank-text-trigger');
    const closeModalBtn = roleRankModal.querySelector('.close-modal');
    const confirmSelectionBtn = roleRankModal.querySelector('.btn-confirm-selection');
    const cancelSelectionBtn = roleRankModal.querySelector('.btn-cancel-selection');
    const modalAuthSelect = roleRankModal.querySelector('#modalAuthSelect');
    const modalRankSelect = roleRankModal.querySelector('#modalRankSelect');

    let currentEditForm = null;

    roleRankTriggerSpans.forEach(span => {
        span.addEventListener('click', function() {
            const parentRow = this.closest('tr');
            if (parentRow && parentRow.classList.contains('row-inactive')) {
                return;
            }

            currentEditForm = this.closest('.role-rank-form');
            
            if (currentEditForm) {
                const userBeingEditedAuth = currentEditForm.querySelector('.user-auth-select').value;
                const userBeingEditedRank = currentEditForm.querySelector('.user-rank-select').value;
                const loggedInAdminAuth = '${sessionScope.loginAuth.name()}';

                Array.from(modalAuthSelect.options).forEach(opt => {
                    if (loggedInAdminAuth === 'SUPER_ADMIN') {
                        opt.disabled = false;
                    } else if (loggedInAdminAuth === 'EMPLOYEE_MANAGER' || loggedInAdminAuth === 'BOARD_MANAGER') {
                        if (opt.value === 'EMPLOYEE_MANAGER' || opt.value === 'BOARD_MANAGER') {
                            opt.disabled = (opt.value !== userBeingEditedAuth);
                        } else {
                            opt.disabled = false;
                        }
                    } else {
                        if (opt.value === 'USER') {
                            opt.disabled = false;
                        } else {
                            opt.disabled = true;
                        }
                    }
                });
                
                modalAuthSelect.value = userBeingEditedAuth;

                if (modalAuthSelect.selectedIndex === -1 || (modalAuthSelect.options[modalAuthSelect.selectedIndex] && modalAuthSelect.options[modalAuthSelect.selectedIndex].disabled)) {
                    let firstEnabledIndex = -1;
                    for (let i = 0; i < modalAuthSelect.options.length; i++) {
                        if (!modalAuthSelect.options[i].disabled) {
                            firstEnabledIndex = i;
                            break;
                        }
                    }
                    if (firstEnabledIndex !== -1) {
                        modalAuthSelect.selectedIndex = firstEnabledIndex;
                    } else if (modalAuthSelect.options.length > 0 && modalAuthSelect.options[0].value === 'USER' && !modalAuthSelect.options[0].disabled) {
                         modalAuthSelect.value = 'USER';
                    }
                }

                modalRankSelect.value = userBeingEditedRank;
                const displaySpan = currentEditForm.querySelector('.current-role-rank');
                if (displaySpan) {
                }
            }
            
            roleRankModal.classList.add('active');
            document.body.style.overflow = 'hidden';
        });
    });

    function closeTheRoleRankModal() {
        roleRankModal.classList.remove('active');
        document.body.style.overflow = '';
        currentEditForm = null;
    }

    if(closeModalBtn) {
        closeModalBtn.addEventListener('click', closeTheRoleRankModal);
    }
    if(cancelSelectionBtn) {
        cancelSelectionBtn.addEventListener('click', closeTheRoleRankModal);
    }

    if(confirmSelectionBtn) {
        confirmSelectionBtn.addEventListener('click', function() {
            if (currentEditForm) {
                const selectedAuth = modalAuthSelect.value;
                const selectedRank = modalRankSelect.value;

                currentEditForm.querySelector('.user-auth-select').value = selectedAuth;
                currentEditForm.querySelector('.user-rank-select').value = selectedRank;

                const selectedAuthOption = modalAuthSelect.options[modalAuthSelect.selectedIndex];
                const selectedRankOption = modalRankSelect.options[modalRankSelect.selectedIndex];

                const selectedAuthText = selectedAuthOption ? selectedAuthOption.textContent.trim() : selectedAuth;
                const selectedRankText = selectedRankOption ? selectedRankOption.textContent.trim() : selectedRank;
                
                const displaySpan = currentEditForm.querySelector('.current-role-rank');
                if (displaySpan) {
                    displaySpan.textContent = `${selectedAuthText} / ${selectedRankText}`;
                }
                
                currentEditForm.submit();
            }
            closeTheRoleRankModal();
        });
    }

    function bindCommentEvents() {
        document.querySelectorAll('.btn_more').forEach(btn => {
            const cmtTasklist = btn.nextElementSibling;
            if (!cmtTasklist || !cmtTasklist.classList.contains('ly_context')) {
                return;
            }

            btn.onclick = function(e) {
                e.stopPropagation();
                const isCurrentlyActive = cmtTasklist.classList.contains('active');
                document.querySelectorAll('.ly_context.active').forEach(ctx => {
                    if (ctx !== cmtTasklist) {
                       ctx.classList.remove('active');
                    }
                });
                cmtTasklist.classList.toggle('active');
            };
        });

        document.addEventListener('click', function (e) {
            document.querySelectorAll('.ly_context.active').forEach(ctx => {
                const parentBtnMore = ctx.previousElementSibling;
                if (!ctx.contains(e.target) && e.target !== parentBtnMore) {
                     ctx.classList.remove('active');
                }
            });
        });
    }

    bindCommentEvents();
    
    const selectBoxes = document.querySelectorAll('.selectBox');
    selectBoxes.forEach(selectBox => {
        const txtBox = selectBox.querySelector('.txtBox');
        const optionList = selectBox.querySelector('.option');
        const hiddenSelect = selectBox.querySelector('.hidden-select');
       
        if(txtBox && optionList && hiddenSelect) {
            txtBox.addEventListener('click', function(event) {
                event.stopPropagation();
                document.querySelectorAll('.selectBox.on').forEach(openSelectBox => {
                    if (openSelectBox !== selectBox) {
                        openSelectBox.classList.remove('on');
                    }
                });
                selectBox.classList.toggle('on');
            });

            optionList.querySelectorAll('li').forEach(optionItem => {
                optionItem.addEventListener('click', function(event) {
                    event.preventDefault();
                    const selectedValue = this.dataset.value;
                    const selectedText = this.textContent;
                    txtBox.value = selectedText;
                    hiddenSelect.value = selectedValue;
                    selectBox.classList.remove('on');
                });
            });

            const currentSelectedHiddenValue = hiddenSelect.value;
            let correspondingLiFound = false;
            optionList.querySelectorAll('li').forEach(li => {
                if (li.dataset.value === currentSelectedHiddenValue) {
                    txtBox.value = li.textContent;
                    correspondingLiFound = true;
                }
            });

            if (!correspondingLiFound) {
                const selectedOptionInHidden = hiddenSelect.querySelector(`option[value="${currentSelectedHiddenValue}"]`);
                if (selectedOptionInHidden) {
                     txtBox.value = selectedOptionInHidden.textContent;
                } else if (optionList.querySelector('li[data-value=""]')) {
                     txtBox.value = optionList.querySelector('li[data-value=""]').textContent;
                } else if (optionList.firstChild) {
                    txtBox.value = optionList.firstChild.textContent;
                } else {
                     txtBox.value = "선택";
                }
            }
        }
    });
    document.addEventListener('click', function(event) {
        const openSelectBoxes = document.querySelectorAll('.selectBox.on');
        openSelectBoxes.forEach(selectBox => {
            if (!selectBox.contains(event.target)) {
                selectBox.classList.remove('on');
            }
        });
    });

    const searchInput = document.querySelector('.inputBox .inpt');
    const btnDel = document.querySelector('.inputBox .btnDel');
    if (searchInput && btnDel) {
        searchInput.addEventListener('input', function() {
            btnDel.style.display = this.value.length > 0 ? 'block' : 'none';
        });
        btnDel.addEventListener('click', function() {
            searchInput.value = '';
            this.style.display = 'none';
            searchInput.focus();
        });
        btnDel.style.display = searchInput.value.length > 0 ? 'block' : 'none';
    }

    const userDetailModal = document.getElementById('userDetailModal');
    const userDetailModalBody = document.getElementById('userDetailModalBody');
    const closeUserDetailModalBtn = userDetailModal.querySelector('.close-user-detail-modal');

    document.querySelectorAll('.link-user-detail').forEach(link => {
        link.addEventListener('click', function(event) {
            event.preventDefault();
           
            const userNum = this.dataset.unum;
            if (!userNum) {
                console.error('uNum을 담은 userNum으로 링크를 찾을 수 없음.');
                return;
            }

            userDetailModalBody.innerHTML = '<p>정보를 가져오는 중...</p>';
            userDetailModal.classList.add('active');
            document.body.style.overflow = 'hidden';

            const detailUrl = '${pageContext.request.contextPath}/api/admin/user/detail/' + userNum;

            fetch(detailUrl)
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error ${response.status}`);
                    }
                    return response.text();
                })
                .then(html => {
                    userDetailModalBody.innerHTML = html;
                })
                .catch(error => {
                	userDetailModalBody.style.color = 'grey';
                    console.error('Error [유저 정보 동기화 오류]:', error);
                    userDetailModalBody.innerHTML = `<p>오류: ${error.message}. 사원정보를 불러오는데 실패했습니다.</p>`;
                });
        });
    });

    function closeUserDetailMdl() {
        userDetailModal.classList.remove('active');
        document.body.style.overflow = '';
        userDetailModalBody.innerHTML = '';
    }

    if(closeUserDetailModalBtn) {
        closeUserDetailModalBtn.addEventListener('click', closeUserDetailMdl);
    }

    userDetailModal.addEventListener('click', function(event) {
        if (event.target === userDetailModal) {
            closeUserDetailMdl();
        }
    });

    let sortDirections = {
        name: 'asc',
        status: 'asc',
        roleRank: 'asc'
    };

    document.querySelectorAll('table.listTypeA thead th.sortable-header').forEach(header => {
        header.addEventListener('click', function() {
            const column = this.dataset.sortColumn;
            const direction = sortDirections[column];
            const tableBody = this.closest('table').querySelector('tbody');
            const rows = Array.from(tableBody.querySelectorAll('tr'));
            const currentArrowSpan = this.querySelector('.sort-arrow');

            rows.sort((rowA, rowB) => {
                let valA, valB;

                if (column === 'name') {
                    valA = rowA.querySelector('td:first-child a.link-user-detail').textContent.trim();
                    valB = rowB.querySelector('td:first-child a.link-user-detail').textContent.trim();
                } else if (column === 'status') {
                    valA = rowA.querySelectorAll('td')[1].textContent.trim();
                    valB = rowB.querySelectorAll('td')[1].textContent.trim();
                } else if (column === 'roleRank') {
                    valA = rowA.querySelector('td:nth-child(3) span.current-role-rank').textContent.trim();
                    valB = rowB.querySelector('td:nth-child(3) span.current-role-rank').textContent.trim();
                }
				
                let comparison = 0;
                if (valA !== undefined && valB !== undefined) {
                    comparison = String(valA).localeCompare(String(valB), 'ko-KR');
                }
                return direction === 'asc' ? comparison : -comparison;
            });

            sortDirections[column] = direction === 'asc' ? 'desc' : 'asc';
            
            document.querySelectorAll('th.sortable-header .sort-arrow').forEach(arrow => {
                if (arrow !== currentArrowSpan) {
                    arrow.innerHTML = '';
                }
            });
            currentArrowSpan.innerHTML = direction === 'asc' ? ' &#9660;' : ' &#9650;';

            rows.forEach(row => tableBody.appendChild(row));
        });
    });

    const addEmployeeModal = document.getElementById('addEmployeeModal');
    const btnAddEmployee = document.getElementById('btnAddEmployee');
    const closeAddModalBtn = addEmployeeModal.querySelector('.close-add-modal');
    const confirmAddBtn = addEmployeeModal.querySelector('.btn-confirm-add');
    const cancelAddBtn = addEmployeeModal.querySelector('.btn-cancel-add');
    const addEmployeeForm = document.getElementById('addEmployeeForm');
    const deptNumSelect = document.getElementById('deptNum');
    const ePositionSelect = document.getElementById('ePosition'); // ePosition select 박스 참조 추가

    if (btnAddEmployee) {
        btnAddEmployee.addEventListener('click', function() {
            addEmployeeModal.classList.add('active');
            document.body.style.overflow = 'hidden';
            addEmployeeForm.reset();
            // 직책 (ePosition) 초기화 (첫 옵션 '직책 선택')
            ePositionSelect.value = ''; 
            // 입사일 기본값을 오늘 날짜로 설정
            const today = new Date();
            const year = today.getFullYear();
            const month = (today.getMonth() + 1).toString().padStart(2, '0');
            const day = today.getDate().toString().padStart(2, '0');
            document.getElementById('eJoinDate').value = `${year}-${month}-${day}`;

            fetch('${pageContext.request.contextPath}/api/admin/departments')
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error ${response.status}`);
                    }
                    return response.json();
                })
                .then(data => {
                    deptNumSelect.innerHTML = '<option value="">부서 선택</option>';
                    data.forEach(dept => {
                        const option = document.createElement('option');
                        option.value = dept.deptNum;
                        option.textContent = dept.deptName;
                        deptNumSelect.appendChild(option);
                    });
                    updateDeptSelectState(); // 부서 목록 로드 후 직책에 따라 상태 업데이트
                })
                .catch(error => {
                    console.error('Error fetching departments:', error);
                    deptNumSelect.innerHTML = '<option value="">부서 목록을 불러올 수 없습니다.</option>';
                    deptNumSelect.disabled = true;
                });
        });
    }

    function closeAddEmployeeModal() {
        addEmployeeModal.classList.remove('active');
        document.body.style.overflow = '';
        deptNumSelect.innerHTML = '<option value="">부서 선택</option>';
        deptNumSelect.disabled = false;
        // ePositionSelect.value = ''; // 직책 선택 초기화는 모달 열릴 때 reset()으로 처리됨
    }

    if (closeAddModalBtn) {
        closeAddModalBtn.addEventListener('click', closeAddEmployeeModal);
    }
    if (cancelAddBtn) {
        cancelAddBtn.addEventListener('click', closeAddEmployeeModal);
    }
    addEmployeeModal.addEventListener('click', function(event) {
        if (event.target === addEmployeeModal) {
            closeAddEmployeeModal();
        }
    });

    if (ePositionSelect) {
        ePositionSelect.addEventListener('change', updateDeptSelectState);
    }

    function updateDeptSelectState() {
        if (ePositionSelect.value === '사장') {
            deptNumSelect.value = '';
            deptNumSelect.disabled = true;
            deptNumSelect.removeAttribute('required');
            deptNumSelect.style.borderColor = '';
        } else {
            deptNumSelect.disabled = false;
            deptNumSelect.setAttribute('required', 'required');
            if (deptNumSelect.value === '') {
                deptNumSelect.style.borderColor = 'red';
            } else {
                deptNumSelect.style.borderColor = '';
            }
        }
    }


    if (confirmAddBtn) {
        confirmAddBtn.addEventListener('click', function() {
            const manualRequiredFields = [
                document.getElementById('eNum'),
                document.getElementById('eName'),
                document.getElementById('eEmail'),
                document.getElementById('eAddress'),
                document.getElementById('eJoinDate')
            ];
            let allFieldsFilled = true;
            manualRequiredFields.forEach(field => {
                if (!field.value.trim()) {
                    allFieldsFilled = false;
                    field.style.borderColor = 'red';
                } else {
                    field.style.borderColor = '';
                }
            });
            
            // 직책 (ePosition) 유효성 검사 (필수)
            if (ePositionSelect.value === '') {
                allFieldsFilled = false;
                ePositionSelect.style.borderColor = 'red';
            } else {
                ePositionSelect.style.borderColor = '';
            }

            // 부서 선택 유효성 검사 (사장일 때는 검사하지 않음)
            if (ePositionSelect.value !== '사장' && deptNumSelect.value === '') {
                allFieldsFilled = false;
                deptNumSelect.style.borderColor = 'red';
            } else {
                deptNumSelect.style.borderColor = '';
            }
            
            if (!allFieldsFilled) {
                alert('모든 필수 필드를 입력해주세요.');
                return;
            }

            addEmployeeForm.submit();
        });
    }
});
</script>
</html>