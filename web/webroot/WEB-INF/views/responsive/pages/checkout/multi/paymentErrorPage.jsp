<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<template:page pageTitle="${pageTitle}" hideHeaderLinks="true">
<div class="row">
<h2 class="site-header__text site-header--align-left col-xs-12 col-md-offset-3 col-xs-offset-1"><spring:theme code="checkout.payment.error.title"></spring:theme></h2>
 </div>
          <div class="text-center">

               <a href="/checkout" class="btn btn-primary h-space-3 h-topspace-2"><spring:theme code="checkout.payment.back.checkout"></spring:theme></a>
</div>
     
</template:page>