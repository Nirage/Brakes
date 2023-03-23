<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="row">
    
    <div class="col-md-12">
            <div class="col-xs-12 col-md-12">
                <span class="forgot-password-line"></span>
            </div>
    </div>
    <div class="col-md-8 col-sm-8 col-sm-offset-2 col-md-offset-2 col-xs-10 col-xs-offset-1">

        <div class="row">
            <spring:url value="/sign-in" var="login"/>
            <a href="${login}" class="btn btn-default custom-button--default forgot-password-back-btn h-space-1 js-b2cPopUpWhitelistedCTA"><spring:theme code="forgottenusername.form.back"/></a>
        </div>

    </div>
</div>