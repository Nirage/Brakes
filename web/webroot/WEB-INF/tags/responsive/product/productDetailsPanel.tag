<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>
<%@ taglib prefix="analytics" tagdir="/WEB-INF/tags/shared/analytics" %>

<sec:authorize access="!hasRole('ROLE_ANONYMOUS')">
	<c:set var="isUserLoggedIn" value="true"/>
</sec:authorize>

<c:set var="showPromotion">
	<promotions:showPromotion product="${product}" isLoggedIn="${isUserLoggedIn}"/>
</c:set>

<analytics:googleAnalyticsProducts productListing="${[ product ]}"/>

<div class="container">
	<div class="row flex flex-direction-reverse-column-xs">			
		<div class="col-xs-12 col-sm-6">
			<div class="row product-details__icons-row visible-xs">
				<div class="col-xs-8">
					<div class="flex align-items-center">
						<div class="product-details__promo-icon ${showPromotion ? '' : 'hidden'} js-productPromoIcon" data-code="${product.code}">
							<span class="bg-promo-red br1 text-white text-uppercase text-bold p1-4 plr1-2"><spring:theme code="product.promotion.offer"></spring:theme></span>
						</div>
						<c:if test="${product.newProduct}">
							<div class="product-details__promo-icon flex align-items-center">
								<span class="icon icon-new icon-new--royal-blue"></span>
							</div>
						</c:if>
						<div class="product-details__advice-icons flex">
							<c:forEach items="${product.productInfoIcons}" var="productInfoIcon">
								<img src="https://brakes.a.bigcontent.io/v1/static/icon-${productInfoIcon}" alt="icon-${productInfoIcon}"/>
							</c:forEach>
						</div>
					</div>
				</div>
				<div class="col-xs-4">
					<div class="product-details__add-to-favourites add-to-favourites js-userActions">
						<product:productAddToFavouritePanel product="${product}" showText="true" />
					</div>
				</div>
			</div>
			<product:productImagePanel galleryImages="${galleryImages}" />
		</div>
		<div class="col-xs-12 col-sm-6">
			<ycommerce:testId code="productDetails_productNamePrice_label_${product.code}">
				<div class="product-details__code">${fn:escapeXml(product.prefix)}&nbsp;${fn:escapeXml(product.code)}</div>
				<h1 class="product-details__name no-content">${fn:escapeXml(product.name)}</h1>
			</ycommerce:testId>
			<div class="product-details__size product-size col-xs-12 hidden-md hidden-lg h-space-1 h-topspace-1 p-0">
				<div class="product-size__item product-size__item--size-pack col-xs-6 p-0"><spring:theme code="product.details.packSize"/>: ${product.packSize}</div>
				<c:if test="${product.unitsPerCase gt 1}"> 
					<div class="product-size__item--size-case col-xs-6 text-bold"><spring:theme code="product.grid.caseSize"/>: ${product.unitsPerCase}</div>
				</c:if>				
			</div>
			<c:if test="${fn:containsIgnoreCase(product.channelStatus, 'CLEARANCE')}">
				<div class="product-details__stock-msg product-details__stock-msg--out-of-stock"><spring:theme code="product.status.clearance"/></div>
			</c:if>
			<div class="row product-details__icons-row  js-productDetail visible-sm visible-md visible-lg h-space-2">
				<div class="col-sm-6 h-space-2">
					<div class="flex align-items-center col-sm-6 p-0">
						<div class="product-details__promo-icon ${showPromotion ? '' : 'hidden'} js-productPromoIcon" data-code="${product.code}">
							<span class="bg-promo-red br1 text-white text-uppercase text-bold p1-4 plr1-2"><spring:theme code="product.promotion.offer"></spring:theme></span>
						</div>
						<c:if test="${product.newProduct}">
							<div class="product-details__promo-icon flex align-items-center">
								<span class="icon icon-new icon-new--royal-blue"></span>
							</div>
						</c:if>
						<div class="product-details__advice-icons flex">
							<c:forEach items="${product.productInfoIcons}" var="productInfoIcon">
								<span title="<spring:theme code="icon.title.${productInfoIcon}"/>">
									<img src="https://brakes.a.bigcontent.io/v1/static/icon-${productInfoIcon}" alt="icon-${productInfoIcon}"/>
								</span>
							</c:forEach>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="product-details__add-to-favourites add-to-favourites js-userActions">
						<product:productAddToFavouritePanel product="${product}" showText="true" />
					</div>
				</div>
			</div>

			<hr class="product-details__divider visible-md visible-lg" />
			<components:productActionsPanel customCSSClass="visible-md visible-lg desktop" />
			<hr class="product-details__divider visible-md visible-lg" />
			<div class="visible-md visible-lg outOfStock__section">
			<product:outOfStockPdp/>
			</div>


			<cms:pageSlot position="VariantSelector" var="component" element="div" class="product-details__variant-selector">
				<cms:component component="${component}" element="div" class="yComponentWrapper page-details-variants-select-component"/>
			</cms:pageSlot>

			<div class="product-details__promotion">
				<product:productPromotionSection product="${product}"/>
			</div>

			<ycommerce:testId code="productDetails_content_label visible-sm visible-md visible-lg">
				<div id="jsProductDetailsDesc" class="product-details__description js-productDetailsDesc p-0">
					<div class="js-productDetailsDescText">
						${ycommerce:sanitizeHTML(product.secondaryTitle)}<br/><br/>${ycommerce:sanitizeHTML(product.shortMarketingDesc)}
					</div>
				</div>
			</ycommerce:testId>

			<c:if test="${product.isDiscontinued eq true}">
				<div class="discontinued__section hidden-sm">	
					<p class="discontinued__title"><spring:theme code="discontinued.pdp.title"></spring:theme></p>
					<p class="discontinued__content"><spring:theme code="discontinued.pdp.content"></spring:theme><p>
				</div>
			</c:if>
			
		</div>
		
	</div>

	<hr class="product-details__divider visible-xs visible-sm" />
	<components:productActionsPanel customCSSClass="visible-xs visible-sm mobile tablet" />
	<hr class="product-details__divider visible-xs visible-sm h-space-1" />
	<div class="visible-xs visible-sm outOfStock__section">
			
			<product:outOfStockPdp/>
			</div>
	<div class="col-xs-12 visible-xs">
		<ycommerce:testId code="productDetails_content_label">
			<div id="jsProductDetailsDesc" class="product-details__description js-productDetailsDesc p-0">
				<div class="js-productDetailsDescText">
					${ycommerce:sanitizeHTML(product.secondaryTitle)}<br/><br/>${ycommerce:sanitizeHTML(product.shortMarketingDesc)}
				</div>
			</div>
		</ycommerce:testId>
		
	</div>
		<c:if test="${product.isDiscontinued eq true}">
				<div class="discontinued__section visible-sm visible-xs">	
					<p class="discontinued__title"><spring:theme code="discontinued.pdp.title"></spring:theme></p>
					<p class="discontinued__content"><spring:theme code="discontinued.pdp.content"></spring:theme><p>
				</div>
		</c:if>

</div><%-- /.container --%>

	<script id="product-desc-template" type="text/x-handlebars-template">
		{{#with this}}
			<div class="js-productDetailsDescText">
				{{#if showReadMore}}
					{{{part1}}}<span class="js-prodMoreEllipses">...</span><span class="js-prodMoreText hide">{{{part2}}}</span>
				{{else}}
					{{{part1}}}<span class="js-prodMoreText">{{{part2}}}</span>
				{{/if}}
			</div>

			{{#if showReadMore}}
				<span class="product-details__readmore js-expandProdDesc"><spring:theme code="productDesc.readmore" /></span>
				<span class="product-details__readless js-collapseProdDesc hide"><spring:theme code="productDesc.readless" /></span>
			{{/if}}
		{{/with}}
	</script>
<favourites:newFavouritiesList/>
<div class="js_spinner spinning-div">
  <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>
	<product:tradeCalculatorModal />
