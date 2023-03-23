<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="cms" tagdir="/WEB-INF/tags/responsive/template/cms" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>

<c:url value="/" var="siteRootUrl"/>

<template:javaScriptVariables/>

<%-- Polyfill to be requested on ONLY ie11 --%>
<script type="text/javascript" nomodule src="/_ui/responsive/theme-brakes/js/polyfill.bundle.js?${releaseVersion}"></script>
<%-- Plugins Bundle --%>
<script type="text/javascript" src="/_ui/responsive/theme-brakes/js/plugins.bundle.js?${releaseVersion}"></script>

<c:choose>
	<c:when test="${wro4jEnabled}">
	  	<script type="text/javascript" src="${contextPath}/wro/brakes-group.min.js?${releaseVersion}"></script>
	  	<script type="text/javascript" src="${contextPath}/wro/addons_responsive.js?${releaseVersion}"></script>
	</c:when>
	<c:otherwise>
		<%-- Old plugins --%>
		<script type="text/javascript" src="${commonResourcePath}/js/enquire.min.js?${releaseVersion}"></script>
		<script type="text/javascript" src="${commonResourcePath}/js/handlebars.min.js?${releaseVersion}"></script>
		<script type="text/javascript" src="${commonResourcePath}/js/handlebarsHelpers.js?${releaseVersion}"></script>
		<script type="text/javascript" src="${commonResourcePath}/js/jquery-ui-1.12.1.custom.min.js?${releaseVersion}"></script>

		<script type="text/javascript" src="${commonResourcePath}/js/utils.js?${releaseVersion}"></script>

		<%-- Cms Action JavaScript files --%>
		<c:forEach items="${cmsActionsJsFiles}" var="actionJsFile">
		    <script type="text/javascript" src="${commonResourcePath}/js/cms/${actionJsFile}"></script>
		</c:forEach>

		<%-- AddOn JavaScript files --%>
		<c:forEach items="${addOnJavaScriptPaths}" var="addOnJavaScript">
		    <script type="text/javascript" src="${addOnJavaScript}"></script>
		</c:forEach>
	</c:otherwise>
</c:choose>

<%-- All pageload Bundles --%>
<script type="text/javascript" src="/_ui/responsive/theme-brakes/js/base.bundle.js?${releaseVersion}"></script>

<%-- CMS Page Specific Bundles --%>
<c:if test="${cmsPage.uid eq 'update-profile'}">
	<script type="text/javascript" src="/_ui/responsive/theme-brakes/js/verticalTabs.bundle.js?${releaseVersion}" async></script>
</c:if>

<c:if test="${cmsPage.uid eq 'sfRegister'}">
	<script type="text/javascript" src="/_ui/responsive/theme-brakes/js/register.bundle.js?${releaseVersion}"></script>
</c:if>

<c:if test="${cmsPage.uid eq 'productGrid' or cmsPage.uid eq 'searchGrid' or cmsPage.uid eq 'OccasionsSearchGrid' or cmsPage.uid eq 'recentPurchasedProductsPage' or cmsPage.uid eq 'myPromoProducts'}">
    <script type="text/javascript" src="/_ui/responsive/theme-brakes/js/plp.bundle.js?${releaseVersion}"></script>
</c:if>

<c:if test="${cmsPage.uid eq 'productDetails'}">
	<script type="text/javascript" src="/_ui/responsive/common/js/viewer.min.js?${releaseVersion}"> </script>
	<product:viewerKitConfig/>
</c:if>

<c:if test="${cmsPage.uid eq 'cartPage'}">
    <script type="text/javascript" src="/_ui/responsive/theme-brakes/js/cart.bundle.js?${releaseVersion}"></script>
</c:if>

<c:if test="${cmsPage.uid eq 'checkoutPage'}">
    <script type="text/javascript" src="/_ui/responsive/theme-brakes/js/checkout.bundle.js?${releaseVersion}"></script>
</c:if>

<cms:previewJS cmsPageRequestContextData="${cmsPageRequestContextData}" />
