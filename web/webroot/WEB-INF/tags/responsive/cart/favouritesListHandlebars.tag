<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script id="favourites-list-template" type="text/x-handlebars-template">
  {{#if favourites.length}}
  <div class="wishlist-popover__heading"><spring:theme code="popup.favourites.addto.header" /></div>
  <ul class="wishlist-popover__list">
    {{#each favourites}}
    <li class="wishlist-popover__item">
      <span class="wishlist-popover__item-add">
        <button tabIndex="0" type="button" class=" js-addCartToWishlist wishlist-popover__item-add__button" data-favourite-id="{{uid}}" data-favourite-name="{{name}}">
          <span class="wishlist-popover__item-icon icon icon-caret-right"></span>
          <span class="wishlist-popover__item-text">{{name}}</span>
        </button>
      </span>
    </li>
    {{/each}}
  </ul>
  {{/if}}
  <button tabIndex="0" type="button "class="btn btn-create wishlist-popover__create-btn font-size-1" data-toggle="modal" data-target="#createWishlistModal">
    <span class="btn-create__icon"></span><spring:theme code="popup.favourites.create" />
  </button>
 </script>