<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<template:page pageTitle="${pageTitle}">
     <cms:pageSlot position="ProductReferenceSlot" var="feature">
          <cms:component component="${feature}" element="div" class="yComponentWrapper"/>
     </cms:pageSlot>
    <div class="js_spinner spinning-div">
        <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
    </div>
</template:page>
