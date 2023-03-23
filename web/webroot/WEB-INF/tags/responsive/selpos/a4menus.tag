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
		<div class="col-sm-12 col-xs-12 h-topspace-2">
		<selpos:checkboxOptionList option="${pageData.option}"/>	
		</div>	
			<div class="col-sm-12 col-xs-12">
				<div class="order-sel__title h-space-2"><spring:theme code="orderSELsAndPOS.a4menus.section2" /></div>
				<div class="js-menuSection">
					<c:forEach begin="0" end="6" varStatus="loopStatus">
						<input class="js-loopStatus" type="hidden" value="7">
						<div class="h-space-3 order-sel__sectionHeading order-sel__bordered order-sel__para js-menuSectionEntry">
							<div class="row">
								<div class="col-xs-12 col-sm-5">
									<formElement:formInputBox
									idKey="products[${loopStatus.index}].code"
									labelKey="orderSELsAndPOS.a4menus.header.code"
									labelCSS="order-sel__sectionHeading--label h-space-1"
									path="products[${loopStatus.index}].code"
									errorKey="firstName"
									inputCSS="form-control site-form__input order-sel__gap order-sel__input js-productCodeMenu"
									mandatory="false"
									showAsterisk="false"
									placeholderKey="orderSELAndPOS.productcode"
									/>
								</div>
								<div class="col-sm-5 col-xs-12">
									<formElement:formInputBox
										idKey="products[${loopStatus.index}].singlePrice"
										labelKey="orderSELsAndPOS.a4menus.header.rrp"
										labelCSS="order-sel__sectionHeading--label h-space-1"
										path="products[${loopStatus.index}].singlePrice"
										inputCSS="form-control site-form__input order-sel__input js-rrpMenu"
										mandatory="false"
										showAsterisk="false"
									placeholderKey="orderSELAndPOS.rrp"
										/>
								</div>
							</div>	
							<input id="products[${loopStatus.index}].selected" name="products[${loopStatus.index}].selected" type="hidden" value="false" class="js-posFieldSelectedMenu">
						</div>		
					</c:forEach>
					<div id="js-add-row-sectionParent"></div>
			</div>
		</div>

		<div class="h-space-3 order-sel__para order-sel__bordered clearfix">
			<div class="col-xs-12">
				<button type="button" class="btn btn-secondary js-add-menu-button"><spring:theme code="orderSELsAndPOS.a4menus.addmenu" /></button>
			</div>
		</div>	
				
		<selpos:deliveryDetails/>
		<selpos:a4menusHandlebarTemplate/>


		
		</sec:authorize>
	</jsp:body>

</selpos:formTemplate>

