<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="order" required="true" type="de.hybris.platform.commercefacades.order.data.AbstractOrderData" %>
<%@ attribute name="orderEntry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ attribute name="consignmentEntry" required="false"
              type="de.hybris.platform.commercefacades.order.data.ConsignmentEntryData" %>
<%@ attribute name="itemIndex" required="true" type="java.lang.Integer" %>
<%@ attribute name="targetUrl" required="false" type="java.lang.String" %>
<%@ attribute name="showStock" required="false" type="java.lang.Boolean" %>
<%@ attribute name="showViewConfigurationInfos" required="false" type="java.lang.Boolean" %>
<%@ attribute name="viewConfigurationInfosBaseUrl" required="false" type="java.lang.String" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/responsive/grid" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="varShowStock" value="${(empty showStock) ? true : showStock}" />
<c:set var="defaultViewConfigurationInfosBaseUrl" value="/my-account/order" />

<c:url value="${orderEntry.product.url}" var="productUrl"/>
<c:set var="entryStock" value="${fn:escapeXml(orderEntry.product.stock.stockLevelStatus.code)}"/>

    

<li class="checkout-confirmation__product-item">

    <%-- chevron for multi-d products --%>
    <div class="hidden-xs hidden-sm item__toggle">
        <c:if test="${orderEntry.product.multidimensional}">
            <div class="js-show-multiD-grid-in-order" data-index="${itemIndex}">
                <ycommerce:testId code="cart_product_updateQuantity">
                    <span class="glyphicon glyphicon-chevron-down"></span>
                </ycommerce:testId>
            </div>
        </c:if>
    </div>

    <%-- product image --%>
    <div class="checkout-confirmation__product-item__image col-md-2">
        <ycommerce:testId code="orderDetail_productThumbnail_link">
            <a href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(product.name)}">
                <product:productImageLazyLoad product="${orderEntry.product}" ttMobile="$plp-mobile$" ttTablet="$plp-tablet$" ttDesktop="$plp-desktop$" format="thumbnail"/>
            </a>
        </ycommerce:testId>

         <div class="checkout-confirmation__advice-icons visible-xs">
                     <c:if test="${orderEntry.product.newProduct}">
                        		<a href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(entry.product.name)}">
                        		<span class="cart-item__advice-icons-img icon icon-new icon-new--royal-blue"></span>
                        		</a>
                      </c:if>
                     <c:forEach items="${orderEntry.product.productInfoIcons}" var="iconClass">

                    <a href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(entry.product.name)}">
                    </a>
                    </c:forEach>
            </div>    
    </div>
     <%-- product name, code, promotions --%>
     <div class="checkout-confirmation__product-item__detailSection">
    <div class="checkout-confirmation__product-item__info">
        <div class="item__code h-space-1">
            <ycommerce:testId code="orderDetails_productCode">
                <c:if test="${not empty orderEntry.product.prefix}">${orderEntry.product.prefix}&nbsp;</c:if>${fn:escapeXml(orderEntry.product.code)}
            </ycommerce:testId>
            <div class="checkout-confirmation__user-actions">
                <div class="js-userActions checkout-confirmation__user-actions-icon">
                <c:if test="${not empty quickOrderForm}">
                    <form:form method="post" class="js-quickOrderForm checkout-confirmation__inline"  action="${contextPath}/cart/quickOrder">
                      <input type="hidden" name="productCode" value="${orderEntry.product.code}"/>
                      <input type="hidden" name="qty"  value="${orderEntry.quantity}"  />
                      <input type="hidden" name="changeQuantity" value="0" />
                      <input type="hidden" name="isCheckoutPage" value="false"/>
                      <span tabindex="0" class="icon icon-recent-purchases js-orderSubmit" title="buy again"></span>
                    </form:form>
                </c:if>
                <product:productAddToFavouritePanel product="${orderEntry.product}"/>
                </div>
            </div>
       </div>
        <ycommerce:testId code="orderDetails_productName_link">
            <a href="${orderEntry.product.purchasable ? fn:escapeXml(productUrl) : ''}"><span class="item__name">${fn:escapeXml(orderEntry.product.name)}</span></a>
        </ycommerce:testId> 
        <c:if test="${orderEntry.product.unitsPerCase gt 1}"> 
                <div class="checkout-confirmation__product-itemUnitPrice"><span><spring:theme code="checkout.multi.order.full.quantity"></spring:theme>&nbsp;${orderEntry.product.unitsPerCase}</span></div>
        </c:if>
             <div class="checkout-confirmation__advice-icons hidden-xs">
                <c:if test="${orderEntry.product.newProduct}">
                          		<a href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(entry.product.name)}">
                          		<span class="cart-item__advice-icons-img icon icon-new icon-new--royal-blue"></span>
                          		</a>
                </c:if>
                <c:forEach items="${orderEntry.product.productInfoIcons}" var="iconClass">
                    <a href="${fn:escapeXml(productUrl)}" title="<spring:theme code="icon.title.${iconClass}"/>">
                        <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
                    </a>
                </c:forEach>
            </div>     
    </div>
    
    <div class="checkout-confirmation__product-item__details">
      <%-- price --%>
    <div class="item__price checkout-confirmation__product-itemPrice">
        <ycommerce:testId code="orderDetails_productItemPrice_label">
            <order:orderEntryPrice orderEntry="${orderEntry}"/>
        </ycommerce:testId>
    </div>
    <c:if test="${orderEntry.product.netWeight == null || orderEntry.pricePerKilo == null || !orderEntry.product.itemCategoryGroup}">
          <div class="checkout-confirmation__product-itemUnitPrice">
              <span>(<format:price priceData="${orderEntry.basePrice}" displayFreeForZero="true" />)</span>

              <span class="checkout-confirmation__left-space">${orderEntry.product.unitPriceStr}</span>
          </div>
    </c:if>
