<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<spring:htmlEscape defaultHtmlEscape="true" />

<%-- JS configuration --%>
	<script type="text/javascript">
		/*<![CDATA[*/
		<%-- Define a javascript variable to hold the content path --%>
		var ACC = { config: {} };
			ACC.config.contextPath = '${ycommerce:encodeJavaScript(contextPath)}';
			ACC.config.encodedContextPath = '${ycommerce:encodeJavaScript(encodedContextPath)}';
			ACC.config.commonResourcePath = '${ycommerce:encodeJavaScript(commonResourcePath)}';
			ACC.config.themeResourcePath = '${ycommerce:encodeJavaScript(themeResourcePath)}';
			ACC.config.siteResourcePath = '${ycommerce:encodeJavaScript(siteResourcePath)}';
			<%-- //TODO for BED add property which can be changed based on the enviroment. For prod and UAT it should be https://c1.adis.ws/v1/content/Brakes/ for local we can use : https://s9lcbdcgpud11r9yndz58l6zo.staging.bigcontent.io/v1/content/brake/ --%>
			ACC.config.amplienceDomainName = "https://c1.adis.ws/v1/content/Brakes/",
			ACC.config.rootPath = '${ycommerce:encodeJavaScript(siteRootUrl)}';
			ACC.config.CSRFToken = '${ycommerce:encodeJavaScript(CSRFToken.token)}';
			ACC.pwdStrengthVeryWeak = '<spring:theme code="password.strength.veryweak" htmlEscape="false" javaScriptEscape="true" />';
			ACC.pwdStrengthWeak = '<spring:theme code="password.strength.weak" htmlEscape="false" javaScriptEscape="true" />';
			ACC.pwdStrengthMedium = '<spring:theme code="password.strength.medium" htmlEscape="false" javaScriptEscape="true" />';
			ACC.pwdStrengthStrong = '<spring:theme code="password.strength.strong" htmlEscape="false" javaScriptEscape="true" />';
			ACC.pwdStrengthVeryStrong = '<spring:theme code="password.strength.verystrong" htmlEscape="false" javaScriptEscape="true" />';
			ACC.pwdStrengthUnsafePwd = '<spring:theme code="password.strength.unsafepwd" htmlEscape="false" javaScriptEscape="true" />';
			ACC.pwdStrengthTooShortPwd = '<spring:theme code="password.strength.tooshortpwd" htmlEscape="false" javaScriptEscape="true" />';
			ACC.pwdStrengthMinCharText = '<spring:theme code="password.strength.minchartext" htmlEscape="false" javaScriptEscape="true" />';
			ACC.accessibilityLoading = '<spring:theme code="aria.pickupinstore.loading" htmlEscape="false" javaScriptEscape="true" />';
			ACC.accessibilityStoresLoaded = '<spring:theme code="aria.pickupinstore.storesloaded" htmlEscape="false" javaScriptEscape="true" />';
			ACC.config.wishlistCreated = '<spring:theme code="wishlist.create.success" />';
			ACC.config.addWishlistToCartFailed = '<spring:theme code="wishlist.addToCartFailed.modal.error" />';
			ACC.config.wishlistItemRemoved = '<spring:theme code="wishlist.item.removed" />'
			ACC.config.poInvalid = '<spring:theme code="ponumber.invalid" />'
			ACC.config.googleApiKey='${ycommerce:encodeJavaScript(googleApiKey)}';
			ACC.config.googleApiVersion='${ycommerce:encodeJavaScript(googleApiVersion)}';
			ACC.config.ajaxPricingEnabled='${ycommerce:encodeJavaScript(ajaxPricingEnabled)}';
			ACC.config.searchTimePricingEnabled='${ycommerce:encodeJavaScript(searchTimePricingEnabled)}';
			ACC.config.pcaApiKey='${ycommerce:encodeJavaScript(pcaApiKey)}';
			ACC.config.pcaFindURL='${ycommerce:encodeJavaScript(pcaFindURL)}';
			ACC.config.isb2cSite=${isb2cSite};
			ACC.config.isHomePage=${isHomePage};
			ACC.config.pcaRetrieveURL='${ycommerce:encodeJavaScript(pcaRetrieveURL)}';
			ACC.config.addToCartUrl='/cart/add';
            ACC.config.notLoggedInAddAction='/cart/notLoggedInAddAction';
			ACC.config.updateCartUrl='/cart/update';
			ACC.config.updateAmmendCartUrl='/my-account/addToAmendOrder';
			ACC.config.salesLocalRepUrl='/localSalesRepResults';
			ACC.config.productPromoUrl="/productpromo";
			ACC.config.resultFacet = "/resultsandfacets";
			ACC.config.promoResultFacet = "/my-promo-products/resultsandfacets";
			<c:if test="${siteUid eq 'brakes'}">
			ACC.config.promoResultFacet = "/promotions/resultsandfacets";
			</c:if>
			ACC.config.alterativeBaseUrl = "/search-result-references?";
            ACC.config.alternativeUrl = "&type=ALTERNATIVES";
            ACC.config.prfectWithUrl = "&type=PERFECT_WITH";
			ACC.config.purchaseOrder= {
				invalid: '<spring:theme code="cart.purchaseOrder.invalid" />',
				provide: '<spring:theme code="cart.purchaseOrder.provide" />',
				incorrect: '<spring:theme code="cart.purchaseOrder.incorrect" />'
			};
			ACC.config.priceUnavailable='<spring:theme code="product.external.price.unavailable" />';
			ACC.config.categoryDesc = {
				<%-- Optional: if needed these valuescan be replaced with values coming from properties --%>
				mobileLength: 51, 
				desktopLength: 261
			};
			ACC.config.productDesc = {
				<%-- Optional: if needed these valuescan be replaced with values coming from properties --%>
				mobileLength: 121, 
				tabletLength: 154,
				desktopLength: 163
			};
			<c:if test="${request.secure}">
				<c:url var="autocompleteUrl" value="/search/autocompleteSecure" />
			</c:if>
			<c:if test="${not request.secure}">
				<c:url var="autocompleteUrl" value="/search/autocomplete" />
			</c:if>
			ACC.autocompleteUrl = '${ycommerce:encodeJavaScript(autocompleteUrl)}';

			<c:url value="/sign-in" var="loginUrl"/>
			ACC.config.loginUrl = '${ycommerce:encodeJavaScript(loginUrl)}';

			<c:url value="/cart/notLoggedInAddAction" var="notLoggedInAddAction"/>
			ACC.config.loginStatusUrl = '/_s/login-status';
			ACC.config.loginUrl = '${ycommerce:encodeJavaScript(loginUrl)}';
			<c:url value="/externalPrices" var="pricingUrl"/>
			ACC.config.pricingUrl = '${ycommerce:encodeJavaScript(pricingUrl)}';
			ACC.config.createwishlist = '/favourite/rollover/create';

			<c:if test="${cmsPage.uid eq 'productGrid'}">
				ACC.config.plp = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'searchGrid'}">
				ACC.config.search = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'productDetails'}">
				ACC.config.pdp = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'favouriteItemGrid'}">
				ACC.config.favouriteslist = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'myPromoProducts'}">
			  ACC.config.promoPage = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'cartPage'}">
				ACC.config.cartPage = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'checkoutPage'}">
				ACC.config.cartPage = true;
				ACC.config.checkoutPage = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'amendorder'}">
				ACC.config.amendOrderPage = true;
			</c:if>
			<c:if test="${cmsPage.uid eq 'recentPurchasedProductsPage'}">
				ACC.config.recentPage = true;
			</c:if>
			ACC.config.registerBrakesInPast = '<spring:theme code="register.brakesInPast" />'
            ACC.config.registerOther = '<spring:theme code="register.other" />'
            ACC.config.registerGoogle = '<spring:theme code="register.google" />'
			<c:if test="${cmsPage.uid eq 'update-profile'}">
				ACC.config.mydetails = true;
			</c:if>

			ACC.config.b2cAddDeliveryAddressEndpoint = "/b2c-checkout-add-details/popup";
			ACC.config.b2cForgottenPasswordEndpoint = "/forgot-password";
			ACC.config.b2cRegisterAccountEndpoint = "/register-checkout/popup";
			ACC.config.b2cCheckRegisterEmailEndpoint = "/b2c-register/email-exists?email=";
			ACC.config.b2cCheckRegisterAccountEndpoint = "/b2c-register";

			ACC.config.viewPromotion = '${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }';


			<c:url var="authenticationStatusUrl" value="/authentication/status" />
			ACC.config.authenticationStatusUrl = '${ycommerce:encodeJavaScript(authenticationStatusUrl)}';
			<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
				ACC.config.authenticated = true;
			</sec:authorize>
			<c:forEach var="jsVar" items="${jsVariables}">
				<c:if test="${not empty jsVar.qualifier}" >
				ACC['${ycommerce:encodeJavaScript(jsVar.qualifier)}'] = '${ycommerce:encodeJavaScript(jsVar.value)}';
				</c:if>
			</c:forEach>
		/*]]>*/
		ACC.config.currencyISO = "${currentCurrency.isocode}";
		ACC.config.currencySymbol = "${currentCurrency.symbol}";
		ACC.config.invalidVoucher = '<spring:theme code="text.voucher.apply.invalid.error" />';
		ACC.config.expiredVoucher = '<spring:theme code="text.voucher.apply.invalid.expired" />';
		ACC.config.redeemedVoucher = '<spring:theme code="text.voucher.apply.invalid.redeemed" />';
		ACC.config.voucherExists = '<spring:theme code="text.voucher.apply.error.exists" />';
		ACC.config.voucherApplySuccess = '<spring:theme code="text.voucher.apply.applied.success" />';
		ACC.config.voucherGeneralInfo = '<spring:theme code="text.voucher.info.content"/>';
		ACC.config.pageId = "${cmsPage.uid}";
		ACC.config.dwellChatOpenTimer = ${cmsSite.dwellChatOpenTimer};
		ACC.config.dwellChatCloseTimer = ${cmsSite.dwellChatCloseTimer};
		ACC.config.dwellChatMinimumIdleAgents = ${cmsSite.dwellChatMinimumIdleAgents};
		ACC.config.ccv2Environment = '${amplienceEnvironment}';
	</script>
	<template:javaScriptAddOnsVariables/>

	<%-- generated variables from commonVariables.properties --%>
	<script type="text/javascript" src="${fn:escapeXml(sharedResourcePath)}/js/generatedVariables.js?${releaseVersion}"></script>
	