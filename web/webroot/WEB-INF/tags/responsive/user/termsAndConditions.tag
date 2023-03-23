<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>	
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>



<spring:url value="/termsAndConditions" var="termsAndConditions"/>
<spring:url value="/privacyPolicy" var="privacyPolicy"/>

<div class="site-form__subsection">
	<div class="row">
		<div class="col-xs-12 col-md-7">
		
			<formElement:formCheckbox 
				idKey="marketingPreference" 
				labelKey="registration.marketingPreferences" 
				path="marketingPreference" 
				mandatory="false"
				inputCSS="js-formField js-formCheckbox" 
				validationType="checkbox" 
				errorKey="marketingPreference"
				tooltip="true"
				tooltipContent="marketingPreferences" />

		<c:if test="${ not empty consentTemplateData }">
			<form:hidden path="consentForm.consentTemplateId" value="${consentTemplateData.id}" />
			<form:hidden path="consentForm.consentTemplateVersion" value="${consentTemplateData.version}" />
			<div class="checkbox">
				<label class="control-label">
					<form:checkbox path="consentForm.consentGiven"/>
					<c:out value="${consentTemplateData.description}" />
				</label>
			</div>
			<div class="help-block"><spring:theme code="registration.consent.link" /></div>
		</c:if>

		<formElement:formCheckbox 
			idKey="termsCheck" 
			labelKey="register.termsConditions" 
			labelArguments="${termsAndConditions}"
			path="termsCheck" 
			mandatory="true"
			inputCSS="js-formField" 
			validationType="checkbox" 
			errorKey="termsAndConditions" 
			/>

		<formElement:formCheckbox 
			idKey="privacyPolicy" 
			labelKey="registration.privacyPolicy" 
			labelArguments="${privacyPolicy}"
			path="privacyPolicy" 
			mandatory="true"
			inputCSS="js-formField " 
			validationType="checkbox" 
			errorKey="privacyPolicy" />
		</div>
	</div>
</div>