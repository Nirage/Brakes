
<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="actionNameKey" required="true" type="java.lang.String"%>
<%@ attribute name="action" required="true" type="java.lang.String"%>
<%@ attribute name="userId" required="true" type="java.lang.String"%>
<%@ attribute name="passwordId" required="true" type="java.lang.String"%>
<%@ attribute name="isMobile" required="false" type="java.lang.Boolean"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value = "/forgot-password" var="forgotPasswordUrl"/>
<spring:url value="/sign-in" var="signInUrl" />
<c:set var="userNameLabel"><spring:theme code="asm.login.password.placeholder"/></c:set>
<c:set var="passwordLabel"><spring:theme code="login.password"/></c:set>

<div class="row">
	<div class="col-sm-12">
		<h2 class="login-popup__sub-heading"><spring:theme code="login.login"/></h2>

		<form:form action="${action}" method="post" class="js-formValidation" modelAttribute="loginForm" id="${isMobile ? 'loginFormMobile' : 'loginForm'}">
			<c:if test="${not empty message}">
				<span class="has-error"><spring:theme code="${message}" /></span>
			</c:if>

			<%--
			<formElement:formInputBox
					idKey="${userId}"
					labelKey="login.username"
					path="j_username"
					mandatory="true"
					errorKey="userName"
					inputCSS="form-control site__form--input js-formField"
					labelCSS="site__form--label h-topspace-1 hide"
					placeholderKey="username"
			/>

			<formElement:formPasswordBox
					idKey="${passwordId}"
					labelKey="login.password"
					path="j_password"
					mandatory="true"
					errorKey="password"
					inputCSS="form-control site__form--input js-formField"
					labelCSS="site__form--label h-topspace-1 h-space-1"
					placeholderKey="password"
			/>

			<ycommerce:testId code="loginAndCheckoutButton">
				<button type="submit" class="btn btn-primary btn--full-width js-submitBtn h-topspace-1">
					<spring:theme code="${actionNameKey}" />
				</button>
			</ycommerce:testId>
			--%>
			<div id="login-iframe"></div>

			<div class="forgotten-password">
				<ycommerce:testId code="login_forgotPassword_link">
					<a href="${forgotPasswordUrl}" class="site__form--forgotlink" >
						<spring:theme code="login.link.forgottenPwd" />
					</a>
				</ycommerce:testId>
			</div>

			<spring:url value="/forgot-username" var="forgotusername" />
			<a href="${forgotusername}" class="site__form--forgotlink">
				<spring:theme code="login.link.forgottenUsername" />
			</a>


			<hr />
                <a href="${signInUrl}"  class="btn btn-secondary btn--full-width js-registerButton">
					<spring:theme code="gotoregister.button.register" />
				</a>
		</form:form>
	</div>
</div>


<div class="js_spinner spinning-div">
  <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>

