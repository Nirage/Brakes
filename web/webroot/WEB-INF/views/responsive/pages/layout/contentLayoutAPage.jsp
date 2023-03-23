<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>

<template:page pageTitle="${pageTitle}">
<div class="container amp-templatepage--a">
    <cms:pageSlot position="Section1" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section2" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section3" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section4" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section5" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section6" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section7" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section8" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section9" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section10" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section11" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section12" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>

</div>
</template:page>
