<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="wishlist.addToCartFailed.modal.title" />
<components:modal id="wishlistToCartError" title="${title}" customCSSClass="cart-modal">
    <p class="h-space-2 error-msg js-errorMsgAddToCart"><spring:theme code="wishlist.modal.title"/></p>
    <div class="clearfix">
        <button class="btn btn-secondary btn--full-width" data-dismiss="modal" aria-label="Close">
          <spring:theme code="wishlist.addToCartFailed.modal.btn.ok"/>
        </button>
    </div>
</components:modal>