<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="favourite" required="false" type="com.envoydigital.brakes.facades.wishlist.data.FavouritesData" %>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="favourite" tagdir="/WEB-INF/tags/responsive/favourite" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>


<c:if test="${not empty favourite && not favourite.shared}">
	<c:set var="isFavouriteProduct" value="true" />
</c:if>

<spring:htmlEscape defaultHtmlEscape="false" />

<c:set var="exceedsTabletLength" value="false" />
<c:set var="exceedsMobileLength" value="false" />


<spring:theme code="text.addToCart" var="addToCartText"/>
<c:choose>
    <c:when test="${not empty searchPageData && not empty searchPageData.freeTextSearch}">
          <c:url value="${product.url}?term=${searchPageData.freeTextSearch}" var="productUrl" />
    </c:when>
    <c:otherwise>
       <c:url value="${product.url}" var="productUrl" />
    </c:otherwise>
</c:choose>

<c:set value="product-item" var="productTagClasses"/>
<c:forEach var="tag" items="${product.tags}">
	<c:set value="${productTagClasses} tag-${tag}" var="productTagClasses"/>
</c:forEach>


<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
<c:set var="isLoggedIn" value="true" />
</sec:authorize>

<c:set var="showPromotion">
	<promotions:showPromotion product="${product}" isLoggedIn="${isLoggedIn}"/>
</c:set>
<c:set var="productStatus" value="Available"/>
<c:if test="${product.isDiscontinued eq true}">
	<c:set var="productStatus" value="Discontinued"/>
</c:if>	
<c:if test="${product.isOutOfStock eq true}">
	<c:set var="productStatus" value="Out-of-Stock"/>
</c:if>	

