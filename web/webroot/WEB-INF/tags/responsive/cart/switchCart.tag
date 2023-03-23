<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="savedCartCount" required="true" type="java.lang.String"%>
<%@ attribute name="savedCarts" required="true" type="java.util.ArrayList" %>
<%@ attribute name="labelCode" required="true" type="java.lang.String"%>
<%@ attribute name="cart" required="true" type="java.lang.Object"%>

<button class="btn btn-secondary btn--full-width switch-baskets">
    <span class="switch-baskets__left">
        <span class="icon icon-switch-basket"></span>
        <span class="switch-baskets__total">${savedCartCount}</span>
    </span>
    <span><spring:theme code="${labelCode}" /></span>
    <span class="icon icon-chevron-down icon--sm"></span>
</button>
<select id="savedCarts" name="savedCarts" class="form-control site-form__select js-savedCarts">
    <c:choose>
        <c:when test="${ fn:length(savedCarts) eq 1 && (fn:escapeXml(cart.code) eq fn:escapeXml(savedCarts[0].code))}"> 
            <option disabled selected value>
                <spring:theme code="basket.select.option.switchBaskets" />
            </option>
        </c:when>
        <c:otherwise>
            <option disabled selected value>
                <spring:theme code="basket.select.option.switchBaskets" />
            </option>
            <c:forEach items="${savedCarts}" var="savedCart">
                <option value="${fn:escapeXml(savedCart.code)}" data-url="/my-account/saved-carts/${savedCart.code}/restore">
            ${fn:escapeXml(savedCart.code)}
                </option>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</select>