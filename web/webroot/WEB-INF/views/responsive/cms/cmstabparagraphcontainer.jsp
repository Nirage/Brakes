<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<div class="product-details__accordions js-productDetailsAccordions hide">
	<div class="container">
		<div class="row">
			<product:productDetailsClassifications product="${product}" />
		</div>
		<c:if test="${product.subjectToVAT}">
			<div class="row">
				<div class="vat__text-box h-space-1">
					<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
					<spring:theme code="product.vat.applicable"/>
				</div>
			</div>
		</c:if>
	</div>
</div>

