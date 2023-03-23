<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>


<script id="entrySubstituteModalTemplate" type="text/x-handlebars-template">
<c:set var="title" value="order.substitute.modal.title" />
<components:modal id="orderSubsituteModal" title="${title}" customCSSClass="cart-modal cart-modal--lg">
    <p class="h-space-2 text"><spring:theme code="order.substitute.modal.body" arguments="{{originalEntry.name}}"/></p>
    <div class="substitute-entry">
      <div class="substitute-entry__img">
        {{var 'productImage' 'https://i1.adis.ws/i/Brakes/image-not-available'}}
        {{var 'image404' ''}}
        {{#if originalEntry.imgUrl}}
            {{var 'productImage' originalEntry.imgUrl}}
            {{var 'image404' '&img404=image-not-available&'}}
        {{/if}}
        <img class="product-item__image product-image js-fallbackImage" src="{{productImage}}?{{image404}}$substitute$" alt="{{originalEntry.altText}}" title="{{originalEntry.altText}}">

      </div>
      <div class="substitute-entry__description">
        <div class="substitute-entry__code">
          {{originalEntry.code}}
        </div>
        <div class="substitute-entry__name">
          {{originalEntry.name}}
        </div>
        <div class="substitute-entry__pack-size">
          <spring:theme code="product.cart.packSize"/>: {{originalEntry.packSize}}
        </div>
      </div>
    </div>

    <form:form id="substituteProductForm" name="substituteProductForm" action="/my-account/order/substitute" method="post" modelAttribute="substituteProductForm">
      <input type="hidden" id="substituteProductCode" name="substituteProductCode" value="{{substituteEntry.code}}">
      <input type="hidden" id="entryNumber" name="entryNumber" value="{{substituteEntry.entryNumber}}">
      <input type="hidden" id="orderNumber" name="orderNumber" value="{{orderCode}}">
  
    <%-- If user clicks reject button acceptSubstitute will be set to 'false' via js --%>
    <input type="hidden" id="acceptSubstitute" name="acceptSubstitute" value="true">

    <div class="order-substitute-modal__btns">
      <button type="button" class="btn btn-secondary order-substitute-modal__reject-btn js-rejectSubstitute">
        <spring:theme code="order.substitute.modal.reject"/>
      </button>
      <button class="btn btn-secondary order-substitute-modal__accept-btn js-acceptSubstitute" type="submit">
          <spring:theme code="order.substitute.modal.ok"/>
      </button>
    </div>
  </form:form>
</components:modal>
</script>
