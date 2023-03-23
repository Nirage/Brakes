<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>


<c:set var="title" value="cart.quantity.popup.large.title" />
<components:modal id="quantityLargePopupPlp" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.large.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-6  cart__popup--top2">
        <button tabindex="0" class="btn btn-secondary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-6  cart__popup--top2">
        <button tabindex="0" class="btn btn-primary" type="button" id="replaceQuantity" name="replaceQuantity">
            <spring:theme code="cart.quantity.popup.large.confirm"/>
        </button>
        </div>
    </div>
</components:modal>
<components:modal id="quantityLargePopup" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.largeaddreplace.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-4  cart__popup--top2">
        <button tabindex="0" class="btn btn-secondary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-4  cart__popup--top2">
        <button tabindex="0" class="btn btn-primary" type="button" id="addToQuantity" name="addToQuantity">
            <spring:theme code="cart.quantity.popup.large.add"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-4  cart__popup--top2">
            <button tabindex="0" type="button" class="btn btn-primary" id="replaceQuantity">
                <spring:theme code="cart.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>
<c:set var="title" value="cart.quantity.popup.large.title" />
<components:modal id="quantityLargeReplacePopup" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.largereplace.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-6">
        <button tabindex="0" class="btn btn-secondary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-6">
            <button tabindex="0" type="button" class="btn btn-primary" id="replaceQuantity">
                <spring:theme code="cart.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>

<c:set var="title" value="cart.quantity.popup.large.title" />
<components:modal id="quantityLargePopupCart" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.largeaddreplace.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-4">
        <button class="btn btn-secondary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-4">
        <button class="btn btn-primary" type="button" id="addToQuantityCart" name="addToQuantityCart">
            <spring:theme code="cart.quantity.popup.large.add"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button type="button" class="btn btn-primary" id="replaceQuantityCart" name="replaceQuantityCart">
                <spring:theme code="cart.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>

<c:set var="title" value="cart.quantity.popup.large.title" />
<components:modal id="quantityLargePopupCartReplace" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.largereplace.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-6">
        <button tabindex="0" class="btn btn-secondary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-6">
            <button tabindex="0" type="button" class="btn btn-primary" id="replaceQuantityCart" name="replaceQuantityCart">
                <spring:theme code="cart.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>

