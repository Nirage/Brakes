<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<c:set var="orderNumber" value="${orderData.code}" />

<link rel="stylesheet" type="text/css" media="all" href="/_ui/responsive/theme-brakes/css/loadingPage.bundle.css?${releaseVersion}" />

<div class="checkout-success" data-order="${orderNumber}">
	<div class="container loading-page">
		<div class="row">
			<div class="col-xs-12 flex align-items-center justify-content-center flex-direction-column p1">
				<div class="roller-cancel position-relative mb2">
					<div class="roller-cancel__lines position-absolute">
						<span class="loading-page__line loading-page__line--top"></span>
						<span class="loading-page__line loading-page__line--middle"></span>
						<span class="loading-page__line loading-page__line--bottom"></span>
					</div>
					<div class="roller-cancel__body flex"></div>
					<div class="roller-cancel__wheels position-absolute flex">
						<span class="loading-page__wheel loading-page__wheel--left"></span>
						<span class="loading-page__wheel loading-page__wheel--right"></span>
					</div>
					<div class="loading-page__shadow bg-primary"></div>
				</div>
				<div class="text-center">
					<div class="font-primary-bold font-size-2 mt2 text-center"><spring:theme code='checkout.orderConfirmation.cancellingInProgress.oos' /></div>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	const checkStatus = (response) => {
		return response && response != 'CANCELLING' && response != 'RETRYING_SEND_TO_ECC';
	};
	const clearIntervalsFn = () => {
		clearInterval(checkStatusCommonInterval);
		clearInterval(timeOutFnInterval);
	};
	const checkStatusCommonInterval = setInterval(function() { checkStatusCommon(checkStatus, clearIntervalsFn) }, 1000);
	const timeOutFnInterval = setInterval(function() { timeOutFn(clearIntervalsFn) } , 30000);
</script>