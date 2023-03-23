<%@ tag body-content="scriptless" trimDirectiveWhitespaces="true"%>
<%@ attribute name="path" required="true" rtexprvalue="true"%>
<%@ attribute name="errorPath" required="false" rtexprvalue="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<spring:bind path="${not empty errorPath ? errorPath : path}">
	<c:choose>
		<c:when test="${not empty status.errorMessages}">
			<div class="site-form__formgroup form-group js-formGroup has-error">
				<jsp:doBody />
				<span class="icon icon-caret-up error-msg js-errorMsg site-form__errormessage">
					<form:errors path="${not empty errorPath ? '' : path}" />
				</span>
			</div>
		</c:when>
		<c:otherwise>
			<div class="site-form__formgroup form-group js-formGroup">
				<jsp:doBody />
					<span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage">
				</span>
			</div>
		</c:otherwise>
	</c:choose>
</spring:bind>
