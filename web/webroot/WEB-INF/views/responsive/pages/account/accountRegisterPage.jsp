<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>


<template:page pageTitle="${pageTitle}">
	<cms:pageSlot position="MiddleContent" var="feature" element="div" >
		<cms:component component="${feature}"  element="div"/>
	</cms:pageSlot>
</template:page>

