<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<spring:url value="/j_spring_security_check" var="loginCustomer"/>

<div class="b2c__route hide js-b2cRoute" id="b2c__router--log-in">
   <%-- Title --%>
  <h2 class="b2c-login__title">
    <spring:message code="b2c.pop.login.title"/>
  </h2>
  <%-- Log-in form wrapper --%>
  <div class="b2c-login__form--outter">
    <%-- Log-in form --%>
    <form:form id="loginForm" class="js-formValidation js-b2cLogInForm" name="loginForm" action="${loginCustomer}" method="post" modelAttribute="loginForm">
      <div class="b2c-login__form--inner">
        <%-- Email --%>
        <div class="site-form__formgroup form-group js-formGroup">
          <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 js-inputgroup">
            <input 
                id="login.username" 
                name="j_username" 
                type="email" 
                class="form-control b2c-login__input-field js-formField is-required b2c-al__text-field--with-background js-adaptiveSearch" 
                data-validation-type="email" 
                value="" 
                autocomplete="noautocomplete"
                required
            >
            <label 
                class="b2c-al__label--with-background" 
                for="login.username" 
                data-error-empty="<spring:theme code='error.invalid.email'/>" 
                data-error-invalid="<spring:theme code='error.invalid.email'/>"
                placeholder="<spring:theme code='b2c.pop.login.email'/>">
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
                id="login.password" 
                name="j_password" 
                type="password" 
                class="form-control b2c-popup__input-field is-required js-formField js-formFieldPassword b2c-al__text-field--with-background js-adaptiveSearch" 
                value="" 
                autocomplete="noautocomplete"
                required
            >
            <label 
                class="b2c-al__label--with-background" 
                for="login.password" 
                placeholder="<spring:theme code='b2c.pop.login.password'/>">
            </label>
            <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
            <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
          </div>		
        </div>
        <%-- Fogotten password --%>
        <div class="b2c-login__cta--forgotten-password js-b2cForgottenPasswordLink">
          <spring:theme code="b2c.pop.login.forgot.password.link"/>
        </div>
      </div>
      <%-- Buttons wrappers --%>
      <div class="b2c-login__ctas-container">
        <%-- Back button --%>
        <div class="btn b2c-login__cta b2c-login__cta--back js-b2cLogInBackBtn">
          <span class="icon icon-chevron-left b2c-login__cta--back-icon"></span>
          <spring:theme code="b2c.pop.login.back.cta"/>
        </div>
        <%-- Login button --%>
        <button type="submit" class="btn btn-primary btn-block b2c-login__cta js-submitBtn js-b2cPopUpWhitelistedCTA disabled">
          <spring:theme code="b2c.pop.login.cta"/>
        </button>
      </div>
    </form:form>
  </div>
</div>