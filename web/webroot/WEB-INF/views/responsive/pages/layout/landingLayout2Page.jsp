<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<template:page pageTitle="${pageTitle}">
  
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
    <cms:pageSlot position="Section13" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section14" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section15" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>
    <cms:pageSlot position="Section16" var="feature">
        <cms:component component="${feature}"/>
    </cms:pageSlot>


      <favourites:newFavouritiesList/>
</template:page>
