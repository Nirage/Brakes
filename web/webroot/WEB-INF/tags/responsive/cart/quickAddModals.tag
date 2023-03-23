<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<c:set var="title" value="quickadd.modal.updateqty.title" />
<components:modal id="quickAddUpdateReplaceQtyModal" title="${title}" customCSSClass="cart-modal cart-modal--lg">
    <p class="h-space-2">
        <spring:theme code="cart.quantity.popup.addreplace"/>
    </p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-4">
            <button tabindex="0" class="btn btn-secondary js-quickAddCancel" data-dismiss="modal" aria-label="Close">
            <spring:theme code="quickadd.modal.updateqty.cancel"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button tabindex="0" type="button" class="btn btn-primary js-quickAddUpdate" data-dismiss="modal" aria-label="Close">
                <spring:theme code="quickadd.modal.updateqty.update"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button tabindex="0" class="btn btn-primary js-quickAddReplace" data-dismiss="modal" aria-label="Close">
            <spring:theme code="quickadd.modal.updateqty.replace"/>
            </button>
        </div>
        
    </div>
</components:modal>

<components:modal id="quickAddUpdateQtyModal" title="${title}" customCSSClass="cart-modal">
    <p class="h-space-2">
        <spring:theme code="cart.quantity.popup.add"/>
    </p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-6">
        <button tabindex="0" class="btn btn-secondary js-quickAddCancel" data-dismiss="modal" aria-label="Close">
           <spring:theme code="quickadd.modal.updateqty.cancel"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-6">
        <button tabindex="0" type="button" class="btn btn-primary js-quickAddUpdate" data-dismiss="modal" aria-label="Close">
            <spring:theme code="quickadd.modal.updateqty.update"/>
        </button>
        </div>
    </div>
</components:modal>

<c:set var="title" value="cart.quantity.popup.large.title" />
<components:modal id="quantityLargePopupQuickAdd" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.large.msg"/></p>
    <div class="clearfix">
        <button tabindex="0" class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        <button tabindex="0" class="btn btn-primary cart-modal__btn-right js-largeQtyPopupAdd" type="button" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.add"/>
        </button>
    </div>
</components:modal>

<c:set var="title" value="cart.quantity.popup.large.title" />
<components:modal id="quantityLargePopupReplaceQuickAdd" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2"><spring:theme code="cart.quantity.popup.largeaddreplace.msg"/></p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-4">
        <button tabindex="0" class="btn btn-secondary js-largeQtyPopupCancel" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.cancel"/>
        </button>
        </div>

        <div class="col-xs-12 col-sm-4">
        <button tabindex="0" class="btn btn-primary js-quickAddUpdate" type="button" data-dismiss="modal" aria-label="Close">
            <spring:theme code="cart.quantity.popup.large.add"/>
        </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button tabindex="0" type="button" class="btn btn-primary js-quickAddReplace">
                <spring:theme code="cart.quantity.popup.add.replace"/>
            </button>
        </div>
    </div>
</components:modal>