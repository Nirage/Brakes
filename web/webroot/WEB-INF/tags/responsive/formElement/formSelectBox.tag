<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="idKey" required="true" type="java.lang.String" %>
<%@ attribute name="labelKey" required="true" type="java.lang.String" %>
<%@ attribute name="path" required="true" type="java.lang.String" %>
<%@ attribute name="items" required="true" type="java.util.Collection" %>
<%@ attribute name="itemValue" required="false" type="java.lang.String" %>
<%@ attribute name="itemLabel" required="false" type="java.lang.String" %>
<%@ attribute name="mandatory" required="false" type="java.lang.Boolean" %>
<%@ attribute name="showAsterisk" required="false" type="java.lang.Boolean" %>
<%@ attribute name="labelCSS" required="false" type="java.lang.String" %>
<%@ attribute name="selectCSSClass" required="false" type="java.lang.String" %>
<%@ attribute name="validationType" required="false" type="java.lang.String"%>
<%@ attribute name="skipBlank" required="false" type="java.lang.Boolean" %>
<%@ attribute name="skipBlankMessageKey" required="false" type="java.lang.String" %>
<%@ attribute name="selectedValue" required="false" type="java.lang.String" %>
<%@ attribute name="tabindex" required="false" rtexprvalue="true" %>
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>
<%@ attribute name="errorKey" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipKey" required="false" type="java.lang.String"%>
<%@ attribute name="endpoint" required="false" type="java.lang.String"%>
<%@ attribute name="subSelect" required="false" type="java.lang.String"%>
<%@ attribute name="tooltipType" required="false" type="java.lang.String"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="escapedPath" value="${fn:escapeXml(path)}"/>
<c:set var="escapedIdKey" value="${fn:escapeXml(idKey)}"/>

<div class="custom-txtbox" id="${escapedIdKey}.section">
	<spring:htmlEscape defaultHtmlEscape="true" />
	<template:errorSpanField path="${path}">
		<ycommerce:testId code="LoginPage_Item_${idKey}">
				<span class="${fn:escapeXml(labelCSS)} ${disabled ? ' is-disabled': ''}"   >
					<spring:theme code="${labelKey}"/>${(showAsterisk == true && mandatory == true) ? ' *' : ''}
							<c:if test="${not empty tooltipKey}">
								<span class="icon icon-question site-form__icon <c:if test="${tooltipType eq 'collapsable'}"> js-triggerTooltip </c:if>" data-container="body" data-toggle=${(tooltipType eq 'collapsable') ? "popover-collapsable":"popover"} data-placement="top" data-content="<spring:theme code="tooltip.text.${tooltipKey}" />" data-type="${tooltipType}"></span>
						</c:if>
				</span>
				<div class="control site-form__dropdown ${disabled ? ' is-disabled': ''}">
					<label for="${escapedIdKey}" data-error-empty="<spring:theme code="error.empty.${errorKey}" />">
					<form:select id="${escapedIdKey}" path="${escapedPath}" cssClass="${selectCSSClass} ${mandatory == true ? 'is-required' : 'is-optional'}" tabindex="${fn:escapeXml(tabindex)}" disabled="${disabled}" data-validation-type="${validationType}"   data-sub-select="${subSelect}" data-endpoint="${endpoint}">
						<c:if test="${skipBlank == null || skipBlank == false}" >
							<option value="" ${empty selectedValue ? 'selected="selected"' : ''}>
								<spring:theme code='${skipBlankMessageKey}'/>
							</option>
						</c:if>

						<c:forEach var="item" items="${items}">
							<c:choose>
								<c:when test="${item.code == 'SEPARATE_DOTTED_LINE'}">
									<option value="${item.code}" disabled="disabled">${item.name}</option></c:when>
								<c:otherwise>
									<option value="${item.code}" ${item.code == selectedValue ? 'selected="selected"' : ''}>${item.name}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</form:select>
					<span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
					<span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
					</label>
				</div>

		</ycommerce:testId>
	</template:errorSpanField>
</div>
