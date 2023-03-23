<%@ page trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="component" tagdir="/WEB-INF/tags/shared/component"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>

<c:url value="/sign-in" var="loginUrl"/>
<c:url value="/cart/add" var="formActionUrl"/>
<c:if test="${not empty productReference.target.cartEntry.quantity}">
    <c:url value="/cart/update" var="formActionUrl" />
</c:if>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
  <c:set var="isLoggedIn" value="true" />
</sec:authorize>

<spring:htmlEscape defaultHtmlEscape="false" />
<c:choose>
	<c:when test="${not empty productReferences and component.maximumNumberProducts > 0}">
		<div class="container">
			<div class="row">
				<div class="col-xs-12">
					<div class="site-header h-space-2">
						<h2 class="site-header__text site-header__text site-header__text--underline">
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
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-xs-12">
					<div class="js-productsCarousel owl-carousel products-carousel">
						<c:forEach end="${component.maximumNumberProducts}" items="${productReferences}" var="productReference">
							<c:url value="${productReference.target.url}" var="productUrl"/>
							<c:url value="${productReference.target.code}" var="productCode"/>

							<c:set var="showPromotion">
								<promotions:showPromotion product="${productReference.target}" isLoggedIn="${isLoggedIn}"/>
							</c:set>

							<div class="product-item js-productItem ${(isLoggedIn && not empty productReference.target.cartEntry.quantity ? ' is-added' : '')}" id="product-${productCode}" data-id="${productCode}">
								<div class="product-item__icons product-item__icons--top">
										<div class="item-icons item-icons--promo ${showPromotion ? '' : 'hidden'} js-productPromoIcon" data-code="${productCode}">
											<span class="icon icon-promo-alt icon-promo-alt--red"><span class="path1"></span><span class="path2"></span></span>
										</div>
										<c:if test="${productReference.target.newProduct}">
											<div class="item-icons item-icons--new  ${showPromotion ? 'item-icons--second' : 'item-icons--first'}">
												<span class="icon icon-new icon-new--royal-blue"></span>
											</div>
										</c:if>

										<c:if test="${isLoggedIn}">
											<div class="item-icons item-icons--user-actions js-userActions">
											  	<c:if test="${isRecentlyPurchasedProduct}"> <%-- TODO remove when story is defined --%>
													<span class="icon icon-recent-purchases" title="buy again"></span>
												</c:if>
												<%-- TODO this seesm to be old implementation --%>
												<%-- BE needs to provide information whether product is already added to favourites --%>
												<c:if test="${empty punchoutUser}">
													<div class="add-to-favourites js-displayWishlist" data-product-id="${productCode}">
														<span class="icon icon-Heart js-wishlistIcon" title="Add to favourites" aria-hidden="true"></span>
													</div>
													<div class="js-productWishlistHolder product-wishlist-holder"></div>
												</c:if> 
											</div>
										</c:if> 
								</div>
								<a class="product-item__thumb" href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(productReference.target.name)}">
									<c:if test="${isLoggedIn}">
										<span class="product-item__qty-overlay"><spring:theme code="product.qty.overlay" arguments="${productReference.target.cartEntry.quantity}"/></span>
									</c:if>
									<product:productImageLazyLoad product="${productReference.target}" format="product" ttMobile="$plp-desktop$" ttTablet="$plp-tablet$" ttDesktop="$plp-mobile$" />
								</a>
								<div class="product-item__info">
									<div class="product-item__code">
									<a href="${productUrl}">${productReference.target.prefix}&nbsp;${productCode}</a>
									</div>
									<div class="product-item__advice-icons text-right">
										<c:forEach items="${productReference.target.productInfoIcons}" var="iconClass">
											<a href="${fn:escapeXml(productUrl)}" class="product-item__advice-link">
												<img class="product-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
											</a>
      							        </c:forEach>
									</div>
								</div>
								<c:if test="${component.displayProductTitles}">
									<a class="product-item__name product-name" href="${productUrl}">
									${fn:escapeXml(productReference.target.name)}
									</a>
								</c:if>
								<c:if test="${productReference.target.unitsPerCase gt 1}"> 
								<div class="product-item__qty"><a href="${productUrl}"><spring:theme code="product.grid.caseSize"/>: ${productReference.target.unitsPerCase}</a></div>
								</c:if>
								<c:if test="${component.displayProductPrices}">

									<div class="product-item__price js-productItemPrice ${not empty productReference.target.wasPrice ? 'has-was-price' : ''}">
										<div class="product-price product-price--current-price">
											<c:choose>
												<c:when test="${isLoggedIn}">
													<c:set var="VAT_asterisk" value="" />
													<c:if test="${productReference.target.subjectToVAT}">
														<c:set var="VAT_asterisk"><span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color hidden js-loadPriceVAT"></span></c:set>
													</c:if>
													<c:set var="priceProductCode" value="${not empty productReference.target.sapProductCode ? productReference.target.sapProductCode : productReference.target.code}" />
													<div class="js-loadPrice" data-product-code="${priceProductCode}" data-price-per-divider="${productReference.target.pricePerDivider}">
														<div class="js-loadWasPrice product-price product-price--was-price hidden">
															<span class="product-price__value product-price__value--was-price">
																<a href="${fn:escapeXml(productUrl)}" class="js-loadWasPriceValue"></a>
															</span>
														</div>
														<span class="product-price__value product-price__value--current js-loadPriceValue">
														</span>${VAT_asterisk}
														
														<c:if test="${not empty productReference.target.unitPriceDescriptor}">
															<span class="js-loadPriceEach hidden">
																<a href="${fn:escapeXml(productUrl)}" class="product-price__price-each js-productPrice">${currentCurrency.symbol}<span class="js-unitPrice"></span>${productReference.target.unitPriceDescriptor}</a>
															</span>	 	
														</c:if>
													</div>
												</c:when>
												<c:otherwise>
													<c:if test="${not empty productReference.target.wasPrice}">
														<div class="product-price product-price--was-price">
															<c:choose>
																<c:when test="${productReference.target.estimatedWasPrice != null}">
																	<span class="product-price__value product-price__value--was-price">
																		<a href="${fn:escapeXml(productUrl)}"><format:price priceData="${productReference.target.estimatedWasPrice}"/></a>
																	</span>
																	<span class="product-price__value product-price__value--was-price">
																		<a href="${fn:escapeXml(productUrl)}"><format:price priceData="${productReference.target.wasPrice}" removeSpacing="true"/></a>
																	</span>
																</c:when>
																<c:otherwise>
																	<span class="product-price__value product-price__value--was-price">
																		<a href="${fn:escapeXml(productUrl)}"><format:price priceData="${productReference.target.wasPrice}"/></a>
																	</span>
																</c:otherwise>
															</c:choose>
														</div>
													</c:if>
													<c:choose>
														<c:when test="${productReference.target.estimatedPrice != null}">
															<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__value product-price__value--current" data-price="${productReference.target.estimatedPrice.value}" data-currency-symbol="${currentCurrency.symbol}"><product:productListerItemPrice product="${productReference.target}"/></a>
															<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__value product-price__value--current" data-price="${productReference.target.price.value}" data-currency-symbol="${currentCurrency.symbol}"><product:productListerItemPrice product="${productReference.target}"/></a>
														</c:when>
														<c:otherwise>
															<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__value product-price__value--current" data-price="${productReference.target.price.value}" data-currency-symbol="${currentCurrency.symbol}"><product:productListerItemPrice product="${productReference.target}"/></a>
															<c:if test="${not empty productReference.target.unitPriceStr}">
																<a href="${fn:escapeXml(productUrl)}" class="js-productPrice product-price__price-each" data-price="${productReference.target.unitPriceStr}" data-currency-symbol="${currentCurrency.symbol}" data-price-descriptor="${productReference.target.unitPriceDescriptor}">
																		${productReference.target.unitPriceStr}</a>
															</c:if>
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
										</div>

									</div>    
								</c:if>
								<div class="product-item__size"><a href="${productUrl}"><spring:theme code="product.grid.packSize"/>: ${productReference.target.packSize}</a></div>

							<div class="addtocart">
