<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
	<cart:cartValidation/>
	<cart:cartPickupValidation/>
    <div class="hidden-xs">
        <cms:pageSlot position="NectarPromotionTileSlot" var="feature">
            <cms:component component="${feature}" element="div" class="yComponentWrapper"/>
        </cms:pageSlot>
    </div>

	<div class="container">
        <c:if test="${not empty savedCartCount and savedCartCount ne 0}">
            <div class="row">
                <h1 class="col-xs-12 hidden-sm hidden-md hidden-lg cart__page-title">
                    <spring:theme code="saved.cart.your.carts" arguments="${savedCartCount}"/>
                </h1>
            </div>
        </c:if>
        <div class="row cart--change-order">

            <div class="col-sm-8 col-xs-12">
                <cms:pageSlot position="CenterLeftContentSlot" var="feature">
                    <cms:component component="${feature}" element="div" class="cart-wrapper"/>
                </cms:pageSlot>
            </div>

            <div class="col-sm-4 col-xs-12">
                <sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
                    <c:set var="isunavailableProductsFlag" value="${unavailableProductsFlag}"/>
                    <c:if test="${empty isunavailableProductsFlag || isunavailableProductsFlag != false}">
                        <%-- THIS Variable is empty when there is an ERROR and false when NO ERROR exists --%>
                        <script>
                            window.outOfStockError = true;
                        </script>
                    </c:if>
                    <c:if test="${not empty savedCarts && fn:length(savedCarts) gt 0}">
                        <div class="cart__switch-baskets">
                            <cart:switchCart savedCartCount="${savedCartCount}" savedCarts="${savedCarts}" labelCode="basket.cart.switchBaskets" cart="${cartData}"/>
                        </div>
                    </c:if>
                </sec:authorize>
                <cart:saveCart/>
                <cms:pageSlot position="CenterRightContentSlot" var="feature">
                    <cms:component component="${feature}" element="div" class="yComponentWrapper"/>
                </cms:pageSlot>

                <%-- Nectar Promotions --%>
                <div class="visible-xs">
                    <cms:pageSlot position="NectarPromotionTileSlot" var="feature">
                        <cms:component component="${feature}" element="div" class="yComponentWrapper"/>
                    </cms:pageSlot>
                </div>
            </div>
            
            <%-- Up Sell/Cross Sell Carousels --%>
            <div class="col-sm-4 col-xs-12 pull-right" data-page="${cmsPage.uid}">
                <cms:pageSlot position="ProductReferenceSlot" var="feature">
                    <cms:component component="${feature}" />
                </cms:pageSlot>
            </div>
            
        </div>

	</div>
   
    <cart:deleteCartModal />
    <cart:clearCartItemsModal />
    <cart:quantityCartModals/>
    <favourites:newFavouritiesList/>
    <promotions:promoQuantityZeroModal />
    <promotions:promoComplexInfoModal />
    <c:if test="${not empty currentB2BUnit && currentB2BUnit.viewPromotions}">
        <cart:potentialPromoModal />
    </c:if>
    <div class="js-potentialPromoModalHolder"></div>
    <!-- For Display VAT applicable -->
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
    <div class="cart__vat-text-box-holder">
        ${vatApplicableText}
    </div>
    <div class="js_spinner spinning-div">
        <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
    </div>
</template:page>
