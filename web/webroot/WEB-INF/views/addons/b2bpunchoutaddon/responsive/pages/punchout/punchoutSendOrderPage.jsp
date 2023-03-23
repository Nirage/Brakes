<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="header" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/common/header"%>

<template:master pageTitle="${pageTitle}">
	<jsp:attribute name="pageCss">
		<link rel="stylesheet" type="text/css" media="all" href="${themeResourcePath}/css/loadingPage.bundle.css?${releaseVersion}" />
	</jsp:attribute>

	<jsp:attribute name="pageScripts">
		<script  type="text/javascript">
			window.onload = function(){
				document.getElementById('js-loading-page').querySelector('form').submit();
			}
		</script>
	</jsp:attribute>

	<jsp:body>
		<main data-currency-iso-code="${fn:escapeXml(currentCurrency.isocode)}">
			<header:header hideMainNav="true" hideTopNav="true" />
			<div id="js-loading-page" class="container loading-page">
				<form id="procurementForm" method="post" action="${fn:escapeXml(browseFormPostUrl)}">
					<input type="hidden" name="cxml-base64" value="${fn:escapeXml(orderAsCXML)}">
				</form>
				<div class="row p1">
					<div class="col-xs-12 flex align-items-center justify-content-center flex-direction-column loading-page--min-height">
						<div class="font-primary-bold font-size-2 mb2 text-center"><spring:theme code="punchout.custom.message.redirecting"/></div>
						<div class="car position-relative mt2">
							<div class="car__lines position-absolute">
								<span class="loading-page__line loading-page__line--top"></span>
								<span class="loading-page__line loading-page__line--middle"></span>
								<span class="loading-page__line loading-page__line--bottom"></span>
							</div>
							<div class="car__body flex"></div>
							<div class="car__wheels position-absolute flex">
								<span class="loading-page__wheel loading-page__wheel--right"></span>
								<span class="loading-page__wheel loading-page__wheel--left"></span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</main>
	</jsp:body>
</template:master>
