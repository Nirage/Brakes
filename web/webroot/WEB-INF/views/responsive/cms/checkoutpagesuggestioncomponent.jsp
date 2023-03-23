<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="checkout" tagdir="/WEB-INF/tags/responsive/checkout"%>
<%@ taglib prefix="component" tagdir="/WEB-INF/tags/shared/component"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<script type="text/javascript">
	window.monetateComponentProductList = [];
	window.monetateQ = window.monetateQ || [];
	window.monetateQ.push([
	"setPageType",
		"${cmsPage.uid}"
	]);
</script>

<div class="container">

	<checkout:checkoutProgressBar currentStep="1" totalSteps="2" position="top"/>

	<c:if test="${not empty suggestions and component.maximumNumberProducts > 0}">
		<div class="checkout-suggestions mt-2">
		<div class="row">
			<div class="col-xs-12 col-sm-9 h-space-2">
				<h2 class="checkout-suggestions__heading">${fn:escapeXml(title)}</h2>
				<p class="checkout-suggestions__subheading">${fn:escapeXml(subTitle)}</p>
			</div>
			<div class="col-xs-12 col-sm-3">
				<a tabindex="0" href="/checkout?steppedCheckout=true" class="btn btn-primary pull-right btn--auto-width-desktop hidden-xs no-border">
					<div class="btn__text-wrapper">
						<span class="btn__text"> <spring:theme code="checkout.checkout" /></span>
						<span class="icon icon-chevron-right btn__icon"></span>
					</div>
				</a>
			</div>
		</div>

		<div class="suggestions">
			<div class="product__listing product__listing--suggestions product__grid js-plpGrid">
				<c:forEach end="${component.maximumNumberProducts}" items="${suggestions}" var="suggestion" varStatus="loop">
				<script type="text/javascript">
				monetateComponentProductList.push("${suggestion.code}");
				</script>
					<product:productListerGridItem product="${suggestion}" customCSSClass="ga-${suggestionType}"/>
				</c:forEach>
				<script type="text/javascript">
					window.monetateQ.push([ "addProducts", monetateComponentProductList ]);
					window.monetateQ.push(["trackData"]);
				</script>
			</div>
		</div>
		</div>
		<div class="row h-space-2">
			<div class="col-xs-12 col-md-9"></div>
			<div class="col-xs-12 col-md-3">
				<a tabindex="0" href="/checkout?steppedCheckout=true" class="btn btn-primary pull-right btn--auto-width-desktop hidden-xs no-border">
					<div class="btn__text-wrapper">
						<span class="btn__text"> <spring:theme code="checkout.checkout" /></span>
						<span class="icon icon-chevron-right btn__icon"></span>
					</div>
				</a>
			</div>
		</div>
		<checkout:checkoutProgressBar currentStep="1" totalSteps="2" position="bottom"/>
	</c:if>
</div>

<checkout:checkoutTwoStepFixedFooter currentStep="1"/>

<favourites:newFavouritiesList/>
<order:quantityOrderModals />
<cart:quantityCartModals/>

<nav:plpHandlebarsTemplates />
<nav:similarProductsHandlebarsTemplate/>
