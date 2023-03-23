<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="basket.page.deletebasket" />
<components:modal id="deleteCurrentCartAndRestore" title="${title}" customCSSClass="cart-modal">
    <c:url value="/cart/deleteCartAndRestore" var="actionUrl" />
    <p class="h-space-2"><spring:theme code="basket.page.deletebasket.question"/></p>
    <form:form id="deleteCurrentCartAndRestorePost" action="${actionUrl}" method="post" class="clearfix js-deleteCurrentCartAndRestoreForm">
        <button tabindex="0" type="button" class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
            <spring:theme code="basket.page.deletebasket.cancel"/>
        </button>
        <button tabindex="0" type="submit" class="btn btn-primary cart-modal__btn-right cart-modal__btn--icon">
            <span class="icon icon-trash"></span>
            <spring:theme code="basket.page.deletebasket.confirm"/>
        </button> 
    </form:form>
    
</components:modal>
