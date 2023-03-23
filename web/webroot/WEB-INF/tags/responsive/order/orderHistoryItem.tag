<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="order" required="true" type="de.hybris.platform.commercefacades.order.data.OrderHistoryData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<c:set var="PONumber" value="-" />
<c:if test="${not empty order.purchaseOrderNumber }">
	<c:set var="PONumber" value="${order.purchaseOrderNumber}" />
</c:if>

<div class="col-sm-6 col-md-3">
  <div class="order-history-item">
    <div class="order-history-item__header">
			<div class="order-history-item__id">${fn:escapeXml(order.code)}</div>
    </div>
    <div class="order-history-item__content">
        <div class="order-history-item__content-section">
            <div class="order-history-item__label">
              <spring:theme code="text.account.orderHistory.placedBy"/>
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

            <div class="order-history-item__label">
              <spring:theme code="text.account.orderHistory.poNumber" />
            </div>
            <div class="order-history-item__value order-history-item__value-reference">${PONumber}</div>
        </div>
        <div class="order-history-item__content-section">
            <div class="order-history-item__dates">
              <div>
                <div class="order-history-item__label">
                  <spring:theme code="text.account.orderHistory.datePlaced"/>
                </div>
                <div class="order-history-item__value">
                  <fmt:formatDate pattern = "dd MMM yyyy" value = "${order.placed}" dateStyle="medium"/>
                </div>
              </div>
              <div>
                <div class="order-history-item__label">
                  <spring:theme code="text.account.orderHistory.requestedDelivery"/>
                </div>
                <div class="order-history-item__value ">
                  <fmt:formatDate pattern = "dd MMM yyyy" value = "${order.deliveryDate}" dateStyle="medium"/>
                </div>
              </div>
            </div>
        </div>
        <div class="order-history-item__content-section last">
          <div class="order-history-item__label"><spring:theme code="text.account.orderHistory.orderStatus"/></div>
          <div class="order-history-item__value order-status order-status--${fn:toLowerCase(order.status)}">
            <spring:theme code="text.account.order.status.display.${fn:toLowerCase(order.status)}"/>
          </div>
        </div>

        <div class="order-history-item__number-items clearfix">
          <span class="order-history-item__number-items-text order-history-item__value">
            <spring:theme code="text.account.orderHistory.nombOfItems"/>
          </span>
          <span class="order-history-item__number-items-value">
            ${order.totalLineItemCount}&nbsp;<spring:theme code="text.account.orderHistory.total.lines" />, ${order.totalUnitCount}&nbsp;<spring:theme code="text.account.orderHistory.total.items" />
          </span>
        </div>

        <div class="order-history-item__totals">
          <span class="order-history-item__totals-text">
            <span class="icon icon-basket"></span>
            <span><spring:theme code="text.account.orderHistory.total"/></span>
          </span>
          <span class="order-history-item__totals-value">
            ${fn:escapeXml(order.total.formattedValue)}
          </span>
        </div>
                        <c:url var="reorderUrl" value="/checkout/summary/order-history/reorder" scope="page"/>

        <c:choose>
 		<c:when test="${isAssistedServiceAgentLoggedIn and (order.status eq 'CONFIRMED_AND_MODIFIED' or order.status eq 'CONFIRMED' or order.status eq 'QUEUED' or order.status eq 'WAITING_FOR_CONFRMATION') and order.deliveryCutOffTimePassed eq true and order.orderReason ne 'ALL' }">
            <div class="order-history-item__actions">
              <a tabindex="0" href="/my-account/order/${order.code}" class="btn btn-secondary btn--full-width js-orderViewDetails">
                <spring:theme code="text.account.orderHistory.total.viewDetails" />
              </a>
              <a  tabindex="0" href="/my-account/start/amending/order/${order.code}" class="btn btn-primary btn--full-width js-amendOrder" data-order-code="${order.code}">
                <span class="icon icon-amend icon--sm"></span>
                <spring:theme code="text.account.orderHistory.amend" />
              </a>
            </div>
          </c:when>        
          <c:when test="${(order.status eq 'CONFIRMED_AND_MODIFIED' or order.status eq 'CONFIRMED') and order.deliveryCutOffTimePassed eq true  and (empty order.lockedBy or order.lockedBy eq user.uid)  and order.orderReason ne 'ALL'}">
            <div class="order-history-item__actions">
              <a tabindex="0" href="/my-account/order/${order.code}" class="btn btn-secondary btn--full-width js-orderViewDetails">
                <spring:theme code="text.account.orderHistory.total.viewDetails" />
              </a>
              <a tabindex="0" href="/my-account/start/amending/order/${order.code}" class="btn btn-primary btn--full-width js-amendOrder" data-order-code="${order.code}">
                <span class="icon icon-amend icon--sm"></span>
                <spring:theme code="text.account.orderHistory.amend" />
              </a>
            </div>
          </c:when>
          <c:otherwise>
            <div class="order-history-item__actions">
              <a tabindex="0" href="/my-account/order/${order.code}" class="btn btn-secondary btn--full-width js-orderViewDetails">
                <spring:theme code="text.account.orderHistory.total.viewDetails" />
              </a>
              <form:form action="${reorderUrl}" id="reorderForm" modelAttribute="reorderForm" class="js-reOrderForm reorder__form">
                <button tabindex="0" type="submit" class="btn btn-primary  btn--full-width reorder__btn">
                    <span class="icon icon-recent-purchases"></span>
                    <spring:theme code="text.account.order.details.reorder"/>
                </button>
                <div>	
                    <input type="hidden" name="orderCode" value="${fn:escapeXml(order.code)}" />
                </div>
              </form:form>
              </div> 
          </c:otherwise>
        </c:choose>
    </div>
  </div>
</div>