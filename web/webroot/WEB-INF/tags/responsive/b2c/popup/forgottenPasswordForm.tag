<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<spring:url value="/forgot-password" var="forgottenPassword"/>

<div class="b2c__route hide js-b2cRoute" id="b2c__router--forgotten-password-form">
  <%-- Title --%>
  <h2 class="b2c-login__title">
    <spring:message code="b2c.pop.forgotten.password.title"/>
  </h2>
  <%-- Forgotten password form wrapper --%>
  <div class="b2c-forgotten-password__form--outter">
    <form:form id="brakesB2cForgotPasswordForm" class="js-formValidation js-b2cForgottenPasswordForm" name="brakesB2cForgotPasswordForm" action="${forgottenPassword}" method="post" modelAttribute="brakesB2cForgotPasswordForm">
      <div class="b2c-forgotten-password__form--inner">
        <%-- Email --%>
        <div class="site-form__formgroup form-group js-formGroup">
          <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 js-inputgroup">
            <input 
                id="username" 
                name="username" 
                type="email" 
                class="form-control b2c-forgotten-password__input-field js-formField is-required js-adaptiveSearch b2c-al__text-field--with-background js-b2cForgottenEmail" 
                data-validation-type="email" 
                value="" 
                autocomplete="noautocomplete"
                required
            >
            <label 
                class="b2c-al__label--with-background" 
                for="username" 
                data-error-empty="<spring:theme code='error.invalid.email'/>" 
                data-error-invalid="<spring:theme code='error.invalid.email'/>"
                placeholder="<spring:theme code='b2c.pop.forgotten.password.email.label'/>">
            </label>
            <span class="icon icon-error site-form__errorsideicon js-error-icon b2c__icon--error"></span>
            <span class="icon icon-tick site-form__validsideicon js-valid-icon b2c__icon--valid"></span>
            <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
          </div>		
        </div>
      </div>
      <%-- Buttons wrappers --%>
      <div class="b2c-forgotten-password__ctas-container">
        <%-- Back button --%>
        <div class="btn b2c-forgotten-password__cta b2c-forgotten-password__cta--back js-b2cForgottenPasswordBackBtn">
          <span class="icon icon-chevron-left b2c-forgotten-password__cta--back-icon"></span>
          <spring:theme code="b2c.pop.forgotten.password.back.cta"/>
        </div>
        <%-- Forgotten password submit button --%>
        <button type="submit" class="btn btn-primary b2c-forgotten-password__cta b2c-forgotten-password__cta--sign-up js-submitBtn js-b2cForgottenPasswordSubmitBtn disabled">
          <spring:theme code="b2c.pop.forgotten.password.cta"/>
        </button>
      </div>
    </form:form>
  </div>
</div>