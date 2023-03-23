<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>


<spring:htmlEscape defaultHtmlEscape="false" />


<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >

<div class="col-sm-11 col-xs-12 h-space-3">
	<div class="order-sel__title"><spring:theme code="orderSELsAndPOS.deliveryDetails.title" /></div>

	<formElement:formInputBox
			idKey="orderSELsAndPOS.firstName"
			labelKey="orderSELsAndPOS.firstName"
			path="firstName"
			errorKey="firstName"
			inputCSS="form-control site-form__input order-sel__input js-formField"
			labelCSS="site-form__label order-sel__sectionHeading--label h-space-1 h-topspace-2"
			mandatory="true"
			showAsterisk="true"
			validationType="name"
			placeholderKey="firstName"/>


	<formElement:formInputBox
			idKey="orderSELsAndPOS.surname"
			labelKey="orderSELsAndPOS.surname"
			path="surname"
			errorKey="surname"
			inputCSS="form-control site-form__input order-sel__input js-formField"
			labelCSS="site-form__label order-sel__sectionHeading--label h-space-1 h-topspace-2"
			mandatory="true"
			showAsterisk="true"
			validationType="name"
			placeholderKey="surname"/>

	<formElement:formInputBox
			idKey="orderSELsAndPOS.businessName"
			labelKey="orderSELsAndPOS.businessName"
			path="businessName"
			errorKey="businessName"
			inputCSS="form-control site-form__input order-sel__input js-formField"
			labelCSS="site-form__label order-sel__sectionHeading--label h-space-1 h-topspace-2"
			mandatory="true"
			showAsterisk="true"
			validationType="name"
			placeholderKey="businessName"/>

	<formElement:formInputBox
			idKey="orderSELsAndPOS.addressLine1"
			labelKey="orderSELsAndPOS.addressLine1"
			path="addressLine1"
			errorKey="addressLine1"
			inputCSS="form-control site-form__input order-sel__input js-formField"
			labelCSS="site-form__label order-sel__sectionHeading--label h-space-1 h-topspace-2"
			mandatory="true"
			showAsterisk="true"
			validationType="address"
			placeholderKey="selPosAddressLine1"/>

	<formElement:formInputBox
			idKey="orderSELsAndPOS.addressLine2"
			labelKey="orderSELsAndPOS.addressLine2"
			validationType="address"
			path="addressLine2"
		    errorKey="addressLine2"
			inputCSS="form-control site-form__input order-sel__input js-formField"
			labelCSS="site-form__label order-sel__sectionHeading--label h-space-1 h-topspace-2"
			mandatory="false"
			showAsterisk="false"
			placeholderKey="selPosAddressLine2"/>

	<formElement:formInputBox
			idKey="orderSELsAndPOS.addressLine3"
			labelKey="orderSELsAndPOS.addressLine3"
			validationType="address"
			path="addressLine3"
			inputCSS="form-control site-form__input order-sel__input js-formField"
			labelCSS="site-form__label order-sel__sectionHeading--label h-space-1 h-topspace-2"
			mandatory="false"
			showAsterisk="false"
			placeholderKey="selPosAddressLine3"/>

	<formElement:formInputBox
			idKey="orderSELsAndPOS.postcode"
			labelKey="orderSELsAndPOS.postcode"
			path="postcode"
			errorKey="postCode"
			inputCSS="form-control site-form__input order-sel__input js-formField"
			labelCSS="site-form__label order-sel__sectionHeading--label h-space-1 h-topspace-2"
			mandatory="true"
			showAsterisk="true"
			validationType="postcode"
			placeholderKey="postcode"/>
</div>


</sec:authorize>


