<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="promo.remove.item.popup.title" />
<components:modal id="promoQuantityZeroModal" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="promo.remove.item.popup.msg"/></p>
    <div class="clearfix">
        <button class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
            <spring:theme code="promo.popup.cancel"/>
        </button>
        <button class="btn btn-primary cart-modal__btn-right cart-modal__btn--icon btn-red" type="button" id="confirmZeroQuantity" name="confirmZeroQuantity">
            <span class="icon icon-trash"></span>
            <spring:theme code="promo.remove.item.popup.remove"/>
        </button>
    </div>
</components:modal>