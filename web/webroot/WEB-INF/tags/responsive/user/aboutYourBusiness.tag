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
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common/"%>


<c:set var="isRequired" value="is-required"/>

<c:if test="${themeName eq 'countrychoice'}">
  <c:set var="isRequired" value=""/>
</c:if>


<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="about-business">
  <div class="site-form__section-header js-formHeader">
   	<spring:theme code="registration.section2.title" />
    <span class="icon icon-amend"></span>
  </div>

  <div class="site-form__section-content">
    <div class="row">
    <div class="col-xs-12 col-sm-6">
      <div class="row">
        <div class="col-xs-12 col-md-6">
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
					  tooltipType="collapsable" />
        </div>

        <c:if test="${themeName eq 'brakes'}">
          <div class="col-xs-12 col-md-6">
            <%-- FIELD NOT REQUIRED FOR COUNTRY CHOICE --%>
            <div class="custom-txtbox">
               <formElement:formSelectBox 
						idKey="registration.monthlySpend"
						labelKey="registration.monthlySpend"
						selectCSSClass="form-control site-form__select js-formSelect js-formField"
						path="budget"
						errorKey="monthlySpend"
						mandatory="true"
						showAsterisk="true"
						skipBlank="false"
						skipBlankMessageKey="form.select.empty"
						items="${budgets}"
						labelCSS="site-form__label"
						validationType="select"
						selectedValue="${registerForm.budget}"/>
              
            </div>
          </div>
        </c:if>
        </div>
        <div class="row">
        <div class="col-xs-12 col-md-6">
          <div class="custom-txtbox">
            <formElement:formSelectBox 
						idKey="registration.sector"
						labelKey="registration.sector"
						selectCSSClass="form-control site-form__select js-formSelect js-formField js-sectorSelect"
						path="sector"
						errorKey="businessSector"
						mandatory="true"
						showAsterisk="true"
						skipBlank="false"
						skipBlankMessageKey="form.select.empty"
						items="${sectors}"
						labelCSS="site-form__label"
						validationType="select" 
            subSelect="sub-sector"
            endpoint="/misc/subsectors" 
            tooltipKey="businessSector"
					  tooltipType="collapsable"
					  selectedValue="${registerForm.sector}" />
          </div>
        </div>
        <div class="col-xs-12 col-md-6">
          <div class="custom-txtbox">
            <div class="site-form__formgroup form-group js-formGroup js-subSector" data-select="sub-sector" >
              <div id="jsSubSector">
                <span class="site-form__label js-subSectorLabel is-disabled" for="subSector">
                  <spring:theme code="registration.subsector" />
                </span>
                <div class="control site-form__dropdown js-subSelectWrapper">
                  <label>
                    <select id="subSector" name="subSector" form="registerForm" class="form-control site-form__select js-formSelect is-required" data-validation-type="select" disabled="disabled">
                      <option value="" selected="selected"><spring:theme code="form.select.empty" /></option>
                    </select>
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div> 
        <div class="col-xs-12">
          <formElement:formTextArea 
            idKey="deliveryRestrictions" 
            labelKey="registration.deliveryRestrictions" 
            path="deliveryRestrictions" 
            errorKey="deliveryRestrictions" 
            areaCSS="form-control site-form__textarea js-formTextarea has-counter" 
            mandatory="false"
            labelCSS="site-form__label"
            rows="7"
            placeholderKey="deliveryRestrictions" 
            maxlength="200" 
            validationType="textarea"
            showCounter="true" />
        </div> 
      </div>
    </div>
    <div class="col-xs-12 col-sm-6 col-md-5 col-md-offset-1">
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
            <input id="register.deliveryPostcode" name="deliveryPostcode" class="form-control site-form__input js-formField is-required js-postcodeInput" value="" autocomplete="noautocomplete" data-validation-type="postcode"/>
            <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
            <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
          </div>
          <span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage hide"></span>
        </div>
        <div class="col-xs-12 col-sm-6 col-md-5">
          <button type="button" class="btn btn-secondary btn-block js-findPostcode">
            <spring:theme code="registration.address.findAddress" />
          </button>
        <div class="site-form__trigger text-left js-enterAddressManually hide">
          <spring:theme code="registration.address.enterManually" />
        </div>

        </div>
        </div>
      </div>	

      <div class="row">
        <div class="col-xs-12">
          <div id="jsSelectAddress">

          </div>
        </div>
      </div>

      <div class="js-addressFields hide">
        <div class="row">
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
            idKey="register.addressLine2"
            labelKey="register.addressLine2" 
            path="line2" 
            errorKey="addressLine2"
            inputCSS="form-control site-form__input js-formField"
            labelCSS="site-form__label"
            mandatory="false" 
            showAsterisk="true"
            validationType="any" />
        </div>
        <div class="col-xs-12">
          <formElement:formInputBox 
            idKey="register.addressLine3"
            labelKey="register.addressLine3" 
            path="line3" 
            errorKey="addressLine3"
            inputCSS="form-control site-form__input js-formField"
            labelCSS="site-form__label"
            mandatory="false" 
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
      </div>
      <div class="row">
        <div class="col-xs-12 col-sm-6 col-md-7">
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
        <div class="col-xs-12 col-sm-6 col-md-5">
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
    </div>
    </div>
    <common:postCodeHandlebarTemplate/>

    <button type="button" class="btn btn-primary visible-xs btn-block btn--full-width js-formNextBtn site-form__next-btn" data-parent="${sectionName}" data-goto="${nextSectionName}"><spring:theme code="registration.next" /></button>
  </div><%--site-form__section-content: about your business --%>


