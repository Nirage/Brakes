<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common/"%>

<div id="b2c-checkout-delivery__step-two" class="b2c-checkout-delivery__step js-b2cCheckoutDeliveryStep hide">
  
  <%-- PostalCode lookup input and button | Begin  --%>
  <div class="col-xs-12 b2c__padding--none site-form__formgroup form-group js-formGroup">
    <div class="col-xs-6 b2c__padding--left-0">
      <div class="site-form__inputgroup js-inputgroup">
        <input 
          id="register.deliveryPostcode" 
          name="deliveryPostcode" 
          class="form-control site-form__input js-formField is-required js-postcodeInput b2c-al__text-field--no-background" 
          value="" 
          autocomplete="noautocomplete" 
          data-validation-type="postcode"
          required
        >
        <label 
          class="b2c-al__label--no-background" 
          for="register.deliveryPostcode" 
          data-error-empty="<spring:theme code='error.invalid.deliveryPostcode'/>" 
          data-error-invalid="<spring:theme code='error.invalid.deliveryPostcode'/>"
          placeholder="<spring:theme code='placeholder.text.postCode'/>">
        </label>
        <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
      </div>
      <span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage hide"></span>
    </div>  
 

    <div class="col-xs-6 b2c__padding--right-0">
      <button type="button" class="btn btn-secondary btn-block js-findPostcode">
        <spring:theme code="registration.address.findAddress"/>
      </button>
      <div class="site-form__trigger text-left js-enterAddressManually hide">
        <spring:theme code="registration.address.enterManually"/>
      </div>
    </div>
  </div>
  <%-- PostalCode lookup input and button | End  --%>

  <%-- Address populated fields | Begin --%>
  <div id="jsSelectAddress" class="col-xs-12 b2c__padding--none b2c__margin-bottom--20" style="margin-top: -32px;"></div>
  <%-- Address populated fields | End --%>

  <%-- Address fields | Begin --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 js-addressFields hide">
    <%-- Address line 1* --%>
    <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 site-form__formgroup form-group js-formGroup">
      <div class="site-form__inputgroup js-inputgroup ">
        <input 
          id="addressLine1" 
          name="addressLine1" 
          type="text" 
          class="form-control b2c-al__text-field--no-background is-required js-formField js-b2cDeliveryFormStepTwo" 
          data-validation-type="address" 
          value="" 
          autocomplete="noautocomplete"
          required
        >
        <label 
          class="b2c-al__label--no-background" 
          for="addressLine1" 
          data-error-empty="<spring:theme code='error.invalid.addressLine1'/>" 
          data-error-invalid="<spring:theme code='error.invalid.addressLine1'/>"
          placeholder="<spring:theme code='register.addressLine1'/> *">
        </label>
        <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
        <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
      </div>
    </div>

    <%-- Address line 2 --%>
    <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20">
      <input 
        id="addressLine2" 
        name="addressLine2" 
        type="text" 
        class="b2c-al__text-field--optional js-adaptiveInputOptional"  
        value="" 
        autocomplete="noautocomplete"
      >
      <label 
        class="b2c-al__label--optional js-adaptiveLabelOptional" 
        for="addressLine2" 
        placeholder="<spring:theme code='register.addressLine2'/>">
      </label>
    </div>

    <%-- Address line 3 --%>
    <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20">
      <input 
        id="addressLine3" 
        name="addressLine3" 
        type="text" 
        class="b2c-al__text-field--optional js-adaptiveInputOptional"  
        value="" 
        autocomplete="noautocomplete"
      >
      <label 
        class="b2c-al__label--optional js-adaptiveLabelOptional" 
        for="addressLine3" 
        placeholder="<spring:theme code='register.addressLine3'/>">
      </label>
    </div>

    <%-- Town/City* --%>
    <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20 site-form__formgroup form-group js-formGroup">
      <div class="site-form__inputgroup js-inputgroup ">
        <input 
          id="town" 
          name="town" 
          type="text" 
          class="form-control b2c-al__text-field--no-background is-required js-formField js-b2cDeliveryFormStepTwo" 
          data-validation-type="city" 
          value="" 
          autocomplete="noautocomplete"
          required
        >
        <label 
          class="b2c-al__label--no-background" 
          for="town" 
          data-error-empty="<spring:theme code='error.invalid.addressTown'/>" 
          data-error-invalid="<spring:theme code='error.invalid.addressTown'/>"
          placeholder="<spring:theme code='placeholder.text.town'/>">
        </label>
        <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
        <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
      </div>
    </div>

    <%-- County* --%>
    <div class="col-xs-12 col-sm-6 b2c__margin-bottom--20 site-form__formgroup form-group js-formGroup" style="padding-left: 0px;">
      <div class="site-form__inputgroup js-inputgroup ">
        <input 
          id="county" 
          name="county" 
          type="text" 
          class="form-control b2c-al__text-field--no-background is-required js-formField js-b2cDeliveryFormStepTwo" 
          data-validation-type="city" 
          value="" 
          autocomplete="noautocomplete"
          required
        >
        <label 
          class="b2c-al__label--no-background" 
          for="county" 
          data-error-empty="<spring:theme code='error.invalid.addressCounty'/>" 
          data-error-invalid="<spring:theme code='error.invalid.addressCounty'/>"
          placeholder="<spring:theme code='placeholder.text.county'/>">
        </label>
        <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
        <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
      </div>
    </div>

    <%-- Postcode* --%>
    <div class="col-xs-12 col-sm-6 b2c__margin-bottom--20 site-form__formgroup form-group js-formGroup" style="padding-right: 0px;">
      <div class="site-form__inputgroup js-inputgroup ">
        <input 
          id="postcode" 
          name="postcode" 
          type="text" 
          class="form-control b2c-al__text-field--no-background is-required js-formField js-b2cDeliveryFormStepTwo" 
          data-validation-type="postcode" 
          value="" 
          autocomplete="noautocomplete"
          required
        >
        <label 
          class="b2c-al__label--no-background" 
          for="postcode" 
          data-error-empty="<spring:theme code='error.invalid.addressPostcode'/>" 
          data-error-invalid="<spring:theme code='error.invalid.addressPostcode'/>"
          placeholder="<spring:theme code='placeholder.text.postCode'/>">
        </label>
        <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
        <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
      </div>
    </div>
    
  </div>	
  <%-- Address fields | End --%>

  <%-- Hook up delivery address fields with postcode look up | Begin --%>
  <script>
    var loqate = window.loqate || {};
    loqate.hybris = {
    forms : [
      {
        formId: "brakesGuestCheckoutForm",
        fields:{
          Line1: "addressLine1",
          Line2: "addressLine2",
          Line3: "addressLine3",
          City: "town",
          AdminAreaName: "county",
          PostalCode: "postcode",
        }
      }
    ]
  };
  </script>
  <%-- Hook up delivery address fields with postcode look up | End --%>

  <%-- Postcode look up handlebars template | Begin --%>
  <common:postCodeHandlebarTemplate/>
  <%-- Postcode look up handlebars template | End --%>


















  <%-- 
  <label for="county">County:</label>
  <input type="text" id="county" name="county"><br><br>

  <label for="addressLine1">Address Line 1:</label>
  <input type="text" id="addressLine1" name="addressLine1"><br><br>

  <label for="addressLine2">Address Line 2:</label>
  <input type="text" id="addressLine2" name="addressLine2"><br><br>

  <label for="town">Town:</label>
  <input type="text" id="town" name="town"><br><br>

  <label for="postcode">Postcode:</label>
  <input type="text" id="postcode" name="postcode"><br><br>  --%> 
</div>