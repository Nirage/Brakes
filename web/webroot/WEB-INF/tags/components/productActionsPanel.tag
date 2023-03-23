<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:url value="/cart/notLoggedInAddAction" var="notLoggedInAddAction"/>
<c:url value="/cart/add" var="formActionUrl"/>
<c:if test="${not empty product.cartEntry.quantity}">
    <c:url value="/cart/update" var="formActionUrl" />
</c:if>
<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedIn" value="true" />
</sec:authorize>

<input type="hidden" id="cartLargeQuantity" value="${cartLargeQuantity}" />
<input type="hidden" id="cartMaximumQuantity" value="${cartMaximumQuantity}" />

<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />
<input type="hidden" value="${viewPromotions}" id="js-cartViewPromotion"/>
<div class="product-details__price-panel ${customCSSClass}">
    <div class="clearfix">
        <div class="product-details__size product-size visible-md visible-lg clearfix">
            <div class="product-size__item product-size__item--size-pack"><spring:theme code="product.details.packSize"/>: ${product.packSize}</div>
          	<c:if test="${product.unitsPerCase gt 1}"> 
                <div class="product-size__item--size-case"><spring:theme code="product.grid.caseSize"/>: ${product.unitsPerCase}</div>
            </c:if>
        </div>
       
        <div class="product-details__price-panel-actions clearfix col-xs-12 col-md-8">
            <div class="product-details__add-to-cart">
                <form:form id="" action="${formActionUrl}" method="post" class="add_to_cart_form js-addToCartForm ${(viewPromotions && (product.hasPotentialPromo || not empty product.wasPrice)) || !isLoggedIn && not empty product.wasPrice ? 'js-cartItemPromoGroup' : ''}" data-id="${fn:escapeXml(product.code)}" >
                    <input type="hidden" name="productCodePost" value="${fn:escapeXml(product.code)}"/>
                    <input type="hidden" name="entryNumber" value="${not empty product.cartEntry ? product.cartEntry.entryNumber : ''}"/>
                    <input type="hidden" name="productNamePost" value="${fn:escapeXml(product.name)}"/>
                    <c:choose>
                        <c:when test="${product.estimatedPrice != null}">
                            <input type="hidden" name="productPostPrice" value="${fn:escapeXml(product.estimatedPrice.value)}"/>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="productPostPrice" value="${fn:escapeXml(product.price.value)}"/>
                        </c:otherwise>
                    </c:choose>
                    <input type="hidden" name="productCartQty" class="js-productCartQty" value="${not empty product.cartEntry.quantity ? product.cartEntry.quantity : 0}"/>
                    <input type="hidden" name="qty" class="js-productCartQty" value="${not empty product.cartEntry.quantity ? product.cartEntry.quantity : 0}"/>
                    <c:choose>
                        <c:when test="${product.stock.stockLevelStatus.code eq 'outOfStock'}">
                            <button type="submit" class="btn btn-primary btn-block product-details__add-to-cart-btn"
                                    aria-disabled="true" disabled="disabled">
                                      <spring:theme code="product.button.addToCart"/>
                            </button>
                        </c:when>
                        <c:otherwise>
                        <c:choose>
                            <c:when test="${product.isDiscontinued eq true}">
                                <button disabled="disabled" class="col-sm-12 col-xs-12 btn btn-primary btn-block discontinued__btn">
                                <spring:theme code="discontinued.button.title"/>
                               </button> 
                            </c:when>
                            <c:otherwise>
                            <c:choose>
                             <c:when test="${product.isOutOfStock eq true}">
                              <button  class="col-sm-12 col-xs-12 btn btn-disabled btn-block discontinued__btn js-outOfStockInfoPdp">
                                <spring:theme code="outOfStock.button.title"/>
                               </button> 
                               <span class="icon icon-error product-item--discontinuedIconLeft js-outOfStockInfoPdp"></span>
                             </c:when>
                                <c:otherwise>
                                <div class="js-productQtyUpdate quantity-update cart__quantity col-xs-12 col-sm-12 h-space-2">
                                    <button type="button" class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-qtyBtn" data-action="remove" aria-label="Remove from cart"></button>
                                    <input class="quantity-update__input js-productQtyInput" type="number" inputmode="numeric"  aria-label="Quantity" value="${not empty product.cartEntry.quantity ? product.cartEntry.quantity : 1}" min="0" max="1000" />
                                    <button type="button" class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-qtyBtn" data-action="add" aria-label="Add to cart"></button>
                                </div>
                                
                               <c:choose>
                                    <c:when test="${isLoggedIn}">
                                        <c:choose>                      
                                            <c:when test="${not empty product.cartEntry.quantity }">
                                                <button type="button" disabled="disabled" class=" col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn js-qtyChangeBtn cart__add-button" data-action="update" data-product-code="${fn:escapeXml(product.code)}" >
                                                    <spring:theme code="product.variants.update"/>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" disabled="disabled" class="col-sm-12 col-xs-12 btn btn-primary btn-block js-enable-btn js-addToCartBtn js-qtyChangeBtn cart__add-button" data-action="add" data-product-code="${fn:escapeXml(product.code)}" >
                                                    <spring:theme code="product.button.addToCart"/>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>                            
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="js-displayLoginPopup col-xs-12 cart__add-button btn btn-primary btn-block"><spring:theme code="product.button.addToCart"/></button>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                        </c:otherwise>
                        </c:choose>
           <%-- TODO add condition to check if QTY is greater then 0 --%>
                           
                        </c:otherwise>
                    </c:choose>
                </form:form>
            </div>

            <div class="product-details__price-wrapper col-xs-6 p-0">
                <ycommerce:testId code="productDetails_productNamePrice_label_${product.code}">
                    <product:productPricePanelDetail product="${product}" />
                </ycommerce:testId>
            </div>
        </div>
    </div>					


</div>
