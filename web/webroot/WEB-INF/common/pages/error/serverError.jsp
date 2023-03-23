<%@ page trimDirectiveWhitespaces="true"%>
<%@ page session="false"%>
<%@ page isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:choose>
    <c:when test="${fn:containsIgnoreCase(pageContext.request.serverName, 'brake.co.uk')}">
        <%@ include file="serverError-brakes.jsp" %>
    </c:when>
    <c:when test="${fn:containsIgnoreCase(pageContext.request.serverName, 'countrychoice.co.uk')}">
        <%@ include file="serverError-countrychoice.jsp" %>
    </c:when>
    <c:otherwise>
<!DOCTYPE html>
<html>
<head>
<title>Server Error</title>
</head>
<body>
    <c:set var="exception" value="${requestScope['javax.servlet.error.exception']}" />
    <p>${exception.message}</p>
    <pre>${pageContext.out.flush();exception.printStackTrace(pageContext.response.writer)}</pre>
    <table>
        <c:forEach items="${requestScope}" var="item">
            <c:if test="${fn:startsWith(item.key, 'javax.servlet.error')}">
            <tr>
                <td>${item.key}</td>
                <td>${item.value}</td>
            </tr>
            </c:if>
        </c:forEach>
    </table>
    <p>${requestScope['org.springframework.web.servlet.DispatcherServlet.EXCEPTION']}</p>
</body>
</html>
    </c:otherwise>
</c:choose>