<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<c:url value = "/sign-in" var="loginUrl"/>
	<div class="row">
		<div class="col-md-12">
			<div class="site__header">
				<spring:theme code="forgotpassword.confirm.page.title.message" />
				<span class="site__header--rectangle"></span>
			</div>
		</div>
		<div class="col-md-8 col-md-offset-2 text-center">
		<span class="icon icon-opened-email custom-iconbox__icon"></span>
			<p class="custom-iconbox__text--regular">
				<c:if test="${not empty message}">
						<span class="has-error"> <spring:theme code="${message}" />
						</span>
				</c:if>
				<spring:theme code="forgotpassword.confirm.page.detail.message" />
			</p>
		</div>
		<div class="col-md-12">				
			<span class="trouble-text"><a href="#" class="brakes__form--forgotlink"><spring:theme code="forgotpassword.link.stillhaving.trouble" /></a></span>
		</div>

		<div class="col-md-12">
			<span class="forgot-password-line"></span>
		</div>
		<div class="col-md-10 col-md-offset-1">
				<a href="${loginUrl}" class="btn btn-default custom-button--default forgot-password-back-btn h-space-1"><spring:theme code="forgotpassword.back.to.sign.in" /></a>
		</div>		
		</div>
	</div>

