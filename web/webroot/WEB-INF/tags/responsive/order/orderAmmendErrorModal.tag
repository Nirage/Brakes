<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<components:modal id="orderAmmendErrorPopup" customCSSClass="cart-modal--lg js-cartModal">
    <p class="h-space-2">
        <span class="js-orderModalMessage hide" data-message="CUTT_OFF"><spring:theme code="text.order.delivery.cutOffTime.popup.msg"/></span>
        <span class="js-orderModalMessage hide" data-message="STATUS"><spring:theme code="text.order.delivery.status.popup.msg"/></span>
        <span class="js-orderModalMessage hide" data-message="ORDER_LOCK"><spring:theme code="text.order.delivery.orderLock.popup.msg"/></span>
        <span class="js-orderModalMessage hide" data-message="UNSUBMITTED"><spring:theme code="text.order.delivery.unsubmitted.popup.msg"/></span>
    </p>
    <div class="clearfix">
        <button class="btn btn-primary btn--full-width js-cutOffTimeOK" aria-label="Close">
            <spring:theme code="text.order.delivery.cutOffTime.popup.ok"/>
        </button>
    </div>
</components:modal>