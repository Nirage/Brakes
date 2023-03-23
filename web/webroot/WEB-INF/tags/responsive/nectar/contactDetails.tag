<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement"
    tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ attribute name="isActive" required="false" type="java.lang.Boolean" %>
<%@ attribute name="sectionName" required="false" type="java.lang.String"%>
<%@ attribute name="nextSectionName" required="false" type="java.lang.String"%>

<c:set var="isRequired" value="is-required"/>


<div class="site-form__section js-formSection is-active h-topspace-5" data-section="contact-details">
    <div class="site-form__section-header js-formHeader">
        <spring:theme code="text.nectarpoints.collect.page.section2.title" />
        <span class="icon icon-amend"></span>
    </div>

    <div class="site-form__section-content">
        <div class="row">
            <div class="col-xs-12 col-sm-12">
                <div class="row">
                    <%-- Email Address --%>
                    <div class="col-xs-12 col-sm-6">
                        <formElement:formInputBox
                            idKey="collectNectar.email"
                            labelKey="collectNectar.email"
                            path="email"
                            errorKey="email"
                            inputCSS="form-control site-form__input js-formField js-formFieldEmail"
                            labelCSS="site-form__label"
                            mandatory="true"
                            showAsterisk="true"
                            validationType="email"
                        />
                    </div>

                    <%-- Confirm Email Address --%>
                    <div class="col-xs-12 col-sm-6">
                        <formElement:formInputBox
                            idKey="collectNectar.confirmEmail"
                            labelKey="collectNectar.confirmEmail"
                            path="confirmEmail"
                            errorKey="confirmEmail"
                            inputCSS="form-control site-form__input js-formField js-formFieldConfirmEmail"
                            labelCSS="site-form__label"
                            mandatory="true"
                            showAsterisk="true"
                            validationType="confirmEmail"
                        />
                    </div>
                </div>
                <div class="row">
                    <%-- Phone Number --%>
                    <div class="col-xs-12 col-sm-6">
                        <formElement:formInputBox
                            idKey="collectNectar.phoneNumber"
                            labelKey="collectNectar.phoneNumber"
                            path="phoneNumber"
                            errorKey="phoneNumber"
                            inputCSS="form-control site-form__input js-formField"
                            labelCSS="site-form__label"
                            showAsterisk="false"
                            validationType="any"
                            htmlType="number"
                        />
                    </div>

                    <%-- Mobile Number --%>
                    <div class="col-xs-12 col-sm-6">
                        <formElement:formInputBox
                            idKey="collectNectar.mobileNumber"
                            labelKey="collectNectar.mobileNumber"
                            path="mobileNumber"
                            errorKey="mobileNumber"
                            inputCSS="form-control site-form__input js-formField"
                            labelCSS="site-form__label"
                            showAsterisk="false"
                            validationType="any"
                            htmlType="number"
                        />
                    </div>
                </div>
            </div>
        </div>

        <button type="button" class="btn btn-primary visible-xs btn-block btn--full-width js-formNextBtn site-form__next-btn" data-parent="${sectionName}" data-goto="${nextSectionName}">
            <spring:theme code="registration.next" />
        </button>
    </div>
</div>
