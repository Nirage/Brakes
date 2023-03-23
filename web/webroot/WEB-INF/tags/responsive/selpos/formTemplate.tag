<%@ tag trimDirectiveWhitespaces="true" %>
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


<form:form method="post" class="site-form js-formValidation js-posSubmitForm" modelAttribute="orderSELsAndPOSForm" action="${contextPath}/my-country-choice/order-sels-and-pos">

	<form:input path="categoryCode" type="hidden" />

	<%-- Inject the page body here --%>
	<jsp:doBody/>

	<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >

		<div class="site-form__actions form-actions clearfix h-topspace-2 h-space-2">
		<div class="col-xs-6 col-sm-11">
			<button tabindex="0" type="submit" class="btn btn-primary btn-md btn-block js-submitBtn pull-right js-posSubmit">
				<spring:theme code="orderSELsAndPOS.submitOrder" />
			</button>
		</div>	
		</div>

	</sec:authorize>

</form:form>