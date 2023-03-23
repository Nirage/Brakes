<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="selposConfirm" tagdir="/WEB-INF/tags/responsive/selpos/confirmation"%>
<%@ taglib prefix="selpos" tagdir="/WEB-INF/tags/responsive/selpos"%>

<div class="row">
    <div class="col-xs-12">
        <div class="site-header site-header--align-left">
            <h1 class="site-header__text site-header--align-left">${cmsPage.title}</h1>
            <span class="site-header__rectangle site-header__rectangle--align-left"></span>
            <p class="site-header__subtext order-sel__para"><spring:theme code="orderSELsAndPOSSubmit.description" /></p>
        </div>
	</div>

	<div class="col-xs-12 order-sel__bordered h-space-3">
	    <selpos:progressBar currentPosition="${orderPage.currentPosition+1}" type="${orderPage.order.type}" breadcrumbs="${orderPage.breadcrumbs}"/>
	</div>

	<div class="col-xs-6 col-xs-offset-3 col-sm-offset-0 col-sm-12">
		<div class="order-sel__title order-sel__title--center h-space-3"><spring:theme code="orderSELsAndPOSSubmit.confirmation.title" /></div>
	</div>

	<c:choose>
		<c:when test="${orderPage.order.option.type eq 'sels'}">
			<selposConfirm:sels order="${orderPage.order}"/>
		</c:when>
		<c:when test="${orderPage.order.option.type eq 'descriptive'}">
			<selposConfirm:descriptive order="${orderPage.order}"/>
		</c:when>
		<c:when test="${orderPage.order.option.type eq 'multibuy'}">
			<selposConfirm:multibuy order="${orderPage.order}"/>
		</c:when>
		<c:when test="${orderPage.order.option.type eq 'a3a4posters'}">
			<selposConfirm:a3a4posters order="${orderPage.order}"/>
		</c:when>
		<c:when test="${orderPage.order.option.type eq 'a4menus'}">
			<selposConfirm:a4menus order="${orderPage.order}"/>
		</c:when>
		<c:when test="${orderPage.order.option.type eq 'tillcards'}">
			<selposConfirm:tillcards order="${orderPage.order}"/>
		</c:when>
	</c:choose>

	<div class="col-xs-12 h-space-3">
		<div class="order-sel__title h-space-2"><spring:theme code="orderSELsAndPOSSubmit.confirmation.delivery.title" /></div>
		<div class="order-sel__subHeading column h-space-2">
			<div>${orderPage.order.firstName}&nbsp;${orderPage.order.surname}</div>
			<div>${orderPage.order.businessName}</div>
			<div>${orderPage.order.addressLine1}</div>
			<div>${orderPage.order.addressLine2}</div>
			<div>${orderPage.order.addressLine3}</div>
			<div>${orderPage.order.postcode}</div>
		</div>

		<form method="get" action="${contextPath}/my-country-choice/order-sels-and-pos">
			<button type="submit" class="btn btn-secondary btn-block"><spring:theme code="orderSELsAndPOSSubmit.orderMore" /></button>
		</form>
	</div>


</div>


