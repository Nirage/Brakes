<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>


<spring:url value="/my-account/update-profile" var="updateProfileUrl"/>
<spring:url value="/my-account/update-password" var="updatePasswordUrl"/>
<spring:url value="/my-account/update-email" var="updateEmailUrl"/>
<spring:url value="/my-account/address-book" var="addressBookUrl"/>
<spring:url value="/my-account/payment-details" var="paymentDetailsUrl"/>
<spring:url value="/my-account/orders" var="ordersUrl"/>


<template:page pageTitle="${pageTitle}">
    <input type="hidden" id="cartLargeQuantity" value="${cartLargeQuantity}" />
    <input type="hidden" id="cartMaximumQuantity" value="${cartMaximumQuantity}" />
    <cms:pageSlot position="SideContent" var="feature" class="accountPageSideContent">
        <cms:component component="${feature}" />
    </cms:pageSlot>
    <cms:pageSlot position="TopContent" var="feature" element="div" class="accountPageTopContent">
        <cms:component component="${feature}" />
    </cms:pageSlot>

    <c:choose>
        <c:when test="${cmsPage.uid eq 'order' || cmsPage.uid eq 'amendorder'}">
            <c:set var="BodyContentSlot">
                <div class="container">
                    <div class="mini-basket__boundary" id="js-stickyMiniBasketBoundary">
                        <div class="row">
                            <div class="js-productsGridContainer col-md-12" data-new-grid="col-md-8" data-old-grid="col-md-12">
                                <div class="row">
                                <order:orderDetailsHeader />
                                <cms:pageSlot position="BodyContent" var="feature">
                                    <cms:component component="${feature}" />
                                </cms:pageSlot>
                                </div>
                            </div>
                            <cart:miniBasketComponent customClass="mini-basket-component--align-right mini-basket-component--order-page"/>
                        </div>
                    </div>
                </div>
            </c:set>
        </c:when>
        <c:otherwise>
            <c:set var="BodyContentSlot">
                <cms:pageSlot position="BodyContent" var="feature" element="div" class="account-section-content">
                    <cms:component component="${feature}" />
                </cms:pageSlot>
            </c:set>
        </c:otherwise>
    </c:choose>

    <div class="account-section">
        ${BodyContentSlot}
    </div>

    <cms:pageSlot position="BottomContent" var="feature" element="div" class="accountPageBottomContent">
        <cms:component component="${feature}" />
    </cms:pageSlot>
    <c:if test="${cmsPage.uid eq 'order' || cmsPage.uid eq 'amendorder'}">
        <cart:quantityCartModals />
        <cart:deleteCartModal />
        <cart:clearCartItemsModal />
        <order:orderAmmendErrorModal />
        <order:entrySubstituteModalHandlebars />
        <div id="entrySubstituteModalHolder"></div>
    </c:if>
    <c:if test="${cmsPage.uid eq 'amendorder'}">
        <order:cancelOrderErrorModal />
        <promotions:promoQuantityZeroModal />

    </c:if>
    <c:if test="${cmsPage.uid eq 'order'}">
        <order:orderPrintHandlebarsTemplates />
        <c:if test="${showOrderResubmittedModal}">
            <order:orderResubmittedModal />
        </c:if>
    </c:if>
    <c:if test="${cmsPage.uid eq 'amendorder'}">
        <order:cancelOrderErrorModal />
        <order:cancelOrderConfirmModal cancelOrderSubmitUrl="/my-account/order/${fn:escapeXml(orderCode)}/cancel/submit" />
        <order:reSubmitErrorOrderModal />
        <order:quantityOrderModals />
        <order:quickAddModalOrder />
    </c:if>
</template:page>