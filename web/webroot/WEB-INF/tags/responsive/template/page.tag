<%@ tag body-content="scriptless" trimDirectiveWhitespaces="true"%>
<%@ attribute name="pageTitle" required="false" rtexprvalue="true"%>
<%@ attribute name="pageCss" required="false" fragment="true"%>
<%@ attribute name="pageScripts" required="false" fragment="true"%>
<%@ attribute name="hideHeaderLinks" required="false"%>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="header" tagdir="/WEB-INF/tags/responsive/common/header"%>
<%@ taglib prefix="footer" tagdir="/WEB-INF/tags/responsive/common/footer"%>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="helpers" tagdir="/WEB-INF/tags/shared/helpers"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:master pageTitle="${pageTitle}">

	<jsp:attribute name="pageCss">
		<jsp:invoke fragment="pageCss" />
	</jsp:attribute>

	<jsp:attribute name="pageScripts">
		<jsp:invoke fragment="pageScripts" />
	</jsp:attribute>

	<jsp:body>


		<main data-currency-iso-code="${fn:escapeXml(currentCurrency.isocode)}" class="${cmsPage.stripHeader ? 'stripped-down': ''}">
		<c:choose>
			<c:when test="${cmsPage.stripHeader}">
				<header:strippedDownHeader />
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${cmsPage.uid eq 'checkoutPage'}">
						<header:strippedDownHeader hideHeaderLinks="${hideHeaderLinks}" />
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${cmsPage.uid eq 'checkoutIframePage'}">
								<header:strippedDownHeader hideHeaderLinks="${hideHeaderLinks}" />
							</c:when>
							<c:otherwise>
								 <header:header hideHeaderLinks="${hideHeaderLinks}" />
							</c:otherwise>
						</c:choose>	
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
			<a id="skip-to-content"></a>
			<div class="site-content js-site-content">
				<div class="main__inner-wrapper">
					<common:globalMessages />
					<cart:cartRestoration />
					<cart:cartValidChecks />
					<jsp:doBody />
					<common:structuredData />
				</div>

			<c:choose>
				<c:when test="${cmsPage.stripFooter}">
					<footer:strippedDownFooter />
				</c:when>
				<c:otherwise>
						<footer:footer />
				</c:otherwise>
			</c:choose>

			</div><%-- END site-content --%>
			<div class="offcanvas-overlay"></div>
			<div class="search-overlay"></div>
		</main>
		<div class="js-mobileWishlistHolder mobile-wishlist-holder"></div>
	</jsp:body>

</template:master>
