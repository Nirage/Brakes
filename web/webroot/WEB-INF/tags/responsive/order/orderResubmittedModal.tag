<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="order.resubmitted.popup.title" />
<components:modal id="orderResubmittedPopup" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="order.resubmitted.popup.success.msg"/></p>
    <div class="clearfix">
        <button class="btn btn-primary btn--full-width" data-dismiss="modal" aria-label="Close">
            <spring:theme code="text.order.delivery.cutOffTime.popup.ok"/>
        </button>
    </div>
</components:modal>