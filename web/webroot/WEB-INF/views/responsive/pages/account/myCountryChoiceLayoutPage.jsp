<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<template:page pageTitle="${pageTitle}">
     <!-- REMOVE This Heading After adding any content, For identifying empty page, just added. -->
	<h2>My Country Choice page</h2>
    <div>
        <a href="/my-country-choice/find-your-sales-contact">Find your local sales</a>
    </div>
    <div>
        <c:url value="/my-country-choice/order-sels-and-pos" var="orderSELsAndPOSUrl"/>
        <a href="${orderSELsAndPOSUrl}">Order SELs and POS</a>
    </div>
    <div>
        <c:url value="/my-country-choice/training-modules" var="trainingModulesUrl"/>
        <a href="${trainingModulesUrl}">Training Modules</a>
    </div>

</template:page>