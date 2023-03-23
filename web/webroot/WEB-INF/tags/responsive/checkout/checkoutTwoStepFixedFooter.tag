<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ attribute name="currentStep" required="true" type="java.lang.Integer" %>
<%@ attribute name="totalSteps" required="false" type="java.lang.Integer" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/checkout/placeOrder" var="placeOrderUrl"/>

<div class="checkout-fixed-footer visible-xs">
    <div class="row">
        <div class="col-xs-6">
            <c:if test="${currentStep ne 1 && missingOrBestSellerAvailable eq true}">
                <a tabindex="0" href="/checkout/step-one" class="btn btn-secondary btn--auto-width-mobile pull-left">
                    <div class="btn__text-wrapper">
                    <span class="icon icon-chevron-left btn__icon"></span>
                        <span class="btn__text"><spring:theme code="checkout.progress.goBack" /></span>
                    </div>
                </a>
            </c:if>
        </div>
        <div class="col-xs-6">
            <c:if test="${currentStep eq 1}">
                <a tabindex="0" href="/checkout?steppedCheckout=true" class="btn btn-primary btn-checkout-header btn--auto-width-mobile pull-right no-border">
                    <div class="btn__text-wrapper">
                        <span class="btn__text"><spring:theme code="checkout.checkout" /></span>
                        <span class="icon icon-chevron-right btn__icon"></span>
                    </div>
                </a>
            </c:if>
            <c:if test="${currentStep eq totalSteps}">
                <form:form id="placeOrderForm" name="placeOrderForm" action="${fn:escapeXml(placeOrderUrl)}" method="post" modelAttribute="placeOrderForm" class="js-placeOrderForm">
                    <c:set var="cardStatus" value="${isPaymentEnabled && (paymentCardStatus eq 'EXPIRED' || paymentCardStatus eq 'NOT_ADDED_BUT_MANDATORY')}" />
                    <button class="btn btn-primary btn-checkout-header btn--auto-width-mobile pull-right js-placeOrder" ${cardStatus ? 'disabled' : ''}>
                        <div class="btn__text-wrapper">
                            <span class="btn__text"><spring:theme code="checkout.summary.placeOrder"/></span>
                            <span class="icon icon-chevron-right btn__icon"></span>
                        </div>
                    </button>
                </form:form>
            </c:if>
        </div>
    </div>
</div>