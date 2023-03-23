<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/template"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
	<cart:cartValidation/>
	<%-- <cart:cartPickupValidation/>
    <div class="hidden-xs">
        <cms:pageSlot position="NectarPromotionTileSlot" var="feature">
            <cms:component component="${feature}" element="div" class="yComponentWrapper"/>
        </cms:pageSlot>
    </div> --%>

	<div class="container mt2">
		<div class="row">		
			<div class="col-sm-4 col-xs-12 col-sm-push-8">
				<c:if test="${not empty cartData.entries}">
					<cms:pageSlot position="CenterRightContentSlot" var="feature">
						<cms:component component="${feature}"/>
					</cms:pageSlot>
				</c:if>
			</div>

			<div class="col-sm-8 col-xs-12 col-sm-pull-4">
				<c:if test="${not empty cartData.entries}">
					<cms:pageSlot position="CenterLeftContentSlot" var="feature">
						<cms:component component="${feature}"/>
					</cms:pageSlot>
				</c:if>
			</div>
		</div>
	</div>

    <cart:deleteCartModal />
    <cart:clearCartItemsModal /> 
    <cart:quantityCartModals/>
    <%-- <favourites:newFavouritiesList/> --%>
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