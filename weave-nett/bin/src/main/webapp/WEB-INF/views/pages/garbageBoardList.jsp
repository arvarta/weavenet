<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>휴지통 - 게시판</title>
</head>
<body>
    <form>
        <table class="listTypeA">
            <thead>
                <tr>
                    <th scope="col">게시판</th>
                    <th scope="col">삭제사유</th>
                    <th scope="col">삭제일자</th>
                    <th scope="col" id="buttonTd"></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${ empty deletedItems }">
                        <tr>
                            <td colspan="4">
                                <div class="nodata img">
                                    <p class="board_no">
                                        <b>삭제된 게시판이 없습니다.</b>
                                    </p> 
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="di" items="${ deletedItems }">
						    <tr>
						        <td>${ di.boardName }</td>
						        <td>${ di.deletedReason }</td>
						        <td class="date">${ di.formattedDate }</td>
						        <td></td>
						    </tr>
						</c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </form>
</body>
</html>
