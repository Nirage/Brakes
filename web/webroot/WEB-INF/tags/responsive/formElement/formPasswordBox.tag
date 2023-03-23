<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="idKey" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="path" required="true" type="java.lang.String"%>
<%@ attribute name="mandatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="labelCSS" required="false" type="java.lang.String"%>
<%@ attribute name="inputCSS" required="false" type="java.lang.String"%>
<%@ attribute name="errorPath" required="false" type="java.lang.String"%>
<%@ attribute name="validationType" required="false" type="java.lang.String"%>
<%@ attribute name="errorKey" required="false" type="java.lang.String"%>
<%@ attribute name="placeholderKey" required="false" type="java.lang.String"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<%-- <c:set var="placeholder"><spring:theme code="asm.emulate.username.placeholder"/></c:set> --%>
		  <c:if test="${not empty placeholderKey}">
         <spring:theme var="placeholder" code="placeholder.text.${placeholderKey}" />
			</c:if>

<div class="custom-txtbox">
<template:errorSpanField path="${path}" errorPath="${errorPath}">
	<ycommerce:testId code="LoginPage_Item_${idKey}">
		<c:if test="${not empty labelKey}">
			<label class="${labelCSS}" for="${idKey}" data-error-empty="<spring:theme code="error.empty.${errorKey}" />" data-error-invalid="<spring:theme code="error.invalid.${errorKey}" />">
			<span class="password-label"><spring:theme code="${labelKey}" />:</span>
				<span class="pull-right site__form--showpassword js-showPassword" data-hidden="true" data-show="<spring:theme code='password.show' />" data-hide="<spring:theme code='password.hide' />">
					<spring:theme code="password.show" />
				</span>
		</c:if>
		<c:if test="${not empty labelKey}">
			</label>
		</c:if>
		
		<div class="site__form--inputgroup">
		<form:password cssClass="${inputCSS} ${mandatory == true ? 'is-required': 'is-optional'} js-formFieldPassword" id="${idKey}" path="${path}" autocomplete="off" data-validation-type="${validationType}" placeholder='${placeholder}' />
		<span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
			<span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
		</div>
	</ycommerce:testId>
</template:errorSpanField>
</div>
