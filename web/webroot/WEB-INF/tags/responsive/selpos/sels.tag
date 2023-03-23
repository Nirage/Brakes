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
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="selpos" tagdir="/WEB-INF/tags/responsive/selpos"%>


<spring:htmlEscape defaultHtmlEscape="false" />


<selpos:formTemplate>

	<jsp:body>
		<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >

		<div class="col-xs-12">
			<selpos:checkboxOptionList option="${pageData.option}"/>
			<selpos:quickAdd categoryCode="${pageData.currentCategory.code}"/>
			<div class="h-space-3 order-sel__sectionHeading">
				<div class="row hidden visible-md visible-lg h-space-2 h-space-2">
					<div class="col-md-1 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.code" /></div>
					<div class="col-md-4 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.name" /></div>
					<div class="col-md-3 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.multiprice" /></div>
					<div class="col-md-3 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.singleprice" /></div>
					<div class="col-md-1 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.select" /></div>
				</div>
				<div class="js-orderSelEnriesSection">
				<c:forEach items="${pageData.preProducts}" var="product" varStatus="loopStatus">
					<div class="row js-orderSelEnries order-sel__border--xs">	
						<input type="hidden" class="js-selPosIndex" id="productSELsAndPOS[${loopStatus.index}]" name="products[${loopStatus.index}].code" value="${product.code}"/>	
						<div class="order-sel__sectionHeading hidden visible-sm visible-xs">
								<div class="col-xs-6 h-space-1 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.code" /></div>
								<div class="col-xs-6 h-space-1 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.name" /></div>
						</div>
						<div class="order-sel__entries">
							<div class="col-md-1 col-xs-6 js-orderSelEntryProductCode">${product.code}</div>
							<div class="col-md-4 col-xs-6 js-orderSelEntryProductName"><div class="order-sel__entries--text">${product.name}</div></div>
							<div class="order-sel__sectionHeading visible-sm visible-xs h-space-2">
									<div class="col-xs-6 h-space-1 h-topspace-1 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.multiprice" /></div>
									<div class="col-xs-6 h-space-1 h-topspace-1 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.singleprice" /></div>
							</div>			
							<div class="col-md-3 col-xs-6"><input type="input" class="form-control site-form__input order-sel__input js-orderSelEntryMultiPrice" name="products[${loopStatus.index}].multiPrice" placeholder="<spring:theme code="orderSELsAndPOS.sels.placeholder.multiPrice" />"></div>
							<div class="col-md-3 col-xs-6"><input type="input" class="form-control site-form__input js-orderSelEntrySinglePrice" name="products[${loopStatus.index}].singlePrice" value="${product.singlePrice}"></div> 
							<div class="col-md-1 col-xs-6 hidden visible-md visible-lg">	
									<div class="pull-right col-xs-12 text-right order-sel__no-pad">
										<div class="site-form__checkbox checkbox  ">
											<input id="products[${loopStatus.index}].selected" type="checkbox" class="js-orderSelEntrySelect" name="products[${loopStatus.index}].selected" >
											<label class="control-label js-orderSelEntrySelectLabel" for="products[${loopStatus.index}].selected">
											</label>
										</div>
									</div>	
							</div>
							<div class="order-sel__sectionHeading visible-xs visible-sm h-topspace-2">
								<div class="col-xs-6 h-topspace-3 order-sel__sectionHeading--label"><spring:theme code="orderSELsAndPOS.sels.header.select" /></div>
							</div>
							<div class="col-md-1 col-xs-6 h-topspace-2 h-space-1 visible-sm visible-xs">	
								<div class="pull-right col-xs-1 text-right order-sel__no-pad">
									<div class="site-form__checkbox checkbox  ">
										<input id="products[${loopStatus.index}].selected" type="checkbox" class="js-orderSelEntrySelect" name="products[${loopStatus.index}].selected" >
										<label class="control-label js-orderSelEntrySelectLabel" for="products[${loopStatus.index}].selected">
										</label>
									</div>
								</div>	
							</div>							
						</div>
					</div>
				</c:forEach>
				</div>
			</div>					
		</div>					

			<div class="col-sm-11 col-xs-12 h-space-3">
				<formElement:formInputBox
						idKey="orderSELsAndPOS.input.note"
						labelKey="orderSELsAndPOS.input.note"
						path="note"
						errorKey="note"
						inputCSS="form-control site-form__input order-sel__input js-formField"
						labelCSS="order-sel__title"
						mandatory="false"
						showAsterisk="false"
						validationType="note"
						placeholderKey="note"/>
			</div>

			<selpos:deliveryDetails/>

		</sec:authorize>
	</jsp:body>

</selpos:formTemplate>
