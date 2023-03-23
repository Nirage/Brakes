<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="pagination" tagdir="/WEB-INF/tags/responsive/nav/pagination" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="statusParam" value="" />
<c:if test="${not empty appliedFilters}">
	<c:set var="statusParam" value="&status=${appliedFilters}" />
</c:if>

<c:set var="searchUrl" value="/my-account/orders?sort=${ycommerce:encodeUrl(searchPageData.pagination.sort)}${statusParam}"/>
<spring:url value="/my-account/recent-purchased-products" var="recentlyPurchasedUrl" htmlEscape="false"/>

	<cms:pageSlot position="WeatherContent" var="comp" >
		<c:set var="hasComponentClass" value="order-history__header--has-component" />
		<c:set var="WeatherContent">
			<cms:component component="${comp}"/>
		</c:set>
	</cms:pageSlot>

<div class="container">
	<div class="order-history">

		<c:if test="${noPreviousOrders eq false}">
			<div class="order-history__header ${hasComponentClass}">
				<div>
					<div class="site-header site-header--align-left order-history__site-header">
						<h1 class="site-header__text site-header--align-left">
							<spring:theme code="text.account.orderHistory" />
						</h1>
						<span class="site-header__rectangle site-header__rectangle--align-left"></span>
					</div>
					<div class="order-history__view-recent hidden-xs hidden-md hidden-lg">
						<a tabindex="0" class="btn btn-primary js-orderHistoryRecent" href="${recentlyPurchasedUrl}">
							<spring:theme code="text.account.orderHistory.recentlyPurchasedCTA" />
						</a>
					</div>
					${WeatherContent}
				</div>
				<div class="order-history__view-recent hidden-sm">
					<a tabindex="0" class="btn btn-primary js-orderHistoryRecent" href="${recentlyPurchasedUrl}">
						<spring:theme code="text.account.orderHistory.recentlyPurchasedCTA" />
					</a>
				</div>
			</div>

			<nav:actionsBarOrderHistory top="true" msgKey="text.account.orderHistory.page" supportShowPaged="${isShowPageAllowed}" supportShowAll="${isShowAllAllowed}" searchPageData="${searchPageData}" searchUrl="${searchUrl}" numberPagesShown="${numberPagesShown}" />

			<div class="row">
					<c:forEach items="${searchPageData.results}" var="order">
						<order:orderHistoryItem order="${order}" />
					</c:forEach>
			</div>

			<div class="order-history__bottom-pagination">
				<pagination:bottomPagination msgKey="text.account.orderHistory.page" searchPageData="${searchPageData}" searchUrl="${searchUrl}"  numberPagesShown="${numberPagesShown}"/>
			</div>
		</c:if>

		<c:if test="${noPreviousOrders eq true}">
			<div class="order-history-empty">
				<div class="order-history__header ${hasComponentClass}">
					<div class="site-header site-header--align-left order-history__site-header">
						<h1 class="site-header__text site-header--align-left">
							<spring:theme code="text.account.orderHistory" />
						</h1>
						<span class="site-header__rectangle site-header__rectangle--align-left"></span>
					</div>
				</div>
				<div class="order-history-empty__content">
					<ycommerce:testId code="orderHistory_noOrders_label">
						<p class="order-history-empty__text"><spring:theme code="text.account.orderHistory.emptyOrderHistory" /></p>
					</ycommerce:testId>
					<a class="btn btn-primary order-history-empty__btn" href="/">
						<spring:theme code="text.account.orderHistory.emptyCTA" />
					</a>
				</div>
			</div>
		</c:if>

		<c:if test="${empty searchPageData.results && noPreviousOrders eq false}">
			<div class="order-history-empty__content">
				<p class="order-history-empty__text"><spring:theme code="text.account.orderHistory.noOrdersForSelection" /></p>
			</div>
		</c:if>

	</div>
</div>
<order:orderAmmendErrorModal />