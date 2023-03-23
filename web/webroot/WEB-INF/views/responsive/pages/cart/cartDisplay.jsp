<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<spring:htmlEscape defaultHtmlEscape="true"/>



<div class="cart">
    
    <div class="hidden-xs">
        <cart:cartHeader />
    </div>

    <c:if test="${empty isCheckoutPage }">
    <div class="cart__actions clearfix">
        <div class="row">
                <div class="col-xs-12 col-sm-8 col-md-6 hidden-xs">
                    <cart:quickOrder cssClass="quick-add--desktop"/>
                </div>
                <div class="col-xs-12 col-sm-4 col-md-6">
                    <button tabIndex="0" class="cart__clear-items hidden-xs hidden-sm" type="button" data-toggle="modal" data-target="#clearCartItems">
                        <c:if test="${not empty cartData.rootGroups}">
                            <span id="clear-cartitems-link" class="cart__clear-items-link" >
                                <spring:theme code="basket.page.clearitems"/>
                            </span>
                            <span class="icon icon-close icon--sm"></span>
                        </c:if>
                    </button>
                </div>
        </div>
    </div>
    </c:if>

    <c:if test="${not empty cartData.rootGroups}">
        <c:url value="${siteUid eq 'brakesfoodshop' ? '/checkout': '/checkout/step-one'}" var="checkoutUrl" scope="session"/>
        <c:url value="/quote/create" var="createQuoteUrl" scope="session"/>
        <c:url value="${continueUrl}" var="continueShoppingUrl" scope="session"/>
        <c:set var="showTax" value="false"/>
        <cart:cartItems cartData="${cartData}"/>
    </c:if>
    <c:if test="${empty cartData.rootGroups}">
        <cart:cartEmpty />
    </c:if>

</div>

<cart:ajaxCartTopTotalSection/>
<cart:favouritesListHandlebars />