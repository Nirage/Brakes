<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="option" required="true" type="com.envoydigital.brakes.facades.orderPosSel.data.OptionPOSandSELData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>

	<div class="col-xs-12 h-space-2 p-0">

		<div class="order-sel__title h-space-2"><spring:theme code="orderSELsAndPOS.sels.section1" /></div>
			<div class="order-sel__bordered ">

		<c:forEach items="${option.values}" var="option" varStatus="loopStatus">
		<div class="h-space-2 order-sel__subHeading">
				<div class="pull-left col-xs-11 order-sel__pad-checkbox"><spring:theme code="orderSELsAndPOS.option.${option}" /></div>
				<div class="pull-right col-xs-1 text-right order-sel__no-pad">
					<div class="site-form__checkbox checkbox">
						<input id="option.values[${loopStatus.index}]" type="checkbox" class="js-orderSelEntrySelect" name="option.values[${loopStatus.index}]" value="${option}" >
						<label class="control-label js-orderSelEntrySelectLabel" for="option.values[${loopStatus.index}]">
						</label>
					</div>
				</div>
				<div style="clear: both;"></div>
</div>
		</c:forEach>
			</div>

	</div>