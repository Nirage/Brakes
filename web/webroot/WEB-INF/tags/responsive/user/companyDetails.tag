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

<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="company-details">
  <div class="site-form__section-header js-formHeader">
    <spring:theme code="registration.section3.title" />
    <span class="icon icon-amend"></span>
  </div>
  <div class="site-form__section-content">
    <div class="row">
      <div class="col-xs-12 col-sm-12 col-md-3">
        <div class="custom-txtbox" id="registration.companyType.section">
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
      </div>
      <div class="col-xs-12 col-sm-6 col-md-3">
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
      <div class="col-xs-12 col-sm-6 col-md-3">
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
      <div class="col-xs-12 col-sm-6 col-md-3">
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
    </div>
     <div class="row">
      <div class="col-xs-12 col-sm-6 col-md-3">
        <div class="site-form__mix-group" id="registration.partOfGroup.option2.section">
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
      </div>
      <div class="col-xs-12 col-sm-6 col-md-3 col-md-offset-1">
        <div class="site-form__mix-group">
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

      </div>
    </div>

    <user:termsAndConditions/>

    <div class="site-form__actions form-actions clearfix">
      <ycommerce:testId code="register_Register_button">
        <button type="submit" class="btn btn-primary btn-block js-submitBtn">
          <spring:theme code="registration.submit" />
        </button>
      </ycommerce:testId>
    </div>
  </div><%-- site-form__section-content: Company details --%>
</div><%-- site-form__section --%>

