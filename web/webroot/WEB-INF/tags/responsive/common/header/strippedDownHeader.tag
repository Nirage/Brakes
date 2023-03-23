<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="hideHeaderLinks" required="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
	<c:set var="isLoggedIn" value="true" />
</sec:authorize>
<c:url value="/" var="backToHomeUrl" />
<c:if test="${cmsPage.uid eq 'checkoutPage' || cmsPage.uid eq 'preCheckoutPage'}">
	<nav class="naigation navigation--top js-navigationTop ${siteUid}-nav ">
	<div class="container">
		<div class="row">
			<div class="col-sm-2 hidden-xs nav-links-wrapper__left p-0">
				<ul class="links-list js-aboutLinks">
					<cms:pageSlot position="HeaderLinks" var="link">
						<cms:component component="${link}" element="li" class="links-list__item"/>
					</cms:pageSlot>
				</ul>
			</div>

			<div class="col-xs-12 col-sm-10 nav-links-wrapper__right p-0">
				<div class="nav__right text-right">
					<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')" >
						<ul class="nav__links nav__links--account">
							<li class="user-login">
								<ycommerce:testId code="header_Login_link">
									<c:url value="/sign-in" var="loginUrl" />
									<a class="user-login__link" href="${fn:escapeXml(loginUrl)}">
										<span class="icon icon-user-login "></span> 
										<span><spring:theme code="header.link.login.register" /></span>
									</a>
								</ycommerce:testId>
							</li>
						</ul>
					</sec:authorize>
					<cms:pageSlot position="MyAccount" var="link">
						<cms:component component="${link}"/>
					</cms:pageSlot>
					<cms:pageSlot position="DeliveryCalendar" var="deliverycalendar" >
						<cms:component component="${deliverycalendar}" />
					</cms:pageSlot>
				</div>
			</div>
		</div>
		</div>
	</nav>
</c:if>
<c:choose>
	<c:when test="${cmsPage.uid eq 'checkoutPage' || cmsPage.uid eq 'preCheckoutPage' || cmsPage.uid eq 'register'}">
		<header class="header header--stripped-down header--stripped-down--bordered js-strippedDownHeader">
	</c:when>
	<c:otherwise>
		<c:choose>
			<c:when test="${cmsPage.uid eq 'checkoutIframePage'}">
				<header class="header header--stripped-down header--stripped-down--bordered js-strippedDownHeader">
			</c:when>
			<c:otherwise>
				<header class="header header--stripped-down js-strippedDownHeader">
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

	<%-- Header TopHeaderSlot --%>
	<cms:pageSlot position="TopHeaderSlot" var="component" element="div" >
		<cms:component component="${component}" />
	</cms:pageSlot>

	<nav class="navigation">
		<div class="main__inner-wrapper">
			<div class="container">
				<div class="row">
					<div class="col-xs-12">
						<c:if test="${cmsPage.uid eq 'checkoutPage' || cmsPage.uid eq 'preCheckoutPage'}">
							<a class="btn btn-back header__btn-back" href="${backToHomeUrl}">
								<span class="btn-back__inner">
									<span class="icon icon--sm icon-chevron-left"></span>
									<span class="hidden-xs"><spring:theme code="header.back.to.homepage"/></span>
								</span>
							</a>
						</c:if>
						
						<div class="site-logo">
						<c:if test="${(step eq 'STEP_TWO' || step eq 'STEP_THREE' || step eq 'STEP_FOUR') && registerForm.hybrisLockedLead eq false}">
						<button class="btn header__btn-exit js-saveAndExit hidden-xs"> <div class="btn__text-wrapper">
                  			<span class="icon icon-chevron-left btn__icon"></span><span class="btn__text"><spring:theme code="header.save.exit"/>
							 </span>
						 </button>
						 <a class="header__btn-exit js-saveAndExit visible-xs"> <div class="btn__text-wrapper">
                  			<span class="icon icon-chevron-left btn__icon"></span><span class="btn__text"><spring:theme code="header.save.exit"/>
							 </span>
						 </a>
						</c:if>
							<cms:pageSlot position="SiteLogo" var="logo" limit="1">
								<cms:component component="${logo}" element="div" class="yComponentWrapper"/>
							</cms:pageSlot>
						</div>
					</div>
				</div>
			</div>
		</div>
	</nav>
	<components:wishlistAlert />
</header>
<c:if test="${isLoggedIn}">
	<nav:paymentBanner/>
</c:if>
