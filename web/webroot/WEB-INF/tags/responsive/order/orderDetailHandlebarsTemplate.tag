<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<components:productIconMessages />

<script id="order-detail-items" type="text/x-handlebars-template">
  {{#each results}}
    {{#if showSubstitutedEntry }}
      {{> orderLineEntryPartial 
          orderEntry=this 
          substitutedEntry=this.substitutedEntry 
          substitutionInitiated=true  
          orderCode=../order.code }}
    {{/if}}
    {{#if showRegularEntry}}
      {{> orderLineEntryPartial orderEntry = this}}
    {{/if}}
  {{/each}}

  {{#if hasNext}}
    {{> orderDetailsLoadMorePartial }}
  {{/if}}
</script>

<script id="orderLineEntryPartial" type="text/x-handlebars-template">
  {{~#ifCond promoGroupNumber '>' -1 }} <div class="cart-item__promo-group"> {{/ifCond}} 
  <li class="order-line-entry cart-item js-orderItem">
    {{~#ifCond linkedPromoEntry '!=' null}}<div class="promo-arrow"></div>{{/ifCond}}
    <div class="cart-item__content">
      <%-- product image --%>
      <div class="cart-item__image">
        <a class="product-item__thumb m0" href="{{product.url}}">
          {{> picturePartial}}
        </a>
        <div class="cart-item__advice-icons hidden-md hidden-lg">
          {{#if product.newProduct}}
                  <a href="{{product.url}}" title="{{product.name}}">
                      <span class="cart-item__advice-icons-img icon icon-new icon-new--royal-blue"></span>
                  </a>
          {{/if}}
          {{#each product.productInfoIcons}}
            <a href="{{product.url}}" title="{{product.name}}">
              <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-{{this}}" alt="{{this}}"/>
            </a>
          {{/each}}
        </div>
      </div>

      <%-- product name, code, promotions --%>
      <div class="cart-item__details">
        <div class="cart-item__description">
          {{> orderItemDescriptionPartial}}
        </div>
        <div class="cart-item__details-right">
            {{> orderItemPricePartial}}
            <c:choose>
                <c:when test="${isAmendOrderDetailsPage}">
                  {{#if substitutionInitiated}}
                    <div class="order-line-entry__qty">
                      <spring:theme code="text.order.details.line.entry.qty" />&nbsp;{{#if deliveredQuantity}}{{deliveredQuantity}}{{else}}{{quantity}}{{/if}}
                    </div>
                  {{else}}
                    {{var "isPromoGroup" false}}
                    {{~#ifCond promoGroupNumber '==' -1}}
                      {{var "isPromoGroup" true}}
                    {{/ifCond}}
                    {{#if isPromoGroup}}
                      {{var "isUnlinkedPromoItem" true}}
                      {{~#ifCond promoGroupNumber '!=' null}}
                        {{var "isUnlinkedPromoItem" false}}
                      {{/ifCond}}
                      {{#if isUnlinkedPromoItem}}
                        {{> orderItemQuantityPartial entry=this}}
                      {{/if}}
                    {{else}}
                      {{> orderItemQuantityPartial entry=this}}
                    {{/if}}
                  {{/if}}
                </c:when>
                <c:otherwise>
                  <div class="order-line-entry__qty">
                    <spring:theme code="text.order.details.line.entry.qty" />&nbsp;{{#if deliveredQuantity}}{{deliveredQuantity}}{{else}}{{quantity}}{{/if}}
                  </div>
                </c:otherwise>
            </c:choose>
          <c:if test="${not isAmendOrderDetailsPage}">
            {{#if substitutionInitiated}}
              <div class="order-status order-status--substitution-init">
                <span class="js-showentrySubstituteModal"
                data-original-entry='{"code":"{{substitutedEntry.product.code}}", "name":"{{substitutedEntry.product.name}}", "packSize":"{{substitutedEntry.product.packSize}}", "imgUrl":"{{substitutedEntry.product.images.1.url}}", "altText":"{{substitutedEntry.product.images.1.altText}}"}'
                data-substitute-entry='{"code":"{{orderEntry.product.code}}", "entryNumber":"{{orderEntry.entryNumber}}"}'
                data-order-code="{{orderCode}}">
                <spring:theme code="text.order.details.line.entry.status.substitutionInitialized" /></span>
              </div>
            {{else}}
              {{#ifCond status '==' 'Queued'}}
                <div class="order-status"><spring:theme code="text.order.details.line.entry.status.QUEUED" /></div>
              {{else}}
                <div class="order-status order-status--{{toLowerCase entryStatusCode}}">{{status}}</div>
              {{/ifCond}} 
            {{/if}}
          </c:if>
          <c:if test="${isAmendOrderDetailsPage}">
              <div class="order-line-entry__amend-status">
                {{#if substitutionInitiated}}
                  <div class="order-status order-status--substitution-init">
                    <span class="js-showentrySubstituteModal" data-original-entry='{"code": "{{substitutedEntry.product.code}}", "name":"{{substitutedEntry.product.name}}", "packSize":"{{substitutedEntry.product.packSize}}", "imgUrl":"{{#if substitutedEntry.product.images}} {{substitutedEntry.product.images.1.url}} {{/if}}", "altText":"{{substitutedEntry.product.images.1.altText}}"}'
                           data-substitute-entry='{"code":"{{orderEntry.product.code}}", "entryNumber":"{{orderEntry.entryNumber}}"}'
                           data-order-code="{{orderDetails.order.code}}"
                           >
                      <spring:theme code="text.order.details.line.entry.status.substitutionInitialized" />
                    </span>
                  </div>
                {{else}}
                  {{#ifCond status '==' 'Queued'}}
                    <div class="order-status"><spring:theme code="text.order.details.line.entry.status.QUEUED" /></div>
                  {{else}}
                    {{#if entryStatusCode}}
                      <div class="order-status order-status--{{toLowerCase entryStatusCode}}">{{status}}</div>
                    {{/if}}
                  {{/ifCond}} 
                {{/if}}
              </div>
          </c:if>
        </div>
      </div>
    </div>
  </li>
  {{~#ifCond promoGroupNumber '>' -1 }} </div> {{/ifCond}}
</script>

<script id="orderItemPricePartial" type="text/x-handlebars-template">	
  <div class="cart-item__price-wrapper">
    <div class="cart-item__total js-item-total">
      {{> orderPricePartial totalPrice displayFreeForZero="true"}}
      {{~#if product.subjectToVAT~}}
        <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
      {{/if}}
    </div>
    <%-- price per item --%>
    <div class="cart-item__price">
        {{#if estimatedPrice}}
          {{#replaceEmptySpace estimatedPrice.formattedValue ""}}{{/replaceEmptySpace}}
        {{else}}
          ({{> orderPricePartial basePrice displayFreeForZero="true"}})&nbsp;{{product.unitPriceStr}}
        {{/if}}
    </div>
    <div class="cart-item__case">
        <spring:theme code="product.cart.caseQuantity"/>: {{product.unitsPerCase}}
    </div>
    <div class="cart-item__pack-size">
        <spring:theme code="product.cart.packSize"/>: {{product.packSize}}
    </div>
  </div>
</script>

<script id="orderPricePartial" type="text/x-handlebars-template">
   {{~#ifCond value '>' 0}}
        {{~#if displayNegationForDiscount}}
            -
        {{/if}}
        {{~formattedValue~}}
    {{else}}
        {{#if displayFreeForZero}}
          <spring:theme code="text.free" text="FREE"/>
        {{else}}
          {{formattedValue}}
        {{/if}}
    {{/ifCond}}
</script>


<script id="orderItemDescriptionPartial" type="text/x-handlebars-template">	
  <a class="cart-item__code js-orderItemCode" data-code="{{product.code}}" href="{{#if product.purchasable}} {{product.url}} {{/if}}">
    {{product.prefix}}&nbsp;{{product.code}}
  </a>
  {{~#ifCond promoGroupNumber '>' -1}}
  <div class="item-icons item-icons--promo cart-item__promo-icon">
      <span class="icon icon-promo-alt icon-promo-alt--red icon-user-actions"><span class="path1"></span><span class="path2"></span></span>
  </div>
  {{/ifCond}}
  <a class="cart-item__name" href="{{#if product.purchasable}} {{product.url}} {{/if}}">
    {{product.name}}
  </a>
  <div class="cart-item__advice-icons hidden-xs hidden-sm">
    {{#if product.newProduct}}
      <span class="cart-item__advice-icons-img icon icon-new icon-new--royal-blue"></span>
    {{/if}}
    {{#each product.productInfoIcons}}
      <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-{{this}}" alt="{{this}}"/>
    {{/each}}
  </div>
</script>

<script id="picturePartial" type="text/x-handlebars-template">	
  {{var 'productImage' 'https://i1.adis.ws/i/Brakes/image-not-available'}}
  {{var 'image404' ''}}

  {{#if product.images}}
      {{var 'productImage' product.images.1.url}}
      {{var 'image404' '&img404=image-not-available&'}}
  {{/if}}

  <picture class="product-item__picture flex justify-content-center">
        <source data-size="desktop" data-srcset="{{productImage}}?{{image404}}&$plp-desktop$&fmt=webp" media="(min-width: 1240px)" type="image/webp">
        <source data-size="desktop" data-srcset="{{productImage}}?{{image404}}&$plp-desktop$" media="(min-width: 1240px)" type="image/jpeg">
        <source data-size="tablet" data-srcset="{{productImage}}?{{image404}}&$plp-tablet$&fmt=webp" media="(min-width: 768px)" type="image/webp">
        <source data-size="tablet" data-srcset="{{productImage}}?{{image404}}&$plp-tablet$" media="(min-width: 768px)" type="image/jpeg">
        <source data-size="mobile" data-srcset="{{productImage}}?{{image404}}&$plp-mobile$&fmt=webp" type="image/webp">
        <source data-size="mobile" data-srcset="{{productImage}}?{{image404}}&$plp-mobile$" type="image/jpeg"> 
        <img data-sizes="auto" class="product-item__image product-image lazyload" data-src="{{productImage}}?{{image404}}&$plp-desktop$" alt="{{product.images.1.altText}}" title="{{product.images.1.altText}}" width="213" height="142" />
        <div class="loader__image"></div>
    </picture>
</script>

<script id="orderDetailsLoadMorePartial" type="text/x-handlebars-template">
  <c:choose>
    <c:when test="${cmsPage.uid eq 'amendorder'}">
      <spring:url value="/my-account/amend/order/results/" var="loadMoreOrdersBaseUrl" htmlEscape="false"/>
    </c:when>
    <c:otherwise>
      <spring:url value="/my-account/order/results/" var="loadMoreOrdersBaseUrl" htmlEscape="false"/>
    </c:otherwise>
  </c:choose>

  <div class="cart-item__load-more order-line-entry__load-more js-orderDetailLoadMoreParent">
    <button class="btn btn-secondary js-orderDetailLoadMore" data-url="${loadMoreOrdersBaseUrl}{{order.code}}?page={{inc pagination.currentPage}}">
      <spring:theme code="text.order.details.loadMore" />
    </button>
  </div>
</script>

<script id="orderItemQuantityPartial" type="text/x-handlebars-template">
  <div class="order-line-entry__qty-form clearfix">
    <form:form id="addToCartForm{{product.code}}" action="/my-account/addToAmendOrder" method="post"
                    class="add_to_cart_form js-addQuantityForm js-addToCartForm" data-id="{{product.code}}">
      <input type="hidden" name="productCode" value="{{product.code}}"/>
      <input type="hidden" name="qty" class="js-productCartQty" value="{{#if quantity}}{{quantity}}{{else}}0{{/if}}"/>

      <div class="js-productQtyUpdate quantity-update {{#if quantity}}{{else}}'hide'{{/if}} quantity-update--cart">
        <button type="button"
          class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-cartQtyChangeBtn"
          data-action="remove" aria-label="Remove from cart"></button>
          <input class="quantity-update__input js-productCartQtyInput" type="number"
                  inputmode="numeric"  aria-label="Quantity"
                  value="{{#if quantity}}{{quantity}}{{else}}0{{/if}}"
                  max="99" />
          <input type="hidden" name="orderCode"  value="{{@root.order.code}}"/>
          <button type="submit"
                  class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-cartQtyChangeBtn"
                  data-action="add" aria-label="Add to cart">
          </button>
      </div>
    </form:form>
  </div>
  <div class="order-line-entry__actions">
    {{#if updateable}}
      <div class="js-cartItemDetailGroup">
          <button type="button" class="btn cart-item__remove js-cartItemDetailBtn" aria-haspopup="true"
                  aria-expanded="false" id="editEntry_{{entryNumber}}" data-form-id="addToCartForm{{product.code}}">
              <span class="icon icon-trash icon--sm"></span>
          </button>
      </div>
    {{/if}}
  </div>
</script>
