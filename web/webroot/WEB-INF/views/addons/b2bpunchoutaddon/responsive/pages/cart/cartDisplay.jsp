<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="addoncart" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/cart" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty cartData.entries}">
    <c:url value="/cxml/requisition" context="${originalContextPath}/punchout" var="requisitionUrl"/>
    <c:url value="/cxml/cancel" context="${originalContextPath}/punchout" var="cancelUrl"/>
    <c:url value="${continueUrl}" var="continueShoppingUrl" scope="session"/>

    <div class="cart-wrapper">

        <div class="cart">

            <div class="hidden-xs">
                <addoncart:cartHeader />
            </div>

            <c:if test="${empty isCheckoutPage }">
            <div class="cart__actions clearfix">
                <div class="row">
                    <div class="col-xs-12 col-sm-6 hidden-xs">
                        <cart:quickOrder cssClass="quick-add--desktop"/>
                    </div>
                    <div class="col-xs-12 col-sm-6">
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

            <addoncart:cartItems cartData="${cartData}"/>
        </div>

    </div>
</c:if>
<cart:ajaxCartTopTotalSection/>
