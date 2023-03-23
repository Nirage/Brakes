<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>

<sec:authorize access="!hasRole('ROLE_ANONYMOUS')">
	<c:set var="isUserLoggedIn" value="true"/>
</sec:authorize>

<c:set var="showPromotion">
	<promotions:showPromotion product="${product}" isLoggedIn="${isUserLoggedIn}"/>
</c:set>
<input type="hidden" value="${product.nettPrices}" class="js-netPrice"/>

<c:if test="${not empty product.classifications}">
	<c:forEach items="${product.classifications}" var="classification" varStatus="counter">
		<c:set var="itemOrder" value="even" />
		<c:if test="${counter.count % 2 != 0}"> 
			<c:set var="itemOrder" value="odd" />
		</c:if>
		<c:if test="${classification.code eq 'ingredientsAndAllergens'}"> 
			<c:set var="itemOrder" value="even" />
		</c:if>
		<c:if test="${classification.code eq 'nutrition'}"> 
			<c:set var="itemOrder" value="odd" />
		</c:if>
		<c:if test="${classification.shownInPDPAccordion}" >
			<product:productClassificationAccordion saleableUnitsHeight="${product.saleableUnitsHeight}" saleableUnitsLength="${product.saleableUnitsLength}" saleableUnitsWidth="${product.saleableUnitsWidth}" classification="${classification}" itemIndex="${counter.count}" itemOrder="${itemOrder}"/>
		</c:if>
	</c:forEach>
</c:if>

<product:accordionHealthSafetyDoc product="${product}" itemOrder="odd"/>	
<product:accordionEmailProductDetails itemOrder="even"/>	
<product:accordionProductDisclaimer itemOrder="odd"/>
<c:if test="${isUserLoggedIn ne 'true'}">
	<product:accordionTradeCalculator itemOrder="odd"/>	
</c:if>

<product:accordionPromotionalDisclaimer itemOrder="even" showPromotionClass="${showPromotion ? '' : 'hidden'} js-productPromoTab" productCode="${product.code}" />

<div class="col-xs-12 col-sm-6">
	<div class="accordion-group js-accordionColumn" data-column="left" id="accordion1" role="tablist">

		<%-- Other accordions will be prepended using JS --%>
	</div>
</div>

<div class="col-xs-12 col-sm-6">
	<div class="accordion-group js-accordionColumn" data-column="right" id="accordion2" role="tablist">

		<%-- Other accordions will be prepended using JS --%>
	</div>
</div>