</div><%--site-form__section --%>


<%-- used in acc.register to run ajax call when BE form validation returned errors --%>
<input id="jsRegistrationSector" type="hidden" value="${registerForm.sector}" />
<input id="jsRegistrationSubSector" type="hidden" value="${registerForm.subSector}" />

<script id="sub-sector-template" type="text/x-handlebars-template">
  {{#ifCond type '==' 'list'}}
   <span class="site-form__label">
    <spring:theme code="registration.subsector" />
   </span>
    <div class="control site-form__dropdown js-subSelectWrapper">
      <label for="subSector" for="subSector" data-error-empty="<spring:theme code='error.empty.businessSubSector' />">
        <select id="subSector" name="subSector" class="form-control site-form__select js-formField js-formSelect ${isRequired}" data-validation-type="select" >
          <option value="" selected="selected"><spring:theme code="form.select.empty" /></option>
          {{#each data}}
            <option value="{{code}}" {{#ifCond code '==' ../value}} selected="selected" {{/ifCond}}>{{name}}</option>
          {{/each}}
        </select>
        	<span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
					<span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
      </label>
      <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
    </div>
  {{/ifCond}}
  {{#ifCond type '==' 'input'}}
    <label class="control-label site-form__label " for="subSector" for="subSector" data-error-empty="<spring:theme code='error.empty.businessSubSector' />">
      <spring:theme code="registration.subsector" />
    </label>
    <div class="site-form__inputgroup js-inputgroup ">
      <input id="subSector" name="subSector" class="form-control site-form__input js-formField ${isRequired}" value="{{value}}" />
      <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
      <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
    </div>
    <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
  {{/ifCond}}
  {{#ifCond type '==' 'disabled'}}
    <span class="site-form__label js-subSectorLabel is-disabled" for="subSector">
      <spring:theme code="registration.subsector" />
    </span>
    <div class="control site-form__dropdown js-subSelectWrapper">
      <label>
        <select id="subSector" name="subSector" class="form-control site-form__select js-formSelect ${isRequired}" data-validation-type="select" disabled="disabled">
          <option value="" selected="selected"><spring:theme code="form.select.empty" /></option>
        </select>
      </label>
    </div>
  {{/ifCond}}
</script>




<script>
	var loqate = window.loqate || {};
	loqate.hybris = {
	forms : [
	  {
	    formId: "registerForm",
			fields:{
				Line1: "register.addressLine1",
				Line2: "register.addressLine2",
				Line3: "register.addressLine3",
				City: "register.addressTown",
				AdminAreaName: "register.addressCounty",
        PostalCode: "register.addressPostcode",
			}
	  }
	]
};
</script>