<%@ tag body-content="empty" trimDirectiveWhitespaces="true"%>
<%@ attribute name="actionNameKey" required="false" type="java.lang.String"%>
<%@ attribute name="action" required="false" type="java.lang.String"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="hideDescription" value="checkout.login.loginAndCheckout" />
<spring:url value="/become-a-customer-eligible" var="newCustomerUrl" />
<spring:url value="/register-existing-registration" var="existingCustomerUrl" />


<div class="col-md-6 col-sm-6">
    <div class="row">
        <div class="col-md-1 col-sm-2">
            <span class="login__devider--text"><spring:theme code="login.register.or" /></span>
        </div>
        <div class="col-md-8 col-md-offset-1 col-sm-10">
            <h1 class="text-center">
                <spring:theme code="gotoregister.headline" />
            </h1>
      
    
                <label class="site__form--label" for=""><spring:theme code="gotoregister.question" /></label>

                <div class="radio login__radio">
                    <input type="radio" class="js-registerCheckbox" id="radioYes" value="yes" name="radio-group">
                    <label for="radioYes"><spring:theme code="gotoregister.hasaccount.yes" /></label>
                </div>
                <div class="radio login__radio">
                    <input type="radio" class="js-registerCheckbox" id="radioNo" value="no" name="radio-group" checked>
                    <label for="radioNo"><spring:theme code="gotoregister.hasaccount.no" /></label>
                </div>

                <input id="gotoregister_button_register" type="hidden" value="<spring:theme code="gotoregister.button.register" />" />
                <input id="gotoregister_button_register_online" type="hidden" value="<spring:theme code="gotoregister.button.register.online" />" />

                <a href="${newCustomerUrl}"  class="btn btn-primary btn--full-width js-registerButton"><spring:theme code="gotoregister.button.register" /></a>
                <a href="${existingCustomerUrl}" class="btn btn-primary btn--full-width js-registerButtonOnline hide" ><spring:theme code="gotoregister.button.register.online" /></a>
                
        </div>
    </div>
</div>

