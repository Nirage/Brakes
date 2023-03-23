<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="idKey" required="true" type="java.lang.String"%>
<%@ attribute name="labelKey" required="true" type="java.lang.String"%>
<%@ attribute name="path" required="true" type="java.lang.String"%>
<%@ attribute name="mandatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="tooltip" required="false" type="java.lang.Boolean"%>
<%@ attribute name="tooltipContent" required="false" type="java.lang.String"%>
<%@ attribute name="labelCSS" required="false" type="java.lang.String"%>
<%@ attribute name="inputCSS" required="false" type="java.lang.String"%>
<%@ attribute name="tabindex" required="false" type="java.lang.String"%>
<%@ attribute name="validationType" required="false" type="java.lang.String"%>
<%@ attribute name="errorKey" required="false" type="java.lang.String"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ attribute name="labelArguments" required="false" type="java.lang.String"%>

<spring:htmlEscape defaultHtmlEscape="false" />
<spring:theme code="${idKey}" var="themeIdKey"/>

<div class="site-form__checkbox-group" id="${themeIdKey}.section">
<template:errorSpanField path="${path}">
	  <div class="site-form__checkbox checkbox  ${tooltip ? ' checkbox--has-tooltip' : ''}">
			<c:if test="${tooltip}">
				<span class="icon icon-question checkbox__tooltip js-triggerTooltip" data-container="body" data-toggle="popover-collapsable" data-placement="top" data-content="<spring:theme code="tooltip.text.${tooltipContent}" />"></span>
			</c:if>
				  <input id="${themeIdKey}" name="${themeIdKey}" type="checkbox" value="" class="${inputCSS} ${mandatory == true ? ' is-required': ' is-optional'}" tabindex="${tabindex}" data-validation-type="${validationType}"/>
					<label class="control-label ${fn:escapeXml(labelCSS)}" for="${fn:escapeXml(themeIdKey)}" data-error-empty="<spring:theme code="error.empty.${errorKey}" />">
	   			<spring:theme code="${labelKey}" arguments="${labelArguments}"/>
	   		</label>

		</div>
</template:errorSpanField>
</div>