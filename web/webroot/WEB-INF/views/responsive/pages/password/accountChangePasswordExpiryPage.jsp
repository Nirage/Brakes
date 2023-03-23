<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/forgot-password" var="forgotPasswordLink"/>
<div class="container">
<div class="row js-b2cPopUpWhitelistedPage">
    <div class="col-md-4 col-sm-8 col-sm-offset-2 col-md-offset-4">
            <div class="middle-container">
		      <div class="row">		
					<div class="col-md-12">
						<p><spring:theme code="text.pasword.expiry.header"/></p>
						
						<p><spring:theme code="reset.pwd.expiry.please.txt"/>&nbsp;<a class="link-text" href="${forgotPasswordLink}"><spring:theme code="reset.pwd.expiry.link.txt"/></a></p>
						<p><spring:theme code="reset.pwd.expiry.detail.txt"/></p>

						<p class="h-space-3"><spring:theme code="reset.pwd.help.txt" /></p>

					</div>
					
					<div class="col-md-8 col-md-offset-2 col-sm-8 col-sm-offset-2">
						<div class="accountActions h-space-5">
							<a class="btn btn-primary btn--full-width js-b2cPopUpWhitelistedCTA" href="/"><spring:theme code="reset.pwd.expiry.go.to.homepage" text="Go to homepage" /></a>

						</div>
					</div>
				</div>
			</div>
		</div>
</div>
</div>