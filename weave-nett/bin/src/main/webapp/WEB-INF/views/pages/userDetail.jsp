<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:if test="${not empty empDto}">
    <div class="modal-user-name-header">
        <h4>${fn:escapeXml(empDto.eName)}님의 상세 정보</h4>
        <hr>
    </div>

    <c:choose>
        <c:when test="${empDto.uStatus == 'PENDING' || empDto.uStatus == 'APPROVED'}">
            <div class="user-detail-actual-data">
                <table class="user-info-table" style="width: 100%; border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <th style="width: 30%; text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">사원 번호</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">${fn:escapeXml(empDto.eNum)}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">이름</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">${fn:escapeXml(empDto.eName)}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">이메일</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">${fn:escapeXml(empDto.eEmail)}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">부서</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">${fn:escapeXml(empDto.deptName)}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">직급</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">${fn:escapeXml(empDto.ePosition)}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">직책</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">${fn:escapeXml(empDto.eGrade)}</td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">현재 권한</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">
                                <c:choose>
                                    <c:when test="${empDto.uAuth == 'EMPLOYEE_MANAGER'}">사원관리자</c:when>
                                    <c:when test="${empDto.uAuth == 'BOARD_MANAGER'}">게시판관리자</c:when>
                                    <c:when test="${empDto.uAuth == 'USER'}">일반</c:when>
                                    <c:otherwise>${fn:escapeXml(empDto.uAuth)} (N/A 또는 알수없음)</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">현재 등급</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">
                                <c:choose>
                                    <c:when test="${empDto.uRank == 'GENERAL'}">일반</c:when>
                                    <c:when test="${empDto.uRank == 'REGULAR'}">정식</c:when>
                                    <c:when test="${empDto.uRank == 'ELITE'}">우수</c:when>
                                    <c:when test="${empDto.uRank == 'HONOR'}">명예</c:when>
                                    <c:otherwise>${fn:escapeXml(empDto.uRank)} (N/A 또는 알수없음)</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">입사일</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">
                                <c:if test="${not empty empDto.eJoinDateAsDate}">
                                    <fmt:formatDate value="${empDto.eJoinDateAsDate}" pattern="yyyy-MM-dd" />
                                </c:if>
                                <c:if test="${empty empDto.eJoinDateAsDate}">
                                    (입사일 정보 없음)
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: left; padding: 8px; border-bottom: 1px solid #eee; background-color: #f9f9f9;">주소</th>
                            <td style="text-align: left; padding: 8px; border-bottom: 1px solid #eee;">${fn:escapeXml(empDto.eAddress)}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="user-detail-message-section">
                <p class="status-message">
                    현재 사용자의 상태(<c:set var="statusText">${empDto.uStatus}</c:set><c:choose><c:when test="${statusText == 'INACTIVE'}">삭제대기</c:when>
                    <c:when test="${statusText == 'REJECTED'}">거절됨</c:when>
                    <c:otherwise>${statusText}</c:otherwise>
                    </c:choose>)에서는 상세 정보를 조회할 수 없습니다.
                </p>
                <p class="additional-info">
                    <c:choose>
                        <c:when test="${empDto.uStatus == 'INACTIVE'}">
                            이 사용자는 현재 삭제 대기 상태입니다.
                        </c:when>
                        <c:when test="${empDto.uStatus == 'REJECTED'}">
                            이 사용자의 등록 요청은 거절되었습니다.
                        </c:when>
                        <c:otherwise>
                            관리자에게 문의하세요.
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </c:otherwise>
    </c:choose>
</c:if>
<c:if test="${empty empDto and not empty error}"> 
    <div class="user-detail-message-section">
        <p class="error-message">${fn:escapeXml(error)}</p>
    </div>
</c:if>
<c:if test="${empty empDto and empty error}"> 
    <div class="user-detail-message-section">
        <p class="info-message">사용자 정보를 불러올 수 없습니다.</p>
    </div>
</c:if>