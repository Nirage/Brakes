<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="order" required="true" type="de.hybris.platform.commercefacades.order.data.OrderHistoryData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="colClasses" value="col-xs-6 col-sm-3" />
<c:set var="colClassesLg" value="col-xs-6 col-sm-4" />
<c:set var="colClassesSm" value="col-xs-6 col-sm-2" />


<order:orderReOrderSuccess reOrderedSuccess="${reOrderedSuccess}"/>

<div class="order-details__section order-details-overview h-space-2">
    <div class="row">
        <div class="col-xs-12">
            <div class="order-details-overview__header">
                ${fn:escapeXml(order.code)}
            </div>
        </div>
    </div>
    <div class="order-details-overview__summary">
        <div class="row order-details-overview__row">
            <div class="${colClasses}">
                <div class="order-details-overview__label">
                    <spring:theme code="text.account.order.details.placedBy"/>
                </div>
                <c:choose>
                    <c:when test="${not empty order.placedBy}">
                       <div class="order-details-overview__value">${order.placedBy}</div>
                    </c:when>
                    <c:otherwise>
                    <c:if test="${not empty order.user }">
                        <div class="order-details-overview__value">${order.user.name}</div>
                    </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="${colClasses}">
                <ycommerce:testId code="orderDetail_overviewStatusDate_label">
                    <div class="order-details-overview__label">
                        <spring:theme code="text.account.order.details.submittedOn"/>
                    </div>
                    <div class="order-details-overview__value">
                        <fmt:formatDate pattern = "dd MMM yyyy" value = "${order.placed}" dateStyle="medium"/>
                    </div>
                </ycommerce:testId>
            </div>
            
            <div class="${colClassesLg}">
                <ycommerce:testId code="orderDetail_overviewOrderStatus_label">
                    <div class="order-details-overview__label"><spring:theme code="text.account.order.details.orderStatus"/></div>
                    <c:if test="${not empty order.status}">
                        <div class="order-details-overview__value order-status order-status--${fn:toLowerCase(order.status)}">
                            <spring:theme code="text.account.order.status.display.${fn:toLowerCase(order.status)}"/>
                        </div>
                    </c:if>
                </ycommerce:testId>
            </div>
            <div class="${colClassesSm} hidden-xs"></div>
            <div class="${colClasses}">
                <ycommerce:testId code="orderDetail_overviewOrderTotal_label">
                    <div class="order-details-overview__label">
                        <spring:theme code="text.account.order.details.poNumber" />
                    </div>
                    <div class="order-details-overview__value">
                        <c:choose>
                            <c:when test="${ not empty order.purchaseOrderNumber }">
                            ${order.purchaseOrderNumber }
                            </c:when>
                            <c:otherwise>
                            -
                            </c:otherwise>
                        </c:choose>
                    </div>
                </ycommerce:testId>
            </div>
            
            <div class="${colClasses}">
                <ycommerce:testId code="orderDetail_overviewOrderTotal_label">
                    <div class="order-details-overview__label">
                        <spring:theme code="text.account.order.details.requestedDelivery" />
                    </div>
                    <div class="order-details-overview__value">
                        <fmt:formatDate pattern = "dd MMM yyyy" value = "${order.deliveryDate}" dateStyle="medium"/>
                        </div>
                </ycommerce:testId>
            </div>
            <div class="${colClasses}">
                <ycommerce:testId code="orderDetail_overviewOrderTotal_label">
                    <div class="order-details-overview__label">
                        <spring:theme code="text.account.order.details.nombOfItems" />
                    </div>
                    <div class="order-details-overview__value">
                        ${order.totalLineItemCount}&nbsp;<spring:theme code="text.account.order.details.total.lines" />, ${order.totalUnitCount}&nbsp;<spring:theme code="text.account.order.details.total.items" />
                    </div>
                </ycommerce:testId>
            </div>

            <div class="${colClasses}">
                <ycommerce:testId code="orderDetail_overviewOrderTotal_label">
                    <div class="order-details-overview__label">
                        <spring:theme code="text.account.order.details.total"/>
                    </div>
                    <div class="order-details-overview__value--noSpace">
                        <format:price priceData="${order.total}"/>
                    </div>
                    <div class="cart-totals__body-text--font12 h-space-3">
                         <c:set value="true" var="minimumOrder"/>
                        <c:if test="${currentB2BUnit.minimumOrderValue gt 0}">                
                            <c:choose>
                                <c:when test="${order.total.value lt currentB2BUnit.minimumOrderValue}">
                                      <c:set value="false" var="minimumOrder"/>
                                <span class="delivery-date__deadline highlighted">
                                    <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
                                </span>
                                </c:when>
                                <c:otherwise>
                                    <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                  
                </ycommerce:testId>
            </div>
        </div>
    </div>
    <c:if test="${isAmendOrderDetailsPage}">
        <c:set var="gridClass" value="col-sm-4" />
        <c:set value="/my-account/resubmit/amend/order" var="resubmitURL"/>
        <c:set value='/my-account/checkAmendOrderEligibiltyForResubmit/' var="reSubmitAmendURL"/>
        <c:set value='/my-account/removeAmendOrder/' var="reSubmitRemoveAmendURL"/>
        <c:set value="${fn:escapeXml(order.code)}" var="orderCode"/>
                                    <input type="hidden" name="orderCode" value="${fn:escapeXml(order.code)}"/>

        <div class="order-details-overview__actions">
            <div class="row">
                <div class="${gridClass}">
                    <form action="${resubmitURL}" method="get" id="js-reSubmitForm">
                        <input value="${fn:escapeXml(order.code)}"  type="hidden" name="orderCode"/>
                             <c:set value="disabled" var="btnDisabled"/>
                        <c:if test="${order.isAnyEntryUnsumbitted && minimumOrder eq true}">
                             <c:set value="" var="btnDisabled"/>
                       </c:if>
                         <c:set value="true" var="minimumOrder"/>

                         <c:if test="${currentB2BUnit.minimumOrderValue gt 0}">       
                             <c:if test="${order.total.value lt currentB2BUnit.minimumOrderValue}">
                                <c:set value="false" var="minimumOrder"/>
                             </c:if>
                        </c:if>
                        <c:set value="/my-account/checkOrderEligibiltyForAmend/" var="cancelOrder"/>
                        <c:set value="${fn:escapeXml(order.code)}" var="orderCode"/>
                        <button type="button" class="btn btn-primary order-details-overview__btn js-reSubmit"  ${btnDisabled} data-url="${reSubmitAmendURL}${orderCode}" data-removeorder-url="${reSubmitRemoveAmendURL}${orderCode}">
                            <spring:theme code="text.order.details.resubmitCTA" />
                        </button>
                    </form> 
                </div>
                <div class="${gridClass}">
                    <a tabindex="0" href="#" class="btn btn-red order-details-overview__btn js-cancelOrder" data-url="${cancelOrder}${orderCode}" data-cancel-url="/my-account/order/${orderCode}">
                        <span class="icon icon-close"></span>
                        <spring:theme code="text.order.details.cancelCTA" />
                    </a>
                </div>
                <div class="${gridClass}">
                    <a tabindex="0" href="/my-account/order/${fn:escapeXml(order.code)}" class="btn btn-secondary order-details-overview__btn">
                    <span class="icon icon-chevron-left"></span>
                        <spring:theme code="text.order.details.backToOrderCTA" />
                    </a>
                </div>
            </div>
        </div>
    </c:if>
    <c:if test="${isOrderDetailsPage }">
        <c:set var="gridClass" value="col-sm-4" />
        <c:choose>
        <c:when test="${isAssistedServiceAgentLoggedIn and (order.status eq 'CONFIRMED_AND_MODIFIED' or order.status eq 'CONFIRMED' or order.status eq 'QUEUED' or order.status eq 'WAITING_FOR_CONFRMATION') and order.deliveryCutOffTimePassed eq true and order.orderReason ne 'ALL' }">
          <c:set var="gridClass" value="col-sm-4" />
        </c:when>
         <c:when test="${(order.status eq 'CONFIRMED_AND_MODIFIED' or order.status eq 'CONFIRMED') and order.deliveryCutOffTimePassed eq true and ( empty order.lockedBy  or order.lockedBy eq user.uid) and order.orderReason ne 'ALL' }">
               <c:set var="gridClass" value="col-sm-4" />
        </c:when>
        </c:choose>
        <div class="order-details-overview__actions">
            <div class="row">
                <c:url var="reorderUrl" value="/checkout/summary/reorder" scope="page"/>
                <div class="${gridClass}">
                    <form:form action="${reorderUrl}" id="reorderForm" modelAttribute="reorderForm" class="js-reOrderForm">
                        <button tabindex="0" type="submit" class="btn btn-primary order-details-overview__btn btn--full-width">
                            <span class="icon icon-recent-purchases"></span>
                            <spring:theme code="text.account.order.details.reorder"/>
                        </button>
                        <div>	
                            <input type="hidden" name="orderCode" value="${fn:escapeXml(order.code)}" />
                        </div>
                    </form:form>
                </div>
                <c:choose>
                 <c:when test="${isAssistedServiceAgentLoggedIn and (order.status eq 'CONFIRMED_AND_MODIFIED' or order.status eq 'CONFIRMED' or order.status eq 'QUEUED' or order.status eq 'WAITING_FOR_CONFRMATION') and order.deliveryCutOffTimePassed eq true  and order.orderReason ne 'ALL' }">
        			   <div class="${gridClass}">
                        <a tabindex="0" href="/my-account/start/amending/order/${order.code }" class="btn btn-primary order-details-overview__btn btn--full-width js-amendOrder" data-order-code="${order.code}">
                            <span class="icon icon-amend"></span>
                            <spring:theme code="text.account.order.details.amend" />
                        </a>
                    </div>
        		</c:when>
                 <c:when test="${(order.status eq 'CONFIRMED_AND_MODIFIED' or order.status eq 'CONFIRMED') and order.deliveryCutOffTimePassed eq true  and order.orderReason ne 'ALL' }">
        			  <div class="${gridClass}">
                        <a tabindex="0" href="/my-account/start/amending/order/${order.code }" class="btn btn-primary order-details-overview__btn btn--full-width js-amendOrde" data-order-code="${order.code}">
                            <span class="icon icon-amend"></span>
                            <spring:theme code="text.account.order.details.amend" />
                        </a>
                    </div>
        		</c:when>
                </c:choose>
                <div class="${gridClass}">
                     <spring:url value="/my-account/order/results/" var="printOrdersBaseUrl" htmlEscape="false"/>
                    <a tabindex="0" class="js-orderPrint btn btn-secondary order-details-overview__btn btn--full-width" data-url="${printOrdersBaseUrl}${order.code}?show=All">
                        <span class="icon icon-print"></span>
                        <spring:theme code="text.order.details.printCTA" />
                    </a>
                </div>
            </div>
        </div>
    </c:if>
    
</div>
