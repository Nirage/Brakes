<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/template"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
	<c:url value="/" var="homePageUrl" />
	<cms:pageSlot position="SideContent" var="feature" element="div" class="side-content-slot cms_disp-img_slot searchEmptyPageTop">
		<cms:component component="${feature}" element="div" class="no-space yComponentWrapper searchEmptyPageTop-component"/>
	</cms:pageSlot>

	<div class="content">
		<div class="site-component">
			<div class="container">
				<div class="row">
					<div class="col-xs-12">
						<div class="search-empty">
							<div class="headline">
								<spring:theme code="search.no.results" arguments="${searchPageData.freeTextSearch}" var="noSearchResults" htmlEscape="false"/>
								<h2 class="site-header__text site-header__text--underline site-header__text--underline-left">
									${ycommerce:sanitizeHTML(noSearchResults)}
								</h2>
							</div>
							<spring:theme code="search.no.results.sub.title" arguments="${searchPageData.freeTextSearch}" var="noSearchResultsSubTiltle" htmlEscape="false" />
							<p class="site-header__subtext">
								${ycommerce:sanitizeHTML(noSearchResultsSubTiltle)}
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<cms:pageSlot position="MiddleContent" var="comp" element="div" class="searchEmptyPageMiddle">
		<cms:component component="${comp}" element="div" class="no-space yComponentWrapper searchEmptyPageMiddle-component"/>
	</cms:pageSlot>

	<cms:pageSlot position="BottomContent" var="comp" element="div" class="searchEmptyPageBottom">
		<cms:component component="${comp}" element="div" class="no-space yComponentWrapper searchEmptyPageBottom-component"/>
	</cms:pageSlot>
</template:page>