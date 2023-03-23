<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="galleryImages" required="true" type="java.util.List" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>

<div class="pdp__gallery">

<c:set var="mediaList">
[<c:forEach items="${galleryImages}" var="container" varStatus="varStatus"><c:set var="mediaType" value="i" /><c:set var="imgUrl" value="${container.product.cleanUrl}" /><c:if test="${not empty container.video}"><c:set var="mediaType" value="v" /><c:set var="imgUrl" value="${container.video.cleanUrl}" /></c:if><c:set var="replaceString" value="https://i1.adis.ws/${mediaType}/Brakes/" /><c:set var="imgName" value="${fn:replace(imgUrl,replaceString, '')}" />{"type": "${mediaType}", "name": "${imgName}"}<c:if test="${!varStatus.last}">,</c:if></c:forEach>]
</c:set>
   <c:choose>
      <c:when test="${product.estimatedPrice != null}">
         <div id="amp-container" class="viewer-kit-target" data-product-summary="${product.summary}" data-product-name="${product.name}" data-product-price="${product.estimatedPrice.formattedValue}"></div>
      </c:when>
      <c:otherwise>
         <div id="amp-container" class="viewer-kit-target" data-product-summary="${product.summary}" data-product-name="${product.name}" data-product-price="${product.price.formattedValue}"></div>
      </c:otherwise>
   </c:choose>
</div>


<c:if test="${not empty galleryImages && fn:length(galleryImages) > 0}">
<script>
  window.brakesAmpSet = "${product.code}_set";

  window.ecommBridge = {};

  window.ecommBridge.site = {
    page: {
      type: "product",
      name: window.brakesAmpSet,
      mediaSet: window.brakesAmpSet,
      mediaList: ${mediaList}
    }
  };
</script>
</c:if>
