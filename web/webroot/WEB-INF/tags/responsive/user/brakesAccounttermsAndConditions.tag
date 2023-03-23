<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
	
<spring:url value="/termsAndConditions" var="termsAndConditions"/>
<spring:url value="/privacyPolicy" var="privacyPolicy"/>
<div class="site-form__subsection">
	<div class="row">
		<div class="col-xs-12 col-md-7">
		
		<formElement:formCheckbox 
			idKey="termsCheck" 
			labelKey="register.termsConditions" 
			path="termsCheck" 
			mandatory="true"
			inputCSS="js-formField" 
			validationType="checkbox" 
			errorKey="termsAndConditions" 
			labelArguments="${termsAndConditions}" />

		<formElement:formCheckbox 
			idKey="privacyPolicy" 
			labelKey="registration.privacyPolicy" 
			path="privacyPolicy" 
			mandatory="true"
			inputCSS="js-formField " 
			validationType="checkbox" 
			errorKey="privacyPolicy" 
			labelArguments="${privacyPolicy}"/>
		</div>
	</div>
	<div class="site-form__actions form-actions clearfix">
      <ycommerce:testId code="register_Register_button">
        <button type="submit" class="btn btn-primary btn-block js-submitBtn">
          <spring:theme code="registration.submit" />
        </button>
      </ycommerce:testId>
    </div>
</div>