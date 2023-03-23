<%@ attribute name="itemOrder" required="true" type="java.lang.String" %>
<%@ attribute name="itemIndex" required="true" type="java.lang.String" %>
<%@ attribute name="saleableUnitsHeight" required="false" type="java.lang.Double" %>
<%@ attribute name="saleableUnitsLength" required="false" type="java.lang.Double" %>
<%@ attribute name="saleableUnitsWidth" required="false" type="java.lang.Double" %>
<%@ attribute name="classification" required="true" type="java.lang.Object" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:set var="classificationHasValidFeatures">
	<product:accordionShowValidClassification classification="${classification}"/>
</c:set>

<c:if test="${classificationHasValidFeatures}">
  <div class="accordion js-accordionItem" data-order="${itemOrder}">
    <div class="accordion__heading" role="tab" id="heading${itemIndex}">
      <h4 class="accordion__title collapsed" role="button" data-toggle="collapse" data-parent="#accordion" data-target="#collapse${itemIndex}" aria-expanded="false" aria-controls="collapse${itemIndex}">
        ${fn:escapeXml(classification.name)}
        <span class="accordion__chevron icon icon-chevron-down"></span>
      </h4>
    </div>
    <div id="collapse${itemIndex}" class="js-pdpAccordionCollapse accordion__collapse collapse" role="tabpanel" aria-labelledby="heading${itemIndex}">
      <div class="accordion__body accordion--strong">
        <c:choose>
          <c:when test="${classification.code eq 'handlingAndCooking'}">
            <product:accordionCookingInstructions classification="${classification}"/>
          </c:when>
          <c:when test="${classification.code eq 'productPackingInfo'}">
            <product:accordionPackingInfo saleableUnitsHeight="${product.saleableUnitsHeight}" saleableUnitsLength="${product.saleableUnitsLength}" saleableUnitsWidth="${product.saleableUnitsWidth}"  classification="${classification}"/>
          </c:when>
          <c:when test="${classification.code eq 'nutrition'}">
            <product:accordionNutrition classification="${classification}"/>
          </c:when>
          <c:when test="${classification.code eq 'ingredientsAndAllergens'}">
            <product:accordionIngredientsAndAllergens classification="${classification}"/>
          </c:when>
          <c:otherwise>
            <product:accordionDefault classification="${classification}"/>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</c:if>
