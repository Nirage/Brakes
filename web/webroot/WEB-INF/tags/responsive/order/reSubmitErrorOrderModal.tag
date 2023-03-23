<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="order.reSubmit.error.modal.title" />
<components:modal id="reSubmitErrorOrderModal" title="${title}" customCSSClass="cart-modal">
    <p class="h-space-2"><spring:theme code="order.resubmit.error.body"/></p>
    <div class="clearfix">       
        <button type="button" class="btn btn-primary" data-dismiss="modal" aria-label="Close">
            <spring:theme code="order.resubmit.button.error.sucess"/>
        </button>
    </div>
</components:modal>