<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${!isCookieNotificationAccepted}">
<div class="cookie__wrapper">
	<div class="container">
		<div class="row">
			<div class="col-sm-8 col-md-8 col-lg-8">
				<div class="cookie__text">
					<spring:theme code="cookiepolicy.bodyline"/>
					&nbsp;<a class="cookie__text-link" href="<spring:theme code="cookiepolicy.link.value"/>"><spring:theme code="cookiepolicy.link.text"/></a>
				</div>	
			</div>
			<div class="col-sm-4 col-md-4 col-lg-4">
				<div class="cookie__btn-wrapper">
					<button class="btn btn-primary cookie__btn js-acceptCookieBtn js-b2cPopUpWhitelistedCTA float-right" id="accept-cookie"><span class="icon icon-tick cookie__btn-icon"></span>&nbsp;<spring:theme code="cookiepolicy.accept.link.text"/></button>
				</div>
			</div>
		</div>
	</div>
</div>
</c:if>
