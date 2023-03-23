<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="user" tagdir="/WEB-INF/tags/responsive/user"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<template:page pageTitle="${pageTitle}">
<div class="container container--narrow">
	<div class="flex flex-direction-column align-items-center mb2">
        <p class="mb2 font-size-2 font-primary-bold text-center"><spring:theme code="account.multi.step.sf.locked.message"/></p>
        <a href="/" class="btn btn-primary"><spring:theme code="account.multi.step.sf.locked.cta"/></a>
    </div>
</div>
</template:page>