<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="wishlist.modal.title" />
<components:modal id="deleteWishlistModal" title="${title}" customCSSClass="cart-modal">
    <p class="h-space-2"><spring:theme code="wishlist.modal.delete.item"/></p>
    <div class="clearfix">
        <button class="btn btn-secondary cart-modal__btn-left js-cancelDeleteWishlist" data-dismiss="modal" aria-label="Close">
          <spring:theme code="wishlist.modal.button.cancel"/>
        </button>
        <button type="button" class="btn btn-primary cart-modal__btn-right js-deleteWishlist" >
          <spring:theme code="wishlist.modal.button.delete"/>
        </button>
    </div>
    <div class="error-msg site-form__errormessage js-removeWishlistError h-space-2 text-center hide"><spring:theme code="wishlist.modal.delete.error"/></div>
</components:modal>