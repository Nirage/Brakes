<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="nectar" tagdir="/WEB-INF/tags/responsive/nectar"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- First section. -->
<div class="container">
        <div>
        <h2 class="nectarBanner__title"><spring:theme code="text.nectarpoints.collect.bonus.page.title"/></h2>
        <p class="nectarBanner__subText"><spring:theme code="text.nectarpoints.collect.bonus.page.details"/></p>
        <p><a href="https://www.nectar.com/register/business/enrol.htm" class="nectarBanner__subText--bold h-space-4" target="_blank"><spring:theme code="text.nectarpoints.collect.page.nocard"/>&nbsp;<spring:theme code="text.nectarpoints.collect.page.signup.here"/></a></p>
        </div>

        <div class="col-xs-12">
           <form:form method="post" modelAttribute="collectNectarBonusForm" action="${contextPath}/nectar-points/bonus-points" cssClass="site-form js-formValidation">
             <nectar:bonusDetails sectionName="bonus-details"/>
           </form:form>
        </div>
        </div>
