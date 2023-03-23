<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>


<script id="potentialPromoModalTemplate" type="text/x-handlebars-template">
<c:set var="title" value="potential.promo.modal.title" />
<components:modal id="potentialPromoModal" title="${title}" customCSSClass="cart-modal cart-modal--lg cart-modal--potential-promo">
    <p class="h-space-2 text">{{promotionMessage}}</p>

  {{#each remainingProducts}}
    {{#if @last}}
      {{var 'lastProduct' 'potential-promo-modal__product--last'}}
    {{/if}}
    {{#if @first}}
      {{var 'lastProduct' 'potential-promo-modal__product--first'}}
    {{/if}}
    <div class="potential-promo-modal__product {{lastProduct}}">
      <a class="potential-promo-modal__image" href="{{url}}" title="{{name}}">
        {{#if cartEntry}}
          <span class="potential-promo-modal__in-cart-overlay">
            <spring:theme code="potential.promo.modal.added.to.cart" /> &nbsp;<span class="icon icon-basket icon--sm"></span>
          </span>
        {{/if}}
        {{> imagePartial}}
       </a>
       <div class="potential-promo-modal__details">
        <div class="potential-promo-modal__code">{{prefix}} {{code}}</div>
        <a class="potential-promo-modal__description" href="{{url}}" title="{{name}}">{{{truncate name 33}}}</a>
        <div class="cart-item__pack-size"><spring:theme code="product.cart.packSize"/>: {{packSize}}</div>
        </div>
      </div>
    {{/each}}
    {{#with freeGift}}
      <div class="potential-promo-modal__product potential-promo-modal__product--free ">
        <a class="potential-promo-modal__image" href="{{url}}" title="{{name}}">
          {{> imagePartial}}
        </a>
        <div class="potential-promo-modal__details">
          <div class="potential-promo-modal__free-label"><spring:theme code="potential.promo.modal.free" /></div>
          <div class="potential-promo-modal__code">{{prefix}} {{code}}</div>
          <a class="potential-promo-modal__description" href="{{url}}" title="{{name}}">{{{truncate name 33}}}</a>
          <div class="cart-item__pack-size"><spring:theme code="product.cart.packSize"/>: {{packSize}}</div>
        </div>
      </div>
    {{/with}}
</components:modal>
</script>

<script id="imagePartial" type="text/x-handlebars-template">	
    {{var 'productImage' 'https://i1.adis.ws/i/Brakes/image-not-available'}}
        {{var 'image404' ''}}

        {{#if images}}
            {{var 'productImage' images.1.url}}
            {{var 'image404' '&img404=image-not-available&'}}
        {{/if}}
        <img class="product-item__image js-fallbackImage" src="{{productImage}}?{{image404}}&w=100" alt="{{images.1.altText}}" title="{{images.1.altText}}">
</script>