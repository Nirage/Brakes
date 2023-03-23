<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>

<div class="site-header site-header--align-left">
	<h1 class="site-header__text site-header--align-left">${cmsPage.title}</h1>
	<span class="site-header__rectangle site-header__rectangle--align-left"></span>
	<c:choose>
		<c:when test="${cmsPage.title eq 'Order SELs and POS'}">
			<p class="site-header__subtext order-sel__bordered order-sel__para"><spring:theme code="orderSELsAndPOS.description" /></p>
		</c:when>
		<c:otherwise>
				<p class="site-header__subtext order-sel__para"><spring:theme code="orderSELsAndPOS.description" /></p>
		</c:otherwise>
	</c:choose>
	<div class="row">
		<c:forEach items="${pageData.subCategories}" var="category">
			<spring:url value="/my-country-choice/order-sels-and-pos" var="categoryUrl" htmlEscape="false">
				<spring:param name="categoryCode"  value="${category.code}"/>
			</spring:url>

			<a href="${categoryUrl}">
				<div class="col-xs-12">
					<div class="order-sel__box h-space-3">
						<div class="row">
							<div class="col-xs-12 col-md-6 pull-right">
								<spring:url value="https://i1.adis.ws/i/Brakes/${category.code}.jpg" var="categoryImageUrl" htmlEscape="true"/>
								<c:set var="altTextHtml" value="${fn:escapeXml(category.image.altText)}" />
								
								<picture class="oreder-sel__picture">
									<source data-size="desktop" srcset="${categoryImageUrl}$plp-desktop$" media="(min-width: 1240px)">
									<source data-size="tablet" srcset="${categoryImageUrl}$plp-tablet$" media="(min-width: 768px)">
									<source data-size="mobile" srcset="${categoryImageUrl}$plp-mobile$">
									<img class="order-sel__img js-fallbackImage" src="${categoryImageUrl}" alt="${altTextHtml}" title="${altTextHtml}">
								</picture>

							</div>
							<div class="col-xs-12 col-md-6">
								<div class="order-sel__text">
									<div class="order-sel__heading">${category.title}</div>
									<span class="site-header__rectangle site-header__rectangle--align-left"></span>
									<div class="order-sel__subHeading">${category.description}</div>
								</div>
							</div>							
						</div>
					</div>
				</div>
			</a>
		</c:forEach>
	</div>
</div>


