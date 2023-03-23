<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="title" value="order.unavailable.products.title" />

<components:modal id="unavailableProductsModal" title="${title}" customCSSClass="cart-modal cart-modal--lg">
    <p class="h-space-2"><spring:theme code="order.unavailable.products.msg"/></p>
    <c:forEach var = "unvailableProduct" items="${unavailableProducts}">
        <p>${unvailableProduct.code},${fn:substring(unvailableProduct.name, 0, 49)}..."</p>
    </c:forEach>
    <button class="btn btn-primary btn--full-width" data-dismiss="modal" aria-label="Close">
        <spring:theme code="order.unavailable.products.ok"/>
    </button>
</components:modal>