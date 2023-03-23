<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="component" tagdir="/WEB-INF/tags/shared/component"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>
<%@ taglib prefix="commonProduct" tagdir="/WEB-INF/tags/responsive/common/product" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/sign-in" var="loginUrl" />

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
	<c:set var="isLoggedIn" value="true" />
</sec:authorize>

<c:choose>
	<c:when test="${not empty suggestions and component.maximumNumberProducts > 0}">

		<c:set var="suggestionLength" value="${fn:length(suggestions)}" />

		<div class="product-recommendations">
			<div class="product-recommendations--border">
				<h2 class="site-header__text site-header__text--underline site-header__text--upsell text-uppercase text-center font-size-1-25 lh2">
				<c:forEach items="${component.productReferenceTypes}" var="reference">
				    <c:choose>
                          <c:when test="${reference.code eq 'UPSELLING'}">
                              <spring:theme code="product.references.upselling.title" />
                          </c:when>
                          <c:when test="${reference.code eq 'CROSSELLING'}">
                              <spring:theme code="product.references.crosselling.title" />
                          </c:when>
                          <c:when test="${reference.code eq 'SIMILAR'}">
                            <spring:theme code="product.references.similar.title" />
                          </c:when>
                          <c:when test="${reference.code eq 'ALTERNATIVES'}">
                            <spring:theme code="product.references.alternatives.title" />
                          </c:when>
                          <c:when test="${reference.code eq 'PERFECT_WITH'}">
                            <spring:theme code="product.references.perfectwith.title" />
                          </c:when>
                          <c:otherwise>
                            <spring:theme code="product.references.others.title" />
                          </c:otherwise>
                    </c:choose> 
                </c:forEach>
				</h2>

				<div class="js-cartProductsCarousel owl-carousel products-carousel hide">

					<c:forEach end="${component.maximumNumberProducts}" var="i" step="1" begin="0">
						<c:choose>
							<c:when test="${cmsPage.uid eq 'checkoutPage'}">
								<c:set var="suggestion" value="${suggestions[suggestionLength-i]}" />
							</c:when>
							<c:otherwise>
								<c:set var="suggestion" value="${suggestions[i]}" />
							</c:otherwise>
						</c:choose>

						<c:url value="${suggestion.url}" var="productUrl" />
						<c:url value="${suggestion.code}" var="productCode" />
						<c:set var="showPromotion"><promotions:showPromotion product="${suggestion}" isLoggedIn="${isLoggedIn}"/></c:set>
						
						<c:if test="${not empty productCode || not empty productUrl}">
						<div class="product-item js-productItem" id="product-${productCode}">
							<%-- Icons --%>
							<div class="product-item__icons product-item__icons--top">
								<div class="item-icons item-icons--promo ${showPromotion ? '' : 'hidden'} js-productPromoIcon" data-code="${productCode}">
									<span class="icon icon-promo-alt icon-promo-alt--red"><span class="path1"></span><span class="path2"></span></span>
								</div>
								<c:if test="${suggestion.newProduct}">
									<div class="item-icons item-icons--new  ${showPromotion ? 'item-icons--second' : 'item-icons--first'}">
										<span class="icon icon-new icon-new--royal-blue"></span>
									</div>
								</c:if>
								<c:if test="${isLoggedIn}">
									<div class="item-icons item-icons--user-actions text-right js-userActions">
										<c:if test="${isRecentlyPurchasedProduct}">
											<span class="icon icon-recent-purchases" title="buy again"></span>
										</c:if>
										<c:choose>
											<c:when test="${isFavouriteProduct}">
												<favourite:editFavourite favourite="${favourite}" product="${suggestion}" isProduct="true"/>
											</c:when>
											<c:otherwise>
												<product:productAddToFavouritePanel product="${suggestion}"/>
											</c:otherwise>
										</c:choose>
									</div>
								</c:if> 
							</div>

							<%-- Image --%>
							<a class="product-item__thumb" href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(suggestion.name)}">
								<product:productImageLazyLoad product="${suggestion}" format="product" ttMobile="$plp-desktop$" ttTablet="$plp-desktop$" ttDesktop="$plp-desktop$" />
							</a>

							<%-- Information --%>
							<div class="suggestion__info">
								<div class="suggestion__code">
									<a href="${productUrl}">${fn:escapeXml(suggestion.prefix)}&nbsp;${productCode}</a>
								</div>
								<div class="product-item__advice-icons text-right">
									<c:forEach items="${suggestion.productInfoIcons}" var="iconClass">
										<a href="${fn:escapeXml(productUrl)}" class="product-item__advice-link">
											<img class="product-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
										</a>
									</c:forEach>
								</div>
							</div>

							<%-- Name --%>
							<c:if test="${component.displayProductTitles}">
								<c:set var="suggestionName" value="${fn:escapeXml(suggestion.name)}" />
								<c:choose>
									<c:when test="${fn:length(suggestionName) gt 65}">
										<c:set var="suggestionNameFormatted" value="${fn:substring(suggestionName, 0, 65)}..." />
									</c:when>
									<c:otherwise>
										<c:set var="suggestionNameFormatted" value="${suggestionName}" />
									</c:otherwise>
								</c:choose>
								<a class="suggestion__name elipsis-1-line" href="${productUrl}">${suggestionNameFormatted}</a>
							</c:if>

							<hr class="separator">

							<div class="product-item__interactions">

								<div class="product-item__price-information full-width">
									<%-- Price --%>
									<c:if test="${component.displayProductPrices}">
										<c:set var="VAT_asterisk" value="" />
										<c:if test="${suggestion.subjectToVAT}">
											<c:set var="VAT_asterisk"><span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
											</c:set>
										</c:if>
										<c:set var="hasWasPrice" value="${not empty suggestion.wasPrice}" />
										<div class="product-item__price js-productItemPrice">
											<div class="product-price product-price--current-price ${hasWasPrice ? 'has-was-price': ''}">
												<c:choose>
													<c:when test="${isLoggedIn}">
														<c:set var="VAT_asterisk" value="" />
														<c:if test="${suggestion.subjectToVAT}">
															<c:set var="VAT_asterisk"><span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color hidden js-loadPriceVAT"></span></c:set>
														</c:if>
														<c:set var="priceProductCode" value="${not empty suggestion.sapProductCode ? suggestion.sapProductCode : suggestion.code}" />
														<div class="js-loadPrice" data-product-code="${priceProductCode}" data-price-per-divider="${suggestion.pricePerDivider}">
															<div class="js-loadWasPrice product-price product-price--was-price hidden">
																<span class="product-price__value product-price__value--was-price">
																	<a href="${fn:escapeXml(productUrl)}" class="js-loadWasPriceValue"></a>
																</span>
																<span class="product-price__value product-price__value--was-price">
																	<a href="${fn:escapeXml(productUrl)}" class="js-loadWasPriceValueEach"></a>
																</span>
															</div>
															<span class="product-price__value product-price__value--current js-loadPriceValue">
															</span>${VAT_asterisk}
															<span class="js-loadPriceEach product-price__price-each hidden">
																<a href="${fn:escapeXml(productUrl)}" class="js-productPrice">${currentCurrency.symbol}<span class="js-unitPrice"></span><c:if test="${not empty suggestion.unitPriceDescriptor}">${suggestion.unitPriceDescriptor}</c:if></a>
															</span>
														</div>
													</c:when>
													
													<c:otherwise>
														<c:if test="${hasWasPrice}">
															<div class="product-price product-price--was-price">
																<c:choose>
																	<c:when test="${suggestion.estimatedWasPrice != null}">
																		<span class="product-price__value product-price__value--was-price">
																			<a href="${fn:escapeXml(productUrl)}"><format:price priceData="${suggestion.estimatedWasPrice}"/></a>
																		</span>
																		<span class="product-price__value product-price__value--was-price">
																			<a href="${fn:escapeXml(productUrl)}"><format:price priceData="${suggestion.wasPrice}" removeSpacing="true"/></a>
																		</span>
																	</c:when>
																	<c:otherwise>
																		<span class="product-price__value product-price__value--was-price">
																			<a href="${fn:escapeXml(productUrl)}"><format:price priceData="${suggestion.wasPrice}"/></a>
																		</span>
																	</c:otherwise>
																</c:choose>
															</div>
														</c:if>
														<c:choose>
															<c:when test="${suggestion.estimatedPrice != null}">
																<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__value product-price__value--current" data-price="${suggestion.estimatedPrice.value}" data-currency-symbol="${currentCurrency.symbol}"><product:productListerItemPrice product="${product}"/></a>&nbsp;
																<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__price-each" data-price="${suggestion.price.value}" data-currency-symbol="${currentCurrency.symbol}"><product:productListerItemPrice product="${product}"/></a>
															</c:when>
															<c:otherwise>
																<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__value product-price__value--current" data-price="${suggestion.price.value}" data-currency-symbol="${currentCurrency.symbol}"><product:productListerItemPrice product="${product}"/></a>
																<c:if test="${not empty suggestion.unitPriceStr}">
																	<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__price-each" data-price="${suggestion.unitPriceStr}" data-currency-symbol="${currentCurrency.symbol}" data-price-descriptor="${suggestion.unitPriceDescriptor}">
																			${suggestion.unitPriceStr}</a>
																</c:if>
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</div>
										</div>    
									</c:if>

									<%-- Pack Size --%>
									<div class="product-item__size">
										<a href="${productUrl}"><spring:theme code="product.grid.packSize"/>: ${suggestion.packSize}</a>
									</div>
								</div>

								<%-- Add to cart --%>
								<form:form action="/cart/add-and-reload" method="post" class="addtocart flex full-width" data-id="${fn:escapeXml(suggestion.code)}" >
									<input type="hidden" name="redirectTargetAfterAddToCart" value="${redirectTargetAfterAddToCart}"/>
									<input type="hidden" name="productCodePost" value="${fn:escapeXml(suggestion.code)}"/>
									<input type="hidden" name="productNamePost" value="${fn:escapeXml(suggestion.name)}"/>
									<c:choose>
										<c:when test="${product.estimatedPrice != null}">
											<input type="hidden" name="productPostPrice" value="${fn:escapeXml(suggestion.estimatedPrice.value)}"/>
										</c:when>
										<c:otherwise>
											<input type="hidden" name="productPostPrice" value="${fn:escapeXml(suggestion.price.value)}"/>
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${cmsPage.uid eq 'checkoutPage' || cmsPage.uid eq 'cartPage'}">
											<input type="hidden" name="productCartQty" value="1"/>
											<input type="hidden" name="qty" value="1"/>
											<input type="hidden" name="entryNumber" value="${not empty suggestion.cartEntry ? suggestion.cartEntry.entryNumber : 0}"/>
										</c:when>
										<c:otherwise>
											<input type="hidden" name="productCartQty" class="js-productCartQty" value="${not empty product.cartEntry.quantity ? product.cartEntry.quantity : 0}"/>
											<input type="hidden" name="qty" class="js-productCartQty" value="${not empty product.cartEntry.quantity ? product.cartEntry.quantity : 0}"/>
										</c:otherwise>
									</c:choose>

									<%-- Update Qty Input --%>																			
									<div class="js-productQtyUpdate quantity-update cart__quantity full-width">
										<button type="button" class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-qtyBtn" data-action="remove" data-page="references" aria-label="<spring:theme code='text.remove.from.cart'></spring:theme>"></button>
										<input class="quantity-update__input js-productQtyInput" type="number" inputmode="numeric"  aria-label="Quantity" value="${not empty suggestion.cartEntry.quantity ? suggestion.cartEntry.quantity : 1}" min="0" max="1000" />
										<button type="button" class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-qtyBtn" data-action="add" data-page="references" aria-label="<spring:theme code='basket.add.to.basket'></spring:theme>"></button>
									</div>

									<c:choose>
										<c:when test="${suggestion.stock.stockLevelStatus.code eq 'outOfStock' }">
											<button type="submit" class="btn btn-primary btn-block glyphicon glyphicon-shopping-cart" aria-disabled="true" disabled="disabled"></button>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${cmsPage.uid eq 'checkoutPage' || cmsPage.uid eq 'cartPage'}">
												<button type="submit" class="btn btn-primary btn-block js-enable-btn cart__add-button ${not empty suggestion.cartEntry.quantity ? 'hide' : ''}" data-action="add" data-product-code="${fn:escapeXml(suggestion.code)}" disabled="disabled">
													<spring:theme code="product.button.addToCart"/>
												</button>
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${suggestion.cartEntry.quantity}">
															<button type="submit" disabled="disabled" class="col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn js-qtyChangeBtn cart__add-button" data-action="update" data-product-code="${fn:escapeXml(suggestion.code)}" >
																<spring:theme code="product.variants.update"/>
															</button>
														</c:when>
														<c:otherwise>
															<button type="submit" disabled="disabled" class="col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn js-qtyChangeBtn cart__add-button" data-action="add" data-product-code="${fn:escapeXml(suggestion.code)}" >
																<spring:theme code="product.button.addToCart"/>
															</button>
														</c:otherwise>	
													</c:choose>	
												</c:otherwise>	
											</c:choose>							
										</c:otherwise>									
									</c:choose>
								</form:form>
							</div>
						</div>
						</c:if> 
					</c:forEach>
				</div>
				<%-- Needs to be repeated depending on products in view --%>
				<commonProduct:loading />
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<component:emptyComponent />
	</c:otherwise>
</c:choose>
