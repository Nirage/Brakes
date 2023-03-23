<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:url value="/sign-in" var="loginUrl"/>


<div class="row js-b2cPopUpWhitelistedPage">
    <div class="col-md-8 col-sm-8 col-sm-offset-2 col-md-offset-2 col-xs-10 col-xs-offset-1">
        <div class="row ">
            <div class="col-xs-12 col-md-12">
                <div class="site__header">
                    <spring:theme code="forgottenusername.form.headline"/>
                    <span class="site__header--rectangle"></span>
                </div>
            </div>
            <div class="col-xs-12 col-md-10 col-md-offset-1">
                <spring:url value="/forgot-username" var="action"/>
                <form:form action="${action}" method="post" class="js-formValidation"
                           modelAttribute="forgottenUsernameForm">
                    <formElement:formInputBox
                            idKey="j_username"
                            labelKey="forgottenUsernameForm.emailAddress"
                            path="emailAddress"
                            mandatory="true"
                            errorKey="forgottenUsernameForm_emailAddress"
                            inputCSS="form-control site__form--input js-formField js-b2cPopUpWhitelistedCTA"
                            labelCSS="site__form--label"
                            validationType="email"

                    />
                    <ycommerce:testId code="loginAndCheckoutButton">
                        <button type="submit" class="btn btn-primary btn--full-width forgot-username__btn js-submitBtn js-b2cPopUpWhitelistedCTA">
                            <spring:theme code="forgottenusername.form.next"/>
                        </button>
                    </ycommerce:testId>
                </form:form>
					
                <span class="trouble-text"><spring:theme code="forgottenusername.form.stilltrouble" /></span>
            
            </div>
        </div>
    </div>
</div>