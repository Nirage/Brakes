<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ attribute name="cancelOrderSubmitUrl" required="true" type="java.lang.String"%>

<c:set var="title" value="order.cancel.confirm.modal.title" />
<components:modal id="cancelOrderConfirmModal" title="${title}" customCSSClass="cart-modal">
    <p class="h-space-2"><spring:theme code="order.cancel.confirm.modal.body"/></p>
    <div class="clearfix">       
        <button class="btn btn-primary cart-modal__btn-left js-cancelOrderConfirm" type="button" data-submit-url="${cancelOrderSubmitUrl}">
            <spring:theme code="order.cancel.confirm.modal.confirmCTA"/>
        </button>
        <button class="btn btn-secondary cart-modal__btn-right" type="button" data-dismiss="modal" aria-label="Close">
            <spring:theme code="order.cancel.confirm.modal.declineCTA"/>
        </button>
    </div>
</components:modal>