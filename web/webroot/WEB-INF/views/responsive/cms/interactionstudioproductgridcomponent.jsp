<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedIn" value="true" />
</sec:authorize>

<c:if test="${isLoggedIn}">
    <product:productListerItemIS title="${title}" subTitle="${subTitle}" maxNumberOfProducts="${maxNumberOfProducts}" notPlp="true" />
</c:if>