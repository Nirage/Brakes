<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>	
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>	
<%@ attribute name="isActive" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common/"%>

<c:if test="${not empty registerForm.companyType}"> 
  <script>
    window.formPrePopulated = true;
  </script>
</c:if>

<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="company-details">
	<div class="site-header site-header--align-left">
		<h1 class="site-header__h1"><spring:theme code="multiStepRegistration.section3.title" /></h1>
	</div>

  <div class="row">
    <div class="col-xs-12" id="registrationCompanyTypeSection">
      <formElement:formSelectBox 
        idKey="registration.companyType"
        labelKey="registration.companyType"
        selectCSSClass="form-control site-form__select js-formSelect js-formField js-companyType"
        path="companyType"
        errorKey="companyType"
        mandatory="true"
        showAsterisk="true"
        skipBlank="false"
        skipBlankMessageKey="form.select.empty.companytype"
        items="${companyTypes}"
        labelCSS="site-form__label"
        validationType="select"
        tooltipKey="companyType"
        tooltipType="collapsable" 
        selectedValue="${registerForm.companyType}"/>
    </div>
    <div class="col-xs-12" id="registerCompanyRegNumberSection">
      <formElement:formInputBox 
        idKey="register.companyRegNumber"
        labelKey="register.companyRegNumber" 
        path="companyRegNumber" 
        errorKey="companyRegNumber" 
        inputCSS="form-control site-form__input js-formField js-companyRegDetails"
        labelCSS="site-form__label js-companyRegDetailsLabel"
        mandatory="true" 
        showAsterisk="true"
        disabled="${empty registerForm.companyRegNumber}" 
        tooltipKey="companyRegNumber"
        tooltipType="collapsable" 
        validationType="companyregnumber" />
    </div>
    <div class="col-xs-12" id="registerCompanyRegNameSection">
      <formElement:formInputBox 
        idKey="register.companyRegName"
        labelKey="register.companyRegName" 
        path="companyRegName" 
        errorKey="companyRegName" 
        inputCSS="form-control site-form__input js-formField js-companyRegDetails"
        labelCSS="site-form__label js-companyRegDetailsLabel"
        mandatory="true" 
        showAsterisk="true"
        disabled="${empty registerForm.companyRegName}" 
        tooltipKey="companyRegName"
        tooltipType="collapsable" />
    </div>
    <div class="col-xs-12" id="registerTradingNameSection">
      <formElement:formInputBox
        idKey="register.tradingName"
        labelKey="register.tradingName"
        path="tradingName"
        errorKey="tradingName"
        inputCSS="form-control site-form__input js-formField"
        labelCSS="site-form__label"
        mandatory="true"
        showAsterisk="true"
        validationType="any"
        placeholderKey="tradingName"
        tooltipKey="tradingName"
        tooltipType="collapsable"
        maxlength="255" />
    </div>

    <%-- postcode section --%>
    <div id="registerDeliveryPostcodeSection">
      <div class="col-xs-12">
        <div class="row">
          <div class="site-form__formgroup form-group js-formGroup">
            <div class="col-xs-12">
              <label
              class="control-label site-form__label"
              for="register.deliveryPostcode"
              data-error-empty="<spring:theme code="error.empty.addressPostcode" />" data-error-invalid="<spring:theme code="error.invalid.addressPostcode" />" data-error-force="<spring:theme code="error.force.addressPostcode" />">
              <spring:theme code="registration.address.deliveryPostcode" />
              </label>
            </div>
            <div class="col-xs-12 col-sm-6 col-md-7">
              <div class="site-form__inputgroup js-inputgroup">
                <input id="register.deliveryPostcode" value="${registerForm.postCode}" name="deliveryPostcode" class="form-control site-form__input js-formField is-required js-postcodeInput" value="" autocomplete="noautocomplete" data-validation-type="postcode"/>
                <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
                <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
              </div>
              <span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage hide"></span>
            </div>
            <div class="col-xs-12 col-sm-6 col-md-5">
              <button type="button" class="btn btn-secondary btn-block js-findPostcode btn--input-height">
                <spring:theme code="registration.address.findAddress" />
              </button>
              <div class="site-form__trigger text-left js-enterAddressManually hide">
                <spring:theme code="registration.address.enterManually" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-xs-12">
        <div class="select-address" id="jsSelectAddress">
        </div>
      </div>
      <div class="js-addressFields ${empty registerForm.line1 ? 'hide' : ''}">
        <div class="col-xs-12">
          <formElement:formInputBox
            idKey="register.addressLine1"
            labelKey="register.addressLine1"
            path="line1"
            errorKey="addressLine1"
            inputCSS="form-control site-form__input js-formField"
            labelCSS="site-form__label"
            mandatory="true"
            showAsterisk="true"
            validationType="any" />
        </div>
        <div class="col-xs-12">
          <formElement:formInputBox
            idKey="register.addressTown"
            labelKey="register.addressTown"
            path="City"
            errorKey="addressTown"
            inputCSS="form-control site-form__input js-formField"
            labelCSS="site-form__label"
            mandatory="true"
            showAsterisk="true"
            validationType="any"
            autocomplete="false" />
        </div>
        <div class="col-xs-12">
          <formElement:formInputBox
            idKey="register.addressCounty"
            labelKey="register.addressCounty"
            path="county"
            errorKey="addressCounty"
            inputCSS="form-control site-form__input js-formField"
            labelCSS="site-form__label"
            mandatory="true"
            showAsterisk="true"
            validationType="any" />
        </div>
        <div class="col-xs-12">
          <formElement:formInputBox
            idKey="register.addressPostcode"
            labelKey="register.addressPostcode"
            path="postCode"
            errorKey="addressPostcode"
            inputCSS="form-control site-form__input js-formField"
            labelCSS="site-form__label"
            mandatory="true"
            showAsterisk="true" />
        </div>
      </div>
    </div>

    <div class="col-xs-12" id="registerTitleSection">
      <formElement:formSelectBox
        idKey="register.title"
        labelKey="register.title"
        selectCSSClass="form-control site-form__select js-formSelect js-formField"
        path="title"
        errorKey="title"
        mandatory="true"
        showAsterisk="true"
        skipBlank="false"
        skipBlankMessageKey="form.select.title.defaultValue"
        items="${titles}"
        labelCSS="site-form__label"
        validationType="select"
        selectedValue="${registerForm.title}" />
    </div>
    <div class="col-xs-12" id="registerFirstNameSection">
      <formElement:formInputBox
        idKey="register.firstName"
        labelKey="register.firstName"
        path="firstName"
        errorKey="firstName"
        inputCSS="form-control site-form__input js-formField"
        labelCSS="site-form__label"
        mandatory="true"
        showAsterisk="true"
        validationType="name" />
    </div>
    <div class="col-xs-12" id="registerLastNameSection">
      <formElement:formInputBox
        idKey="register.lastName"
        labelKey="register.lastName"
        errorKey="lastName"
        path="lastName"
        inputCSS="form-control site-form__input js-formField"
        labelCSS="site-form__label"
        mandatory="true"
        showAsterisk="true"
        validationType="name" />
    </div>

    <div id="v-telephone-number"
      class="col-xs-12"
      data-mobile-id="register.phone"
      data-landline-id="register.companyPhoneNumb"
      data-telephone-tooltip-text="<spring:theme code='tooltip.text.mobilePhone' />"
      data-error-empty="Please provide your telephone number(s)"
    >
      <div class="custom-txtbox">
        <template:telephoneErrorField path="mobileNumber">
          <ycommerce:testId code="LoginPage_Item_register.phone">
              <label class="flex justify-content-between font-size-1 mt2"
                for="mobileNumber"
                data-error-empty="<spring:theme code='error.empty.phone' />"
                data-error-invalid="<spring:theme code='error.invalid.phone' />"
              >
                Telephone number&nbsp;*&nbsp;<span class="mrauto text-grey text-italic">(Please fill in at least one field)</span>
                <i class="icon icon-question font-size-1-25 custom-tooltip">
                  <span class="custom-tooltip__text font-size-base-sm lh1 p1 br1 font-primary position-absolute bg-white"><spring:theme code="tooltip.text.mobilePhone" /></span>
                </i>
              </label>
              <div class="position-relative">
                <c:set var="mobileNumber" value="${registerForm.mobileNumber}" /> 
                <c:set var="formatMobileNumber" value="${fn:substring(mobileNumber, 0, 4)}${fn:length(mobileNumber) >= 5 ? ' ' : ''}${fn:substring(mobileNumber, 4, 7)}${fn:length(mobileNumber) >= 8 ? ' ' : ''}${fn:substring(mobileNumber, 7, 11)}" />
                <input id="register.phone" type="hidden" name="mobileNumber" value="${mobileNumber}" />
                <input
                  type="tel"
                  id="mobileNumber"
                  class="site-form__input form-control font-size-1 js-formField v-telephone-input"
                  value="${formatMobileNumber}"
                  autocomplete="noautocomplete"
                  placeholder="Mobile number"
                  minlength="13"
                  maxlength="13"
                  pattern="^(07){1}[0-9]{9}$"
                >
                <i class="icon"></i>
              </div>
              <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage">
                <spring:theme code="error.invalid.phone" />
              </span>
          </ycommerce:testId>
        </template:telephoneErrorField>
      </div>
      <div class="custom-txtbox">
        <template:telephoneErrorField path="phoneNumber">
          <ycommerce:testId code="LoginPage_Item_register.companyPhoneNumb">
              <label class="flex justify-content-between font-size-1 m0"
                for="phoneNumber"
                data-error-empty="<spring:theme code='error.invalid.companyPhone' />"
                data-error-invalid="<spring:theme code='error.empty.companyPhone' />"
              ></label>
              <div class="position-relative">
                <c:set var="phoneNumber" value="${registerForm.phoneNumber}" /> 
                <c:set var="formatPhoneNumber" value="${fn:substring(phoneNumber, 0, 4)}${fn:length(phoneNumber) >= 5 ? ' ' : ''}${fn:substring(phoneNumber, 4, 7)}${fn:length(phoneNumber) >= 8 ? ' ' : ''}${fn:substring(phoneNumber, 7, 11)}" />
                <input id="register.companyPhoneNumb" type="hidden" name="phoneNumber" value="${phoneNumber}" />
                <input
                  type="tel"
                  id="phoneNumber"
                  class="site-form__input form-control font-size-1 js-formField v-telephone-input"
                  value="${formatPhoneNumber}"
                  autocomplete="noautocomplete"
                  placeholder="Landline number"
                  minlength="12"
                  maxlength="13"
                  pattern="^0[1238]{1}([0-9]{8}|[0-9]{9})$"
                >
                <i class="icon"></i>
              </div>
              <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage">
                <spring:theme code="error.invalid.phone" />
              </span>
          </ycommerce:testId>
        </template:telephoneErrorField>
      </div>
    </div>

    <div class="col-xs-12" id="registerJobTitleSection">
      <formElement:formInputBox
        idKey="register.jobTitle"
        labelKey="register.jobTitle"
        path="jobTitle"
        errorKey="jobTitle"
        inputCSS="form-control site-form__input js-formField"
        labelCSS="site-form__label"
        mandatory="true"
        showAsterisk="true"
        validationType="any" />
    </div>
    <div class="col-xs-12" id="registrationPartOfGroupOptionSection">
      <div class="site-form__mix-group" id="registration.partOfGroup.option.section">
        <div class="site-form__mix-group-header"><spring:theme code="registration.partOfGroup.title" /> 
        <span class="icon icon-question js-triggerTooltip" data-container="body" data-toggle="popover-collapsable" data-placement="top" data-content="<spring:theme code='tooltip.text.partOfGroup' />"></span></div>
        <formElement:formRadioButton 
          idKey="registration.partOfGroup.option1" 
          labelKey="registration.partOfGroup.option1" 
          path="businessGroup"
          inputCSS="js-radioButtonGroup"
          labelCSS=""
          mandatory=""
          value="Yes" />
    
        <formElement:formRadioButton 
          idKey="registration.partOfGroup.option2" 
          labelKey="registration.partOfGroup.option2" 
          path="businessGroup"
          inputCSS="js-radioButtonGroup"
          labelCSS=""
          mandatory=""
          value="No" />
      </div>
    </div>

    <div  class="col-xs-12" id="registerBusinessGroupSection">
      <formElement:formInputBox 
        idKey="register.businessGroup"
        labelKey="register.businessGroup" 
        path="businessGroupName" 
        errorKey="partOfGroupName" 
        inputCSS="form-control site-form__input js-formField"
        labelCSS="site-form__label js-siteFormLabel"
        mandatory="true" 
        showAsterisk="true"
        validationType="any" 
        disabled="${!registerForm.businessGroup}"
        dataName="businessGroup" />
    </div>  
    <div class="col-xs-12" id="registrationLegalOwnerOptionSection">
      <div class="site-form__mix-group" id="registration.legalOwner.option.section">
        <div class="site-form__mix-group-header"><spring:theme code="registration.legalOwner.title" /></div>         
        <formElement:formRadioButton 
          idKey="legal-owner-yes" 
          labelKey="registration.legalOwner.option1" 
          path="legalOwner"
          inputCSS="js-radioButtonGroup"
          labelCSS=""
          mandatory=""
          value="Yes" />
        <formElement:formRadioButton 
          idKey="legal-owner-no" 
          labelKey="registration.legalOwner.option2" 
          path="legalOwner"
          inputCSS="js-radioButtonGroup"
          labelCSS=""
          mandatory=""
          value="No" />
      </div>
    </div>
    <div class="col-xs-12" id="registerLegalOwnerSection">
      <formElement:formInputBox 
        idKey="register.legalOwner"
        labelKey="register.legalOwner" 
        path="legalOwnerName" 
        errorKey="legalOwnerName" 
        inputCSS="form-control site-form__input js-formField"
        labelCSS="site-form__label js-siteFormLabel"
        mandatory="true" 
        showAsterisk="true"
        validationType="any"
        disabled="${registerForm.legalOwner}" 
        dataName="legalOwner" />
    </div>
    <div class="col-xs-12 js-registerEmailSection" id="registerEmailSection">
      <formElement:formInputBox
        idKey="register.email"
        labelKey="register.email"
        path="email"
        errorKey="email"
        inputCSS="form-control site-form__input js-formField js-formFieldEmail js-emailField"
        labelCSS="site-form__label"
        mandatory="true"
        showAsterisk="true"
        validationType="email"
        tooltipKey="email"
        tooltipType="collapsable" />
    </div>
    <div class="col-xs-12 js-registerConfirmEmailSection" id="registerConfirmEmailSection">
      <formElement:formInputBox
        idKey="register.confirmEmail"
        labelKey="register.confirmEmail"
        path="confirmEmail"
        errorKey="confirmEmail"
        inputCSS="form-control site-form__input js-formField js-formFieldConfirmEmail js-emailField"
        labelCSS="site-form__label"
        mandatory="true"
        showAsterisk="true"
        validationType="confirmEmail"
        tooltipKey="email"
        tooltipType="collapsable" />
    </div>
              
    <input type="hidden" value="${registerForm.marketingPreference}" class="js-marketingConsentVal"/>
    <div class="col-xs-12 register-form__checkbox" id="marketingPreferenceSection">
      <formElement:formCheckbox
        idKey="marketingPreference"
        labelKey="registration.marketingConsent"
        path="marketingPreference"
        mandatory="false"
        labelCSS="site-form__label"
        inputCSS="js-formField js-formCheckbox js-marketingConsent"
        validationType="checkbox"
        errorKey="marketingConsent"
        tooltip="true"
        tooltipContent="marketingPreferences" />
    </div>
  </div>
</div><%-- site-form__section --%>
<common:postCodeHandlebarTemplate/>

<script>
	var loqate = window.loqate || {};
	loqate.hybris = {
	forms : [
	  {
	    formId: "registerForm",
			fields:{
				Line1: "register.addressLine1",
				City: "register.addressTown",
				AdminAreaName: "register.addressCounty",
        PostalCode: "register.addressPostcode",
			},
      	businessfields:{
				Line1: "register.businessAddressLine1",
				City: "register.businessAddressTown",
				AdminAreaName: "register.businessAddressCounty",
        PostalCode: "register.businessAddressPostcode",
			}
	  }
	]
};
</script>