<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<%-- Add quantity modal --%>
<c:set var="title" value="cart.quantity.popup.add.title" />
<components:modal id="quantityCartModal" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.addreplace"/></p>
    <form:form id="quantityCartPost" action="${actionUrl}" method="post" class="clearfix row">
        <div class="col-xs-12 col-sm-4">
            <button tabindex="0" type="button" class="btn btn-primary" id="addToQuantity" name="addToQuantity">
                <spring:theme code="cart.quantity.popup.add.to"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button tabindex="0" type="button" class="btn btn-primary" id="replaceQuantity" name="replaceQuantity">
                <spring:theme code="cart.quantity.popup.add.replace"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button tabindex="0" class="btn btn-secondary btn--full-width" data-dismiss="modal" aria-label="Close">
                <spring:theme code="basket.page.clearitems.cancel"/>
            </button>
        </div>
    </form:form>
</components:modal>

<cart:cartZeroModals />
<cart:cartLargeModals />
<cart:cartMaxModals />
<cart:deleteCartModal />
<cart:clearCartItemsModal />
<cart:quickAddModals />
<cart:cartProductUnavailable />