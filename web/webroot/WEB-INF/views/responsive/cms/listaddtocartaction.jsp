<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<c:url value="/cart/notLoggedInAddAction" var="notLoggedInAddAction"/>
<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedIn" value="true" />
</sec:authorize>

<input type="hidden" id="cartLargeQuantity" value="${cartLargeQuantity}" />
<input type="hidden" id="cartMaximumQuantity" value="${cartMaximumQuantity}" />

<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />

<c:if test="${not product.multidimensional }">
    <c:url value="/cart/add" var="formActionUrl"/>
    <c:if test="${not empty product.cartEntry.quantity}">
        <c:url value="/cart/update" var="formActionUrl" />
    </c:if>
    <spring:url value="${product.url}/configuratorPage/{/configuratorType}" var="configureProductUrl" htmlEscape="false">
        <spring:param name="configuratorType" value="${configuratorType}" />
    </spring:url>
    <input type="hidden" value="${viewPromotions}" class="js-cartViewPromotion"/>
    
    <form:form id="addToCartForm${fn:escapeXml(product.code)}" action="${formActionUrl}" method="post" 
    class="cart__add add_to_cart_form js-addToCartForm ${viewPromotions && product.cartEntry.promoGroupNumber gt -1 ? 'js-cartItemPromoGroup' : ''}" data-id="${fn:escapeXml(product.code)}" >

        <ycommerce:testId code="addToCartButton">
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
            <%-- TODO populate it from BE --%>
            <input type="hidden" name="qty" class="js-productCartQty" value="${not empty product.cartEntry.quantity ? product.cartEntry.quantity : 0}"/>
            <input type="hidden" name="productCartQty" class="js-productCartQty" value="${not empty product.cartEntry.quantity ? product.cartEntry.quantity : 0}"/>

            <c:choose>
                <c:when test="${product.stock.stockLevelStatus.code eq 'outOfStock' }">
                    <button type="submit" class="btn btn-primary btn-block "
                            aria-disabled="true" disabled="disabled">
                            <spring:theme code="product.button.addToCart"/>
                    </button>
                </c:when>
                <c:otherwise>
                        <c:choose>
                            <c:when test="${product.isDiscontinued eq true}">
                                <button  class=" btn btn-primary btn-block col-sm-12 col-xs-12 discontinued__btn discontinued__btnDisabled js-discontinuedInfo ">
                                <spring:theme code="discontinued.button.title"/>
                               </button> 
                               <span class="icon icon-error product-item--discontinuedIcon js-discontinuedInfo"></span>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${product.isOutOfStock eq true}">
                                        <button  class=" btn btn-primary btn-block col-sm-12 col-xs-12 discontinued__btn discontinued__btnDisabled js-outOfStockInfo ">
                                            <spring:theme code="outOfStock.button.title"/>
                                        </button> 
                                        <span class="icon icon-error product-item--discontinuedIcon js-outOfStockInfo"></span>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="js-productQtyUpdate quantity-update cart__quantity col-xs-12 col-sm-12">
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
                                                <button type="button" class="col-xs-12 js-displayLoginPopup cart__add-button btn btn-primary btn-block"><spring:theme code="product.button.addToCart"/></button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>

                    <%-- TODO add condition to check if QTY is greater then 0 --%>
                  
                </c:otherwise>
            </c:choose>
        </ycommerce:testId>
    </form:form>

    <form:form id="configureForm${fn:escapeXml(product.code)}" action="${configureProductUrl}" method="get" class="configure_form">
        <c:if test="${product.configurable}">
            <c:choose>
                <c:when test="${product.stock.stockLevelStatus.code eq 'outOfStock' }">
                    <button id="configureProduct" type="button" class="btn btn-primary btn-block"
                            disabled="disabled">
                        <spring:theme code="basket.configure.product"/>
                    </button>
                </c:when>
                <c:otherwise>
                    <button id="configureProduct" type="button" class="btn btn-primary btn-block js-enable-btn" disabled="disabled"
                            onclick="location.href='${fn:escapeXml(configureProductUrl)}'">
                        <spring:theme code="basket.configure.product"/>
                    </button>
                </c:otherwise>
            </c:choose>
        </c:if>
    </form:form>
</c:if>
<product:discontinuedInfo product="${product}"/>
<product:outOfStockInfo product="${product}"/>