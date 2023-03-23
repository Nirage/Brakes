<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<c:url value = "/my-account/amend/order/${amendingOrderCode}" var="reviewAmendsUrl"/>
<c:url value = "/my-account/cancel/amend/order/${amendingOrderCode}" var="cancelAmendsUrl"/>
<div class="amend-order-banner">
    <div class="amend-order-banner__container">
        <div class="amend-order-banner__order-details">
            <strong><spring:theme code="banner.amend.text" />&nbsp;${amendingOrderCode}</strong>
            <strong class="text-warning text-uppercase"><spring:theme code="banner.amend.order.deadline.txt" />&nbsp;${amendingOrderDeadline}</strong>
        </div>
        <div class="amend-order-banner__CTA-container">
            <a class="btn btn-primary text-white" href="${reviewAmendsUrl}"><spring:theme code="banner.amend.order.review.txt" /></a>
            <a class="btn btn-secondary btn-secondary--green" href="${cancelAmendsUrl}"><spring:theme code="banner.amend.order.cancel.txt" /></a>
        </div>
    </div>
</div>
