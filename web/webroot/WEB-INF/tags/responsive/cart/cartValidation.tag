<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<div class="global-alerts">

<c:if test="${invalidDeliveryDate}">
<div class="alert alert-info alert-dismissable js-alertDissapear">
      <button class="close" aria-hidden="true" data-dismiss="alert" type="button">
        <span class="icon icon-close icon--sm"></span>
      </button>
      <span class="icon icon-error alert__icon alert__icon--danger"></span>
      <span class="alert__text "><spring:theme code="basket.deliverydatechanged"/></span>
    </div>
</c:if>

  <c:if test="${priceChanged}">
    <div class="alert alert-info alert-dismissable js-alertDissapear">
      <button class="close" aria-hidden="true" data-dismiss="alert" type="button">
        <span class="icon icon-close icon--sm"></span>
      </button>
      <span class="icon icon-error alert__icon alert__icon--danger"></span>
      <span class="alert__text "><spring:theme code="basket.pricechanged"/></span>
    </div>
  </c:if>
</div>
<c:choose>
  <c:when test="${not empty validationData}">
    <script>
      window.productRemoved = true;
    </script>
  </c:when>
  <c:otherwise>
    <script>
      window.productRemoved = false;
    </script>
  </c:otherwise>
</c:choose>