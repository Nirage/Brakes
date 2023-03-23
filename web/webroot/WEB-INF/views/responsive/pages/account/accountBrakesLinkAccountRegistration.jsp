<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<spring:url value="/become-a-customer-eligible" var="signupUrl"/>
<div class="container">
	<div class="row">
		<%-- Page header --%>
		<div class="col-xs-12">
			<div class="site-header site-header--align-left site-header--margin-bottom">
				<h1 class="site-header__text"><spring:theme code="register.link.orderingAccount" /></h1>
				<span class="site-header__rectangle site-header__rectangle--align-left"></span>
				<p class="site-header__subtext"><spring:theme code="register.link.completeForm"/></p>
				<p class="site-header__subtext"><spring:theme code="register.link.signup" arguments="${signupUrl}" /></p>
			</div>
		</div>
		<%-- Page content --%>
		<div class="col-xs-12">
			<form:form method="post" id="registerBrakesOrderingAccountForm" modelAttribute="registerBrakesOrderingAccountForm" action="/register-existing-registration" cssClass="site-form js-registrationForm js-formValidation">
				<user:aboutYouExistingCustomer isActive="true" sectionName="about-you" nextSectionName="your-brakes-account"/>
				<user:yourBrakesAccount sectionName="your-brakes-account"/>
			</form:form>
		</div><%-- .col-xs-12 --%>
	</div><%-- .row --%>
</div><%-- .container --%>
<div class="js_spinner spinning-div">
  <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>