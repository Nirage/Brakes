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


<c:if test="${not empty registerForm.title}"> 
  <script>
    window.formPrePopulated = true;
  </script>
</c:if>

<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="${sectionName}">
	<div class="site-header site-header--align-left">
		<h1 class="site-header__h1"><spring:theme code="multiStepRegistration.section1.title" /></h1>
	</div>
	<div class="row">
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
		
		<div class="col-xs-12" id="registerPhoneSection">
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
		<div class="col-xs-12" id="registerBusinessTelephoneNumberSection">
			<formElement:formInputBox 
				idKey="register.businessTelephoneNumber"
				labelKey="registration.businessTelephoneNumber" 
				path="businessTelephoneNumber" 
				errorKey="phone"
				inputCSS="form-control site-form__input js-formField"
				labelCSS="site-form__label"
				mandatory="false" 
				showAsterisk="true"
				validationType="mobilephone"
				/>
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
		<div class="col-xs-12" id="registerLeadSourceSection">
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

			<div class="custom-txtbox js-leadSourceFreeText  ${registerForm.leadSource eq 'OTHER' || registerForm.leadSource eq 'GOOGLE_OR_OTHER_SEARCH_ENGINE' || registerForm.leadSource eq 'I_HAVE_USED_BRAKES_IN_THE_PAST' ? ' ' : 'hide'}">
				<div class="site-form__formgroup form-group js-formGroup">
					<label class="site-form__label  site-form__labelUp js-leadSourceFreeTextLbl" for="register.leadSourceText" data-error-empty="error.empty.leadReason" 
					data-error-maxlength="<spring:theme code="error.maxChars.leadSourceText"></spring:theme>"
						data-error-invalid="<spring:theme code="error.invalid.leadSourceText"></spring:theme>">
						<c:choose>
							<c:when test="${registerForm.leadSource eq 'GOOGLE_OR_OTHER_SEARCH_ENGINE'}">
								<spring:theme code="register.google" />
							</c:when>
							<c:when test="${registerForm.leadSource eq 'I_HAVE_USED_BRAKES_IN_THE_PAST'}">
								<spring:theme code="register.brakesInPast" />
							</c:when>
							<c:otherwise>
								<spring:theme code="register.other" />
							</c:otherwise>
						</c:choose>			
					</label>
					<formElement:formTextArea 
						idKey="register.leadSourceText"
						labelKey=""
						path="leadSourceText"
						errorKey="leadSourceText"
						areaCSS="form-control site-form__textarea js-formTextarea has-counter js-leadSourceFreeTextArea" 
						labelCSS="site-form__label"
						mandatory="false"
						maxlength="170"
						validationType="printablecharacters"
						rows="7"
						showCounter="true"
					/>				
				</div>
			</div>
		</div>	
		
		<div class="col-xs-12" id="registerLeadReasonSection">
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
		<c:if test="${siteUid == 'brakes'}">
		<div class="col-xs-12" id="registerPreviousSupplier">
			<formElement:formTextArea 
				idKey="register.previousSupplier"
				labelKey="register.previousSupplier"
				path="previousSupplier"
				errorKey="previousSupplier"
				areaCSS="form-control site-form__textarea js-formTextarea has-counter" 
				labelCSS="site-form__label"
				mandatory="false"
				maxlength="100"
				validationType="printablecharacters"
				rows="3"
				showCounter="true"
				tooltipKey="previousSupplier"
				tooltipType="collapsable" />
		</div>
		</c:if>
	</div>
</div><%-- site-form__section --%>

