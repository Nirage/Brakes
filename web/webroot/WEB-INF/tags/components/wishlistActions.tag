<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="componentName" required="false" type="java.lang.String"%>
<%@ attribute name="sizeOfWishlist" required="false" type="java.lang.Integer"%>


<div class="edit-wishlist">
  <div class="fav-item__edit-section fav-item__edit-section--top">
    <c:if test="${componentName == 'wishlistListingPage'}">
      <div class="fav-item__edit-action fav-item-rename js-favEditAction" data-action="amend">
        <span class="icon icon-amend fav-item__edit-icon"></span>
        <span class="fav-item__edit-text"><spring:theme code="popup.favourite.rename" /></span>
      </div>
    </c:if>
    <div class="fav-item__edit-action fav-item-delete js-favEditAction" data-action="delete">
      <span class="icon icon-trash fav-item__edit-icon"></span>
      <span class="fav-item__edit-text"><spring:theme code="popup.favourite.delete" /></span>
    </div>
  </div>
 <c:if test="${sizeOfWishlist gt 1}">
  <div class="fav-item__edit-section fav-item__edit-section-seperator"></div>
  <div class="fav-item__edit-section fav-item__edit-section--bottom">
    <div class="fav-item__edit-action fav-item-movetotop js-favEditAction" data-action="move" data-move-type="moveToTop">
    <span class="icon icon-move-to-top fav-item__edit-icon"></span>
    <span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveToTop" /></span>
  </div>
  <div class="fav-item__edit-action fav-item-moveup js-favEditAction" data-action="move" data-move-type="moveUp">
    <span class="icon icon-move-up fav-item__edit-icon"></span>
    <span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveUp" /></span>
  </div>
  <div class="fav-item__edit-action fav-item-movedown js-favEditAction" data-action="move" data-move-type="moveDown">
    <span class="icon icon-move-down fav-item__edit-icon"></span>
    <span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveDown" /></span>
  </div>
  <div class="fav-item__edit-action fav-item-movetobottom js-favEditAction" data-action="move" data-move-type="moveToBottom">
    <span class="icon icon-move-to-bottom fav-item__edit-icon"></span>
    <span class="fav-item__edit-text"><spring:theme code="popup.favourite.moveToBottom" /></span>
  </div>
  </div>
 </c:if>
</div>