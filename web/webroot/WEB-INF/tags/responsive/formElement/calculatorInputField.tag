<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ attribute name="idKey" required="true" type="java.lang.String"%>
<%@ attribute name="formId" required="true" type="java.lang.String"%>
<%@ attribute name="mandatory" required="false" type="java.lang.Boolean"%>
<%@ attribute name="showAsterisk" required="false" type="java.lang.Boolean" %>
<%@ attribute name="labelCSS" required="false" type="java.lang.String"%>
<%@ attribute name="inputCSS" required="false" type="java.lang.String"%>
<%@ attribute name="showPlaceholder" required="false" type="java.lang.Boolean"%>

<%@ attribute name="htmlType" required="false" type="java.lang.String"%>
<%@ attribute name="validationType" required="false" type="java.lang.String"%>
<%@ attribute name="inputType" required="false" type="java.lang.String"%>
<%@ attribute name="tabindex" required="false" rtexprvalue="true"%>
<%@ attribute name="readonly" required="false" type="java.lang.Boolean"%>


<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${showPlaceholder}">
    <spring:theme var="placeholder" code="placeholder.text.${formId}.${idKey}" />
</c:if>

<div class="form-group tools-panel__formgroup site-form__formgroup js-formGroup">
  <div class="site-form__inputgroup js-inputgroup">
		<label class=" ${labelCSS} tools-panel__form-label ${disabled ? ' is-disabled' : ' '}" for="${formId}${idKey}" <c:if test="${!readonly}"> data-error-empty="<spring:theme code="error.empty.${formId}.${idKey}" />" data-error-invalid="<spring:theme code="error.invalid.${formId}.${idKey}" />" </c:if>>
			<spring:theme code="customerTools.${formId}.${idKey}.label" />${(showAsterisk == true && mandatory == true) ? ' *' : ''}
		</label>

    <input type="${htmlType}" id="${formId}${idKey}" class="${inputCSS} form-control tools-panel__form-control js-formField js-formInput ${mandatory == true ? 'is-required': 'is-optional'}" ${readonly ? 'readonly' : ''} tabindex="${tabindex}" data-validation-type="${validationType}" data-input-type="${inputType}" data-parent="${formId}"  placeholder="${placeholder}" />

    <c:if test="${!readonly}">
      <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
      <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
    </c:if>
  </div>
</div>