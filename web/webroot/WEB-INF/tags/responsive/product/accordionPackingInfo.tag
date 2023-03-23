<%@ attribute name="classification" required="true" type="java.lang.Object" %>
<%@ attribute name="saleableUnitsHeight" required="false" type="java.lang.Double" %>
<%@ attribute name="saleableUnitsLength" required="false" type="java.lang.Double" %>
<%@ attribute name="saleableUnitsWidth" required="false" type="java.lang.Double" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<p>
  <c:forEach items="${classification.features}" var="feature" varStatus="featureIndex">
    <c:set var="displayFeature" value="true" />
    <c:if test="${fn:contains(feature.code, 'units_length')}">
      <c:set var="displayFeature" value="false" />
      <c:forEach items="${feature.featureValues}" var="value" >
        <c:set var="unitLength" value="${value.value}" />
      </c:forEach> 
    </c:if>
    <c:if test="${fn:contains(feature.code, 'units_width')}">
      <c:set var="displayFeature" value="false" />
      <c:forEach items="${feature.featureValues}" var="value">
        <c:set var="unitWidth" value="${value.value}" />
      </c:forEach> 
    </c:if>
    <c:if test="${fn:contains(feature.code, 'units_height')}">
      <c:set var="displayFeature" value="false" />
      <c:forEach items="${feature.featureValues}" var="value">
        <c:set var="unitHeight" value="${value.value}" />
      </c:forEach> 
    </c:if>
    <c:if test="${displayFeature}">
      <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
         <c:choose>
            <c:when test="${value.value eq true}">
              ${feature.name}
            </c:when>
            <c:otherwise>
                 <c:if test="${not empty value.value && value.value ne '-'}">
                    ${feature.name}:
                    ${fn:escapeXml(value.value)}
                       <c:choose>
                          <c:when test="${feature.range}">
                              ${not status.last ? '-' : fn:escapeXml(feature.featureUnit.symbol)}
                           </c:when>
                          <c:otherwise>
                             ${fn:escapeXml(feature.featureUnit.symbol)}${not status.last ? '<br/>' : ''}
                          </c:otherwise>
                       </c:choose>
                       ${not featureIndex.last ? '<br/>' : ''}
                  </c:if>
            </c:otherwise>
          </c:choose>
          
       </c:forEach>
        
    </c:if>
  </c:forEach>
</p>

<c:if test="${not empty saleableUnitsHeight && not empty saleableUnitsLength && not empty saleableUnitsWidth}" >
  <p><spring:theme code="productDetails.productPackagingInfo.case.heading"/></p>
  <p>${saleableUnitsLength} x ${saleableUnitsWidth} x ${saleableUnitsHeight} <spring:theme code="productDetails.productPackagingInfo.case.dimention.unit"/></p>
</c:if>