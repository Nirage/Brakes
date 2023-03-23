<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:url value="/cart/clearCartItems" var="actionUrl" />
<c:set var="title" value="basket.page.clearitems" />
<components:modal id="clearCartItems" title="${title}" customCSSClass="cart-modal">
    <p class="h-space-2"><spring:theme code="basket.page.clearitems.question"/></p>
    <form:form id="clearCartItemsPost" action="${actionUrl}" method="post" class="clearfix js-clearCartItemsForm">
        <button type="button" class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
            <spring:theme code="basket.page.clearitems.cancel"/>
        </button>
        <button tabindex="0" type="submit" class="btn btn-primary cart-modal__btn-right cart-modal__btn--icon">
            <span class="icon icon-close"></span>
            <spring:theme code="basket.page.clearitems.confirm"/>
        </button>
    </form:form>
</components:modal>