<div class="checkout-confirmation__product-itemPackSize"><spring:theme code="checkout.multi.order.packsize"/>&nbsp;${orderEntry.product.packSize}</div>
 <%-- quantity --%>
    <div class="checkout-confirmation__product-itemQty hidden-xs hidden-sm">
        <c:forEach items="${orderEntry.product.baseOptions}" var="option">
            <c:if test="${not empty option.selected and option.selected.url eq orderEntry.product.url}">
                <c:forEach items="${option.selected.variantOptionQualifiers}" var="selectedOption">
                    <div>
                        <ycommerce:testId code="orderDetail_variantOption_label">
                            <span>${fn:escapeXml(selectedOption.name)}:</span>
                            <spring:theme code="checkout.multi.order.quantity"/>
                            <span>${fn:escapeXml(selectedOption.value)}</span>
                        </ycommerce:testId>
                    </div>
                    <c:set var="entryStock" value="${fn:escapeXml(option.selected.stock.stockLevelStatus.code)}"/>
                </c:forEach>
            </c:if>
        </c:forEach>

        <ycommerce:testId code="orderDetails_productQuantity_label">
            <label class=""><spring:theme code="text.account.order.qty"/>:</label>
            <span class="qtyValue">
                <c:choose>
                    <c:when test="${consignmentEntry ne null }">
                        ${fn:escapeXml(consignmentEntry.quantity)}
                    </c:when>
                    <c:otherwise>
                        ${fn:escapeXml(orderEntry.quantity)}
                    </c:otherwise>
                </c:choose>
            </span>
        </ycommerce:testId>
    </div>
    </div>              
   </li>

<li>
	<c:if test="${empty targetUrl}">
		<spring:url value="/my-account/order/{/orderCode}/getReadOnlyProductVariantMatrix" var="targetUrl">
			<spring:param name="orderCode" value="${order.code}"/>
		</spring:url>
	</c:if>		
	<grid:gridWrapper entry="${orderEntry}" index="${itemIndex}" styleClass="display-none add-to-cart-order-form-wrap" targetUrl="${targetUrl}"/>
</li>

