<%@ tag trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="utils" uri="http://brake.co.uk/tld/encrypt" %>

<c:url value="/cart/notLoggedInAddAction" var="notLoggedInAddAction" />
<components:productIconMessages />

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
	<c:set var="isLoggedIn" value="true" />
</sec:authorize>
<c:if test="${not empty searchPageData && not empty searchPageData.freeTextSearch}">
	<c:set value="?term=${searchPageData.freeTextSearch}" var="searchParam" />
</c:if>

<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />
<%-- Used to check whether item is part of complex promotion --%>
<c:set var="cartItemPromoGroupCheck" value="" />
<c:if test="${viewPromotions}">
	<c:set var="cartItemPromoGroupCheck" value="{{#ifCond cartEntry.promoGroupNumber '>' -1}}js-cartItemPromoGroup{{/ifCond}}" />
</c:if>
<c:set var="showPerfectWithInPage" value="${not empty cmsPage.showPerfectWith ? cmsPage.showPerfectWith : 'true'}" />
<c:set var="showSimilarInPage" value="${not empty cmsPage.showSimilar ? cmsPage.showSimilar : 'true'}" />

<script id="product-item-template" type="text/x-handlebars-template">
    {{#each results}}
        {{#ifCond alternatives '==' false}}
                {{var 'offsetClass' 'col-xs-offset-6'}}
            {{else}}
                 {{var 'offsetClass' ''}}

        {{/ifCond}}
        {{var 'productStatus' 'Available'}}

        {{#ifCond isDiscontinued '==' false}}
            {{var 'discontinuedClass' ''}}
        {{else}}
            {{var 'discontinuedClass' 'product-item--discontinued'}}
            {{var 'productStatus' 'Discontinued'}}
        {{/ifCond}}  
        {{#ifCond isOutOfStock '==' false}}
        {{else}}
            {{var 'discontinuedClass' 'product-item--discontinued'}}
            {{var 'productStatus' 'Out-of-Stock'}}
        {{/ifCond}}  
        <div class="product-item--noborder js-productItem js-product {{#if cartEntry.quantity}} is-added {{/if}}" id="product-{{code}}" data-id="{{code}}" data-page="{{../pagination.currentPage}}">
           	<div class="similar__btn js-similarBtnParent">
			    {{#ifCond alternatives '==' true}}
                    <c:if test="${showSimilarInPage }">
			    	    <div class="similar__btn--tab similar__btnHalf js-alternatives js-similarBtn ga-see-similar"  id="ga-{{productStatus}}-{{code}}" data-id="ga-{{productStatus}}-{{code}}" data-perfect="{{perfectWith}}" data-similar="{{alternatives}}" data-code="{{code}}">
					        <div data-code="{{code}}"><spring:theme code="similar.products.title"></spring:theme></div>
				        </div>
                    </c:if> 
                {{/ifCond}}
                {{#ifCond perfectWith '==' true}}
                    <c:if test="${showPerfectWithInPage}">
                        <div class="similar__btn--tab similar__btnHalf js-alternatives js-perfectBtn {{offsetClass}} ga-perfect-with"  id="ga-{{productStatus}}-{{code}}" data-id="ga-{{productStatus}}-{{code}}" data-perfect="{{perfectWith}}" data-similar="{{alternatives}}" data-code="{{code}}">
                            <div data-code="{{code}}"><spring:theme code="perfectWith.products.title"></spring:theme></div>
                        </div>
                    </c:if>
                {{/ifCond}}
 
	    	</div>
           
        <c:choose>
            <c:when test="${isLoggedIn && viewPromotions}">
                {{#ifCond hasPotentialPromo '||' product.wasPrice}}
                    {{var 'promoIconVisibilityClass' ''}}
                    {{var 'promoIconVisibilityBorderClass' 'product-item--promotion-border overflow-hide'}}
                    {{var 'secondIconOrderClass' 'item-icons--second'}}
                {{else}}
                    {{var 'promoIconVisibilityClass' 'hidden'}}
                    {{var 'promoIconVisibilityBorderClass' ''}}
                    {{var 'secondIconOrderClass' 'item-icons--first'}}
                {{/ifCond}}
            </c:when>
            <c:when test="${isLoggedIn && !viewPromotions}">
                {{var 'promoIconVisibilityClass' 'hidden'}}
                {{var 'promoIconVisibilityBorderClass' ''}}
                {{var 'secondIconOrderClass' 'item-icons--first'}}
            </c:when>
            <c:otherwise>
                {{#if wasPrice}}
                    {{var 'promoIconVisibilityClass' ''}}
                    {{var 'promoIconVisibilityBorderClass' 'product-item--promotion-border overflow-hide'}}
                    {{var 'secondIconOrderClass' 'item-icons--second'}}
                {{else}}
                    {{var 'promoIconVisibilityClass' 'hidden'}}
                    {{var 'promoIconVisibilityBorderClass' ''}}
                    {{var 'secondIconOrderClass' 'item-icons--first'}}
                {{/if}}
            </c:otherwise>
        </c:choose>
        <c:if test="${cmsPage.uid eq 'myPromoProducts'}">
            {{var 'promoIconVisibilityClass' ''}}
            {{var 'promoIconVisibilityBorderClass' 'product-item--promotion-border overflow-hide'}}
            {{var 'secondIconOrderClass' 'item-icons--second'}}
        </c:if>
		<div class="product-item--border js-productItemBorder {{discontinuedClass}} {{promoIconVisibilityBorderClass}}" data-code="{{code}}">
            <div class="product-item__icons product-item__icons--top">
                <div class="item-icons item-icons--promo item-icons--first {{promoIconVisibilityClass}} js-productPromoIcon" data-code="{{code}}">
                    <span data-code="${product.code}" class="badge badge--promotion"><spring:theme code="product.promotion.offer"></spring:theme></span>
			    </div>
                {{#if newProduct}}
                    <div class="item-icons item-icons--new  {{secondIconOrderClass}}">
                        <span class="icon icon-new icon-new--royal-blue"></span>
                    </div>
                {{/if}}
                    <div class="item-icons item-icons--user-actions js-userActions">
                        <c:if test="${isLoggedIn}">
                            <c:if test="${isRecentlyPurchasedProduct}"> <%-- TODO remove when story is defined --%>
                                <span class="icon icon-recent-purchases" title="buy again"></span>
                            </c:if>
                        </c:if>
                        <c:if test="${empty punchoutUser}">
                            <span class="add-to-favourites">
                                {{#if inFavourites}}
                                    {{var 'heartIcon' 'icon-heart-filled'}}
                                {{else}}
                                    {{var 'heartIcon' 'icon-Heart'}}
                                {{/if}}
                                <c:if test="${!isLoggedIn}">
                                    <a href="/sign-in">
                                </c:if>
                                {{#ifCond isDiscontinued '==' true}}
                                    {{var 'favIconClass' 'product-item--discontinuedFavicon'}}
                                {{else}}
                                    {{var 'favIconClass' ''}}
                                {{/ifCond}}
                                {{#ifCond isOutOfStock '==' true}}
                                    {{var 'favIconClass' 'product-item--discontinuedFavicon'}}
                                {{else}}
                                {{/ifCond}}
                                <span class="js-displayWishlist" data-product-id="{{code}}" title="<spring:theme code="favourites.add"/>">
                                    <span class="icon {{heartIcon}} {{favIconClass}} js-wishlistIcon" aria-hidden="true"></span>
                                </span>
                                <c:if test="${!isLoggedIn}">
                                    </a>
                                </c:if>
                            </span>
                            <div class="js-productWishlistHolder product-wishlist-holder"></div>
                        </c:if> 
                    </div>

	        </div>
            <a class="product-item__thumb" href="{{url}}${searchParam}" title="{{name}}">
                <c:if test="${isLoggedIn}">
                  <span class="product-item__qty-overlay">
                    <spring:theme code="product.qty.overlay" arguments="${'{{cartEntry.quantity}}'}"/>
                  </span>
                </c:if>
                {{> picturePlpPartial}}
            </a>
            <div class="product-item__info">
                <div class="product-item__code"><a href="{{url}}${searchParam}">{{#if prefix}}{{prefix}}&nbsp;{{/if}}{{code}}</a></div>
                <div class="product-item__advice-icons text-right">
                    {{#each productInfoIcons}}
                    <span class="js-icon-wrap-{{this}}">
		        <img class="product-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-{{this}}" alt="icon-{{this}}"/>
                </span>
    {{/each}}
                </div>
            </div>
            <a class="product-item__name product-name" title="{{name}}" href="{{url}}${searchParam}">
                {{#ifCond (length name) '>' 51 }}
                    {{{subString name 0 51}}}...
                {{else}}
                    {{{name}}}
                {{/ifCond}}
            </a>
            <div class="product-item__qty"> 
                {{#ifCond unitsPerCase '>' 1 }} 
                    <spring:theme code="product.grid.caseSize"/>: {{unitsPerCase}}
                {{/ifCond}}
            </div>            
            <div class="product-item__price js-productItemPrice {{#if wasPrice}} has-was-price {{/if}}">
                {{#if potentialPromotions}}
                    <div class="promo">
                        {{#each potentialPromotions}}
                           <a href="{{url}}${searchParam}" title="{{name}}"> {{description}}</a>
                        {{/each}}
                    </div>
                {{/if}}
                <div class="product-price product-price--current-price">
                    <c:choose>
						<c:when test="${isLoggedIn}">
                            <div class="js-loadPrice" data-product-code="{{#if sapProductCode}}{{sapProductCode}}{{else}}{{code}}{{/if}}" data-price-per-divider="{{pricePerDivider}}">
                                <div class="js-loadWasPrice product-price product-price--was-price hidden">
									<span class="product-price__value product-price__value--was-price">
										<span class="js-loadWasPriceValue"></span>
									</span>
									<span class="product-price__value product-price__value--was-price hidden">
										<span class="js-loadWasPriceValueEach"></span>
									</span>
								</div>
                                <span class="product-price__value product-price__value--current js-loadPriceValue {{#if estimatedPrice}}is-weighted-product{{/if}}">
								</span>
                                {{~#if subjectToVAT~}}
                                 <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color"></span>
                                {{/if}}
                                <span class="js-loadPriceEach product-price__price-each {{#if estimatedPrice}}is-weighted-product{{/if}} hidden">
                                    <span class="js-productPrice">${currentCurrency.symbol}<span class="js-unitPrice"></span>{{#if unitPriceDescriptor}}{{unitPriceDescriptor}}{{/if}}</span>
                                </span>
                            </div>
                        </c:when>
						<c:otherwise>
                            {{#if wasPrice}}
                            <div class="product-price product-price--was-price">
                                {{#if estimatedWasPrice}}
                                    <span class="product-price__value product-price__value--was-price">
                                        <span>{{estimatedWasPrice.formattedValue}}</span>
                                    </span>
                                    <span class="product-price__value product-price__value--was-price">
                                            <span>{{#replaceEmptySpace wasPrice.formattedValue ""}}{{/replaceEmptySpace}}</span>
                                        </span>
                                {{else}}
                                    <span class="product-price__value product-price__value--was-price">
                                        <span >{{#replaceEmptySpace wasPrice.formattedValue ""}}{{/replaceEmptySpace}}</span>
                                    </span>
                                {{/if}}
                            </div>
                            {{/if}}
                            {{#if estimatedPrice}}
                                <span class="js-productPrice product-price__value product-price__value--current is-weighted-product" data-currency-symbol="${currentCurrency.symbol}" data-price="{{estimatedPrice.value}}">{{estimatedPrice.formattedValue}}</span>
                                <span class="product-price__price-each is-weighted-product">
                                    <span class="js-productPrice js-productPriceEach" data-currency-symbol="${currentCurrency.symbol}" data-price="{{price.value}}">{{#replaceEmptySpace price.formattedValue ""}}{{/replaceEmptySpace}}</span>
                                </span>
                            {{else}}
                                {{#if price}}
                                    <span class="js-productPrice product-price__value product-price__value--current" data-currency-symbol="${currentCurrency.symbol}" data-price="{{price.value}}">{{> productListerItemPricePartial this}}</span>
                                    {{#if unitPriceDescriptor}}
                                        <span class="js-productPrice js-productPriceEach product-price__price-each" data-price="{{unitPriceStr}}" data-price-descriptor="{{unitPriceDescriptor}}" data-currency-symbol="${currentCurrency.symbol}">{{unitPriceStr}}</span>
                                    {{/if}}
                                {{else}}
                                    <span class="js-productPrice product-price__value product-price__value--current">Pricing Unavailable</span>
                                {{/if}}
                            {{/if}} 
                         </c:otherwise>
                    </c:choose>
                </div>
            </div> <%-- End of product-item__price --%>
            <div class="product-item__size"><spring:theme code="product.grid.packSize"/>: {{packSize}}</div>
            <div class="addtocart">
                <form id="addToCartForm{{code}}" action="/cart/add" method="post" class="cart__add add_to_cart_form js-addToCartForm ${cartItemPromoGroupCheck}" data-id="{{code}}">
                    <input type="hidden" name="productCodePost" value="{{code}}"/>
                    <input type="hidden" name="entryNumber" value="{{#if cartEntry.entryNumber}}{{cartEntry.entryNumber}}{{/if}}"/>
                    <input type="hidden" name="productNamePost" value="{{name}}"/>
                    <input type="hidden" name="productPostPrice" value="{{price.value}}"/>
                    <input type="hidden" name="qty" class="js-productCartQty" value="{{#if cartEntry.quantity}}{{cartEntry.quantity}}{{else}} 0 {{/if}}"/>
                    <input type="hidden" name="productCartQty" class="js-productCartQty" value="{{#if cartEntry.quantity}}{{cartEntry.quantity}}{{else}} 0 {{/if}}"/>
                    {{#ifCond isDiscontinued '==' true}}
                             <button  class=" btn btn-primary btn-block col-sm-12 col-xs-12 discontinued__btn discontinued__btnDisabled js-discontinuedInfo ">
                                <spring:theme code="discontinued.button.title"/>
                               </button> 
                               <span class="icon icon-error product-item--discontinuedIcon js-discontinuedInfo"></span>

                    {{else}}
                        {{#ifCond isOutOfStock '==' true}}
                                 <button  class=" btn btn-primary btn-block col-sm-12 col-xs-12 discontinued__btn discontinued__btnDisabled js-outOfStockInfo ">
                                            <spring:theme code="outOfStock.button.title"/>
                                        </button> 
                                        <span class="icon icon-error product-item--discontinuedIcon js-outOfStockInfo"></span>

                        {{else}}
                            <div class="cart__quantity col-sm-12 col-xs-12 js-productQtyUpdate quantity-update">
                                    <button type="button" class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus  js-qtyBtn" data-action="remove" aria-label="Remove from cart"></button>
                                    <input class="quantity-update__input js-productQtyInput" type="number" inputmode="numeric" aria-label="Quantity" value="{{#if cartEntry.quantity}}{{cartEntry.quantity}}{{else}}1{{/if}}" max="1000" />
                                    <button type="button" class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus  js-qtyBtn" data-action="add" aria-label="Add to cart"></button>
                                </div>
                                <c:choose>                        
                            <c:when test="${isLoggedIn}">   
                                {{#ifCond product.stock.stockLevelStatus.code '==' 'outOfStock'}}
                                <button type="submit" class="btn btn-primary btn-block glyphicon glyphicon-shopping-cart"
                                aria-disabled="true" disabled="disabled">
                                </button>
                                {{else}}
                                {{#if cartEntry.quantity}}
                                <button type="button" class="col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn  cart__add-button js-qtyChangeBtn" data-action="update" data-product-code="{{code}}" disabled="disabled">
                                    <spring:theme code="product.variants.update"/>
                                </button>
                                {{else}}                          
                                <button type="button" class="col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn cart__add-button js-qtyChangeBtn" data-action="add" data-product-code="{{code}}" disabled="disabled">
                                    <spring:theme code="product.button.addToCart"/>
                                </button>   
                                {{/if}}                       
                                {{/ifCond}}
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="js-displayLoginPopup col-xs-12 cart__add-button  btn btn-primary btn-block"><spring:theme code="product.button.addToCart"/></button>
                            </c:otherwise>
                            </c:choose>
                        {{/ifCond}}
                {{/ifCond}}
                </form>
            <product:discontinuedInfo product="${product}"/>
            <product:outOfStockInfo product="${product}"/>

            </div>

            </div>
        </div>
    {{/each}}
</script>
<script id="picturePlpPartial" type="text/x-handlebars-template">
    {{var 'productImage' 'https://i1.adis.ws/i/Brakes/image-not-available'}}
    {{#if images}}
        {{var 'productImage' images.1.url}}
    {{/if}}

    <picture class="product-item__picture flex justify-content-center">
        <source data-size="desktop" data-srcset="{{productImage}}?{{image404}}&$plp-desktop$&fmt=webp" media="(min-width: 1240px)" type="image/webp">
        <source data-size="desktop" data-srcset="{{productImage}}?{{image404}}&$plp-desktop$" media="(min-width: 1240px)" type="image/jpeg">
        <source data-size="tablet" data-srcset="{{productImage}}?{{image404}}&$plp-tablet$&fmt=webp" media="(min-width: 768px)" type="image/webp">
        <source data-size="tablet" data-srcset="{{productImage}}?{{image404}}&$plp-tablet$" media="(min-width: 768px)" type="image/jpeg">
        <source data-size="mobile" data-srcset="{{productImage}}?{{image404}}&$plp-mobile$&fmt=webp" type="image/webp">
        <source data-size="mobile" data-srcset="{{productImage}}?{{image404}}&$plp-mobile$" type="image/jpeg"> 
        <img data-sizes="auto" class="product-item__image product-image lazyload" data-src="{{productImage}}?{{image404}}&$plp-desktop$" alt="{{name}}" width="213" height="142" />
        <div class="loader__image"></div>
    </picture>
</script>
<script id="productListerItemPricePartial"
	type="text/x-handlebars-template">
		<%-- if product is multidimensional with different prices, show range, else, show unique price --%>
    {{#if multidimensional}}
        {{#ifCond priceRange.minPrice.value '!=' priceRange.maxPrice.value}}
            {{> pricePartial price.priceRange.minPrice}} - {{> pricePartial price.priceRange.maxPrice}}
        {{/ifCond}}
    {{else}}
        {{> pricePartial price}}
    {{/if~}}
    {{#if subjectToVAT}}<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>{{/if}}
</script>
<script id="pricePartial" type="text/x-handlebars-template">
   {{#ifCond value '>' 0}}
        {{#if displayNegationForDiscount}}
            -
        {{/if}}
        {{formattedValue~}}
    {{else}}
        {{#if displayFreeForZero}}
            <spring:theme code="text.free" text="FREE"/>
        {{else}}
             {{formattedValue}}
        {{/if}}
    {{/ifCond}}
</script>


<script id="load-more-btn-template" type="text/x-handlebars-template">

<c:if test="${cmsPage.uid eq 'favouriteItemGrid'}">
    <c:if test="${not empty favouriteItemPageData.sorts[0].code}">
        <c:set var="sortQuery" value="&sort=${favouriteItemPageData.sorts[0].code}" />
    </c:if>

    <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn h-space-4 {{#ifCond action '==' 'append'}}js-loadNextFavourites{{else}}js-loadPreviousFavourites{{/ifCond}}" 
    data-url="/my-account/favourites/${ycommerce:encodeUrl(utils:encrypt(favouriteItemPageData.favourite.uid))}/results?page={{pageToLoadGetParam}}${sortQuery}" data-base-url="/my-account/favourites/${ycommerce:encodeUrl(utils:encrypt(favouriteItemPageData.favourite.uid))}" data-sort-by="${sortQuery}" data-action="{{action}}">

    {{#ifCond action '==' "append"}}
        <spring:theme code="product.grid.loadMore" />
        {{else}}
        <spring:theme code="product.grid.loadPrevious" />
    {{/ifCond}}
    </button>
</c:if>

<c:if test="${cmsPage.uid ne 'favouriteItemGrid' && cmsPage.uid ne 'recentPurchasedProductsPage' && cmsPage.uid ne 'myPromoProducts'}">
    <c:set var="searchUrl" value="${fn:substringBefore(searchPageData.currentQuery.url, '?')}" />
    <c:set var="baseUrl" value="${searchUrl}/resultsandfacets?q=${searchPageData.currentQuery.query.value}" />
    {{#if currentQuery}}
        <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn {{customCSSClass}}" data-url="${searchUrl}/resultsandfacets?q={{currentQuery.query.value}}&page={{pageToLoadGetParam}}" data-base-url="${searchUrl}?q={{currentQuery.query.value}}&page={{pageToLoadGetParam}}" data-action="{{action}}">
    {{else}}
        <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn {{customCSSClass}}" data-url="${baseUrl}&page={{pageToLoadGetParam}}" data-base-url="${searchUrl}?q=${searchPageData.currentQuery.query.value}" data-action="{{action}}">
    {{/if}}
        {{#ifCond action '==' "append"}}
            <spring:theme code="product.grid.loadMore" />
        {{else}}
            <spring:theme code="product.grid.loadPrevious" />
        {{/ifCond}}
    </button>
</c:if>
<c:if test="${cmsPage.uid eq 'recentPurchasedProductsPage'}">
    <c:url var="recentPurchasesBaseUrl" value="/my-account/recent-purchased-products" />
    <c:set var="invokedUrl" value="${recentPurchasesBaseUrl}/resultsandfacets" />
    <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn {{customCSSClass}}" data-base-url="${recentPurchasesBaseUrl}" data-url="${invokedUrl}?{{#if currentQuery.query.value}}q={{currentQuery.query.value}}&{{/if}}page={{pageToLoadGetParam}}&weeksInPast=${currentWeeksInPast}" data-action="{{action}}" data-sort-by="&weeksInPast=${currentWeeksInPast}">
        {{#ifCond action '==' "append"}}
        <spring:theme code="product.grid.loadMore" />
        {{else}}
        <spring:theme code="product.grid.loadPrevious" />
        {{/ifCond}}
    </button>
</c:if>
<c:if test="${cmsPage.uid eq 'myPromoProducts' and siteUid eq 'brakes'}">
    <c:set var="invokedUrl" value="${recentPurchasesBaseUrl}/results" />
    <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn {{customCSSClass}}" data-base-url="/promotions/monthly-promotions" data-url="/promotions/resultsandfacets?{{#if currentQuery.query.value}}q={{currentQuery.query.value}}&{{/if}}page={{pageToLoadGetParam}}"
     data-action="{{action}}">
        {{#ifCond action '==' "append"}}
        <spring:theme code="product.grid.loadMore" />
        {{else}}
        <spring:theme code="product.grid.loadPrevious" />
        {{/ifCond}}
    </button>
</c:if>
<c:if test="${cmsPage.uid eq 'myPromoProducts' and siteUid ne 'brakes'}">
    <c:set var="invokedUrl" value="${recentPurchasesBaseUrl}/results" />
    <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn {{customCSSClass}}" data-base-url="/my-promo-products/getPromoProducts" data-url="/my-promo-products/resultsandfacets?{{#if currentQuery.query.value}}q={{currentQuery.query.value}}&{{/if}}page={{pageToLoadGetParam}}"
     data-action="{{action}}">
        {{#ifCond action '==' "append"}}
        <spring:theme code="product.grid.loadMore" />
        {{else}}
        <spring:theme code="product.grid.loadPrevious" />
        {{/ifCond}}
    </button>
</c:if>
</script>

<c:if test="${cmsPage.uid eq 'favouriteItemGrid'}">
<c:set var="isFavouriteProduct" value="true" />
<script id="favourite-product-item-template" type="text/x-handlebars-template">
    {{#each results}}
        {{#ifCond alternatives '==' false}}
                {{var 'offsetClass' 'col-xs-offset-6'}}
            {{else}}
                 {{var 'offsetClass' ''}}
            {{/ifCond}}
            {{var 'productStatus' 'Available'}}
            {{#ifCond isDiscontinued '==' false}}
                {{var 'discontinuedClass' ''}}
            {{else}}
                {{var 'discontinuedClass' 'product-item--discontinued'}}
                {{var 'productStatus' 'Discontinued'}}
            {{/ifCond}}  
            {{#ifCond isOutOfStock '==' false}}
            {{else}}
                 {{var 'discontinuedClass' 'product-item--discontinued'}}
                 {{var 'productStatus' 'Out-of-Stock'}}
        {{/ifCond}}
        {{#with product}}
        <div class="product-item--noborder js-productItem js-product {{#if cartEntry.quantity}}is-added{{/if}} ${isFavouriteProduct ? 'js-favouriteItem' : ''}" id="product-{{code}}" data-id="{{code}}" data-favourite="${favouriteItemPageData.favourite.uid}">
            <div class="similar__btn js-similarBtnParent">
			    {{#ifCond alternatives '==' true}}
                    <c:if test="${showSimilarInPage }">
			    	    <div class="similar__btn--tab similar__btnHalf js-alternatives js-similarBtn ga-see-similar"  id="ga-{{productStatus}}-{{code}}" data-id="ga-{{productStatus}}-{{code}}" data-perfect="{{perfectWith}}" data-similar="{{alternatives}}" data-code="{{code}}">
					        <div data-code="{{code}}"><spring:theme code="similar.products.title"></spring:theme></div>
				        </div>
                    </c:if> 
                {{/ifCond}}
                {{#ifCond perfectWith '==' true}}
                    <c:if test="${showPerfectWithInPage}">
                        <div class="similar__btn--tab similar__btnHalf js-alternatives js-perfectBtn {{offsetClass}} ga-perfect-with"  id="ga-{{productStatus}}-{{code}}" data-id="ga-{{productStatus}}-{{code}}" data-perfect="{{perfectWith}}" data-similar="{{alternatives}}" data-code="{{code}}">
                            <div data-code="{{code}}"><spring:theme code="perfectWith.products.title"></spring:theme></div>
                        </div>
                    </c:if>
                {{/ifCond}}
	    	</div>
            <c:choose>
                <c:when test="${isLoggedIn && viewPromotions}">
                    {{#ifCond hasPotentialPromo '||' product.wasPrice}}
                        {{var 'promoIconVisibilityClass' ''}}
                        {{var 'promoIconVisibilityBorderClass' 'product-item--promotion-border overflow-hide'}}
                        {{var 'secondIconOrderClass' 'item-icons--second'}}
                    {{else}}
                        {{var 'promoIconVisibilityClass' 'hidden'}}
                        {{var 'promoIconVisibilityBorderClass' ''}}
                        {{var 'secondIconOrderClass' 'item-icons--first'}}
                    {{/ifCond}}
                </c:when>
                <c:when test="${isLoggedIn && !viewPromotions}">
                    {{var 'promoIconVisibilityClass' 'hidden'}}
                    {{var 'promoIconVisibilityBorderClass' ''}}
                    {{var 'secondIconOrderClass' 'item-icons--first'}}
                </c:when>
                <c:otherwise>
                    {{#if wasPrice}}
                        {{var 'promoIconVisibilityClass' ''}}
                        {{var 'promoIconVisibilityBorderClass' 'product-item--promotion-border overflow-hide'}}
                        {{var 'secondIconOrderClass' 'item-icons--second'}}
                    {{else}}
                        {{var 'promoIconVisibilityClass' 'hidden'}}
                        {{var 'promoIconVisibilityBorderClass' ''}}
                        {{var 'secondIconOrderClass' 'item-icons--first'}}
                    {{/if}}
                </c:otherwise>
            </c:choose>
            <div class="product-item--border js-productItemBorder {{discontinuedClass}} {{promoIconVisibilityBorderClass}}" data-code="{{code}}">
                <div class="product-item__icons product-item__icons--top">

                    <div class="item-icons item-icons--promo item-icons--first js-productPromoIcon {{promoIconVisibilityClass}}" data-code="{{code}}">
                        <span data-code="${product.code}" class="badge badge--promotion"><spring:theme code="product.promotion.offer"></spring:theme></span>
                    </div>
                    {{#if newProduct}}
                        <div class="item-icons item-icons--new  {{secondIconOrderClass}}">
                            <span class="icon icon-new icon-new--royal-blue"></span>
                        </div>
                    {{/if}}
                    <sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
                        <div class="item-icons item-icons--user-actions js-userActions">
                            <c:if test="${isRecentlyPurchasedProduct}"> <%-- TODO remove when story is defined --%>
                                <span class="icon icon-recent-purchases" title="buy again"></span>
                            </c:if>
                            <div class="fav-item__edit js-editWishlist fav-item__edit--product" data-url="/favourite/rollover/edit/{{../../activeListId}}/{{code}}" data-product-code="{{code}}">
                                <span class="icon icon-more icon-user-actions"></span>
                            </div>
                            <div class="fav-item__edit-container js-editWishlistContainer">
                                <components:wishlistActions sizeOfWishlist="${fn:length(favouriteItemPageData.results)}"/>
                            </div>
                        </div>
                    </sec:authorize> 
                </div>
                <a class="product-item__thumb" href="{{url}}" title="{{product.name}}">
                    <c:if test="${isLoggedIn}">
                    <span class="product-item__qty-overlay">
                        <spring:theme code="product.qty.overlay" arguments="${'{{cartEntry.quantity}}'}"/>
                    </span>
                    </c:if>
                    {{> picturePlpPartial}}
                </a>
                <div class="product-item__info">
                    <div class="product-item__code"> <a  href="{{url}}" title="{{product.name}}">{{#if prefix}}{{prefix}}&nbsp;{{/if}}{{code}}</a></div>
                    <div class="product-item__advice-icons text-right">
                        {{#each productInfoIcons}}
                            <span class="js-icon-wrap-{{this}}">
                            <img class="product-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-{{this}}" alt="icon-{{this}}"/>
                            </span>
                        {{/each}}
                    </div>
                </div>
                <a class="product-item__name product-name" title="{{name}}" href="{{url}}"> 
                    {{#ifCond (length name) '>' 51 }}
                        {{{subString name 0 51}}}...
                    {{else}}
                        {{{name}}}
                    {{/ifCond}}
                </a>
                <div class="product-item__qty"> 
                    {{#ifCond unitsPerCase '>' 1 }} 
                        <spring:theme code="product.grid.caseSize"/>: {{unitsPerCase}}
                    {{/ifCond}}
                </div>
                <div class="product-item__price js-productItemPrice {{#if wasPrice}} has-was-price {{/if}}">
                    {{#if potentialPromotions}}
                        <div class="promo">
                            {{#each potentialPromotions}}
                            <a  href="{{url}}${searchParam}" title="{{name}}"> {{description}} </a>
                            {{/each}}
                        </div>
                    {{/if}}
                    <div class="product-price product-price--current-price">
                        <c:choose>
                            <c:when test="${isLoggedIn}">
                                <div class="js-loadPrice" data-product-code="{{#if sapProductCode}}{{sapProductCode}}{{else}}{{code}}{{/if}}" data-price-per-divider="{{pricePerDivider}}">
                                    <div class="js-loadWasPrice product-price product-price--was-price hidden">
                                        <span class="product-price__value product-price__value--was-price">
                                            <span class="js-loadWasPriceValue"></span>
                                        </span>
                                        <span class="product-price__value product-price__value--was-price hidden">
                                            <span class="js-loadWasPriceValueEach"></span>
                                        </span>
                                    </div>                                
                                    <span class="product-price__value product-price__value--current js-loadPriceValue {{#if estimatedPrice }}is-weighted-product{{/if}}">
                                    </span>
                                    {{~#if subjectToVAT~}}
                                    <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
                                    {{/if}}
                                    <span class="product-price__price-each js-loadPriceEach hidden">
                                        <span class="js-productPrice">${currentCurrency.symbol}<span class="js-unitPrice"></span>{{#if unitPriceDescriptor}}{{unitPriceDescriptor}}{{/if}}</span>
                                    </span>
                                    
                                </div>
                            </c:when>
                            <c:otherwise>
                                {{#if wasPrice}}
                                    <div class="product-price product-price--was-price">
                                        {{#if estimatedWasPrice}}
                                            <span class="product-price__value product-price__value--was-price">
                                                <span >{{> pricePartial product.estimatedWasPrice}}</span>
                                            </span>
                                            <span class="product-price__value product-price__value--was-price">
                                                <span >{{> pricePartial wasPrice}}</span>
                                            </span>
                                        {{else}}
                                            <span class="product-price__value product-price__value--was-price">
                                                <span >{{> pricePartial wasPrice}}</span>
                                            </span>
                                        {{/if}}
                                    </div>
                                {{/if}}
                                {{#if estimatedPrice}}
                                    <span class="js-productPrice product-price__value product-price__value--current is-weighted-product" data-currency-symbol="${currentCurrency.symbol}" data-price="{{product.estimatedPrice.value}}">{{> productListerItemPricePartial this}}</span>
                                    <span class="product-price__price-each is-weighted-product" data-currency-symbol="${currentCurrency.symbol}" data-price="{{price.value}}">
                                        <span class="js-productPriceEach">{{#replaceEmptySpace price.formattedValue ""}}{{/replaceEmptySpace}}</span>
                                    </span>
                                {{else}}
                                    {{#if price}}
                                        <span class="js-productPrice product-price__value product-price__value--current" data-currency-symbol="${currentCurrency.symbol}" data-price="{{price.value}}">{{> productListerItemPricePartial this}}</span>
                                        {{#if unitPriceDescriptor}}
                                        <span class="js-productPrice product-price__price-each" data-price="{{price.value}}" data-price-descriptor="{{unitPriceDescriptor}}" data-currency-symbol="${currentCurrency.symbol}">{{unitPriceStr}}</span>
                                        {{/if}}
                                    {{else}}
                                        <span class="js-productPrice product-price__value product-price__value--current">Pricing Unavailable</span>
                                    {{/if}}
                                {{/if}}
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="product-item__size"><spring:theme code="product.grid.packSize"/>: {{packSize}}</div>
                <div class="addtocart">
                    <form id="addToCartForm{{code}}" action="/cart/add" method="post" class="cart__add add_to_cart_form js-addToCartForm  ${cartItemPromoGroupCheck}" data-id="{{code}}">
                        <input type="hidden" name="productCodePost" value="{{code}}"/>
                        <input type="hidden" name="entryNumber" value="{{#if cartEntry.entryNumber}}{{cartEntry.entryNumber}}{{/if}}"/>
                        <input type="hidden" name="productNamePost" value="{{name}}"/>
                        <input type="hidden" name="productPostPrice" value="{{price.value}}"/>
                        <input type="hidden" name="qty" class="js-productCartQty" value="{{#if cartEntry.quantity}}{{cartEntry.quantity}}{{else}} 0 {{/if}}"/>
                        <input type="hidden" name="productCartQty" class="js-productCartQty" value="{{#if cartEntry.quantity}}{{cartEntry.quantity}}{{else}} 0 {{/if}}"/>
                        {{#ifCond isDiscontinued '==' true}}
                            <button  class=" btn btn-primary btn-block col-sm-12 col-xs-12 discontinued__btn discontinued__btnDisabled js-discontinuedInfo ">
                                <spring:theme code="discontinued.button.title"/>
                            </button> 
                            <span class="icon icon-error product-item--discontinuedIcon js-discontinuedInfo"></span>
                        {{else}}
                            {{#ifCond isOutOfStock '==' true}}
                                <button  class=" btn btn-primary btn-block col-sm-12 col-xs-12 discontinued__btn discontinued__btnDisabled js-outOfStockInfo ">
                                    <spring:theme code="outOfStock.button.title"/>
                                </button> 
                                <span class="icon icon-error product-item--discontinuedIcon js-outOfStockInfo"></span>
                            {{else}}
                                <div class="cart__quantity col-sm-12 col-xs-12 js-productQtyUpdate quantity-update">
                                    <button type="button" class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus  js-qtyBtn" data-action="remove" aria-label="Remove from cart"></button>
                                    <input class="quantity-update__input js-productQtyInput" type="number" inputmode="numeric" aria-label="Quantity" value="{{#if cartEntry.quantity}}{{cartEntry.quantity}}{{else}}1{{/if}}" max="1000" />
                                    <button type="button" class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus  js-qtyBtn" data-action="add" aria-label="Add to cart"></button>
                                </div>
                                <c:choose>
                                    <c:when test="${isLoggedIn}">
                                        {{#ifCond product.stock.stockLevelStatus.code '==' 'outOfStock'}}
                                            <button type="submit" class="btn btn-primary btn-block glyphicon glyphicon-shopping-cart"
                                            aria-disabled="true" disabled="disabled">
                                            </button>
                                        {{else}}
                                            {{#if cartEntry.quantity}}
                                                <button type="button" class="col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn  cart__add-button js-qtyChangeBtn" data-action="update" data-product-code="{{code}}" disabled="disabled">
                                                    <spring:theme code="product.variants.update"/>
                                                </button>
                                            {{else}}                          
                                                <button type="button" class="col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn cart__add-button js-qtyChangeBtn" data-action="add" data-product-code="{{code}}" disabled="disabled">
                                                    <spring:theme code="product.button.addToCart"/>
                                                </button>   
                                            {{/if}}   
                                        {{/ifCond}}
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${notLoggedInAddAction}" class="col-xs-12 cart__add-button  btn btn-primary btn-block"><spring:theme code="product.button.addToCart"/></a>
                                    </c:otherwise>
                                </c:choose>
                            {{/ifCond}}
                        {{/ifCond}}
                    </form>
                    <product:discontinuedInfo product="${product}"/>
                </div>
            </div>
        </div>
        {{/with}}
    {{/each}}
</script>
</c:if>

