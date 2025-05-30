<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WeaveNet - 관리자 메인</title>
    <link href="${pageContext.request.contextPath}/css/adminInfo.css" rel="stylesheet" type="text/css">
</head>
<body>

    <p class="welcome-msg">
        <strong>${adminName != null ? adminName : '관리자'}</strong> <span>님, 반갑습니다</span>
    </p>

    <hr>

    <c:choose>
        <c:when test="${not empty dashboardData}">
            <div class="dashboard-section">
                <div class="status-box">
                    <h3>사원 현황 <span class="count">${dashboardData.totalEmployees}</span></h3>
                    <table class="status-table">
                        <tr>
                            <td>사용가능</td>
                            <td>${dashboardData.activeEmployees}</td>
                        </tr>
                        <tr>
                            <td>승인대기</td>
                            <td>${dashboardData.pendingEmployees}</td>
                        </tr>
                        <tr>
                            <td>삭제대기</td>
                            <td>${dashboardData.inactiveEmployees}</td>
                        </tr>
                        <tr>
                            <td>삭제</td>
                            <td>0</td>
                        </tr>
                    </table>
                </div>

                <div class="status-box">
                    <h3>게시글 현황</h3>
                    <table class="status-table">
                        <tr>
                            <td>오늘의 게시글</td>
                            <td>${dashboardData.todayPosts}</td>
                        </tr>
                        <tr>
                            <td>오늘의 댓글</td>
                            <td>${dashboardData.todayComments}</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td> 
                            <td></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td> 
                            <td></td>
                        </tr>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <p>대시보드 데이터를 불러올 수 없습니다.</p>
        </c:otherwise>
    </c:choose>

    <hr>

    <div class="role-section">
        <h2>관리자 역할 소개</h2>
        <table class="role-table">
            <tr>
                <td>총관리자</td>
                <td>전체 관리 권한을 제어하고, 시스템 내 관리자 권한을 직접 부여·회수하는 최상위 관리자입니다.</td>
            </tr>
            <tr>
                <td>사원 관리자</td>
                <td>사원 가입 승인부터 삭제, 역할 등급 조정, 활동관리까지 담당하는 사용자 전담 관리자입니다.</td>
            </tr>
            <tr>
                <td>게시판 관리자</td>
                <td>게시판, 게시글, 댓글 전반의 생성·수정·삭제 및 공지사항까지 모두 관리하는 콘텐츠 관리자입니다.</td>
            </tr>
        </table>
    </div>

</body>
</html>