<form:form id="" action="${formActionUrl}" method="post" class="add_to_cart_form js-addToCartForm cart__add " data-id="${fn:escapeXml(productReference.target.code)}" >
            <input type="hidden" name="productCodePost" value="${fn:escapeXml(productReference.target.code)}"/>
            <input type="hidden" name="entryNumber" value="${not empty productReference.target.cartEntry ? productReference.target.cartEntry.entryNumber : ''}"/>
            <input type="hidden" name="productNamePost" value="${fn:escapeXml(productReference.target.name)}"/>
			<c:choose>
				<c:when test="${productReference.target.netWeight != null && productReference.target.itemCategoryGroup}">
					<input type="hidden" name="productPostPrice" value="${fn:escapeXml(productReference.target.estimatedPrice.value)}"/>
				</c:when>
				<c:otherwise>
					<input type="hidden" name="productPostPrice" value="${fn:escapeXml(productReference.target.price.value)}"/>
				</c:otherwise>
			</c:choose>
            <%-- TODO populate it from BE --%>
            <input type="hidden" name="productCartQty" class="js-productCartQty" value="${not empty productReference.target.cartEntry.quantity ? productReference.target.cartEntry.quantity : 0}"/>
            <input type="hidden" name="qty" class="js-productCartQty" value="${not empty productReference.target.cartEntry.quantity ? productReference.target.cartEntry.quantity : 0}"/>

            <c:choose>
                <c:when test="${productReference.target.stock.stockLevelStatus.code eq 'outOfStock' }">
                    <button type="submit" class="btn btn-primary btn-block glyphicon glyphicon-shopping-cart"
                            aria-disabled="true" disabled="disabled">	
                    </button>
                </c:when>
                <c:otherwise>
				  <div class="js-productQtyUpdate quantity-update cart__quantity col-sm-12 col-xs-12">
                        <button type="button" class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-qtyBtn" data-action="remove" data-page="references" aria-label="Remove from cart"></button>
                        <input class="quantity-update__input js-productQtyInput" type="number" inputmode="numeric"  aria-label="Quantity" value="${not empty productReference.target.cartEntry.quantity ?  productReference.target.cartEntry.quantity: 1}" min="0" max="1000" />
                        <button type="button" class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-qtyBtn" data-action="add" data-page="references" aria-label="Add to cart"></button>
                    </div>
                <c:choose>
                     <c:when test="${isLoggedIn}">
                            <c:choose>                      
                                <c:when test="${not empty productReference.target.cartEntry.quantity}">
                                    <button type="button" disabled="disabled" class="col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn js-qtyChangeBtn cart__add-button" data-action="update" data-product-code="${fn:escapeXml(productReference.target.code)}" >
                                        <spring:theme code="product.variants.update"/>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" disabled="disabled" class="col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn js-qtyChangeBtn cart__add-button" data-action="add" data-product-code="${fn:escapeXml(productReference.target.code)}" >
                                        <spring:theme code="product.button.addToCart"/>
                                    </button>
                                 </c:otherwise>
                            </c:choose>                            
                        </c:when>
                    <c:otherwise>
                        <button type="button" class="js-displayLoginPopup btn btn-primary btn-block  cart__add-button">
                            <spring:theme code="product.button.addToCart"/>
                        </button>
                    </c:otherwise>
                
                </c:choose>

                    <%-- TODO add condition to check if QTY is greater then 0 --%>
                    
                </c:otherwise>
            </c:choose>
            </form:form>							</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</c:when>

	<c:otherwise>
		<component:emptyComponent />
	</c:otherwise>
</c:choose>


