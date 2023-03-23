<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<spring:url value="/my-account/orders" var="orderHistoryUrl" htmlEscape="false"/>
<c:set var="orderData" value="${orderDetails.order}"/>
<div class="h-space-2 clearfix">
  <div class="col-xs-12 col-md-2 h-topspace-2 js-productsGridContainer" data-new-grid="col-md-3" data-old-grid="col-md-2">
    <a class="btn btn-back-normal header__btn-back" href="${orderHistoryUrl}">
      <span class="btn-back__inner">
          <span class="icon icon--sm icon-chevron-left"></span>
          <span class=""><spring:theme code="text.account.order.details.back"/></span>
      </span>
    </a>
  </div>

  <div class="col-xs-12 col-md-8">
    <div class="site-header site-header--align-left order-history__site-header">
      <h1 class="site-header__text site-header--align-left">
        <spring:theme code="text.account.order.details.title" arguments="${fn:escapeXml(orderData.code)}"/>
      </h1>
      <span class="site-header__rectangle site-header__rectangle--align-left"></span>
    </div>
  </div>
</div>