<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="wishlist.addToCart.modal.title" />
<components:modal id="addWishlistToCartModal" title="${title}" customCSSClass="cart-modal">
    <p class="h-space-2"><spring:theme code="wishlist.addToCart.modal.text"/></p>
    <div class="clearfix">
        <button class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
          <spring:theme code="wishlist.addToCart.modal.btn.cancel"/>
        </button>
        <button type="button" class="btn btn-primary cart-modal__btn-right js-addWishlistToCart" >
          <spring:theme code="wishlist.addToCart.modal.btn.ok"/>
        </button>
    </div>
    <div class="error-msg site-form__errormessage js-addWishlistToCartError h-space-2 text-center hide"><spring:theme code="wishlist.addToCart.modal.error"/></div>
</components:modal>