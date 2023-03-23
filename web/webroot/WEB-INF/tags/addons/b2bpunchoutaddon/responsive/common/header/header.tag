<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav"%>

<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="hideHeaderLinks" required="false"%>
<%@ attribute name="hideTopNav" required="false"%>
<%@ attribute name="hideMainNav" required="false"%>

<c:url value="/cxml/requisition" context="${originalContextPath}/punchout" var="requisitionUrl"/>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set value="nav__left js-site-logo" var="logoClass"></c:set>
<c:if test="${isInspectOperation}">
	<c:set value="nav__left js-site-logo inspect-logo" var="logoClass"></c:set>
</c:if>

<cms:pageSlot position="TopHeaderSlot" var="component" element="div" class="container">
	<cms:component component="${component}" />
</cms:pageSlot>

<header class="js-mainHeader">
	<%-- Top Nav --%>
	<c:if test="${empty hideTopNav}">
	<nav class="navigation navigation--top js-navigationTop ${siteUid}-nav">
		<div class="container">
			<div class="row">
				<div class="col-sm-2 nav-links-wrapper__left p-0">
					<span class="js-moreAboutLinks visible-sm links-list-trigger">
						<spring:theme code="topNav.moreTablet.btn"/>
					</span>

					<ul class="links-list js-aboutLinks">
						<cms:pageSlot position="HeaderLinks" var="headerNavComponent">
								<c:forEach items="${headerNavComponent.navigationNode.children}" var="topLevelLinks">
									<c:forEach items="${topLevelLinks.entries}" var="entry">
										<c:set value="${ycommerce:componentVisible(entry.item.uid)}" var="componentVisible"/>
										<c:forEach items="${entry.item.restrictions}" var="restriction">
                                             <c:set value="false" var="componentVisible"/>
                                       </c:forEach>
										<c:if test="${componentVisible}">
											<li class="links-list__item ga-topnav-1 <c:if test="${fn:length(topLevelLinks.children) > 0 }"> js-linksItemDrillDown has-subnav</c:if>">
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

				<div class="col-xs-12 col-sm-10 nav-links-wrapper__right p-0">
					<div class="nav__right text-right">
						<c:if test="${!isb2cSite}">
							<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')" >
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
		</div>
	</nav>
	</c:if>

	<%--   Punchout Blue Strip   --%>
	<cms:component uid="BrakesPunchoutHeaderJSPComponent" />

	<%-- Nav Middle Section --%>
	<c:if test="${not isInspectOperation and empty hideMainNav}">
		<nav class="navigation navigation--middle js-navigation--middle b0">
			<div class="container">
				<div class="row">
					<div class="mobile-nav">
                    <div class="mobile-nav-column mobile-nav-column--left">
                        <div class="mobile-nav__item js-mobile-nav__item mobile-nav__burger-menu">
                            <button class="btn mobile__nav__row--btn-menu js-toggle-sm-navigation js-menu ga-mobile-nav-1" type="button">
                                <i class="icon icon-menu"></i>
                                <p class="mobile-nav__burger-menu-text"><spring:theme code="mobile.nav.menu" /></p>
                            </button>
                        </div>
                        <c:if test="${not empty isCheckoutPage}">
                            <li class="nav__links-item">
                                <a href="/" class="btn btn-secondary hidden-sm hidden-xs"><spring:theme code="checkout.backtohomepage" /></a>
                            </li>
                        </c:if>
                    </div>
                    <div class="mobile-nav-column">
                        <div class="mobile-nav__logo mobile-nav__item js-mobile-nav__item hidden-md hidden-lg">
                            <cms:pageSlot position="SiteLogo" var="logo" limit="1">
                                <cms:component component="${logo}" element="div" class="yComponentWrapper mobile-logo ga-mobile-nav-3"/>
                            </cms:pageSlot>
                        </div>
                    </div>
                    <div class="mobile-nav-column mobile-nav-column--right">
                        <c:if test="${isb2cSite}">
                            <c:choose>
                                <c:when test="${isLoggedIn}">
                                    <c:choose>
                                        <c:when test="${hasFavourites}">	
                                            <div class="mobile-nav__favourites is-mobile hidden-md hidden-lg ${hasFavourites ? ' js-favouritesNav ' : '' }"
                                            >
                                                <c:url value="/my-account/favourites" var="favouritesUrl"/>
                                                <spring:url value="/favourites/rollover/{/componentUid}" var="rolloverPopupUrl" htmlEscape="false">
                                                    <spring:param name="componentUid"  value="${component.uid}"/>
                                                </spring:url>
                                                <a tabindex="0" href="${favouritesUrl}" data-mini-favourites-url="${rolloverPopupUrl}" class="btn mobile-nav__item js-mobile-nav__item js-favouritesLink">
                                                    <i class="icon icon-Heart"></i>
                                                </a>
                                                <div class="mini-favourites js-favouritesContainer hide">
                                                    <div id="jsMobileMiniFavourites"></div>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <a tabindex="0" href="${favouritesUrl}" class="mobile-nav__favourites mobile-nav__item js-mobile-nav__item">
                                                <i class="icon icon-Heart"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <a href="${favouritesUrl}" class="ga-mobile-nav-4 mobile-nav__favourites mobile-nav__item js-mobile-nav__item">
                                        <i class="icon icon-Heart"></i>
                                        <div class="mini-favourites js-favouritesContainer hide "></div>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <cms:pageSlot position="MiniCart" var="cart" element="div" class="miniCartSlot componentContainer mobile-nav__cart mobile-nav__item js-mobile-nav__item">
                            <cms:component component="${cart}" />
                        </cms:pageSlot>
                    </div>
                </div>
				</div>
				<div class="row desktop__nav">
					<div class="col-xs-12 col-sm-2">
						<div class="js-site-logo site-logo hidden-xs">
							<cms:pageSlot position="SiteLogo" var="logo" limit="1">
								<cms:component component="${logo}" element="div" class="yComponentWrapper ga-nav-bar-1"/>
							</cms:pageSlot>
						</div>
					</div>
					<div class="col-xs-12 col-sm-5">
						<div class="site-search">
							<cms:pageSlot position="SearchBox" var="component">
								<cms:component component="${component}" element="div"/>
							</cms:pageSlot>
						</div>
					</div>
					<div class="nav__right col-xs-6 col-sm-5 hidden-xs text-right">
						<ul class="nav__links nav__links--shop_info">
							<li>
								<cms:pageSlot position="MiniCart" var="cart">
									<cms:component component="${cart}"/>
								</cms:pageSlot>
							</li>
							<li class="nav__links-item">
							  <c:choose>
							           <c:when test="${cmsPage.uid eq 'cartPage' && totalItems gt 0}">
                                          <a tabindex="0" href="${requisitionUrl}" class="js-btnCheckoutHeader btn btn-primary text-white hidden-sm hidden-xs btn-checkout-header ga-nav">
                                            <spring:theme code="punchout.custom.return.text" />
                                          </a>
                                      </c:when>
                                      <c:otherwise>
                                         <a tabindex="0" href="/cart" class="js-btnCheckoutHeader btn btn-primary text-white hidden-sm hidden-xs btn-checkout-header ga-nav">
                                             <spring:theme code="punchout.checkout.checkout" />
                                          </a>
                                      </c:otherwise>
                               </c:choose>
							</li>
						</ul>
					</div>
				</div>
	        </div>
		</nav>
		<a id="skiptonavigation"></a>
		<nav:topNavigation />
	</c:if>
</header>


<cms:pageSlot position="BottomHeaderSlot" var="component" element="div"	class="container">
	<cms:component component="${component}" />
</cms:pageSlot>
