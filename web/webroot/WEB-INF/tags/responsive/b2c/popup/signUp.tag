<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<spring:url value="/b2c-register" var="registerCustomer"/>

<div class="b2c__route hide js-b2cRoute" id="b2c__router--sign-up">
   <%-- Title --%>
  <h2 class="b2c-signup__title">
    <spring:message code="b2c.pop.signup.title"/>
  </h2>
  <%-- Sign-up form wrapper --%>
  <div class="b2c-signup__form--outter">
    <%-- Sign-up form --%>
    <form:form id="brakesB2cRegisterForm" class="js-formValidation js-b2cSignUpForm" name="brakesB2cRegisterForm" action="${registerCustomer}" method="post" modelAttribute="brakesB2cRegisterForm">
      <div class="b2c-signup__form--inner">
        <%-- B2B Unit --%>
        <div class="b2c__margin-bottom--20">
          <%-- Unit title --%>
          <span><spring:message code="b2c.pop.signup.unit.title"/></span>
          <%-- Unit selection --%>
          <span class="b2c-signup__unit--selected js-b2cSingUpUnitSelection"></span>
        </div>
        <%-- Email --%>
        <div class="site-form__formgroup form-group js-formGroup">
          <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 js-inputgroup">
            <input 
                id="b2cEmail" 
                name="email" 
                type="email" 
                class="form-control b2c-signup__input-field js-formField is-required js-adaptiveSearch b2c-al__text-field--with-background js-signUpEmailField" 
                data-validation-type="email" 
                value="" 
                autocomplete="noautocomplete"
                required
            >
            <label 
                class="b2c-al__label--with-background" 
                for="b2cEmail" 
                data-error-empty="<spring:theme code='error.invalid.email'/>" 
                data-error-invalid="<spring:theme code='error.invalid.email'/>"
                placeholder="<spring:theme code='b2c.pop.signup.email'/>">
            </label>
            <span class="icon icon-error site-form__errorsideicon js-error-icon b2c__icon--error"></span>
            <span class="icon icon-tick site-form__validsideicon js-valid-icon b2c__icon--valid"></span>
            <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
          </div>		
        </div>
        <%-- Password --%>
        <div class="site-form__formgroup form-group js-formGroup">
          <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 js-inputgroup">
            <input 
                id="b2cSingUpPassword" 
                name="password" 
                type="password" 
                class="form-control b2c-popup__input-field js-formField js-formFieldPassword is-required js-adaptiveSearch  b2c-al__text-field--with-background" 
                data-validation-type="password" 
                value="" 
                autocomplete="noautocomplete"
                required
            >
            <label 
                class="b2c-al__label--with-background" 
                for="b2cSingUpPassword" 
                data-error-empty="<spring:theme code='error.invalid.password'/>" 
                data-error-invalid="<spring:theme code='b2c.pop.signup.password.error'/>"
                placeholder="<spring:theme code='b2c.pop.signup.password'/>">
            </label>
            <span class="icon icon-error site-form__errorsideicon js-error-icon b2c__icon--error"></span>
            <span class="icon icon-tick site-form__validsideicon js-valid-icon b2c__icon--valid"></span>
            <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
          </div>		
        </div>
        <%-- Confirm password --%>
        <div class="site-form__formgroup form-group js-formGroup">
          <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 js-inputgroup">
            <input 
                id="b2cSingUpConfirmPassword" 
                name="confirmPassword" 
                type="password" 
                class="form-control b2c-popup__input-field is-required js-formField b2c-al__text-field--with-background js-adaptiveSearch" 
                data-validation-type="confirmPassword" 
                value="" 
                autocomplete="noautocomplete"
                required
            >
            <label 
                class="b2c-al__label--with-background" 
                for="b2cSingUpConfirmPassword" 
                data-error-empty="<spring:theme code='error.invalid.password'/>" 
                data-error-invalid="<spring:theme code='error.invalid.password'/>"
                placeholder="<spring:theme code='b2c.pop.signup.confirm.password'/>">
            </label>
            <span class="icon icon-error site-form__errorsideicon js-error-icon b2c__icon--error"></span>
            <span class="icon icon-tick site-form__validsideicon js-valid-icon b2c__icon--valid"></span>
            <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
          </div>		
        </div>
      </div>
      <%-- Buttons wrappers --%>
      <div class="b2c-signup__ctas-container">
        <%-- Back button --%>
        <div class="btn b2c-signup__cta b2c-signup__cta--back js-b2cSignUpBackBtn">
          <span class="icon icon-chevron-left b2c-signup__cta--back-icon"></span>
          <spring:theme code="b2c.pop.signup.back.cta"/>
        </div>
        <%-- Sign-up button --%>
        <button type="submit" class="btn btn-primary b2c-signup__cta b2c-signup__cta--sign-up js-submitBtn js-b2cSignUpSubmitBtn disabled">
          <spring:theme code="b2c.pop.signup.cta"/>
        </button>
      </div>
      <%-- Mandatory fields label --%>
      <div class="b2c-signup__mandatory-fields">
        <spring:message code="b2c.pop.signup.mandatory.fields.label"/>
      </div>
    </form:form>
  </div>
</div>