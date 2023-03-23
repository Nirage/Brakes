<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="checkout" tagdir="/WEB-INF/tags/responsive/checkout"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">

	<cart:cartValidation/>
	<cart:cartPickupValidation/>
    <c:if test="${not empty param['steppedCheckout']}">

        <div class="container container--narrow">
	        <checkout:checkoutProgressBar currentStep="2" totalSteps="2" position="top"/>
            <div class="row">
                <div class="col-xs-12 col-sm-9">
                    <h2 class="checkout-suggestions__heading"><spring:theme code="checkout.progress.stepTwo.header" /></h2>
                    <p class="checkout-suggestions__subheading"><spring:theme code="checkout.progress.stepTwo.text" /></p>
                </div>
                <c:if test="${missingOrBestSellerAvailable eq true}">
                    <div class="col-xs-12 col-sm-3">
                        <a tabindex="0" href="/checkout/step-one" class="btn btn-secondary has-items pull-right btn--auto-width-desktop hidden-xs">
                            <div class="btn__text-wrapper">
                                <span class="icon icon-chevron-left btn__icon"></span>
                                <span class="btn__text"><spring:theme code="checkout.progress.goBack" /></span>
                            </div>
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </c:if>

	<div class="container cart-page">
        <c:if test="${not empty savedCartCount and savedCartCount ne 0}">
            <div class="row">
                <h1 class="col-xs-12 hidden-sm hidden-md hidden-lg cart__page-title">
                    <spring:theme code="saved.cart.your.carts" arguments="${savedCartCount}"/>
                </h1>
            </div>
        </c:if>

        <div class="row">
            <div class="col-sm-4 col-xs-12 col-sm-push-8">
                <sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
                    <c:if test="${not empty savedCartCount and savedCartCount ne 0}">
                        <spring:url value="/my-account/saved-carts" var="listSavedCartUrl" htmlEscape="false"/>
                        <a href="${fn:escapeXml(listSavedCartUrl)}" class="save__cart--link cart__head--link">
                            <spring:theme code="saved.cart.total.number" arguments="${savedCartCount}"/>
                        </a>
                        <c:if test="${not empty quoteCount and quoteCount ne 0}">
                            <spring:url value="/my-account/my-quotes" var="listQuotesUrl" htmlEscape="false"/>
                            <a href="${fn:escapeXml(listQuotesUrl)}" class="cart__quotes--link cart__head--link">
                                <spring:theme code="saved.quote.total.number" arguments="${quoteCount}"/>
                            </a>
                        </c:if>
                    </c:if>
                </sec:authorize>
                <cart:saveCart/>
                <cms:pageSlot position="CenterRightContentSlot" var="feature">
                    <cms:component component="${feature}" element="div" class="yComponentWrapper"/>
                </cms:pageSlot>
            </div>
            <div class="col-sm-8 col-xs-12 col-sm-pull-4">
                <cms:pageSlot position="CenterLeftContentSlot" var="feature">
                    <cms:component component="${feature}" element="div" class="cart-wrapper"/>
                </cms:pageSlot>
            </div>
        </div>
            
        <%-- Up Sell/Cross Sell Carousels --%>
        <div class="row product-recommendations--hide-mobile product-recommendations--loading" data-page="${cmsPage.uid}">
            <cms:pageSlot position="ProductReferenceSlot" var="feature">
                <cms:component component="${feature}"/>
            </cms:pageSlot>
        </div>

	</div>
    <cart:deleteCartModal />
    <cart:clearCartItemsModal />
    <cart:quantityCartModals/>
    <favourites:newFavouritiesList/>
    <promotions:promoQuantityZeroModal />
    <promotions:promoComplexInfoModal />
    <%-- For Display VAT applicable --%>
    <c:forEach items="${cartData.entries}" var="entries">
        <c:if test="${entries.product.subjectToVAT}">
            <c:set var="vatApplicableText">
                <div class="cart__vat-text-box vat__text-box">
                    <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
                    <spring:theme code="product.vat.applicable" />
                </div>
            </c:set>
        </c:if>
    </c:forEach>
    <div class="cart__vat-text-box-holder">${vatApplicableText}</div>
    <div class="js_spinner spinning-div">
        <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
    </div>

        <c:if test="${not empty param['steppedCheckout']}">
            <div class="container container--narrow">
        		<div class="row h-space-2 hidden-xs">
			        <div class="col-xs-12 col-md-9"></div>
                    <div class="col-xs-12 col-md-3">
                        <c:if test="${missingOrBestSellerAvailable eq true}">
                            <a tabindex="0" href="/checkout/step-one" class="btn btn-secondary has-items pull-right btn--auto-width-desktop">
                                <div class="btn__text-wrapper">
                                <span class="icon icon-chevron-left btn__icon"></span>
                                    <span class="btn__text"><spring:theme code="checkout.progress.goBack" /></span>
                                </div>
                            </a>
                        </c:if>
                    </div>
		        </div>
	            <checkout:checkoutProgressBar currentStep="2" totalSteps="2" position="bottom"/>
            </div>
            <checkout:checkoutTwoStepFixedFooter currentStep="2" totalSteps="2"/>
        </c:if>
</template:page>
