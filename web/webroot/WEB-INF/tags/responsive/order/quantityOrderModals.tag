<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<%-- Add quantity modal --%>
<c:set var="title" value="order.quantity.popup.add.title" />
<components:modal id="quantityOrderModal" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="order.quantity.popup.add"/></p>
    <form:form id="quantityCartPost" action="${actionUrl}" method="post" class="clearfix row">
        <div class="col-xs-12 col-sm-4 col-sm-push-4 cart-modal__btn--mb">
            <button type="button" class="btn btn-primary" id="addToQuantity" name="addToQuantity">
                <spring:theme code="order.quantity.popup.add.to"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4 col-sm-push-4 cart-modal__btn--mb">
            <button type="button" class="btn btn-primary" id="replaceQuantity" name="replaceQuantity">
                <spring:theme code="order.quantity.popup.add.replace"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4 col-sm-pull-8">
            <button class="btn btn-secondary btn--full-width" data-dismiss="modal" aria-label="Close">
                <spring:theme code="basket.page.clearitems.cancel"/>
            </button>
        </div>
    </form:form>
</components:modal>

<c:set var="title" value="order.quantity.popup.zero.title" />
<components:modal id="orderQuantityZeroModal" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="order.quantity.popup.zero.msg"/></p>
    <div class="clearfix">
        <button class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
            <spring:theme code="basket.page.deletebasket.cancel"/>
        </button>
        <button class="btn btn-primary cart-modal__btn-right cart-modal__btn--icon" type="button" id="confirmZeroQuantity" name="confirmZeroQuantiry">
            <span class="icon icon-trash"></span>
            <spring:theme code="order.quantity.popup.zero.delete"/>
        </button>
    </div>
</components:modal>

<c:set var="title" value="order.quantity.popup.large.title" />
<components:modal id="orderQuantityLargePopup" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="order.quantity.popup.largeaddreplace.msg"/></p>
    <div class="clearfix">
        <div class="col-xs-12 col-sm-4">
        <button class="btn btn-secondary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="basket.page.deletebasket.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button class="btn btn-primary" type="button" id="addToQuantityCart">
                <spring:theme code="order.quantity.popup.large.add"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button type="button" class="btn btn-primary" id="replaceQuantityCart" name="replaceQuantityCart">
                <spring:theme code="order.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>

<c:set var="title" value="cart.quantity.popup.large.title" />
<components:modal id="orderQuantityLargePopupReplace" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="order.quantity.popup.largereplace.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-6">
        <button class="btn btn-secondary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-6">
            <button type="button" class="btn btn-primary" id="replaceQuantityCart" name="replaceQuantityCart">
                <spring:theme code="cart.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>


<c:set var="title" value="order.quantity.popup.maximum.title" />
<components:modal id="orderQuantityMaximumPopup" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="order.quantity.popup.maximum.msg"/></p>
    <div class="clearfix">
        <button class="btn btn-primary btn--full-width" data-dismiss="modal" aria-label="Close">
            <spring:theme code="order.quantity.popup.maximum.ok"/>
        </button>
    </div>
</components:modal>

<c:set var="title" value="order.quantity.popup.large.title" />
<components:modal id="orderQuantityLargePopupQuickAdd" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="order.quantity.popup.large.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-6">
        <button class="btn btn-secondary js-largeQtyPopupCancel" data-dismiss="modal" aria-label="Close">
            <spring:theme code="basket.page.deletebasket.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-6">
            <button class="btn btn-primary js-largeQtyPopupAdd" type="button">
                <spring:theme code="order.quantity.popup.large.add"/>
            </button>
        </div>
    </div>
</components:modal>

<c:set var="title" value="order.quantity.popup.large.title" />
<components:modal id="orderQuantityLargeReplacePopupQuickAdd" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="order.quantity.popup.largereplace.msg"/></p>
    <div class="clearfix">
        <div class="col-xs-12 col-sm-4 p-0">
            <button class="btn btn-secondary js-largeQtyPopupCancel" data-dismiss="modal" aria-label="Close">
                <spring:theme code="basket.page.deletebasket.cancel"/>
            </button>
        </div>
        
        <div class="col-xs-12 col-sm-4">
            <button class="btn btn-primary js-quickAddUpdate" type="button">
                <spring:theme code="order.quantity.popup.large.add"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4 p-0">
            <button type="button" class="btn btn-primary js-quickAddReplace">
                <spring:theme code="order.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>