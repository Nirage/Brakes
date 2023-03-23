
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ attribute name="customClass" required="false" type="java.lang.String" %>

<div class="cart-empty ${customClass}">
    <p class="cart-empty__text"><spring:theme code="cart.page.empty.message"/></p>
    <c:url value="/" var="homepage" />
    <a href="${homepage}" class="btn btn-primary"><spring:theme code="cart.page.empty.cta"/></a>
</div>
