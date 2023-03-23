<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement"
	tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>				
<%@ attribute name="isActive" required="false" type="java.lang.Boolean" %>      
<%@ attribute name="sectionName" required="false" type="java.lang.String"%>
<%@ attribute name="nextSectionName" required="false" type="java.lang.String"%>

<div class="site-form__section js-formSection ${isActive ? 'is-active' : 'pristine'}" data-section="${sectionName}">
	<div class="site-form__section-header js-formHeader">
		<spring:theme code="registration.section1.title" />
		<span class="icon icon-amend"></span>
	</div>
	<div class="site-form__section-content">
		<div class="row">
			<div class="col-xs-12 col-sm-6 col-md-4">
				<formElement:formInputBox 
					idKey="register.firstName"
					labelKey="register.firstName" 
					path="firstName" 
					errorKey="firstName"
					inputCSS="form-control site-form__input js-formField"
					labelCSS="site-form__label"
					mandatory="true" 
					showAsterisk="true"
					validationType="name" />
			</div>
			<div class="col-xs-12 col-sm-6 col-md-4">
				<formElement:formInputBox 
					idKey="register.lastName"
					labelKey="register.lastName" 
					errorKey="lastName"
					path="lastName" 
					inputCSS="form-control site-form__input js-formField"
					labelCSS="site-form__label"
					mandatory="true"
					showAsterisk="true"
					validationType="name" />
			</div>
      <div class="col-xs-12 col-sm-6 col-md-4">
      <formElement:formInputBox 
					idKey="register.email"
					labelKey="register.email" 
					path="email" 
					errorKey="email"
					inputCSS="form-control site-form__input js-formField"
					labelCSS="site-form__label"
					mandatory="true" 
					showAsterisk="true"
					validationType="email" 
					tooltipKey="email"
					tooltipType="collapsable" />
      </div>
		</div>
 
		<button type="button" class="btn btn-primary visible-xs btn-block btn--full-width js-formNextBtn site-form__next-btn" data-parent="${sectionName}" data-goto="${nextSectionName}"><spring:theme code="registration.next" /></button>

	</div><%-- site-form__section-content: --%>
</div><%-- site-form__section --%>

