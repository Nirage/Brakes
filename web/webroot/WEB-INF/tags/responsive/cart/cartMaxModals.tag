<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<c:set var="title" value="cart.quantity.popup.maximum.title" />
<components:modal id="quantityMaximumPopup" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.maximum.msg"/></p>
    <div class="clearfix">
        <button tabindex="0" class="btn btn-primary btn--full-width" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.maximum.ok"/>
        </button>
    </div>
</components:modal>