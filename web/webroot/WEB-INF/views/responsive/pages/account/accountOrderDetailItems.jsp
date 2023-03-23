<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>

<div class="container">
    <div class="row">
    <div class="col-xs-12">
        <div class="account-orderdetail account-consignment checkout-confirmation">
            <div class="account-orderdetail account-consignment checkout-confirmation__header">
                <div class="checkout-confirmation__header--left"> <spring:theme code="checkout.multi.order.summary" /></div>
                    <c:if test="${not empty orderData.unconsignedEntries}">
                        <div class="checkout-confirmation__header--right hidden-xs">
                        <strong>
                           <span class="checkout-confirmation__icon icon icon-basket"></span>
                              <c:choose>
                                <c:when test="${isb2cSite && orderData.isVatApplicable}">
                                  <spring:theme code="checkout.multi.order.total.with.vat"/>
                                </c:when>
                                <c:otherwise>
                                  <spring:theme code="checkout.multi.order.total"/>
                                </c:otherwise>
                              </c:choose>
                        </strong>&nbsp;
                        <spring:theme code="checkout.multi.order.total.price"/>&nbsp;
                        <strong><format:price priceData="${orderData.totalPrice}"/></strong></div>
                    </c:if>
                </div>
            <c:if test="${not empty orderData.unconsignedEntries}">
                <div class="checkout-confirmation__content">
                     <div class="visible-xs checkout-confirmation__content-top">
                      <strong>
                         <c:choose>
                             <c:when test="${isb2cSite && orderData.isVatApplicable}">
                               <spring:theme code="checkout.multi.order.total.with.vat"/>
                             </c:when>
                             <c:otherwise>
                               <spring:theme code="checkout.multi.order.total"/>
                             </c:otherwise>
                          </c:choose>
                      </strong>&nbsp;
                     <spring:theme code="checkout.multi.order.total.price"/>&nbsp;
                     <span> <strong><format:price priceData="${orderData.totalPrice}"/></strong></span></div>
                    <div><spring:theme code="checkout.multi.order.delivery.date"/>
                        <span class="checkout-confirmation__left-space1"> ${orderData.formattedDeliveryDate}</span>
                    </div>
                    <div>
                    <spring:theme code="checkout.multi.order.items"/>
                    <span class="checkout-confirmation__left-space2"> ${orderData.entries.size()}&nbsp;<spring:theme code="text.account.orderHistory.total.lines "/> ,</span>
                    <span class="checkout-confirmation__subtext">${orderData.totalUnitCount}&nbsp;<spring:theme code="text.account.orderHistory.total.items "/> </span>

                    </div>
                </div>
<div class="account-orderdetail account-consignment">
    <ycommerce:testId code="orderDetail_itemList_section">
        <c:if test="${not empty orderData.unconsignedEntries}">
            <order:orderUnconsignedEntries order="${orderData}"/>
        </c:if>
        <c:forEach items="${orderData.consignments}" var="consignment">
            <c:if test="${consignment.status.code eq 'WAITING' or consignment.status.code eq 'PICKPACK' or consignment.status.code eq 'READY'}">
                <div class="productItemListHolder fulfilment-states-${fn:escapeXml(consignment.status.code)}">
                    <order:accountOrderDetailsItem order="${orderData}" consignment="${consignment}" inProgress="true"/>
                </div>
            </c:if>
        </c:forEach>
        <c:forEach items="${orderData.consignments}" var="consignment">
            <c:if test="${consignment.status.code ne 'WAITING' and consignment.status.code ne 'PICKPACK' and consignment.status.code ne 'READY'}">
                <div class="productItemListHolder fulfilment-states-${fn:escapeXml(consignment.status.code)}">
                    <order:accountOrderDetailsItem order="${orderData}" consignment="${consignment}"/>
                </div>
            </c:if>
        </c:forEach>
    </ycommerce:testId>
</div>
            </c:if>
        </div>
    </div>
</div>
    <favourites:newFavouritiesList/>
</div>


