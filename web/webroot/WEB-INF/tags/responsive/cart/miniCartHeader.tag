<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<div class="cart-header cart-header--minicart">
  <span class="cart-header__id">
      <c:if test="${not empty cart.code}">
          ${fn:escapeXml(cart.code)}
      </c:if>
  </span>
  <div class="cart-header__actions">
    <span class="icon icon-more cart-header__actions-menu js-cartHeaderActionsMenu"></span>
    <div class="cart-popover js-cartHeaderActionsPopover hide">
      <div class="cart-popover__views">
        <%-- View 1 --%>
        <div class="cart-popover__view cart-popover__view--normal js-cartHeaderActionsContent is-visible" data-id="normal">
          <c:if test="${showCreateNewBasket}">
            <div class="cart-popover__item">
              <a tabIndex="0" href="${contextPath}/cart/save/returnMiniCartDetails" class="cart-popover__item-link"><spring:theme code="mini.cart.summary.newBasket" /> </a>
            </div>
          </c:if>
          <div class="cart-popover__item cart-popover__item--bb js-changeActionView" data-target="favourites">
              <button tabIndex="0" class="js-saveCartAsFavourites cart-popover__item-button"> <spring:theme code="basket.page.mob.favourite"/> </button>
          </div>
          <c:if test="${not empty cart.rootGroups}">
            <div class="cart-popover__item">
              <button tabIndex="0" type="button" class="cart-popover__item cart-popover__item-button" data-toggle="modal" data-target="#clearCartItems">
                  <spring:theme code="basket.page.mob.clearitems"/>
              </button>
              </div>
          </c:if>
          <div class="cart-popover__item">
          <button tabIndex="0" class="cart-popover__item-button" type="button" data-toggle="modal" data-target="#deleteCurrentCartAndRestore">
              <spring:theme code="basket.page.mob.delete"/>
          </button>
          </div>
          <c:if test="${! empty( cart.entries) }">
            <div class="cart-popover__item cart-popover__item--bt">
              <button tabIndex="0" type="button" class="js-miniCartPrint cart-popover__item-button">
                  <spring:theme code="basket.page.mob.print"/>
              </button>
            </div>
          </c:if>
        </div>
        <%-- View 2 --%>
        <div class="cart-popover__view cart-popover__view--favourites js-cartHeaderActionsContent" data-id="favourites">
          <button tabIndex="0" type="button" class="btn btn-back-normal js-changeActionView" data-target="normal">
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
  </div>
</div>
 
