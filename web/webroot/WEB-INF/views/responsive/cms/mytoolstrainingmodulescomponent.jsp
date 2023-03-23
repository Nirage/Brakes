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
<%@ taglib prefix="quiz" tagdir="/WEB-INF/tags/responsive/quiz" %>

<div class="row">
    <div class="col-xs-12">
        <div class="site-header site-header--align-left">
            <h1 class="site-header__text site-header--align-left">${cmsPage.title}</h1>
            <span class="site-header__rectangle site-header__rectangle--align-left"></span>
            <p class="site-header__subtext"><spring:theme code="trainingModules.description" /></p>
        </div>
        <quiz:viewResults/>
    </div>
    <div class="col-xs-12">
        <form:form method="post" modelAttribute="trainingModulesForm" action="${contextPath}/my-country-choice/training-modules" cssClass="site-form js-trainingModulesForm js-formValidation">
            <div class="site-form__section is-active">
                <div class="site-form__section-content">
                    <div class="row">
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <formElement:formInputBox
                                idKey="trainingModules.firstName"
                                labelKey="trainingModules.firstName"
                                path="firstName"
                                errorKey="firstName"
                                inputCSS="form-control site-form__input js-formField"
                                labelCSS="site-form__label"
                                mandatory="true"
                                showAsterisk="true"
                                validationType="name"
                                placeholderKey="firstName"
                            />
                        </div>
                        <div class="col-xs-12 col-sm-6 col-md-4">
                            <formElement:formInputBox
                                idKey="trainingModules.surname"
                                labelKey="trainingModules.surname"
                                errorKey="surname"
                                path="surname"
                                inputCSS="form-control site-form__input js-formField"
                                labelCSS="site-form__label"
                                mandatory="true"
                                showAsterisk="true"
                                validationType="name"
                                placeholderKey="lastName"
                            />
                        </div>
                        <div class="col-xs-12 col-md-4">
                            <formElement:formSelectBox
                                idKey="trainingModules.quiz"
                                labelKey="trainingModules.quiz"
                                selectCSSClass="form-control site-form__select js-formSelect js-formField"
                                path="quiz"
                                errorKey="quiz"
                                mandatory="true"
                                showAsterisk="true"
                                skipBlank="false"
                                skipBlankMessageKey="form.select.quiz.defaultValue"
                                items="${quizzes}"
                                labelCSS="site-form__label"
                                validationType="select"
                                selectedValue="${trainingModulesForm.quiz}"
                            />
                        </div>
                    </div>

                    <div class="site-form__actions form-actions clearfix h-topspace-2 h-space-2">
                        <ycommerce:testId code="trainingModules_Start_button">
                            <button type="submit" class="btn btn-primary btn-block js-submitBtn">
                                <spring:theme code="trainingModules.start" />
                            </button>
                        </ycommerce:testId>
                    </div>
                </div>
            </div>
        </form:form>
    </div>

</div>

