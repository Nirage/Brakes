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
        selectedValue="${registerForm.companyType}"
      />
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
    <div class="col-xs-12" id="registerCompanyPhoneNumbSection">
      <formElement:formInputBox 
        idKey="register.companyPhoneNumb"
        labelKey="register.companyPhoneNumb" 
        path="phoneNumber" 
        errorKey="companyPhone"
        inputCSS="form-control site-form__input js-formField"
        labelCSS="site-form__label"
        mandatory="true" 
        showAsterisk="true"
        validationType="phone" />
    </div>
    <div class="col-xs-12" id="registrationPartOfGroupOptionSection">
      <div class="site-form__mix-group" id="registration.partOfGroup.option.section">
        <div class="site-form__mix-group-header"><spring:theme code="registration.partOfGroup.title" /> 
        <span class="icon icon-question js-triggerTooltip" data-container="body" data-toggle="popover-collapsable" data-placement="top" data-content="<spring:theme code="tooltip.text.partOfGroup" />"></span></div>
        <formElement:formRadioButton 
        idKey="registration.partOfGroup.option1" 
        labelKey="registration.partOfGroup.option1" 
        path="businessGroup"
        inputCSS="js-radioButtonGroup"
        labelCSS=""
        mandatory=""
        value="Yes"
        />
    
        <formElement:formRadioButton 
        idKey="registration.partOfGroup.option2" 
        labelKey="registration.partOfGroup.option2" 
        path="businessGroup"
        inputCSS="js-radioButtonGroup"
        labelCSS=""
        mandatory=""
        value="No"
        />
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
        value="Yes"
        />
        <formElement:formRadioButton 
        idKey="legal-owner-no" 
        labelKey="registration.legalOwner.option2" 
        path="legalOwner"
        inputCSS="js-radioButtonGroup"
        labelCSS=""
        mandatory=""
        value="No"
        />
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
    <div class="col-xs-12" id="registerConfirmEmailSection" class="js-registerConfirmEmailSection">
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

