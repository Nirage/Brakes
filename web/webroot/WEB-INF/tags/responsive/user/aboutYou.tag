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

<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="${sectionName}">
	<div class="site-form__section-header js-formHeader">
		<spring:theme code="registration.section1.title" />
		<span class="icon icon-amend"></span>
	</div>
	<div class="site-form__section-content">
		<div class="row">
			<div class="col-xs-12 col-md-4">					
				<div class="site-form__title">
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
			</div>
			<div class="col-xs-12 col-sm-6 col-md-4">
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
			<div class="col-xs-12 col-sm-6 col-md-4">
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
			</div>
			<div class="row">
			<div class="col-xs-12 col-sm-6 col-md-4">
				<formElement:formInputBox 
					idKey="register.email"
					labelKey="register.email" 
					path="email" 
					errorKey="email"
					inputCSS="form-control site-form__input js-formField"
					labelCSS="site-form__label"
					mandatory="true" 
					showAsterisk="true"
					validationType="email" 
					tooltipKey="email"
					tooltipType="collapsable" />
			</div>
			<div class="col-xs-12 col-sm-6 col-md-4">
				<formElement:formInputBox 
					idKey="register.phone"
					labelKey="register.phone" 
					path="mobileNumber" 
					errorKey="phone"
					inputCSS="form-control site-form__input js-formField"
					labelCSS="site-form__label"
					mandatory="true" 
					showAsterisk="true"
					validationType="mobilephone"
					tooltipKey="mobilePhone"
					tooltipType="collapsable" />
			</div>
			<div class="col-xs-12 col-sm-6 col-md-4">
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
			</div>
			<div class="row">
				<div class="col-xs-12 col-sm-6 col-md-4">
					<formElement:formSelectBox
						idKey="register.leadSource"
						labelKey="register.leadSource"
						path="leadSource"
						errorKey="leadSource"
						selectCSSClass="form-control site-form__select js-formSelect js-formField js-leadSource"
						skipBlankMessageKey="form.select.empty"
						mandatory="false"
						validationType="any"
						items="${leadSources}"
						labelCSS="site-form__label"
						selectedValue="${registerForm.leadSource}"/> 

					<div class="custom-txtbox js-leadSourceFreeText hide ">
						<div class="site-form__formgroup form-group js-formGroup">
							<label class="site-form__label  js-leadSourceFreeTextLbl" for="register.leadSourceText" data-error-empty="error.empty.leadReason" 
							data-error-maxlength="<spring:theme code="error.maxChars.leadSourceText"></spring:theme>"
							 data-error-invalid="<spring:theme code="error.leadSourceText"></spring:theme>"><spring:theme code="register.leadSourceText"></spring:theme></label>
							<textarea id="register.leadSourceText" name="leadSourceText" class="form-control site-form__textarea js-formTextarea has-counter js-leadSourceFreeTextArea"  data-validation-type="printablecharacters" rows="7"></textarea><span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage">
							</span>
						</div>
					</div>
				</div>	
      		
				<div class="col-xs-12 col-sm-6 col-md-6">
					<formElement:formTextArea 
						idKey="register.leadReason"
						labelKey="register.leadReason"
						path="leadReason"
						errorKey="leadSourceText"
						areaCSS="form-control site-form__textarea js-formTextarea has-counter" 
						labelCSS="site-form__label"
						mandatory="false"
						maxlength="170"
						validationType="printablecharacters"
						rows="7"
						showCounter="true"
					/>				
				</div>
			</div>
		

		<button type="button" class="btn btn-primary visible-xs btn-block btn--full-width js-formNextBtn site-form__next-btn" data-parent="${sectionName}" data-goto="${nextSectionName}"><spring:theme code="registration.next" /></button>

	</div><%-- site-form__section-content: about you --%>
</div><%-- site-form__section --%>

