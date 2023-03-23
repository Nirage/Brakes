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
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<spring:htmlEscape defaultHtmlEscape="false" />
<c:url value="/my-account/favourites" var="favouritesUrl"/>
<c:url value="/sign-in" var="loginUrl"/>
<c:url value="/j_spring_security_check" var="loginActionUrl"/>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
	<c:set var="isLoggedIn" value="true" />
	<c:if test="${hasFavourites}">
		<c:set var="hasFavList" value="true" />
	</c:if>
</sec:authorize>

<header class="js-mainHeader">
	<div class="sticky-header js-stickyHeader header">

		<%-- Header TopHeaderSlot --%>
		<cms:pageSlot position="TopHeaderSlot" var="component" element="div" >
			<cms:component component="${component}" />
		</cms:pageSlot>

		<nav class="navigation navigation--top js-navigationTop ${siteUid}-nav">
			<div class="container-xl">
				<div class="row">
					<div class="nav-links-wrapper__left">
						<span class="js-moreAboutLinks visible-sm links-list-trigger">
							<spring:theme code="topNav.moreTablet.btn"/>
						</span>

						<ul class="links-list js-aboutLinks">
							<cms:pageSlot position="HeaderLinks" var="headerNavComponent">
								<c:forEach items="${headerNavComponent.navigationNode.children}" var="topLevelLinks">
									<c:forEach items="${topLevelLinks.entries}" var="entry">
										<c:set value="${ycommerce:componentVisible(entry.item.uid)}" var="componentVisible"/>
										<c:if test="${!empty punchoutUser}">
											<c:forEach items="${entry.item.restrictions}" var="restriction">
												<c:set value="false" var="componentVisible"/>
											</c:forEach>
										</c:if>
										<c:if test="${componentVisible}">
											<li class="links-list__item ga-topnav-1 <c:if test="${fn:length(topLevelLinks.children) > 0 }"> js-linksItemDrillDown has-subnav</c:if> ">
												<cms:component component="${entry.item}" evaluateRestriction="true"/>
												<ul class="links-list__subnav links-subnav">
													<c:forEach items="${topLevelLinks.children}" var="childLevel2">
														<c:if test="${not empty childLevel2.entries}">
															<c:forEach items="${childLevel2.entries}" var="childlink2">
																<li class="links-subnav__item ga-topnav-2"><cms:component component="${childlink2.item}" evaluateRestriction="true" /></li>
															</c:forEach>
														</c:if>
													</c:forEach>
												</ul>
											</li>
										</c:if>
									</c:forEach>
								</c:forEach>
							</cms:pageSlot>
						</ul>
					</div>

					<div class="nav__right text-right flex justify-content-flex-end align-items-center mlauto-desktop">
						<c:if test="${isLoggedIn && singlesignon && joinLoyaltyEnabled}">
							<li class="links-list__item ga-topnav-1">
								<a 
									type="button"
									href="/singleSignon"
									id="sso-button"
									class="font-primary-bold underline disabled js-popover-loading"
								><spring:theme code="single.signon.join.cta" />
								</a>
							</li>
						</c:if>
						<c:if test="${!isb2cSite}">
							<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')">
								<ul class="nav__links nav__links--account">
									<li class="user-login">
										<ycommerce:testId code="header_Login_link">
											<c:url value="/sign-in" var="loginUrl" />
											<span class="user-login__link ga-topbar-login js-loginPopupTrigger">
												<i class="icon icon-user-login"></i>
												<span><spring:theme code="header.link.login.register" /></span>
											</span>
										</ycommerce:testId>
									</li>
								</ul>
							</sec:authorize>
						</c:if>
						<cms:pageSlot position="MyAccount" var="link">
							<cms:component component="${link}"/>
						</cms:pageSlot>
						<cms:pageSlot position="DeliveryCalendar" var="deliverycalendar" >
							<cms:component component="${deliverycalendar}" />
						</cms:pageSlot>
					</div>
				</div>
			</div>
		</nav>

		<%-- Added during punchout integration --%>
		<cms:pageSlot position="BottomHeaderNavSlot" var="component">
			<cms:component component="${component}" />
		</cms:pageSlot>

		<%-- a hook for the my account links in desktop/wide desktop--%>
		<div class="hidden-xs hidden-sm js-secondaryNavAccount collapse" id="accNavComponentDesktopOne">
			<ul class="nav__links"></ul>
		</div>
		<div class="hidden-xs hidden-sm js-secondaryNavCompany collapse" id="accNavComponentDesktopTwo">
			<ul class="nav__links js-nav__links"></ul>
		</div>
		<nav class="navigation navigation--middle js-navigation--middle">
			<div class="container-xl">
				<div class="row flex flex-wrap-xs align-items-center">
					<div class="nav__item js-mobile-nav__item nav__burger-menu hidden-sm hidden-md hidden-lg">
						<button class="btn nav__row--btn-menu js-toggle-sm-navigation js-menu ga-mobile-nav-1 ml1" type="button">
							<i class="icon icon-menu" aria-hidden="true"></i>
							<p class="nav__burger-menu-text"><spring:theme code="mobile.nav.menu" /></p>
						</button>
					</div>
					<div class="js-site-logo site-logo col-sm-${siteUid == 'brakes' ? '2' : '3'}">
						<cms:pageSlot position="SiteLogo" var="logo" limit="1">
							<cms:component component="${logo}" element="div" class="yComponentWrapper ga-nav-bar-1"/>
						</cms:pageSlot>
					</div>
					<cms:pageSlot position="SearchBox" var="component">
						<cms:component component="${component}" />
					</cms:pageSlot>

					<c:if test="${!isb2cSite}">
						<div id="v-login-popup"
							class="nav__item js-mobile-nav__item user"
							data-site-uid="${siteUid}"
							data-user-id="${user.unit.uid}"
							data-user-name="${user.unit.name}"
							data-is-logged-in="${isLoggedIn}"
							data-user-id-value="${user.uid}"
							data-hybris-idp-client='${hybrisIDPClient}'
							data-signin-title="<spring:theme code='login.login'/>"
							data-heading-value="<spring:theme code='account.mydetails.heading' />"
							data-my-details-value="<spring:theme code='account.mydetails' />"
							data-not-found-value="<spring:theme code='account.switchaccount.noresults' />"
							data-switch-account-value="<spring:theme code='account.switchaccount' />"
							data-switch-placeholder-value="<spring:theme code='account.switchaccount.search.placeholder' />"
							data-switch-back-value="<spring:theme code='account.back' />"
							data-my-favourites-value="<spring:theme code='text.account.favourites.my' />"
							data-my-favourites-url="/my-account/favourites"
							data-logout-value="<spring:theme code='header.link.logout' />"
						>
							<button class="btn btn-link nav__links-item__link js-loginPopupTrigger" aria-label="<spring:theme code='${isLoggedIn ? "account.mydetails.heading" : "login.login"}' />">
								<div class="icon icon-user"></div>
							</button>
						</div>
						<span class="spinning-div">
							<img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
						</span>
					</c:if>
					<c:choose>
						<c:when test="${isb2cSite}">
							<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
								<div class="nav__links-item">
									<cms:pageSlot position="MiniCart" var="cart" element="div" class="componentContainer">
										<cms:component component="${cart}" element="div"/>
									</cms:pageSlot>
								</div>
								<c:if test="${empty isCheckoutPage}">
									<div class="nav__links-item">
										<a tabindex="0" href="${siteUid eq 'brakesfoodshop' ? '/checkout': '/checkout/step-one'}" class="js-btnCheckoutHeader btn btn-secondary hidden-sm hidden-xs btn-checkout-header ga-nav ${cartTotalItems > 0 ? ' has-items' : ''}">
											<spring:theme code="checkout.checkout" />
										</a>
									</div>
								</c:if>
							</sec:authorize>
						</c:when>
						<c:otherwise>
							<div class="nav__links-item nav__cart">
								<cms:pageSlot position="MiniCart" var="cart" element="div" class="componentContainer b2bsite">
									<cms:component component="${cart}" element="div"/>
								</cms:pageSlot>
							</div>
							<div class="nav__links-item login-wrapper nav-v-separator nav__delivery">
								<button class="btn btn-link nav__links-item__link ${isLoggedIn ? 'js-deliveryPopupTrigger' : 'js-loginPopupTrigger'}" aria-label="<spring:theme code='navPopUp.myorders.heading' />">
									<div class="icon-van-wrapper">
										<div class="icon icon-van"></div>
										<c:if test="${isLoggedIn}"><div class="icon-van-count hide js-ordersCount"></div></c:if>
									</div>
								</button>
								<c:if test="${isLoggedIn}">
									<div class="nav-popup nav-popup--delivery hide js-deliveryPopup">
										<nav:myOrdersPopup />
									</div>
									<span class="nav-popup--bg"></span>
								</c:if>
							</div>
							<c:if test="${empty isCheckoutPage && empty amendingOrderCode}">
							<c:choose>
							<c:when test="${empty punchoutUser}">
								<spring:theme code="checkout.checkout" var="checkoutLabel"/>
							</c:when>
							<c:otherwise>
								<spring:theme code="punchout.checkout.checkout" var="checkoutLabel"/>
							</c:otherwise>
							</c:choose>
								<div class="nav__links-item ml1 mr1">
									<c:choose>
										<c:when test="${isLoggedIn}">
											<a tabindex="0" href="${siteUid eq 'brakesfoodshop' ? '/checkout': '/checkout/step-one'}" class="js-btnCheckoutHeader btn btn-secondary hidden-sm hidden-xs btn-checkout-header ga-nav-bar-6 ${cartTotalItems > 0 ? ' has-items' : ''}">${checkoutLabel}</a>
										</c:when>
										<c:otherwise>
											<button class="js-loginPopupTrigger btn ${siteUid eq 'brakes' ? 'btn-primary text-white' : 'btn-secondary'}  hidden-sm hidden-xs btn-checkout-header ga-nav-bar-6">${checkoutLabel}</button>
										</c:otherwise>
									</c:choose>
								</div>
							</c:if>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</nav>
		<div id="popover-loading"
			class="hide" 
			data-sso-message="<spring:theme code='single.signon.success.redirect.msg'/>"
			data-help-message="<spring:theme code='help.success.redirect.msg'/>"
			data-error-message="<spring:theme code='single.signon.error.msg'/>"
		></div>
		<a id="skiptonavigation"></a>
		<nav:topNavigation />
		<components:wishlistAlert />
		<components:productDeletedAlert />
		<%-- TODO review if we need this handling, as approach changed and we are reloading the page for all the updates in minibasket--%>
		<div class="global-alerts js-miniCartGlobalMessagesHolder"></div>
</header>

<div class="non-sticky-content js-nonStickyContent">
	<%-- Benefits Bar --%>
	<nav:benefitsBar />

	<%-- Payment Banner Bar --%>
	<c:if test="${isLoggedIn}">
		<nav:paymentBanner/>
	</c:if>

	<cms:pageSlot position="BottomHeaderSlot" var="component" element="div"	class="container">
		<c:choose>
			<c:when test="${page.uid eq 'searchGrid' || page.uid eq 'searchEmpty'}">
				<c:if test="${component.uid ne 'breadcrumbComponent' }">
					<cms:component component="${component}" />
				</c:if>
			</c:when>
			<c:otherwise>
				<cms:component component="${component}" />
			</c:otherwise>
		</c:choose>
	</cms:pageSlot>
</div>