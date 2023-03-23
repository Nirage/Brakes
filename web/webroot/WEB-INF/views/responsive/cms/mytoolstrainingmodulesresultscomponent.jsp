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
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<div class="row">
    <div class="col-xs-12">
        <div class="site-header site-header--align-left">
            <h1 class="site-header__text site-header--align-left">${cmsPage.title}</h1>
            <span class="site-header__rectangle site-header__rectangle--align-left"></span>
            <p class="site-header__subtext"><spring:theme code="trainingModulesResults.description" /></p>
        </div>
    </div>

    <div class="col-xs-12">
        <div id="jsQuizResultsContainer">
            <div class="quiz__results">
            <div class="quiz__results-header">
                <div class="quiz__results-entry-column quiz__results-entry-column--1">
                    <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.name" /></div>
                </div>
                <div class="quiz__results-entry-column quiz__results-entry-column--2">
                    <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.date" /></div>
                </div>
                <div class="quiz__results-entry-column quiz__results-entry-column--3">
                    <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.module" /></div>
                </div>
                <div class="quiz__results-entry-column quiz__results-entry-column--4">
                    <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.correct" /></div>
                </div>
                <div class="quiz__results-entry-column quiz__results-entry-column--5">
                    <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.incorrect" /></div>
                </div>
                <div class="quiz__results-entry-column quiz__results-entry-column--6">
                    <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.passed" /></div>
                </div>
            </div>
            <c:forEach items="${quizResultsPageData.results}" var="quizResult">
                <div class="quiz__results-entry">
                    <div class="quiz__results-entry-column quiz__results-entry-column--1">
                        <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.name" /></div>
                        <div class="quiz__results-entry-content">${quizResult.firstName}&nbsp;${quizResult.surname}</div>
                    </div>
                    <div class="quiz__results-entry-column quiz__results-entry-column--2">
                        <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.date" /></div>
                        <div class="quiz__results-entry-content">${quizResult.date}</div>
                    </div>
                    <div class="quiz__results-entry-column quiz__results-entry-column--3">
                        <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.module" /></div>
                        <div class="quiz__results-entry-content">${quizResult.quizName}</div>
                    </div>
                    <div class="quiz__results-entry-column quiz__results-entry-column--4">
                        <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.correct" /></div>
                        <div class="quiz__results-entry-content">${quizResult.correct}</div>
                    </div>
                    <div class="quiz__results-entry-column quiz__results-entry-column--5">
                        <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.incorrect" /></div>
                        <div class="quiz__results-entry-content">${quizResult.incorrect}</div>
                    </div>
                    <div class="quiz__results-entry-column quiz__results-entry-column--6">
                        <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.passed" /></div>
                        <div class="quiz__results-entry-content">
                        <span class="icon "></span>
                        <span class="icon ${quizResult.passed ? 'icon-tick ' : 'icon-close'} "></span>
                        </div>
                    </div>
                    <c:if test="${quizResult.passed}">
                        <div class="quiz__results-entry-column quiz__results-entry-column--full-width">
                            <a class="quiz__results-download-cert" href="/my-country-choice/training-modules-results/certificate?resultCode=${quizResult.code}"><spring:theme code="trainingModulesResults.result.download.certificate" /></a>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
            </div>
        </div>
    </div>

    <div class="col-xs-12">
        <form:form method="post" id="trainingModulesResultsForm" modelAttribute="trainingModulesResultsForm" action="${contextPath}/my-country-choice/training-modules-results" cssClass="site-form js-trainingModulesResultsForm js-formValidation">
            <div class="site-form__section is-active">
                <div class="site-form__section-content">
                    <div class="row">
                        <div class="col-xs-12">
                            <h4 class="quiz__filters-heading"><spring:theme code="trainingModulesResults.filterHeading" /></h4>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <formElement:formInputBox
                                idKey="startDate"
                                labelKey=""
                                hideLabel="${true}"
                                path="startDate"
                                errorKey="startDate"
                                inputCSS="form-control site-form__input js-formField js-resultsStartDate quiz__results-filter-input"
                                labelCSS="site-form__label hide"
                                mandatory="false"
                                showAsterisk="true"
                                validationType="date"
                                placeholderKey="startDate"/>
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <formElement:formInputBox
                                idKey="endDate"
                                labelKey=""
                                hideLabel="${true}"
                                errorKey="endDate"
                                path="endDate"
                                inputCSS="form-control site-form__input js-formField js-resultsEndDate quiz__results-filter-input"
                                labelCSS="site-form__label hide"
                                mandatory="false"
                                showAsterisk="true"
                                validationType="date"
                                placeholderKey="endDate"/>
                        </div>
                    </div>

                    <button tabindex="0" type="submit" class="btn btn-primary quiz__filters-btn js-viewResults">
                        <div class="btn__text-wrapper">
                            <span class="btn__text "><spring:theme code="trainingModulesResults.filterDates" /></span>
                        </div>
                    </button>
                    <button tabindex="0" type="button" class="btn btn-secondary quiz__filters-btn js-resetResults">
                    <div class="btn__text-wrapper">
                        <span class="btn__text "><spring:theme code="trainingModulesResults.filterReset" /></span>
                    </div>
                </button>
            </div>
            </div>
        </form:form>
    </div>
</div>

<script id="quiz-results-template" type="text/x-handlebars-template">
<div class="quiz__results">
    <div class="quiz__results-header">
        <div class="quiz__results-entry-column quiz__results-entry-column--1">
            <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.name" /></div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--2">
            <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.date" /></div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--3">
            <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.module" /></div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--4">
            <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.correct" /></div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--5">
            <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.incorrect" /></div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--6">
            <div class="quiz__results-entry-heading hidden-xs hidden-sm"><spring:theme code="trainingModulesResults.result.column.passed" /></div>
        </div>
    </div>
    {{#each this}}
    <div class="quiz__results-entry">
        <div class="quiz__results-entry-column quiz__results-entry-column--1">
            <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.name" /></div>
            <div class="quiz__results-entry-content">{{firstName}}&nbsp;{{surname}}</div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--2">
            <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.date" /></div>
            <div class="quiz__results-entry-content">
            {{date}}
            </div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--3">
            <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.module" /></div>
            <div class="quiz__results-entry-content">{{quizName}}</div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--4">
            <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.correct" /></div>
            <div class="quiz__results-entry-content">{{correct}}</div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--5">
            <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.incorrect" /></div>
            <div class="quiz__results-entry-content">{{incorrect}}</div>
        </div>
        <div class="quiz__results-entry-column quiz__results-entry-column--6">
            <div class="quiz__results-entry-heading visible-xs visible-sm"><spring:theme code="trainingModulesResults.result.column.passed" /></div>
            <div class="quiz__results-entry-content">
            <span class="icon "></span>
            <span class="icon {{#if passed}} icon-tick  {{else}} icon-close {{/if}} "></span>
            </div>
        </div>
        {{#if passed}}
        <div class="quiz__results-entry-column quiz__results-entry-column--full-width">
            <a class="quiz__results-download-cert" href="/my-country-choice/training-modules-results/certificate?resultCode={{code}}"><spring:theme code="trainingModulesResults.result.download.certificate" /></a>
        </div>
        {{/if}}
    </div>
    {{/each}}
</div>
</script>