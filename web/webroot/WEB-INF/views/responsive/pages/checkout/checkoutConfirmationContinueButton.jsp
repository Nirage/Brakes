<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<spring:url value="${continueUrl}" var="continueShoppingUrl" scope="session" htmlEscape="false"/>
	<c:url value="/" var="homePageUrl" />


<div class="row">
    <div class="col-xs-12">
        <div class="continue__shopping h-space-6 text-center">
            <a href="/" tabindex="0" class="btn btn-primary btn--continue-shopping js-continue-shopping-button" data-continue-shopping-url="${fn:escapeXml(homePageUrl)}">
                <spring:theme code="checkout.orderConfirmation.continueShopping" />
            </a>
        </div>
    </div>
</div>
