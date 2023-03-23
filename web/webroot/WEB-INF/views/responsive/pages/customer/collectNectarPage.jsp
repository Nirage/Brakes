<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="nectar" tagdir="/WEB-INF/tags/responsive/nectar"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<div class="container">
	<div class="row">
    	<div class="col-xs-12">

        <!-- First section. -->
        <div>
        <h2 class="nectarBanner__title h-space-3"><spring:theme code="text.nectarpoints.collect.page.title"/></h2>
        <div class="nectarBanner__subText h-space-5">
        <p class="h-space-3"><spring:theme code="text.nectarpoints.collect.page.details"/></p>
        <p class="h-space-3"><spring:theme code="text.nectarpoints.collect.page.pleasenote"/></p>
        <p><a href="https://www.nectar.com/register/business/enrol.htm" class="nectarBanner__subText--bold h-space-4" target="_blank"><spring:theme code="text.nectarpoints.collect.page.nocard"/>&nbsp;<spring:theme code="text.nectarpoints.collect.page.signup.here"/></a></p>
        </div>
        </div>


         <div class="col-xs-12">
         			<form:form method="post" modelAttribute="collectNectarForm" action="${contextPath}/nectar-points/link-your-account" cssClass="site-form js-formValidation">
         				<nectar:businessDetails isActive="true" sectionName="business-details" nextSectionName="contact-details"/>
         				<nectar:contactDetails sectionName="contact-details" nextSectionName="manage-your-brakes-account-details"/>
         				<nectar:manageYourBrakesAccount sectionName="manage-your-brakes-account-details" nextSectionName="your-details"/>
         				<nectar:yourDetails sectionName="your-details"/>
         			</form:form>
         </div>
    </div>
        </div>

</div>