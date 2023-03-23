<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"%>
<%@ attribute name="currentStep" required="true" type="java.lang.Integer" %>
<%@ attribute name="totalSteps" required="true" type="java.lang.Integer" %>
<%@ attribute name="position" required="true" type="java.lang.String" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="register" tagdir="/WEB-INF/tags/responsive/register" %>


<spring:htmlEscape defaultHtmlEscape="true" />
<register:saveAndExit/>

<c:set var="progressCompletion"><fmt:formatNumber value="${currentStep/totalSteps * 100}"/></c:set>

<div class="registration-progress js-registrationProgressBar">
    <c:if test="${position eq 'top'}">
        <div class="registration-progress__heading">
            <spring:theme code="registration.progress.steps" arguments="${currentStep},${totalSteps}"/>
        </div>
    </c:if>
    <div class="registration-progress__progress-bar progress-bar ${position eq 'top' ? 'h-space-4' : ''} ${position eq 'bottom' ? 'h-topspace-4' : ''}">
        <div class="progress-bar__active" style="width: ${progressCompletion}%"></div>
    </div>
    <c:if test="${position eq 'bottom'}">
        <div class="registration-progress__heading h-topspace-2">
            <spring:theme code="registration.progress.steps" arguments="${currentStep},${totalSteps}"/>
        </div>
    </c:if>
    <div class="registration-progress__actions">
        <div class="row">
            <div class="col-xs-12 col-sm-6">
                <a tabindex="0" href="${currentStep eq 1 ? '/become-a-customer-eligible' : previousStepUrl}" class="btn btn-secondary has-items pull-left btn--auto-width-desktop hidden-xs">
                    <div class="btn__text-wrapper">
                        <span class="icon icon-chevron-left btn__icon"></span>
                        <span class="btn__text"><spring:theme code="registration.progress.goBack"/></span>
                    </div>
                </a>
            </div>
            <div class="col-xs-12 col-sm-6">
            

                <button type="button" tabindex="0" class="js-submitRegistrationForm btn btn-primary pull-right btn--auto-width-desktop hidden-xs disabled" >
                    <div class="btn__text-wrapper">
                        <c:choose>
                            <c:when test="${currentStep eq totalSteps}">
                                <span class="btn__text"><spring:theme code="registration.progress.submit"/></span>
                            </c:when>
                            <c:otherwise>
                                <span class="btn__text"><spring:theme code="registration.progress.goNext"/></span>
                                <span class="icon icon-chevron-right btn__icon"></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </button>
            </div>
        </div>
    </div>
</div>