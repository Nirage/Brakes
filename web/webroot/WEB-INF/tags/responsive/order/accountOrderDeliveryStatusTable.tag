<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Phone hint --%>
<div class="order-delivery-status__phonehint">
    <img width="30" style="vertical-align:middle;" src="https://i1.adis.ws/i/Brakes/email-question-mark"
         alt="question"/>
    <span><spring:theme code="order.deliverystatus.phonehint"/></span>
</div>
<%-- Order Delivery Status Card --%>
<div class="order-delivery-status__card">
    <%-- Delivery Status Info --%>
    <table width="100%" border="0" class="order-delivery-status__card__info table clearfix" cellpadding="10">
        <tr class="order-delivery-status__card__info__header">
            <th>${fn:toUpperCase(orderDeliveryStatusData.customerName)}</th>
        </tr>
        <tr>
            <td class="order-delivery-status__card__refresh">
                <h5><span class="bullet"></span><spring:theme code="order.deliverystatus.refreshhint"/></h5>
            </td>
        </tr>
        <tr>
            <td>
                <table width="100%" class="order-delivery-status__card__info__table table">
                    <tr>
                        <td width="30%" class="order-delivery-status__card__info__label"><spring:theme code="order.deliverystatus.orderstatus"/></td>
                        <td width="70%" class="order-delivery-status__card__info__detail">${fn:substring(orderDeliveryStatusData.deliveryStatus, 1, fn:length(orderDeliveryStatusData.deliveryStatus))}</td>
                    </tr>
                    <tr>
                        <td class="order-delivery-status__card__info__label"><spring:theme code="order.deliverystatus.expectedarrival"/></td>
                        <td class="order-delivery-status__card__info__detail"><spring:theme code="order.deliverystatus.arrivalspan"
                                                                                            arguments="${orderDeliveryStatusData.deliveryDate},${orderDeliveryStatusData.etaDeliveryWindow}"/></td>
                    </tr>
                    <tr>
                        <td class="order-delivery-status__card__info__label"><spring:theme code="order.deliverystatus.driver"/></td>
                        <td class="order-delivery-status__card__info__detail">${orderDeliveryStatusData.driverName}</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <%-- Delivery Status Progress Bar --%>
    <c:set var="deliveryStatus" value = "${fn:substring(orderDeliveryStatusData.deliveryStatus, 0, 1)}" />
    <div class="order-delivery-status__card__progress row text-center">
        <c:choose>
            <c:when test="${deliveryStatus > 1 || deliveryStatus == 1}">
                <img src="https://i1.adis.ws/i/Brakes/emails-delivery-status-check.png" alt="Planned for delivery" width="40" height="40"/>
            </c:when>
            <c:otherwise>
                <img src="https://i1.adis.ws/i/Brakes/emails-delivery-status-uncheck.png" alt="Planned for delivery" width="40" height="40"/>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${deliveryStatus > 1}">
                <div class="order-delivery-status__card__progress__bar active"></div>
            </c:when>
            <c:otherwise>
                <div class="order-delivery-status__card__progress__bar"></div>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${deliveryStatus > 2 || deliveryStatus == 2}">
                <img src="https://i1.adis.ws/i/Brakes/emails-delivery-status-check.png" alt="Out For Delivery" width="40" height="40"/>
            </c:when>
            <c:otherwise>
                <img src="https://i1.adis.ws/i/Brakes/emails-delivery-status-uncheck.png" alt="Out For Delivery" width="40" height="40"/>
            </c:otherwise>
        </c:choose>
        </td>
        <td width="*">
            <c:choose>
            <c:when test="${deliveryStatus > 2}">
            <div class="order-delivery-status__card__progress__bar active"></div>
            </c:when>
            <c:otherwise>
            <div class="order-delivery-status__card__progress__bar"></div>
            </c:otherwise>
            </c:choose>

            <c:choose>
            <c:when test="${deliveryStatus > 3 || deliveryStatus == 3}">
            <img src="https://i1.adis.ws/i/Brakes/emails-delivery-status-check.png" alt="Delivered" width="40" height="40"/>
            </c:when>
            <c:otherwise>
            <img src="https://i1.adis.ws/i/Brakes/emails-delivery-status-uncheck.png" alt="Delivered" width="40" height="40"/>
            </c:otherwise>
            </c:choose>
    </div>
    <div class="order-delivery-status__card__progress__label text-justify">
        <div class="picked">
            <spring:theme code="order.deliverystatus.orderpicked"/>
        </div>
        <div class="outfor">
            <spring:theme code="order.deliverystatus.orderoutfordelivery"/>
        </div>
        <div class="delivered">
            <spring:theme code="order.deliverystatus.orderdelivered"/>
        </div>
    </div>