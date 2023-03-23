<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<div class="cart-header">
  <span class="cart-header__id">
      <c:if test="${not empty cartData.code}">
          ${fn:escapeXml(cartData.code)}
      </c:if>
  </span>
  <c:if test="${!isb2cSite && empty punchoutUser}">
    <div class="cart-header__actions">
      <div class="hidden-md hidden-lg">
        <span tabindex="0" class="icon icon-more cart-header__actions-menu js-cartHeaderActionsMenu"></span>
        <div class="cart-popover js-cartHeaderActionsPopover hide">
          <%-- View 1 --%>
          <div class="cart-popover__view cart-popover__view--normal js-cartHeaderActionsContent is-visible" data-id="normal">
          <c:if test="${cmsPage.uid eq 'checkoutPage'}">
            <div class="cart-popover__item cart-popover__item--bb js-changeActionView" data-target="favourites">
                <div tabindex="0" class="js-saveCartAsFavourites cart-popover__item-button"><spring:theme code="basket.page.mob.favourite"/></div>
            </div>
            </c:if>
          <c:if test="${cmsPage.uid ne 'checkoutPage'}">
            <c:if test="${not empty cartData.rootGroups}">
                <div tabIndex="0" type="button" class="cart-popover__item" data-toggle="modal" data-target="#clearCartItems">
                    <spring:theme code="basket.page.mob.clearitems"/>
                </div>
            </c:if>
            <div tabindex="0" class="cart-popover__item" role="button" data-toggle="modal" data-target="#deleteCurrentCartAndRestore">
                <spring:theme code="basket.page.mob.delete"/>
            </div>
          </c:if>  
            <c:if test="${! empty( cartData.entries) }">
                <div tabindex="0" class="js-cartPrint cart-popover__item cart-popover__item--bt">
                    <spring:theme code="basket.page.mob.print"/>
                </div>
            </c:if>
          </div>
                  <%-- View 2 --%>
          <div class="cart-popover__view cart-popover__view--favourites js-cartHeaderActionsContent" data-id="favourites">
            <button tabindex="0" type="button" class="btn btn-back-normal js-changeActionView" data-target="normal">
              <span class="btn-back-normal__inner">
                <span class="icon icon--sm icon-chevron-left"></span>
                <span><spring:theme code="account.back"/></span>
              </span>
            </button>
            <div class="wishlist-popover wishlist-popover--cart-actions js-wishlistPopoverContent js-wishlistHolder">
            </div>
          </div>
        </div>
      </div>

        <span class="cart-header__actions-inner hidden-sm hidden-xs">
          <c:if test="${! empty(cartData.entries) }">
              <span class="cart-header__actions-item">
                  <button tabindex="0" class="js-cartPrint cart-header__actions-item__button">
                    <span class="icon icon-print"></span>
                    <span><spring:theme code="basket.page.print" /></span>
                  </button>
              </span>
          </c:if>
          
          <c:if test="${cmsPage.uid ne 'checkoutPage'}">
          <span class="cart-header__actions-item">
            <button tabindex="0" class="cart-header__actions-item__button" data-toggle="modal" data-target="#deleteCurrentCartAndRestore" type="button">
                <span class="icon icon-trash"></span>
                <span><spring:theme code="basket.page.deletebasket"/></span>
            </button>
            </span>
          </c:if>
          <div class="cart-header__actions-item ${! empty(cartData.entries) ? 'js-saveBasketFavourite' : ''}" data-target="popover">    
            <c:if test="${! empty( cartData.entries) }">
              <button tabindex="0" class="js-saveCartAsFavourites cart-header__actions-item__button">
                <span class="icon icon-Heart "></span>
                <spring:theme code="basket.page.favourite"/>
              </button>
            </c:if>
            <c:if test="${cmsPage.uid ne 'checkoutPage' && empty(cartData.entries)}">
                <button tabindex="0" class="js-saveCartAsFavourites cart-header__actions-item__button cart-header__actions-item__button--notPlain">
                <span class="icon icon-Heart "></span>
                <spring:theme code="basket.page.favourite"/>
            </c:if>
              <div class="cart-header__wishlist-holder hide">
                <div class="js-wishlistHolder wishlist-popover"></div>
              </div>
          </div>
        </span>
    </div>
  </c:if>
</div>
 
 