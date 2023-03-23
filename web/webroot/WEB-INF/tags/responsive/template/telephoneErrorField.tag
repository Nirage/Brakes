<%@ tag body-content="scriptless" trimDirectiveWhitespaces="true"%>
<%@ attribute name="path" required="true" rtexprvalue="true"%>
<%@ attribute name="errorPath" required="false" rtexprvalue="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<spring:bind path="${not empty errorPath ? errorPath : path}">
	<div class="site-form__formgroup form-group mr0 js-formGroup ${not empty status.errorMessages ? 'has-error' : ''}">
		<jsp:doBody />
		<c:if test="${not empty status.errorMessages}">
			<span class="site-form__errormessage">
				<i class="icon icon-caret-up"></i>
				<form:errors path="${not empty errorPath ? '' : path}" />
			</span>
		</c:if>
	</div>
</spring:bind>
