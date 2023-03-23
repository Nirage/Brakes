<%@ tag body-content="scriptless" trimDirectiveWhitespaces="true" %>
<%@ attribute name="pageTitle" required="false" rtexprvalue="true" %>
<%@ attribute name="metaDescription" required="false" %>
<%@ attribute name="metaKeywords" required="false" %>
<%@ attribute name="pageCss" required="false" fragment="true" %>
<%@ attribute name="pageScripts" required="false" fragment="true" %>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="analytics" tagdir="/WEB-INF/tags/shared/analytics" %>
<%@ taglib prefix="sso" tagdir="/WEB-INF/tags/shared/sso" %>
<%@ taglib prefix="monetate" tagdir="/WEB-INF/tags/shared/monetate" %>
<%@ taglib prefix="sfwebbeacon" tagdir="/WEB-INF/tags/shared/sfwebbeacon" %>
<%@ taglib prefix="addonScripts" tagdir="/WEB-INF/tags/responsive/common/header" %>
<%@ taglib prefix="generatedVariables" tagdir="/WEB-INF/tags/shared/variables" %>
<%@ taglib prefix="debug" tagdir="/WEB-INF/tags/shared/debug" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="htmlmeta" uri="http://hybris.com/tld/htmlmeta"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>

<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<c:choose>
 <c:when test="${cmsSite.uid == 'brakes'}">
    <c:set var="googleAnalyticsTrackingId" value="${googleAnalyticsTrackingIdbrakes}" />
 </c:when>
 <c:when test="${cmsSite.uid == 'countryChoice'}">
     <c:set var="googleAnalyticsTrackingId" value="${googleAnalyticsTrackingIdcountryChoice}" />
  </c:when>
  <c:when test="${cmsSite.uid == 'brakesfoodshop'}">
     <c:set var="googleAnalyticsTrackingId" value="${googleAnalyticsTrackingIdbrakesfoodshop}" />
  </c:when>
</c:choose>

<!DOCTYPE html>
<html lang="${fn:escapeXml(currentLanguage.isocode)}" class="no-js">
<head>
    <c:if test="${enableSfwebBeaconTag}">
	    <sfwebbeacon:sfwebbeaconTag/>
	</c:if>
	<monetate:monetateTag/>
	<title>
		${not empty pageTitle ? pageTitle : not empty cmsPage.title ? fn:escapeXml(cmsPage.title) : 'Accelerator Title'}
	</title>

	<%-- Meta Content --%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
	<meta name="format-detection" content="telephone=no">
	
	<%-- Additional meta tags --%>
	<htmlmeta:meta items="${metatags}"/>

	<%-- Additional canonical tags --%>
	<link rel="canonical" href="${canonicalFlag}"/>

	<%-- Favourite Icon --%>
	<link rel="shortcut icon" type="image/x-icon" media="all" href="${themeResourcePath}/images/favicon-32x32.png" />

	<%-- Fonts Preload --%>
	<link rel="preload" href="${fn:escapeXml(themeResourcePath)}/fonts/BrandonText-Regular.otf" as="font" type="font/otf" crossorigin />
	<link rel="preload" href="${fn:escapeXml(themeResourcePath)}/fonts/BrandonText-Bold.otf" as="font" type="font/otf" crossorigin />
	<link rel="preload" href="${fn:escapeXml(themeResourcePath)}/fonts/iconsbrakesgroup.ttf" as="font" type="font/ttf" crossorigin />
	<link rel="preload" href="${fn:escapeXml(themeResourcePath)}/fonts/glyphicons-halflings-regular.woff2" as="font" type="font/woff2" crossorigin />

	<product:productPagination />
	<%-- CSS Files Are Loaded First as they can be downloaded in parallel --%>
	<template:styleSheets/>

	<%-- Inject any additional CSS required by the page --%>
	<jsp:invoke fragment="pageCss"/>
	<analytics:analytics googleGTMId="${googleAnalyticsTrackingId}"/>

	<%-- Check if JavaScript is enabled on site --%>
	<script type="text/javascript">
  	document.documentElement.className = document.documentElement.className.replace("no-js","js");
	</script>
	<%-- Picturefill --%>
	<script type="text/javascript" src="/_ui/responsive/common/js/picturefill.min.js?${releaseVersion}" async></script>
	<generatedVariables:generatedVariables/>
</head>

<body class="${pageBodyCssClasses} ${cmsPageRequestContextData.liveEdit ? ' yCmsLiveEdit' : ''} language-${fn:escapeXml(currentLanguage.isocode)} site-${siteUid}">

    <c:set var="showSimilarInPage" value="${not empty cmsPage.showSimilar ? cmsPage.showSimilar : 'true'}" />
    <c:set var="showPerfectWithInPage" value="${not empty cmsPage.showPerfectWith ? cmsPage.showPerfectWith : 'true'}" />
	<c:if test="${not empty googleAnalyticsTrackingId}">
	<!-- Google Tag Manager (noscript) -->
	<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=${ycommerce:encodeJavaScript(googleAnalyticsTrackingId)}"
	height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
	<!-- End Google Tag Manager (noscript) -->
	</c:if>
	<analytics:googleAnalytics/>

	<%-- Inject the page body here --%>
	<jsp:doBody/>

	<cart:printBasket/>

	<cart:printMiniBasketHolder />
	<%-- Used for Print on wishlist pages --%>
  <div id="jsFavouritesPrintTable" class="visible-print-block" ></div>

	<form name="accessiblityForm">
		<input type="hidden" id="accesibility_refreshScreenReaderBufferField" name="accesibility_refreshScreenReaderBufferField" value=""/>
	</form>
	<div id="ariaStatusMsg" class="skip" role="status" aria-relevant="text" aria-live="polite"></div>

	<%-- Load JavaScript required by the site --%>
	<template:javaScript/>
	
	<%-- Inject any additional JavaScript required by the page --%>
	<jsp:invoke fragment="pageScripts"/>

	<%-- Inject CMS Components from addons using the placeholder slot--%>
	<addonScripts:addonScripts/>
</body>

<debug:debugFooter/>

</html>
