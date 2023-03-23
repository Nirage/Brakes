<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>

	<cms:pageSlot position="RegistrationConfirmationContent" var="feature" element="div" >
		<cms:component component="${feature}"  element="div"/>
	</cms:pageSlot>

	<div class="register-confirm__footer">
		<a href="/" class="btn btn-primary btn--full-width"><spring:theme code="registerconfirmation.back.to.home" /></a>
	 </div>	
	       
	      
		
