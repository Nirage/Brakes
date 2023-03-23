<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="pageData" required="true" type="com.envoydigital.brakes.facades.orderPosSel.data.POSandSELPageData" %>
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


<spring:htmlEscape defaultHtmlEscape="false" />

<selpos:formTemplate>

	<jsp:body>
		<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
		<div class="h-topspace-2 h-space-3 order-sel__sectionHeading order-sel__para order-sel__bordered js-add-row-sectionParent js-multiSectionEntry ">
			<div class="row  h-space-2 js-addRowEntries">
			<div class="col-xs-12">
				<div class="col-xs-12 col-sm-4 js-posFieldSection">
					<input class="js-loopStatus" type="hidden" value="1">
					<formElement:formInputBox
								idKey="products[0].code"
								labelKey="PRODUCT CODE"
								labelCSS="order-sel__sectionHeading--label h-space-1"
								path="products[0].code"
								errorKey="firstName"
								inputCSS="form-control site-form__input order-sel__input js-productCodeMulti js-rowEntryProductCode"
								mandatory="false"
								showAsterisk="false"
								placeholderKey="orderSELAndPOS.productcode"
					/>
				</div>
			<div class="col-xs-12 col-sm-4">
				<div class="custom-txtbox">
					<div class="site-form__formgroup form-group"	>			
						<label class="order-sel__sectionHeading--label h-space-1"><spring:theme code="orderSELsAndPOS.input.singleMultiPrice" /></label>
						<div class="control site-form__dropdown ">
							<select name="products[0].multiPrice" class="form-control site-form__select js-multiPrice js-rowEntryMultiPrice">
									<option value=""><spring:theme code="orderSELsAndPOS.input.option.select" /></option>
									<c:forEach items="${pageData.option.values}" var="option" varStatus="loopStatus">
										<option value="${option}" ${option == products[0].multiPrice ? 'selected="selected"' : ''}><spring:theme code="orderSELsAndPOS.option.${option}" /></option>
									</c:forEach>
							</select>	
						</div>
					</div>
				</div>
			</div>

			<div class="col-xs-12 col-sm-4 js-posFieldSection">
				<formElement:formInputBox
								idKey="products[0].singlePrice"
								labelKey="RRP"
								labelCSS="order-sel__sectionHeading--label h-space-1"
								path="products[0].singlePrice"
								inputCSS="form-control site-form__input order-sel__input js-formField js-SinglePrice js-singlePriceSelected js-rowEntryRrp"
								mandatory="false"
								showAsterisk="false"
								placeholderKey="orderSELAndPOS.rrp"

								/>
			</div>
		</div>
		<input name="products[0].selected" value="false"   class="js-posFieldSelectedMulti js-rowEntrySelected" type="hidden" />

	</div>
		</div>	

	<div id="js-add-row-sectionParent"></div>
	
	<div class="col-xs-12">
		<div class="row h-space-3 order-sel__para order-sel__bordered">
			<div class="col-xs-12">
				<button type="button" class="btn btn-secondary js-add-row-button"><spring:theme code="orderSELsAndPOS.multibuy.addrow" /></button>
			</div>
		</div>
	</div>	
	
	<selpos:deliveryDetails/>
	<selpos:multibuyHandlebarTemplate/>


	</sec:authorize>
</jsp:body>

</selpos:formTemplate>

