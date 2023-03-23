<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>


<div class="row">
    <div class="col-xs-12">
        <div class="site-header site-header--align-left">
            <h1 class="site-header__text site-header--align-left">
                <c:choose>
                    <c:when test="${quizResultRecord.passed}">
                       <spring:theme code="trainingModuleSubmit.passed.header" />
                    </c:when>
                    <c:otherwise>
                       <spring:theme code="trainingModuleSubmit.notPassed.header" />
                    </c:otherwise>
                </c:choose>
            </h1>
            <span class="site-header__rectangle site-header__rectangle--align-left"></span>
            <p class="site-header__subtext">
                <c:choose>
                    <c:when test="${quizResultRecord.passed}">
                       <spring:theme code="trainingModuleSubmit.passed.description" />
                    </c:when>
                    <c:otherwise>
                       <spring:theme code="trainingModuleSubmit.notPassed.description" />
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <div class="col-xs-12">
        <div class="row">
            <div class="col-xs-12">
                <span class="quiz__score-title"><spring:theme code="trainingModuleSubmit.score.title" /></span>
            </div>
            <div class="col-xs-12 col-md-8">
                <div class="quiz__results-bar">
                    <div class="quiz__results-bar quiz__results-bar--done" style="width: ${quizResultRecord.score}%">
                        <div class="quiz__results-bar-text-holder">
                            <span class="quiz__results-bar-text">${quizResultRecord.score}%</span>
                        </div>
                    </div>
                
                </div>
               
            </div>
        </div>

        <div class="row">
        <div class="col-xs-12">
            <c:choose>
                <c:when test="${quizResultRecord.passed}">
                    <form:form method="get" action="${contextPath}/my-country-choice/training-modules-results/certificate" cssClass="quiz__tryanother-form">
                        <input type="hidden" name="resultCode" value="${quizResultRecord.code}" />
                        <button type="submit" class="btn btn-primary btn--margin-top-20 btn--auto-width-desktop js-viewResults ">
                            <div class="btn__text-wrapper">
                                <span class="btn__text "><spring:theme code="trainingModuleSubmit.result.download.certificate" /></span>
                            </div>
                        </button>
                    </form:form>
                </c:when>
                <c:otherwise>
                    <form:form method="post" id="trainingModulesForm" action="${contextPath}/my-country-choice/training-modules" cssClass="quiz__retake-form">
                        <input type="hidden" name="firstName" value="${quizResultRecord.firstName}" />
                        <input type="hidden" name="surname" value="${quizResultRecord.surname}" />
                        <input type="hidden" name="quiz" value="${quizResultRecord.quizCode}" />
                        <button type="submit" class="btn btn-secondary btn--margin-top-20 btn--auto-width-desktop js-viewResults ">
                            <div class="btn__text-wrapper">
                                <span class="btn__text "><spring:theme code="trainingModuleSubmit.retake" /></span>
                            </div>
                        </button>
                    </form:form>
                </c:otherwise>
            </c:choose>
            <form:form method="get" action="${contextPath}/my-country-choice/training-modules" cssClass="quiz__tryanother-form">
                <button type="submit" class="btn btn-secondary btn--margin-top-20 btn--auto-width-desktop js-viewResults ">
                    <div class="btn__text-wrapper">
                        <span class="btn__text "><spring:theme code="trainingModuleSubmit.tryAnother" /></span>
                    </div>
                </button>
            </form:form>
            </div>
        </div>
    </div>


</div>

