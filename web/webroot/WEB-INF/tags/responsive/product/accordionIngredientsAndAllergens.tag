<%@ attribute name="classification" required="true" type="java.lang.Object" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<c:forEach items="${classification.features}" var="feature">
  <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
    <c:choose>
        <c:when test="${value.value eq true || value.value eq '-'}">
           <!-- AT THE MOMENT DON'T SHOW THIS VALUE IN STOREFRONT-->
            <%--${feature.name}--%>
        </c:when>
        <c:when test="${fn:containsIgnoreCase(feature.name, 'ingredients')}">
          <p><spring:theme code="productDetails.ingredients.first.text"/>: ${value.value}</p>
        </c:when>
        <c:when test="${fn:containsIgnoreCase(feature.name, 'contains')}">
          <c:if test="${!fn:containsIgnoreCase(value.value, 'food allergens')}">
            <p><spring:theme code="productDetails.ingredients.allergens"/></p>
          </c:if>
          <p>${feature.name} : ${value.value}</p>
        </c:when>
        <c:otherwise>
            <p>${feature.name} : ${value.value}</p>
          </c:otherwise>
    </c:choose>
  </c:forEach>

</c:forEach>
