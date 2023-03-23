<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="categories" required="true" type="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<spring:htmlEscape defaultHtmlEscape="false" />

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >

	<c:forEach items="${categories}" var="category">
		<spring:url value="/my-country-choice/order-sels-and-pos" var="categoryUrl" htmlEscape="false">
			<spring:param name="categoryCode"  value="${category.code}"/>
		</spring:url>
			
		<a href="${categoryUrl}">
			<div class="col-sm-12 col-md-4 h-topspace-2">
				<div class="order-sel__box h-space-2">
					<div class="row">
						<div class="col-xs-12 pull-right order-sel__img--wrapper">
							<spring:url value="https://i1.adis.ws/i/Brakes/${category.code}.jpg" var="categoryImageUrl" htmlEscape="true"/>
							<c:set var="altTextHtml" value="${fn:escapeXml(category.image.altText)}" />

							<picture class="oreder-sel__picture">
								<source data-size="desktop" srcset="${categoryImageUrl}$plp-desktop$" media="(min-width: 1240px)">
								<source data-size="tablet" srcset="${categoryImageUrl}$plp-tablet$" media="(min-width: 768px)">
								<source data-size="mobile" srcset="${categoryImageUrl}$plp-mobile$">
								<img class="order-sel__img js-fallbackImage" src="${categoryImageUrl}$plp-desktop$" alt="${altTextHtml}" title="${altTextHtml}">
							</picture>

						</div>
						<div class="col-xs-12">
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


</sec:authorize>


