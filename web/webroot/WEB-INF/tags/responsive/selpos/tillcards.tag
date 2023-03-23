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
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>


<spring:htmlEscape defaultHtmlEscape="false" />
<selpos:formTemplate>
	<jsp:body>
		<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
			<div class="col-sm-12 col-xs-12 h-topspace-2 h-space-3 order-sel__sectionHeading order-sel__para order-sel__bordered">
				<div class="order-sel__title h-space-2"><spring:theme code="orderSELsAndPOS.tillcards.section1" /></div>
				<div class="col-sm-6 col-xs-12 order-sel__no-pad">
					<div class="custom-txtbox">
						<div class="site-form__formgroup form-group">			
							<label class="order-sel__sectionHeading--label h-space-2"><spring:theme code="orderSELsAndPOS.tillcards.section1.option" /></label>
							<div class="control site-form__dropdown ">
								<select name="option.values[0]">
									<option value=""><spring:theme code="orderSELsAndPOS.input.option.select" /></option>
									<c:forEach items="${pageData.option.values}" var="option" varStatus="loopStatus">
										<option value="${option}"><spring:theme code="orderSELsAndPOS.option.${option}" /></option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
				</div>				
			</div>
			<div class="col-sm-12 col-xs-12">
				<div class="order-sel__title h-space-3"><spring:theme code="orderSELsAndPOS.tillcards.section2" /></div>
				<div class="js-add-row-sectionParent">
					<c:forEach begin="0" end="12" step="2" varStatus="loopStatus">
						<div class="h-space-3 order-sel__sectionHeading order-sel__bordered order-sel__para js-addRowEntries">
							<input type="hidden" class="js-loopStatus" value="7"/>
							<div class="row">
								<div class="col-xs-12 col-sm-5 order-sel__gap js-posFieldSection">
									<formElement:formInputBox
												idKey="products[${loopStatus.index}].code"
												labelKey="orderSELsAndPOS.input.productcode"
												labelCSS="order-sel__sectionHeading--label h-space-1"
												path="products[${loopStatus.index}].code"
												errorKey="productCode"
												inputCSS="form-control site-form__input order-sel__input js-posField js-rowEntryProductCode"
												mandatory="false"
												showAsterisk="false"
												placeholderKey="orderSELAndPOS.productcode"
									/>
									<form:input path="products[${loopStatus.index}].selected" id="products[${loopStatus.index}].selected" value="false" type="hidden" class="js-posFieldSelected js-rowEntryProductCodeSelected"/>
								</div>
								<div class="col-xs-12 col-sm-5 js-posFieldSection">
									<formElement:formInputBox
												idKey="products[${loopStatus.index+1}].code"
												labelKey="orderSELsAndPOS.input.productcode"
												labelCSS="order-sel__sectionHeading--label h-space-1"
												path="products[${loopStatus.index+1}].code"
												errorKey="productCode"
												inputCSS="form-control site-form__input order-sel__input js-posField js-rowEntryProductCode1"
												mandatory="false"
												showAsterisk="false"
												placeholderKey="orderSELAndPOS.productcode"
									/>
								<form:input path="products[${loopStatus.index+1}].selected" id="products[${loopStatus.index+1}].selected" class="js-posFieldSelected js-rowEntryProductCodeSelected1" value="false" type="hidden" />

								</div>
							</div>
						</div>					
			 		</c:forEach>
					<div id="js-add-row-sectionParent"></div>

				</div>
			</div>
			<div class="h-space-3 order-sel__para order-sel__bordered clearfix">
				<div class="col-xs-12">
					<button type="button" class="btn btn-secondary order-sel__submitbtn js-add-till-card-button"><spring:theme code="orderSELsAndPOS.tillcards.addmenu" /></button>
				</div>
			</div>		
		<selpos:deliveryDetails/>
		<selpos:tillcardHandlebarTemplate/>

		</sec:authorize>
	</jsp:body>
</selpos:formTemplate>


