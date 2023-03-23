<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="orderData" value="${orderDetails.order}"/>
<div class="col-xs-12 col-md-8 col-md-offset-2 js-productsGridContainer" data-new-grid="col-md-12 col-md-offset-0" data-old-grid="col-md-8 col-md-offset-2">
	<ycommerce:testId code="orderDetail_overview_section">
				<order:accountOrderDetailsOverview order="${orderData}"/>
		</ycommerce:testId>
</div>
