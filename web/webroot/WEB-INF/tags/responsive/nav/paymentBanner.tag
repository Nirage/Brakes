<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="status" value="${paymentCardStatus}" />
<c:choose>
	<c:when test="${status eq 'NOT_ADDED_BUT_MANDATORY'}">
		<c:set var="bannerCode" value="mydetails.payment.no.card.use.mandatory" />
		<c:set var="paymentBtnCode" value="mydetails.payment.add.card"/>
		<c:set var="cardIcon" value="icon-red-bank-card"/>
		<c:set var="action" value="Add payment card"/>
	</c:when>
	<c:when test="${status eq 'NOT_ADDED'}">
    	<c:set var="bannerCode" value="mydetails.payment.no.card.use" />
    	<c:set var="paymentBtnCode" value="mydetails.payment.add.card"/>
        <c:set var="cardIcon" value="icon-red-bank-card"/>
        <c:set var="action" value="Add payment card"/>
	</c:when>
	<c:when test="${status eq 'EXPIRED'}">
    	<c:set var="bannerCode" value="mydetails.payment.card.expiry" />
    	<c:set var="paymentBtnCode" value="mydetails.payment.update.card"/>
    	<c:set var="cardIcon" value="icon-red-bank-card"/>
		<c:set var="action" value="Update payment card"/>
	</c:when>
    <c:when test="${status eq 'ABOUT_TO_EXPIRE'}">
    	<c:set var="bannerCode" value="mydetails.payment.card.nearly.expiry" />
    	<c:set var="paymentBtnCode" value="mydetails.payment.update.card"/>
    	<c:set var="cardIcon" value="icon-orange-bank-card"/>
		<c:set var="action" value="Update payment card"/>
	</c:when>
	<c:when test="${status eq 'ADDED'}">
    	<c:set var="bannerCode" value="mydetails.payment.card.approved" />
    	<c:set var="paymentBtnCode" value="mydetails.payment.card.approved.button.label"/>
    	<c:set var="cardIcon" value="icon-green-bank-card"/>
		<c:set var="action" value="Update payment card"/>
	</c:when>
</c:choose>


<c:if test= "${not empty status && status ne 'APPROVED' && showPaymentBanner eq 'true'}">
<div class="payment-banner">
	<div class="row">
		<div class="col-xs-12 col-md-12 col-md-offset-0">
            <div class="payment-banner__section container js-paymentBanner">
				<div class="payment-banner__content payment-banner__content--left hidden-xs">
                   <span class="payment-banner__item icon ${cardIcon}"></span>
				   <span class="payment-banner__item"> <spring:theme code="${bannerCode}"></spring:theme></span>
				</div>
                <div class="visible-xs payment-banner__content--left">
                <div class="payment-banner__content ">
                    <span class="payment-banner__item icon ${cardIcon}"></span>
                    <span class="payment-banner__item"> <spring:theme code="${bannerCode}.mobile"></spring:theme></span>	
                </div>
                </div>
                <div class="payment-banner__content payment-banner__content--right">
                    <a class="btn btn-primary js-bannerSumbmitBtn" href="/mydetails?scrollTo=scrollToPayment" data-action="${status}" data-btnAction="${action}" tabindex="0" title="<spring:theme code="${paymentBtnCode}"></spring:theme>"><spring:theme code="${paymentBtnCode}"></spring:theme></a>
		    	</div>
            </div>
		</div>
	</div>
</div>
</c:if>
