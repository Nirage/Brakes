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

<c:if test="${not empty registerForm.tradingName}"> 
  <script>
    window.formPrePopulated = false;
  </script>
</c:if>


<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="about-business">
 	<div class="site-header site-header--align-left">
		<h1 class="site-header__h1"><spring:theme code="multiStepRegistration.section2.title" /></h1>
	</div>
  <div class="row">
    <c:if test="${cmsSite.uid == 'countryChoice'}">
      <div class="col-xs-12 site-form__input--icon-left" id="registerDateEstablishedSection">
        <formElement:formInputBox 
          idKey="register.dateEstablished"
          labelKey="register.dateEstablished" 
          path="dateEstablished" 
          errorKey="dateEstablished"
          inputCSS="form-control site-form__input js-formField"
          labelCSS="site-form__label"
          mandatory="true" 
          showAsterisk="true"
          validationType="allDate"
          htmlType="date"
          />
      </div>
      <div class="col-xs-12" id="registerNumberOfFullTimeEmployeesSection">
        <formElement:formInputBox
          idKey="register.numberOfFullTimeEmployees"
          labelKey="register.numberOfFullTimeEmployees"
          path="numberOfFullTimeEmployees"
          errorKey="numberOfFullTimeEmployees"
          inputCSS="form-control site-form__input js-formField"
          labelCSS="site-form__label"
          mandatory="true"
          showAsterisk="true"
          validationType="companyregnumber"
          maxlength="6"/>
      </div>
      <div class="col-xs-12" id="registerAnualStoreTurnoverSection">
        <formElement:formSelectBox
          idKey="annualStoreTurnover"
          labelKey="register.annualStoreTurnover"
          path="annualStoreTurnover"
          errorKey="annualStoreTurnover"
          selectCSSClass="form-control site-form__select js-formSelect js-formField"
          skipBlankMessageKey="form.select.empty"
          showAsterisk="false"
          mandatory="false"
          validationType="any"
          items="${annualStoreTurnOvers}"
          labelCSS="site-form__label"
          selectedValue="${registerForm.annualStoreTurnover}"/> 
      </div>
		</c:if>

    <c:if test="${themeName eq 'brakes'}">
      <div class="col-xs-12" id="registrationMonthlySpendSection">
        <%-- FIELD NOT REQUIRED FOR COUNTRY CHOICE --%>
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
          selectedValue="${registerForm.budget}"
        />          
      </div>
    </c:if>
    <div class="col-xs-12" id="registrationSectionSector">
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
        endpoint="/misc/sfsubsectors" 
        tooltipKey="businessSector"
        tooltipType="collapsable"
        selectedValue="${registerForm.sector}"
      />
    </div>

    <div class="col-xs-12" id="registrationSubSectorSection">
      <div class="custom-txtbox" id="subSector.section">
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
    <div class="col-xs-12" id="registrationCurrentSupplier">
      <formElement:formSelectBox
        idKey="registration.currentSupplier"
        labelKey="registration.currentSupplier"
        selectCSSClass="form-control site-form__select js-formSelect js-formField"
        path="currentSupplier"
        errorKey="currentSupplier"
        mandatory="false"
        showAsterisk="false"
        skipBlank="false"
        skipBlankMessageKey="form.select.empty"
        items="${currentSuppliers}"
        labelCSS="site-form__label"
        validationType="select"
        selectedValue="${registerForm.currentSupplier}"
      />
    </div>
    <div class="col-xs-12 hide" id="registrationCurrentSupplierComments">
      <formElement:formTextArea
        idKey="registration.currentSupplierComments"
        labelKey="registration.currentSupplierComments"
        path="currentSupplierComments"
        errorKey="currentSupplierComments"
        areaCSS="form-control site-form__textarea js-formTextarea has-counter"
        mandatory="true"
        labelCSS="site-form__label"
        rows="7"
        placeholderKey="currentSupplierComments"
        maxlength="100"
        validationType="textarea"
        showCounter="true"
      />
    </div>
    <div class="col-xs-12" id="registrationDeliveryRestrictionsSection">
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

      <input id="subSector" name="subSector" class="form-control site-form__input js-formField ${isRequired}" data-validation-type="any" {{#ifCond value '==' ''}}  value="${registerForm.subSector}" {{else}} value="{{value}}" {{/ifCond}}/>
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

