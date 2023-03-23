<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="currentPosition" required="true" type="java.lang.Integer" %>
<%@ attribute name="type" required="true" type="java.lang.String" %>
<%@ attribute name="breadcrumbs" required="true" type="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="selpos" tagdir="/WEB-INF/tags/responsive/selpos"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>

<c:choose>
	<c:when test="${type eq 'SEL'}">
		<c:set var="lastStep" value="3"/>
	</c:when>
	<c:otherwise>
		<c:set var="lastStep" value="2"/>
	</c:otherwise>
</c:choose>
<c:set var="categoryCodesLength" value="${fn:length(pageData.categoryCodes)}"/>

<div class=" h-space-3">
	<div class="order-sel__progressSection h-space-2">
		<div class="row m-0">
			<c:forEach var = "i" begin = "1" end = "${lastStep}">
				<c:choose>
					<c:when test="${currentPosition eq i}">
						<c:set var="completedStepTitle" value="__selected"></c:set>
					</c:when>
					<c:otherwise>
						<c:set var="completedStepTitle" value=""></c:set>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${type eq 'SEL'}">
						<div class="col-xs-4 order-sel__progress-bar--step${completedStepTitle}">
							<spring:theme code="orderSELsAndPOS.step" arguments="${i}"/>
						</div>
					</c:when>
					<c:otherwise>
						<div class="col-xs-6  order-sel__progress-bar--step${completedStepTitle}"><spring:theme code="orderSELsAndPOS.step" arguments="${i}"/></div>
					</c:otherwise>
				</c:choose>

			</c:forEach>
		</div>
	</div>
	<div class="progress order-sel__progress">
		<c:set var="completedStep"><fmt:formatNumber value="${currentPosition-1}"/></c:set>
		<c:choose>
			<c:when test="${type eq 'SEL'}">
			<div class="progress-bar order-sel__progress-bar order-sel__progress-bar--completed${completedStep}" role="progressbar" >
				</div>
				<div class="progress-bar order-sel__progress-bar order-sel__progress-bar--${currentPosition}" role="progressbar" >
				</div>

			</c:when>
			<c:otherwise>
				<div class="progress-bar order-sel__progress-bar order-sel__progress-bar--selcompleted${completedStep}" role="progressbar" >
				</div>
				<div class="progress-bar order-sel__progress-bar order-sel__progress-bar--sel${currentPosition}" role="progressbar" >
				</div>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="order-sel__progressSection">
		<c:set var="lastBreadcrumbTitle"><spring:theme code="orderSELsAndPOSSubmit.breadcrumb.lastStep" /></c:set>
		<c:forEach var = "i" begin="0" end = "${lastStep - 2}" varStatus="loopStatus" >
			<div class="${type eq 'SEL' ? 'col-xs-4 h-space-2' : 'col-xs-6 h-space-2'}">
				<c:if test="${not empty breadcrumbs[i]}"><a class="order-sel__progressSection__link ${i eq currentPosition-2 ? 'is-disabled' : ''}" href="<spring:url value="/my-country-choice/order-sels-and-pos?categoryCode=${breadcrumbs[i].code}" htmlEscape="false"/>" ></c:if>
						${not empty breadcrumbs[i] ? breadcrumbs[i].title : (loopStatus.count >= lastStep && currentPosition >= lastStep ? lastBreadcrumbTitle : '...' ) }
				<c:if test="${not empty breadcrumbs[i]}"></a></c:if>
			</div>
		</c:forEach>
		<c:if test="${categoryCodesLength eq 0}">
			<div class="${type eq 'SEL' ? 'col-xs-4 h-space-2' : 'col-xs-6 h-space-2'}">
				<c:choose>
				<c:when test="${currentPosition gt 1}">
					<span class="order-sel__progressSection__link is-disabled">${lastBreadcrumbTitle}</span>
				</c:when>
				<c:otherwise>...</c:otherwise>
				</c:choose>
			</div>
		</c:if>
		<c:if test="${categoryCodesLength > 0}">
			<c:if test="${categoryCodesLength lt lastStep - 1 || categoryCodesLength eq lastStep - 1}">
				<div class="${type eq 'SEL' ? 'col-xs-4 h-space-2' : 'col-xs-6 h-space-2'}">
					...
				</div> 
			</c:if>
		</c:if>
	</div>
</div>