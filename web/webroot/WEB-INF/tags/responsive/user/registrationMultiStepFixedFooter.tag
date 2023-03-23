<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="currentStep" required="true" type="java.lang.Integer" %>
<%@ attribute name="totalSteps" required="false" type="java.lang.Integer" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<div class="registration-fixed-footer visible-xs">
    <div class="row">
        <div class="col-xs-6">
            <a tabindex="0" href="${currentStep eq 1 ? '/become-a-customer-eligible' : previousStepUrl}" class="btn btn-secondary btn--auto-width-mobile pull-left">
                <div class="btn__text-wrapper">
                    <span class="icon icon-chevron-left btn__icon"></span>
                    <span class="btn__text"><spring:theme code="registration.progress.goBack" /></span>
                </div>
            </a>
        </div>
        <div class="col-xs-6">

        
            <button class="btn btn-primary btn-checkout-header btn--auto-width-mobile pull-right js-submitRegistrationForm">
                <c:choose>
                    <c:when test="${currentStep eq totalSteps}">
                        <span class="btn__text"><spring:theme code="registration.progress.submit"/></span>
                    </c:when>
                    <c:otherwise>
                        <span class="btn__text"><spring:theme code="registration.progress.goNext"/></span>
                        <span class="icon icon-chevron-right btn__icon"></span>
                    </c:otherwise>
                </c:choose>
            </button>
        </div>
    </div>
</div>