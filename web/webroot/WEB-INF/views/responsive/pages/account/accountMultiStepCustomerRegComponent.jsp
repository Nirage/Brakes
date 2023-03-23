<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>


<!-- Use this url for save and exit => ${contextPath}/customer-register-save-and-exit/submit -->

<form:form method="post" id="registerForm" modelAttribute="registerForm" action="${contextPath}/become-a-customer-register/submit" cssClass="site-form js-multiStepRegistrationForm js-formValidation multi-step-registration">
<input type="hidden" value="${contextPath}/customer-register-save-and-exit/submit" class="js-saveExitSubmitUrl">

<form:hidden path="step" id="step" class="js-step" value="${step}" />
	<c:choose>
		<c:when test="${step eq 'STEP_ONE'}">
			<user:companyDetailsMultiStepReg/>
		</c:when>
		<c:when test="${step eq 'STEP_TWO'}">
			<user:aboutYourBusinessMultiStepReg sectionName="about-business" nextSectionName="company-details"/>
		</c:when>
		<c:when test="${step eq 'STEP_THREE'}">
			<user:aboutYouMultiStepReg isActive="true" sectionName="about-you" nextSectionName="about-business"/>
		</c:when>
		<c:when test="${step eq 'STEP_FOUR'}">
		    <user:termsAndConditionsMultiStepReg/>
		</c:when>
	</c:choose>
</form:form>

<div class="js_spinner spinning-div">
  <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>
