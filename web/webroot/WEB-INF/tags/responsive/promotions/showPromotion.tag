<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="product" required="true" type="java.lang.Object" %>
<%@ attribute name="isLoggedIn" required="true" type="java.lang.String" %>

<c:if test="${cmsPage.uid ne 'myPromoProducts'}">
    <c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />
    <c:if test="${isLoggedIn}"> 
        <c:choose>
            <c:when test="${(viewPromotions && (product.hasPotentialPromo || not empty product.wasPrice))}">
                true
            </c:when>
            <c:otherwise>
                false
            </c:otherwise>
        </c:choose>
    </c:if>
    <c:if test="${!isLoggedIn}">
        <c:choose>
            <c:when test="${(product.hasPotentialPromo || not empty product.wasPrice)}">
                true
            </c:when>
            <c:otherwise>
                false
            </c:otherwise>
        </c:choose>
    </c:if>
</c:if>
<c:if test="${cmsPage.uid eq 'myPromoProducts'}">
    true
</c:if>

