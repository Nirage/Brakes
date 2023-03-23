<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="actionNameKey" required="true" type="java.lang.String"%>
<%@ attribute name="action" required="true" type="java.lang.String"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value = "/sign-in" var="loginUrl"/>
		<div class="row js-b2cPopUpWhitelistedPage">
			<div class="col-xs-12 col-md-12">			
				<div class="site__header">
					<spring:theme code="account.forgotton.password.title" />
					<span class="site__header--rectangle"></span>
				</div>
			</div>
			
					<div class="col-xs-12 col-md-10 col-md-offset-1">
			<form:form action="${action}" method="post" class="js-formValidation" modelAttribute="forgotPasswordForm">

					<c:if test="${not empty message}">
												<span class="has-error"> <spring:theme code="${message}" />
												</span>
					</c:if>

					<formElement:formInputBox
							idKey="username"
							labelKey="forgotpassword.email"
							path="username"
							mandatory="true"
							errorKey="userName"
							inputCSS="form-control site__form--input js-formField js-b2cPopUpWhitelistedCTA"
							labelCSS="site__form--label"
					/>
					<button type="submit" class="btn btn-primary btn--full-width forgot-password-btn js-submitBtn js-b2cPopUpWhitelistedCTA">
						<spring:theme code="${actionNameKey}" />
					</button>
					
					<span class="trouble-text"><spring:theme code="forgotpassword.link.stillhaving.trouble" /></span>
					</div>
					<div class="col-xs-12 col-md-12">
					<span class="forgot-password-line"></span>
					</div>
					<div class="col-xs-12 col-md-10 col-md-offset-1">
					<a href="${loginUrl}" class="btn btn-default custom-button--default forgot-password-back-btn h-space-1 js-b2cPopUpWhitelistedCTA"><spring:theme code="forgotpassword.back.to.sign.in" /></a>
					
				</form:form>
					</div>
				
		</div>
