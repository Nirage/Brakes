<%-- This component has been replaced by checkoutConfirmationOOSThankMessage due to BRAKESP2-3115 --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>

<spring:htmlEscape defaultHtmlEscape="true" />
<spring:url value="/sign-in/register/termsandconditions" var="getTermsAndConditionsUrl" htmlEscape="false"/>
	<c:url value="/" var="homePageUrl" />

<div class="checkout-success">
	<div class="checkout-success__body">
		<div class="checkout-success__body__headline">
					<spring:theme code='checkout.orderConfirmation.thankYouForOrder' arguments='${orderData.user.name}' /> <br>
					<spring:theme code='checkout.orderConfirmation.orderstatus' />
                    <span class="checkout-success__body__status">&nbsp;${orderData.statusDisplay}</span>
		</div>
        <div class="site-header__rectangle"></div>
        <div class="h-space-3">
            <p class="checkout-success__body__text"><spring:theme code='checkout.orderConfirmation.message1'/>&nbsp;<span class="font-primary-bold"><spring:theme code='checkout.orderConfirmation.message12'/>${orderData.code}</span>
            <spring:theme code='checkout.orderConfirmation.message123'/><span class="font-primary-bold"> ${orderData.parentAccountId} - ${orderData.parentAccountName}  </span> </p>
            <p class="checkout-success__body__text"><spring:theme code='checkout.orderConfirmation.message2'/></p>
        </div>
		<c:if test="${not empty orderData.purchaseOrderNumber}">
			<p class="checkout-success__body__text"><spring:theme code='checkout.orderConfirmation.message3'/> &nbsp; ${orderData.purchaseOrderNumber}</p>
		</c:if>
	    <p class="checkout-success__body__text"><spring:theme code='checkout.orderConfirmation.message4'/></p>
        <a class="btn btn-default h-topspace-3 btn-primary js-continue-shopping-button" href="${fn:escapeXml(homePageUrl)}" data-continue-shopping-url="${fn:escapeXml(homePageUrl)}">
			<spring:theme code="general.continue.shopping" text="Continue Shopping"/>
		</a>
	</div>
	
	<order:giftCoupons giftCoupons="${giftCoupons}"/>
		
	<c:if test="${not empty guestRegisterForm}">
		<div class="checkout__new-account">
			<div class="checkout__new-account__headline"><spring:theme code="guest.register"/></div>
			<p><spring:theme code="order.confirmation.guest.register.description"/></p>
	
			<form:form method="post" modelAttribute="guestRegisterForm" class="checkout__new-account__form clearfix">
                <div class="col-sm-8 col-sm-push-2 col-md-6 col-md-push-3">
                    <form:hidden path="orderCode"/>
                    <form:hidden path="uid"/>

                    <div class="form-group">
                        <label for="email" class="control-label "><spring:theme code="register.email"/></label>
                        <input type="text" value="${fn:escapeXml(guestRegisterForm.uid)}" class="form-control" name="email" id="email" readonly>
                    </div>

                    <formElement:formPasswordBox idKey="password" labelKey="guest.pwd" path="pwd" inputCSS="password strength form-control" mandatory="true"/>
                    <formElement:formPasswordBox idKey="guest.checkPwd" labelKey="guest.checkPwd" path="checkPwd" inputCSS="password form-control" mandatory="true"/>
                    <c:if test="${ not empty consentTemplateData }">
                        <form:hidden path="consentForm.consentTemplateId" value="${consentTemplateData.id}" />
                        <form:hidden path="consentForm.consentTemplateVersion" value="${consentTemplateData.version}" />
                        <div class="checkbox">
                            <label class="control-label uncased">
                                <form:checkbox path="consentForm.consentGiven" />
                                <c:out value="${consentTemplateData.description}" />
                            </label>
                        </div>
                        <div class="help-block">
                            <spring:theme code="registration.consent.link" />
                        </div>
                    </c:if>
                    <template:errorSpanField path="termsCheck">
	                    <div class="checkbox">
							<label class="control-label uncased">
								<form:checkbox id="registerChkTermsConditions" path="termsCheck" disabled="true"/>
                                <spring:theme var="termsAndConditionsHtml" code="register.termsConditions" arguments="${fn:escapeXml(getTermsAndConditionsUrl)}" htmlEscape="false" />
                                ${ycommerce:sanitizeHTML(termsAndConditionsHtml)}
							</label>
						</div>
					</template:errorSpanField>
                    <div class="accountActions-bottom">
                        <ycommerce:testId code="guest_Register_button">
                            <button type="submit" class="btn btn-block btn-primary" disabled="disabled">
                                <spring:theme code="guest.register"/>
                            </button>
                        </ycommerce:testId>
                    </div>
                </div>
			</form:form>
		</div>
	</c:if>
</div>



