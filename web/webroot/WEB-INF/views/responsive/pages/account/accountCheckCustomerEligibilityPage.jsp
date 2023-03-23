<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<%-- TODO: replace the hardcoded texts with the new usage of the message  bundle --%>
<c:url value="${siteUid eq 'brakes' ? '/brakes/become-a-customer-register/company-details': '/become-a-customer-register/company-details'}" var="registerStepOneUrl" scope="session"/>
<template:page pageTitle="${pageTitle}">
    <div class="site-banner">
        <cms:pageSlot position="MiddleContent" var="feature" element="div">
            <cms:component component="${feature}"/>
        </cms:pageSlot>
    </div>
    <div class="row no-margin">
        <cms:pageSlot position="BottomContent" var="feature" element="div">
            <cms:component component="${feature}"/>
        </cms:pageSlot>

        <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3">
            <form:form method="post" action="${registerStepOneUrl}" >
              <button type="submit" class="btn btn-primary btn--full-width"><spring:theme code="egilibilitypage.continue"/></button>
            </form:form>
        </div>
        <div class="col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3">
            <spring:url value="/" var="toHomePage"/>
            <a href="${toHomePage}" class="btn btn-default custom-button--default h-space-10"><spring:theme
                    code="egilibilitypage.tohome"/></a>
        </div>


    </div>
</template:page>