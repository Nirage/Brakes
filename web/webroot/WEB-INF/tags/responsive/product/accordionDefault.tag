<%@ attribute name="classification" required="true" type="java.lang.Object" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<table class="table">
  <tbody>
    <c:forEach items="${classification.features}" var="feature">
      <tr>
        <td class="attrib">${feature.name}</td>
        <td>
          <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
            ${value.value}
            <c:choose>
              <c:when test="${feature.range}">
                ${not status.last ? '-' : fn:escapeXml(feature.featureUnit.symbol)}
              </c:when>
              <c:otherwise>
                ${fn:escapeXml(feature.featureUnit.symbol)}
                ${not status.last ? '<br/>' : ''}
              </c:otherwise>
            </c:choose>
          </c:forEach>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>