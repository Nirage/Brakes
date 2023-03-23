<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${showCreateNewBasket}">
<spring:url value="/cart/save" var="actionUrl" htmlEscape="false"/>
    <a tabindex="0" href="${actionUrl}" class="btn btn-secondary btn--full-width h-space-2 cart__save-link js-cartSave">
        <span class="icon icon-plus"></span>
        <spring:theme code="basket.save.cart" />
    </a>
</c:if>