<div class="product-item--noborder js-productItem js-product ${(isLoggedIn && not empty product.cartEntry.quantity ? ' is-added' : '')} ${isFavouriteProduct ? ' js-favouriteItem' : ''} ${customCSSClass}" id="product-${product.code}" data-id="${product.code}" data-status="${productStatus}" data-favourite="${isFavouriteProduct ? favourite.uid : ''}" data-page=${(searchPageData.pagination.currentPage)}>
	<c:set var="showSimilarInPage" value="${not empty cmsPage.showSimilar ? cmsPage.showSimilar : 'true'}" />
	<c:set var="showPerfectWithInPage" value="${not empty cmsPage.showPerfectWith ? cmsPage.showPerfectWith : 'true'}" />

	<div class="similar__btn js-similarBtnParent">
		<c:set var="offsetClass" value=""/>
		<c:set var="perfectWith" value="false"/>			
		<c:set var="alternatives" value="false"/>	
		
		<c:if test="${product.alternatives eq false || showSimilarInPage eq false}">
			<c:set var="offsetClass" value="col-xs-offset-6"/>			
		</c:if>
		<c:if test="${product.perfectWith eq true && showPerfectWithInPage eq true}">
			<c:set var="perfectWith" value="true"/>			
		</c:if>
		<c:if test="${product.alternatives eq true && showSimilarInPage eq true}">
			<c:set var="alternatives" value="true"/>			
		</c:if>
		<c:if test="${product.alternatives && showSimilarInPage eq true}">
			<div class="similar__btn--tab  similar__btnHalf js-alternatives js-similarBtn ga-see-similar" id="ga-${productStatus}-${product.code}"  data-id="ga-${productStatus}-${product.code}" data-perfect="${perfectWith}" data-similar="${alternatives}" data-code="${product.code}">
				<div data-code="${product.code}"><spring:theme code="similar.products.title"></spring:theme></div>
			</div>
		</c:if>
		<c:if test="${product.perfectWith && showPerfectWithInPage eq true}">
			<div class="similar__btn--tab  similar__btnHalf js-alternatives js-perfectBtn ${offsetClass} ga-perfect-with" id="ga-${productStatus}-${product.code}" data-id="ga-${productStatus}-${product.code}" data-perfect="${perfectWith}" data-similar="${alternatives}" data-code="${product.code}">
				<div data-code="${product.code}"><spring:theme code="perfectWith.products.title"></spring:theme></div>
			</div>
		</c:if>
	</div>
	<div class="product-item--border ${showPromotion ? 'product-item--promotion-border overflow-hide' : ''} js-productItemBorder ${product.isDiscontinued eq true || product.isOutOfStock eq true ? 'product-item--discontinued':""}" data-code="${product.code}">
		<ycommerce:testId code="product_wholeProduct">
			<%-- Product Info & Icons --%>
			<div class="product-item__icons product-item__icons--top">
				<div class="item-icons item-icons--promo item-icons--first ${showPromotion ? '' : 'hidden'} js-productPromoIcon" data-code="${product.code}">
					<span data-code="${product.code}" class="badge badge--promotion"><spring:theme code="product.promotion.offer"></spring:theme></span>
				</div>
				<c:if test="${product.newProduct}">
					<div class="item-icons item-icons--new ${showPromotion ? 'item-icons--second' : 'item-icons--first'}">
						<span class="icon icon-new icon-new--royal-blue"></span>
					</div>
				</c:if>
				<div class="item-icons item-icons--user-actions text-right js-userActions">
					<c:if test="${isLoggedIn}">
						<c:if test="${isRecentlyPurchasedProduct}"> <%-- TODO remove when story is defined --%>
							<span class="icon icon-recent-purchases" title="buy again"></span>
						</c:if>
					</c:if>
					<c:choose>
						<c:when test="${isFavouriteProduct}">
							<favourite:editFavourite favourite="${favourite}" product="${product}" isProduct="true"/>
						</c:when>
						<c:otherwise>
							<product:productAddToFavouritePanel product="${product}"/>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			
			<a class="product-item__thumb" href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(product.name)}">
				<c:if test="${isLoggedIn}">
					<span class="product-item__qty-overlay"><spring:theme code="product.qty.overlay" arguments="${product.cartEntry.quantity}"/></span>
				</c:if>
				<product:productImageLazyLoad product="${product}" ttMobile="$plp-mobile$" ttTablet="$plp-tablet$" ttDesktop="$plp-desktop$" format="thumbnail"/>
			</a>
			<!-- Use following to get the alternatives flag ${product.alternatives} -->
			<div class="product-item__info">
				<div class="product-item__code">
					<a href="${fn:escapeXml(productUrl)}"><c:if test="${not empty product.prefix}">${fn:escapeXml(product.prefix)}&nbsp;</c:if>${product.code}</a>
				</div>
				<div class="product-item__advice-icons text-right">
					<c:forEach items="${product.productInfoIcons}" var="iconClass">
						<span title="<spring:theme code="icon.title.${iconClass}"/>">
							<img class="product-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="icon-${iconClass}"/>
						</span>
					</c:forEach>
				</div>
			</div>
			<%-- Product Name --%>
			<ycommerce:testId code="product_productName">
				<c:set var="productName" value="${fn:escapeXml(product.name)}" />
				<a class="product-item__name product-name elipsis-3-line" title="${productName}" href="${fn:escapeXml(productUrl)}">
					<c:out escapeXml="false" value="${productName}" />
				</a>
			</ycommerce:testId>
			<%-- Product Case Size --%>
			
			<div class="product-item__qty"><c:if test="${product.unitsPerCase gt 1}"><spring:theme code="product.grid.caseSize"/>: ${product.unitsPerCase}</c:if></div>
			
			<%-- Product Price --%>
			<div class="product-item__price js-productItemPrice ${not empty product.wasPrice ? 'has-was-price' : ''}">		
				<ycommerce:testId code="product_productPrice">
					<product:productPricePanel isLoggedIn="${isLoggedIn}" product="${product}"/>
				</ycommerce:testId>
				<c:forEach var="variantOption" items="${product.variantOptions}">
					<c:forEach items="${variantOption.variantOptionQualifiers}" var="variantOptionQualifier">
						<c:if test="${variantOptionQualifier.qualifier eq 'rollupProperty'}">
							<c:set var="rollupProperty" value="${variantOptionQualifier.value}"/>
						</c:if>
						<c:if test="${variantOptionQualifier.qualifier eq 'thumbnail'}">
							<c:set var="imageUrlHtml" value="${fn:escapeXml(variantOptionQualifier.value)}"/>
						</c:if>
						<c:if test="${variantOptionQualifier.qualifier eq rollupProperty}">
							<c:set var="variantNameHtml" value="${fn:escapeXml(variantOptionQualifier.value)}"/>
						</c:if>
					</c:forEach>
					<a href="${fn:escapeXml(productUrl)}"><img style="width: 32px; height: 32px;" src="${imageUrlHtml}" alt="${variantNameHtml}"/></a>
				</c:forEach>
			</div>
			<%-- Product Pack Size --%>
			<div class="product-item__size"><spring:theme code="product.grid.packSize"/>: ${product.packSize}</div>

			<c:set var="product" value="${product}" scope="request"/>
			<c:set var="addToCartText" value="${addToCartText}" scope="request"/>
			<c:set var="addToCartUrl" value="${addToCartUrl}" scope="request"/>
			<c:set var="isGrid" value="true" scope="request"/>
			<div class="addtocart">
				<div class="actions-container-for-${fn:escapeXml(component.uid)} <c:if test="${ycommerce:checkIfPickupEnabledForStore() and product.availableForPickup}"> pickup-in-store-available</c:if>">
					<action:actions element="div" parentComponent="${component}"/>
				</div>
			</div>
		</ycommerce:testId>
	</div>
</div>

