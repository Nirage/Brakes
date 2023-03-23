
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

<c:set var="hideDescription" value="checkout.login.loginAndCheckout" />
<c:url value = "/forgot-password" var="forgotPasswordUrl"/>

<%-- Define b2c and b2b value | Begin --%>
<c:set var="layout" value="col-md-6 col-sm-6 login__wrapper--signin" />
<c:if test="${isb2cSite}">
	<c:set var="layout" value="col-xs-12 col-sm-6 col-sm-offset-3 login__wrapper--signin2" />
</c:if>
<%-- Define b2c and b2b value | End --%>

<div class="${layout}">
	<div class="row">
		<div class="col-md-8 col-sm-10 col-md-offset-2">
			<h1 class="h-topspace-2 text-center">
				<spring:theme code="login.title" />
			</h1>
			<div id="v-login-popup"
				class="nav__item js-mobile-nav__item user"
				data-site-uid="${siteUid}"
				data-user-id="${user.unit.uid}"
				data-user-name="${user.unit.name}"
				data-is-logged-in="${isLoggedIn}"
				data-user-id-value="${user.uid}"
				data-hybris-idp-client='${hybrisIDPClient}'
				data-heading-value="<spring:theme code='account.mydetails.heading' />"
				data-my-details-value="<spring:theme code='account.mydetails' />"
				data-not-found-value="<spring:theme code='account.switchaccount.noresults' />"
				data-switch-account-value="<spring:theme code='account.switchaccount' />"
				data-switch-placeholder-value="<spring:theme code='account.switchaccount.search.placeholder' />"
				data-switch-back-value="<spring:theme code='account.back' />"
				data-my-favourites-value="<spring:theme code='text.account.favourites.my' />"
				data-my-favourites-url="/my-account/favourites"
				data-logout-value="<spring:theme code='header.link.logout' />"
			></div>
			<div class="text-center mt1">
                Forgot&nbsp;
			<spring:url value="/forgot-username" var="forgotusername" />
                <a href="${forgotusername}" class="text-primary underline">
                  username
                </a>
                &nbsp;or&nbsp;
                <a href="${forgotPasswordUrl}" class="text-primary underline">
                  password
                </a>
                ?
              </div>
		</div>
	</div>
	<%-- Show span if not b2c site --%>
  <c:if test="${!isb2cSite}">
		<span class="login__devider--textdesktop"><spring:theme code="login.register.or" /></span>
	</c:if>
</div>

<div class="js_spinner spinning-div">
  <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>

