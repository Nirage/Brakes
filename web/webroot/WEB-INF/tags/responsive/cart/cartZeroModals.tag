<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="cart.quantity.popup.zero.title" />
<components:modal id="quantityZeroModal" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.zero.msg"/></p>
    <div class="clearfix">
        <button class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
            <spring:theme code="basket.page.deletebasket.cancel"/>
        </button>
        <button tabindex="0" class="btn btn-primary cart-modal__btn-right cart-modal__btn--icon" type="button" id="confirmZeroQuantity" name="confirmZeroQuantity">
            <span class="icon icon-trash"></span>
            <spring:theme code="cart.quantity.popup.zero.delete"/>
        </button>
    </div>
</components:modal>