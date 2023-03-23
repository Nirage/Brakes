<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<%@ attribute name="msgCode" required="false" type="java.lang.String" %>

<c:set var="title" value="quickadd.modal.updateqty.title" />
<components:modal id="orderQuickAddUpdateQtyModal" title="${title}" customCSSClass="cart-modal js-cartModal">
    <p class="h-space-2">
        <spring:theme code="order.page.add.question"/>
    </p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-6">
            <button class="btn btn-secondary js-quickAddCancel" data-dismiss="modal" aria-label="Close">
            <spring:theme code="quickadd.modal.updateqty.cancel"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-6">
            <button type="button" class="btn btn-primary js-quickAddUpdate" data-dismiss="modal" aria-label="Close">
                <spring:theme code="quickadd.modal.updateqty.update"/>
            </button>
        </div>
    </div>
</components:modal>
<c:set var="title" value="quickadd.modal.updateqty.title" />
<components:modal id="orderQuickAddUpdateReplaceQtyModal" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
    <p class="h-space-2">
        <spring:theme code="order.page.clearitems.question"/>
    </p>
    <div class="row clearfix">
        <div class="col-xs-12 col-sm-4">
            <button class="btn btn-secondary js-quickAddCancel" data-dismiss="modal" aria-label="Close">
            <spring:theme code="quickadd.modal.updateqty.cancel"/>
            </button>
        </div>
        
        <div class="col-xs-12 col-sm-4">
            <button type="button" class="btn btn-primary js-quickAddUpdate" data-dismiss="modal" aria-label="Close">
                <spring:theme code="quickadd.modal.updateqty.update"/>
            </button>
        </div>
        <div class="col-xs-12 col-sm-4">
            <button class="btn btn-primary js-quickAddReplace" data-dismiss="modal" aria-label="Close">
            <spring:theme code="quickadd.modal.updateqty.replace"/>
            </button>
        </div>
    </div>
</components:modal>