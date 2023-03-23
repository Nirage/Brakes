<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags"%>
<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/sign-in" var="loginUrl"/>
<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedOut" value="true" />
</sec:authorize>

<c:url value="${url}" var="favUrl"/>
<spring:url value="${favUrl}/${productCode}" var="addToFavUrl" htmlEscape="false">
    <spring:param name="productCode"  value="${productCode}"/>
</spring:url>