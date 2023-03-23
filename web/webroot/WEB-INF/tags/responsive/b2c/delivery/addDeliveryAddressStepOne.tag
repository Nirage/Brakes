<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ attribute name="skipBlank" required="false" type="java.lang.Boolean" %>
<%@ attribute name="skipBlankMessageKey" required="false" type="java.lang.String" %>

<div id="b2c-checkout-delivery__step-one" class="b2c-checkout-delivery__step js-b2cCheckoutDeliveryStep">
  <%-- Select title --%>			
  <div class="col-xs-12 b2c__margin-bottom--20 b2c__padding--none">
    <div class="control site-form__dropdown">
      <label for="title">
        <select id="title" name="title">
          <c:if test="${skipBlank == null || skipBlank == false}" >
            <option value="" ${empty selectedValue ? 'selected="selected"' : ''}>
              <spring:theme code='b2c.delivery.popup.title.label'/>
            </option>
          </c:if>
          <c:forEach var="item" items="${titles}">
            <c:if test="${item.code ne 'SEPARATE_DOTTED_LINE'}" >
              <option value="${item.code}" ${item.code == selectedValue ? 'selected="selected"' : ''}>${item.name}</option>
            </c:if>
          </c:forEach>
        </select>
      </label>
    </div>
  </div>
  <%-- First name --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 site-form__formgroup form-group js-formGroup">
    <div class=" js-inputgroup">
      <input 
        id="b2cDeliveryFirstName" 
        name="firstName" 
        type="text" 
        class="form-control b2c-al__text-field--no-background is-required js-formField js-b2cDeliveryFormStepOne" 
        data-validation-type="name" 
        value="" 
        autocomplete="noautocomplete"
        required
      >
      <label 
          class="b2c-al__label--no-background" 
          for="b2cDeliveryFirstName" 
          data-error-empty="<spring:theme code='error.invalid.firstName'/>" 
          data-error-invalid="<spring:theme code='error.invalid.firstName'/>"
          placeholder="<spring:theme code='b2c.delivery.popup.first.name.label'/>">
      </label>
      <span class="icon icon-error site-form__errorsideicon js-error-icon b2c__icon--error"></span>
      <span class="icon icon-tick site-form__validsideicon js-valid-icon b2c__icon--valid"></span>
      <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
    </div>		
  </div>
  <%-- Last name --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 site-form__formgroup form-group js-formGroup">
    <div class="js-inputgroup">
      <input 
        id="b2cDeliveryLastName" 
        name="lastName" 
        type="text" 
        class="form-control b2c-al__text-field--no-background is-required js-formField js-b2cDeliveryFormStepOne" 
        data-validation-type="name" 
        value="" 
        autocomplete="noautocomplete"
        required
      >
      <label 
          class="b2c-al__label--no-background" 
          for="b2cDeliveryLastName" 
          data-error-empty="<spring:theme code='error.invalid.lastName'/>" 
          data-error-invalid="<spring:theme code='error.invalid.lastName'/>"
          placeholder="<spring:theme code='b2c.delivery.popup.last.name.label'/>">
      </label>
      <span class="icon icon-error site-form__errorsideicon js-error-icon b2c__icon--error"></span>
      <span class="icon icon-tick site-form__validsideicon js-valid-icon b2c__icon--valid"></span>
      <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
    </div>		
  </div>
  <%-- Phone number --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 site-form__formgroup form-group js-formGroup">
    <div class="js-inputgroup">
      <input 
        id="b2cDeliveryPhoneNumber" 
        name="phone" 
        type="tel" 
        class="form-control b2c-al__text-field--no-background is-required js-formField js-b2cDeliveryFormStepOne" 
        data-validation-type="phone" 
        value="" 
        autocomplete="noautocomplete"
        required
      >
      <label 
          class="b2c-al__label--no-background" 
          for="b2cDeliveryPhoneNumber" 
          data-error-empty="<spring:theme code='error.invalid.phone'/>" 
          data-error-invalid="<spring:theme code='error.invalid.phone'/>"
          placeholder="<spring:theme code='b2c.delivery.popup.phone.number.label'/>">
      </label>
      <span class="icon icon-error site-form__errorsideicon js-error-icon b2c__icon--error"></span>
      <span class="icon icon-tick site-form__validsideicon js-valid-icon b2c__icon--valid"></span>
      <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
    </div>		
  </div>
  <%-- Email address --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20">
    <div class="b2c-checkout-delivery__email-field">
      ${userId}
    </div>
  </div>
</div>