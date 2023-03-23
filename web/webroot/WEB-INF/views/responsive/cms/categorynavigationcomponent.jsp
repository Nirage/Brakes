<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>

<c:set var="categoriesThreshold" value="13"/>
<c:if test="${themeName eq 'countrychoice'}">
	<c:set var="categoriesThreshold" value="13"/>
	<c:set var="isCountryChoice" value="countryChoice"/>
</c:if>
<sec:authorize access="!hasRole('ROLE_ANONYMOUS')">
	<c:set var="isUserLoggedIn" value="true"/>
</sec:authorize>


<c:if test="${component.visible}">
	<nav class="navigation navigation--bottom js_navigation--bottom js-enquire-offcanvas-navigation" role="navigation">
		<div class="container-xl">
			<div id="jsMainNavigation" class="navigation__overflow main-nav js-mainNavigation">
				<span class="main-nav__control main-nav__control--prev js-mainNavLeft"><span class="icon icon--sm icon-chevron-left main-nav__control-icon"></span></span>
				<span class="main-nav__control main-nav__control--next js-mainNavRight"><span class="icon icon--sm icon-chevron-right main-nav__control-icon"></span></span>
				<div class="main-nav__categories-wrapper js-mainNavCategoriesWrapper">
					<div class="visible-xs links-list links-list--mobile-nav">
						<div class="links-list__item">
							<a class="js-toggleMobileSub" data-target-id="main-nav"><spring:theme code="mobile.nav.products" /></a>
						</div>
					</div>
					<ul class="nav__links nav__links--products main-nav__categories js-offcanvas-links js-mainNavCategories js-destMobileSub" data-destination-id="main-nav">
						<c:set var="categoriesCount" value="0" />
						<c:forEach items="${component.navigationNode.children}" var="childLevel1"  varStatus="mainCat"> 
					
							<c:if test="${not empty childLevel1.title and childLevel1.visible}">
								<c:set var="categoriesCount" value="${categoriesCount + 1}" />	
								<li class="${mainCat.index >= categoriesThreshold ? 'nav__links--more-category js-more-category' : 'nav__links--category'} auto nav__links--primary ga-megamenu-1 <c:if test="${isCountryChoice eq 'countryChoice'}">nav__links--primarywide </c:if><c:if test="${not empty childLevel1.children}">nav__links--primary-has__sub js-enquire-has-sub</c:if> ">
									<c:choose>
										<c:when test="${not empty childLevel1.entries}">	
											<c:forEach items="${childLevel1.entries}" var="childlink1">
												<cms:component component="${childlink1.item}" evaluateRestriction="true" element="span" class="nav__link js_nav__link" />
											</c:forEach>
										</c:when>
										<c:otherwise>
											<c:if test="${not empty childLevel1.title}">
												<%-- data-title is used in css for solving issue with the menu items shifting when turned to bold on hover --%>
												<span class="${not empty childLevel1.children ? 'nav__link js_nav__link' : ''}">
													<c:choose>
														<c:when test="${childLevel1.uid == 'PromotionsNavNode'}">
															<cms:component component="${childLevel1.catHomePagelink}" evaluateRestriction="true" element="span"/>
														</c:when>
														<c:otherwise>  
															<a href="${ycommerce:renderHref(childLevel1.catHomePagelink)}" data-title="${childLevel1.title}">${childLevel1.title}</a>
														</c:otherwise>  
													</c:choose>		
												</span>	
											</c:if>
										</c:otherwise>
									</c:choose>
									
									<span class="icon icon--sm icon-chevron-right visible-xs hidden-lg nav__link--drill__down"></span>

									<%-- Calculate how many sub columns are needed -- Start --%>
									<c:set var="totalSubNavigationColumns" value="${0}"/>
									<c:set var="hasSubChild" value="false"/>
									<c:forEach items="${childLevel1.children}" var="childLevel2"> 
										<c:if test="${not empty childLevel2.children}">
											<c:set var="hasSubChild" value="true"/>
											<c:set var="subSectionColumns" value="${fn:length(childLevel2.children)/component.wrapAfter}"/>
											<c:if test="${subSectionColumns > 1 && fn:length(childLevel2.children)%component.wrapAfter > 0}">
												<c:set var="subSectionColumns" value="${subSectionColumns + 1}"/>
											</c:if>
											<c:choose>
												<c:when test="${subSectionColumns > 1}">
													<c:set var="totalSubNavigationColumns" value="${totalSubNavigationColumns + subSectionColumns}" />
												</c:when>
						
												<c:when test="${subSectionColumns < 1}">
													<c:set var="totalSubNavigationColumns" value="${totalSubNavigationColumns + 1}" />
												</c:when>
											</c:choose>
										</c:if>
									</c:forEach>
									<%-- Calculate how many sub columns are needed -- End --%>
									<c:set value="col-md-12" var="subNavigationClass"/>
									<c:if test="${not empty childLevel1.children}">								
										<div class="sub__navigation js_sub__navigation ${subNavigationClass} col-sm-12">
											<div class="sub__navigation-overflow">
												<button class="btn btn-nav-back js-enquire-sub-close hidden-sm hidden-md hidden-lg col-xs-12 sub__navigation-back-btn">
													<div class="btn-nav-back__inner">
														<span class="icon icon--sm icon-chevron-left"></span>
														<span><spring:theme code="mobile.nav.back.btn" /></span>
													</div>
												</button>

												<c:choose>
													<c:when test="${not empty childLevel1.featuredBrands}" >
														<c:set var="subNavWrapperColumnsClass" value="col-md-10" />
													</c:when>
													<c:otherwise>
														<c:set var="subNavWrapperColumnsClass" value="col-md-12" />
													</c:otherwise>
												</c:choose>

												<div class="row">
													<div class="container-xl">
														<div class="sub-navigation__wrapper">
															<%-- Begin View all link--%>
															<c:if test="${not empty childLevel1.catHomePagelink}" >
																<div class="sub-navigation__view-all ga-megamenu-2">
																	<cms:component component="${childLevel1.catHomePagelink}" evaluateRestriction="true" />
																	<span class="icon icon--sm icon-chevron-right hidden-xs"></span>
																</div>
															</c:if>
															<%-- End View all link--%>
															<div class="${subNavWrapperColumnsClass} h-space-2">
																<c:choose>
																	<c:when test="${hasSubChild}">
																		<div class="sub-navigation__columns">
																			<c:forEach items="${childLevel1.children}" var="childLevel2" varStatus="loop">
																				<c:if test="${childLevel2.visible}">
																					<div class="sub-navigation-section <c:if test="${not empty childLevel2.children}"> js-level1HasSub</c:if>">
																						<c:choose>
																							<c:when test="${not empty childLevel2.entries}">
																								<c:forEach items="${childLevel2.entries}" var="Level2entry" >
																									<cms:component component="${Level2entry.item}" evaluateRestriction="true" element="div" class="title js-navLinkLevel2 ga-megamenu-2" />
																								</c:forEach>
																							</c:when>
																							<c:otherwise>
																								<c:if test="${not empty childLevel2.title}">
																									<cms:component component="${childLevel2.catHomePagelink}" evaluateRestriction="true" element="div" class="title js-navLinkLevel2 ga-megamenu-2" />
																								</c:if>
																							</c:otherwise>
																						</c:choose>
																						<span class="icon icon--sm icon-chevron-right visible-xs nav__link--drill__down"></span>
																						<div class="sub__navigation-level2 js_sub__navigation">
																							<div class="sub__navigation-overflow">
																								<ul class="sub-navigation-list <c:if test="${not empty childLevel2.title}">has-title</c:if>">
																									<%-- Added links for Back to/view all --%>
																									<c:if test="${not empty childLevel1.title}">
																										<button class="btn btn-nav-back js-subLevel2Close hidden-sm hidden-md hidden-lg col-xs-12 sub__navigation-back-btn">
																											<div class="btn-nav-back__inner">
																												<span class="icon icon--sm icon-chevron-left"></span>
																												<span><spring:theme code="mobile.nav.back.to.all" arguments="${childLevel1.title}"/></span>	
																											</div>
																										</button>
																									</c:if>
																									<c:if test="${not empty childLevel2.title}">
																										<div class="title hidden-sm hidden-md hidden-lg"><a href="${childLevel2.catHomePagelink.url}"><spring:theme code="mobile.nav.view.all" arguments="${childLevel2.title}"/></a></div>
																									</c:if>
																									
																									<c:forEach items="${childLevel2.children}" var="childLevel3" step="${component.wrapAfter}" varStatus="i">
																										<%-- wrap if more than 'component.wrapAfter' rows in one sub column --%>
																										<c:if test="${i.index>=component.wrapAfter}"> 
																											<c:if test="${!i.first}">
																													</ul>
																												</div>
																											</c:if>
																											<div class="sub-navigation-section">
																												<ul class="sub-navigation-list <c:if test="${not empty childLevel2.title}">has-title</c:if>">
																										</c:if>
																										<c:forEach items="${childLevel2.children}" var="childLevel3" begin="${i.index}" end="${i.index + component.wrapAfter - 1}">
																											<c:if test= "${childLevel3.visible}">
																												<c:forEach items="${childLevel3.entries}" var="childlink3" >
																													<%-- <c:if test="${childlink3.item.type eq 'Simple Banner Component'}"> --%>
																													<div class="sub-navigation-list__item">
																														<span class="icon icon--sm icon-chevron-right visible-xs hidden-lg nav__link--drill__down">
																														</span>
																														<cms:component component="${childlink3.item}" evaluateRestriction="true" element="li" class="nav__link--secondary ga-megamenu-3" />
																													</div>
																												</c:forEach>
																											</c:if>
																										</c:forEach>
																									</c:forEach>
																								</ul>
																							</div>
																						</div>
																					</div>
																				</c:if>
																			</c:forEach>
																		</div>
																	</c:when>    
																	<c:otherwise>
																		<div class="sub-navigation-section">
																			<ul class="sub-navigation-list <c:if test="${not empty childLevel2.title}">has-title</c:if>">
																				<c:forEach items="${childLevel1.children}" var="childLevel2"> 
																					<c:forEach items="${childLevel2.entries}" var="childlink2">
																						<cms:component component="${childlink2.item}" evaluateRestriction="true" element="li" class="nav__link--secondary" />
																					</c:forEach>
																				</c:forEach>
																			</ul>
																		</div>	
																	</c:otherwise>
																</c:choose>
															</div>
															<%-- Begin featuredBrands--%>
															<c:if test="${not empty childLevel1.featuredBrands}" >
																<div class="col-md-2 hidden-xs hidden-sm">
																	<div class="sub-navigation-section featured-brands">
																		<div class="title">
																			<span class="title__text"><spring:theme code="nav.featured.brands" /></span>
																		</div>
																		<c:forEach items="${childLevel1.featuredBrands}" var="featuredBrand"> 
																				<cms:component component="${featuredBrand}" evaluateRestriction="true" />
																		</c:forEach>
																	</div>
																</div>
															</c:if>
															<%-- End featuredBrands--%>
															<c:if test="${not empty childLevel1.leaderboard}" >
																<div class="hidden-xs hidden-sm">
																	<cms:component component="${childLevel1.leaderboard}" evaluateRestriction="true"/>
																</div>
															</c:if>
														</div>
													</div>
												</div>
											</div>
										</div>
									</c:if>
								</li>
							</c:if>
						</c:forEach>
					
						
					</ul>
				</div>

				<ul class="visible-xs js-aboutLinksDest links-list links-list--mobile-nav about-nav about-nav--mobile">
					<%-- Dynamically populated using JS --%>
				</ul>
			</div>
		</div>
	</nav>
</c:if>