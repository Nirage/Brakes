<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="idKey" required="true" type="java.lang.String" %>
<%@ attribute name="labelKey" required="true" type="java.lang.String" %>
<%@ attribute name="path" required="true" type="java.lang.String" %>
<%@ attribute name="mandatory" required="false" type="java.lang.Boolean" %>
<%@ attribute name="labelCSS" required="false" type="java.lang.String" %>
<%@ attribute name="areaCSS" required="false" type="java.lang.String" %>
<%@ attribute name="placeholderKey" required="false" type="java.lang.String" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>
<%@ attribute name="showCounter" required="false" type="java.lang.Boolean" %>
<%@ attribute name="maxlength" required="false" type="java.lang.Integer" %>
<%@ attribute name="rows" required="false" type="java.lang.Integer" %>
<%@ attribute name="cols" required="false" type="java.lang.Integer" %>
<%@ attribute name="validationType" required="false" type="java.lang.String"%>
<%@ attribute name="errorKey" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipKey" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipType" required="false" type="java.lang.String"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>

<spring:htmlEscape defaultHtmlEscape="false" />
<c:if test="${not empty placeholderKey}">
<spring:theme var="placeholder" code="placeholder.text.${placeholderKey}" />
</c:if>

<div class="custom-textarea" id="${idKey}.section">
    <template:errorSpanField path="${path}">
        <label class="${fn:escapeXml(labelCSS)}" for="${fn:escapeXml(idKey)}" data-error-maxlength="<spring:theme code="error.maxChars.${errorKey}"/>" data-error-empty="<spring:theme code="error.empty.${errorKey}" arguments="${maxlength}"/>" data-error-invalid="<spring:theme code="error.invalid.${errorKey}" />">
            <spring:theme code="${labelKey}"/>${mandatory == true ? ' *' : ''}
            <span class="skip"><form:errors path="${path}"/></span>
        </label>
		<c:if test="${not empty tooltipKey}">
			<span class="icon icon-question site-form__icon <c:if test="${tooltipType eq 'collapsable'}"> js-triggerTooltip </c:if>" data-container="body" data-toggle=${(tooltipType eq 'collapsable') ? "popover-collapsable":"popover"} data-placement="top" data-content="<spring:theme code="tooltip.text.${tooltipKey}" />" data-type="${tooltipType}"></span>
		</c:if>
        <form:textarea 
            cssClass="${fn:escapeXml(areaCSS)} ${mandatory == true ? 'is-required' : 'is-optional'}" 
            id="${idKey}" 
            path="${path}" 
            disabled="${disabled}" 
            placeholder="${placeholder}"
            data-maxlength="${maxlength}" 
            rows="${rows}" 
            cols="${cols}" 
            data-validation-type="${validationType}" 
            maxlength="${maxlength}" />

        <c:if test="${showCounter}">
          <span class="site-form__textarea-counter js-counterWrap">
            <spring:theme code="${idKey}.counter" arguments="${maxlength}"/>
           </span>
           <span class="icon icon-caret-up error-msg js-counterErrorMsg site-form__errormessage hide">
            <spring:theme code="${idKey}.error.counter" arguments="${maxlength}"/>
           </span>
        </c:if>
    </template:errorSpanField>
</div>
