<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="wishlist.item.remove.modal.title" />
<components:modal id="deleteWishlistItemModal" title="${title}" customCSSClass="cart-modal">
    <div class="clearfix">
        <button class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
          <spring:theme code="wishlist.modal.button.cancel"/>
        </button>
        <button type="button" class="btn btn-primary cart-modal__btn-right js-deleteWishlistItem" >
          <spring:theme code="wishlist.modal.button.delete"/>
        </button>
    </div>
    <div class="error-msg site-form__errormessage js-removeWishlistError h-space-2 text-center hide"><spring:theme code="wishlist.modal.delete.item.error"/></div>
</components:modal>