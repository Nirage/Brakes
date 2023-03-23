<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"%>
<%@ attribute name="currentStep" required="true" type="java.lang.Integer" %>
<%@ attribute name="totalSteps" required="true" type="java.lang.Integer" %>
<%@ attribute name="position" required="true" type="java.lang.String" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="progressCompletion"><fmt:formatNumber value="${currentStep/ totalSteps * 100}"/></c:set>

<div class="checkout-progress">
    <c:if test="${position eq 'top'}">
        <div class="checkout-progress__heading">
            <spring:theme code="checkout.progress.steps" arguments="${currentStep},${totalSteps}"/>
        </div>
    </c:if>
    <div class="checkout-progress__progress-bar progress-bar">
        <div class="progress-bar__active" style="width: ${progressCompletion}%"></div>
    </div>
    <c:if test="${position eq 'bottom'}">
        <div class="checkout-progress__heading h-topspace-2">
            <spring:theme code="checkout.progress.steps" arguments="${currentStep},${totalSteps}"/>
        </div>
    </c:if>
</div>