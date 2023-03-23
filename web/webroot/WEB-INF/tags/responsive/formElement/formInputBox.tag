<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="idKey" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="path" required="true" type="java.lang.String"%>
<%@ attribute name="mandatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="hideLabel" required="false" type="java.lang.Boolean" %>
<%@ attribute name="showAsterisk" required="false" type="java.lang.Boolean" %>
<%@ attribute name="labelCSS" required="false" type="java.lang.String"%>
<%@ attribute name="inputCSS" required="false" type="java.lang.String"%>
<%@ attribute name="placeholderKey" required="false" type="java.lang.String"%>

<%@ attribute name="htmlType" required="false" type="java.lang.String"%>
<%@ attribute name="validationType" required="false" type="java.lang.String"%>
<%@ attribute name="tabindex" required="false" rtexprvalue="true"%>
<%@ attribute name="autocomplete" required="false" type="java.lang.String"%>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean"%>
<%@ attribute name="maxlength" required="false" type="java.lang.Integer"%>
<%@ attribute name="readonly" required="false" type="java.lang.Boolean"%>
<%@ attribute name="errorKey" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipKey" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipType" required="false" type="java.lang.String"%>
<%@ attribute name="dataName" required="false" type="java.lang.String"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<div class="custom-txtbox" id="${idKey}.section">
<template:errorSpanField path="${path}">
	<ycommerce:testId code="LoginPage_Item_${idKey}">
		<label class="${labelCSS} ${disabled ? ' is-disabled' : ' '}" for="${idKey}" data-error-empty="<spring:theme code="error.empty.${errorKey}" />" data-error-invalid="<spring:theme code="error.invalid.${errorKey}" />">
			<c:choose>
			<c:when test="${not hideLabel}">
			    <spring:theme code="${labelKey}" />${(showAsterisk == true && mandatory == true) ? ' *' : ''}
			</c:when>
			<c:otherwise>
			    &nbsp;
			</c:otherwise>
			</c:choose>
			<c:if test="${not empty tooltipKey}">
				<i class="icon icon-question site-form__icon <c:if test="${tooltipType eq 'collapsable'}"> js-triggerTooltip </c:if>" data-container="body" data-toggle=${(tooltipType eq 'collapsable') ? "popover-collapsable":"popover"} data-placement="top" data-content="<spring:theme code="tooltip.text.${tooltipKey}" />" data-type="${tooltipType}"></i>
			</c:if>
		</label>

		<div class="site-form__inputgroup js-inputgroup">
			<c:if test="${not empty placeholderKey}">
        		<spring:theme var="placeholder" code="placeholder.text.${placeholderKey}" />
			</c:if>
			<form:input type="${htmlType}" cssClass="${inputCSS} ${disabled ? ' is-disabled' : ' '} ${mandatory == true ? 'is-required': 'is-optional'}" id="${idKey}" path="${path}"
				tabindex="${tabindex}" autocomplete="${autocomplete ? 'true' : 'noautocomplete'}" 
				disabled="${disabled}" readonly="${readonly}" maxlength="${maxlength}" data-validation-type="${validationType}" data-name="${dataName}" placeholder="${placeholder}"/>
			<span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
			<span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
		</div>
	</ycommerce:testId>
</template:errorSpanField>
</div>
