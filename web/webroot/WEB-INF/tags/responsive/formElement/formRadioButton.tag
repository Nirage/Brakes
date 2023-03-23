<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="idKey" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="path" required="false" type="java.lang.String"%>
<%@ attribute name="mandatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="iconCSS" required="false" type="java.lang.String"%>
<%@ attribute name="labelCSS" required="false" type="java.lang.String"%>
<%@ attribute name="inputCSS" required="false" type="java.lang.String"%>
<%@ attribute name="tabindex" required="false" type="java.lang.String"%>
<%@ attribute name="value" required="false" type="java.lang.String"%>
<%@ attribute name="name" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipKey" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipType" required="false" type="java.lang.String"%>
<%@ attribute name="validationType" required="false" type="java.lang.String"%>
<%@ attribute name="errorKey" required="false" type="java.lang.String"%>
<%@ attribute name="showError" required="false" type="java.lang.String"%>



<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:errorSpanField path="${path}">
    <spring:theme code="${idKey}" var="themeIdKey"/>

    <div class="radio">
        <form:radiobutton data-showError="${showError}" data-validation-type="${validationType}" cssClass="${inputCSS}"  id="${themeIdKey}" path="${path}" tabindex="${tabindex}" value="${value}" />
        <label class="control-label ${fn:escapeXml(labelCSS)}" for="${fn:escapeXml(themeIdKey)}" data-error-empty="<spring:theme code="error.empty.${errorKey}" />" data-error-invalid="<spring:theme code="error.invalid.${errorKey}" />">
      
            <spring:theme code="${labelKey}"/>
            <c:if test="${mandatory != null && mandatory == true}">
	   				<span class="mandatory">
	   					<spring:theme code="login.required" var="loginrequiredText" />
	   				</span>
            </c:if>
            <span class="skip"><form:errors path="${path}"/></span>
        </label>
        <c:if test="${not empty tooltipKey}">
        			<span class="icon icon-question site-form__icon ${fn:escapeXml(iconCSS)} <c:if test="${tooltipType eq 'collapsable'}"> js-triggerTooltip </c:if>" data-container="body" data-toggle=${(tooltipType eq 'collapsable') ? "popover-collapsable":"popover"} data-placement="top" data-content="<spring:theme code="tooltip.text.${tooltipKey}" />" data-type="${tooltipType}"></span>
        </c:if>
    </div>

</template:errorSpanField>
