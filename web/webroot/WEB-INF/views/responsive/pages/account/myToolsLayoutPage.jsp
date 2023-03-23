<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<template:page pageTitle="${pageTitle}">

    <div class="container">
        <div class="row">
            <div class="col-xs-12 col-sm-4 col-md-3 h-topspace-2">
                <cms:pageSlot position="MyToolsLeftNavigation" var="feature">
                    <cms:component component="${feature}"/>
                </cms:pageSlot>
            </div>
            <div class="col-xs-12 col-sm-8 col-md-9">
                <%-- Main container --%>
                <cms:pageSlot position="MyToolsSlot" var="feature">
                    <cms:component component="${feature}"/>
                </cms:pageSlot>
            </div>
            <div class="col-md-9 col-sm-8">
                <cms:pageSlot position="Section2B" var="feature" element="div" class="">
                    <cms:component component="${feature}"/>
                </cms:pageSlot>
            </div>
        </div>
    </div>

</template:page>