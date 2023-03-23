<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement"
	tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
	<div class="text-left" data-id="user-details">
		<h1 class="nav-popup__main-heading">
			<spring:theme code="navPopUp.myorders.heading" />
		</h1>
		<hr />

		<div class="account-dropdown__views">
			<a href="/my-account/orders" class="h-space-1 center-block" title="<spring:theme code='navPopUp.myorders.orderHistory' />">
				<spring:theme code="navPopUp.myorders.orderHistory" />
			</a>
			<a href="/my-account/recent-purchased-products" title="<spring:theme code='navPopUp.myorders.recentPurchases' />">
				<spring:theme code="navPopUp.myorders.recentPurchases" />
			</a>
			<hr/>
			<h2 class="nav-popup__sub-heading" title="<spring:theme code='navPopUp.myorders.myActiveOrders' />">
				<a href="/my-account/orders"><spring:theme code="navPopUp.myorders.myActiveOrders" /></a>
			</h2>
			<div class="js-amendebleOrdersTarget"><%-- Injected Content --%></div>
		</div>
	</div>


	<script id="amendeble-orders-template" type="text/x-handlebars-template">
		{{#ifCond orders.length '>' 0}}
			{{#each orders}}
				<div class="amendeble-order h-topspace-2 h-space-3">
					<div class="row">
						<div class="col-xs-8">
							<div class="amendeble-order__order">{{code}}</div>
							<div class="amendeble-order__delivery-date">{{deliveryDate}}</div>
						</div>
						<div class="col-xs-4">
							<div class="mini-cart-icon amendeble-order__bag">
								<span class="icon icon-basket"></span>
								<span class="amendeble-order__unit-count">{{totalUnitCount}}</span>
							</div>
							<div class="amendeble-order__total">{{total.formattedValue}}</div>
						</div>
					</div>
					{{#ifCond amendable '==' false}}
					   <a class="btn btn-secondary h-topspace-1" href="/my-account/order/{{code}}"><spring:theme code="navPopUp.myorders.view.details" /></a>
					{{else}}
					    <a class="btn btn-secondary h-topspace-1" href="/my-account/start/amending/order/{{code}}"><spring:theme code="navPopUp.myorders.viewAmend" /></a>
					{{/ifCond}}
				</div>
				<hr />
			{{/each}}

			{{#ifCond orders.length '>' minCount}}
				<a class="btn btn-secondary h-topspace-1" href="/my-account/orders?sort=byLastTwelveMonths&status=CONFIRMED&status=QUEUED&status=WAITING_FOR_CONFRMATION&status=CONFIRMED_AND_MODIFIED">
                    <spring:theme code="navPopUp.myorders.viewMore" />
                </a>
			{{/ifCond}}

		{{else}}
			<hr/>
			<p style="color:#757575"><spring:theme code="navPopUp.myorders.noOrders" /></p>
		{{/ifCond}}
	</script>
</sec:authorize> 
