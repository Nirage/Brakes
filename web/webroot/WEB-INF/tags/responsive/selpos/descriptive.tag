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

			<div class="h-space-3">
				<div class="col-xs-12 h-space-3">
					<div class="order-sel__title h-space-2">
						<spring:theme code="orderSELsAndPOS.descriptive.section1" />
					</div>

					<c:forEach items="${pageData.preProducts}" var="product" varStatus="loopStatus">
						<input type="hidden" id="productSELsAndPOS${loopStatus.index}.code" name="products[${loopStatus.index}].code" value="${product.code}"/>
						<input type="hidden" id="productSELsAndPOS${loopStatus.index}.name" name="products[${loopStatus.index}].name" value="${product.name}"/>
						<div class="order-sel__bordered order-sel__subHeading">
							<div class="pull-left col-xs-10 order-sel__no-pad h-topspace-2 h-space-2 ">${product.name}</div>
							<div class="pull-right col-xs-2 text-right order-sel__no-pad h-topspace-2 h-space-2">
								<div class="site-form__checkbox checkbox">
									<input id="products[${loopStatus.index}].selected" name="products[${loopStatus.index}].selected" type="checkbox"  class="js-formField is-optional" tabindex="" data-validation-type="checkbox">
									<label class="control-label " for="products[${loopStatus.index}].selected">
									</label>
								</div>
						</div>
						<div style="clear: both;"></div>

						</div>
					</c:forEach>

				</div>
			</div>

			<selpos:deliveryDetails/>

		</sec:authorize>
	</jsp:body>

</selpos:formTemplate>
