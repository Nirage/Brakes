<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="customerTools" tagdir="/WEB-INF/tags/responsive/customerTools"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>


<div class="page-gross-profit-calculator js-toolsGPC">
  <customerTools:gpcHeading />
  <div class="row">
    <div class="col-xs-12">
      <customerTools:vatSelector isCentered="${cmsSite.uid == 'brakes' ? 'true': 'false'}" />
    </div>
  </div>
  <div class="row">
    <c:choose>
      <c:when test="${cmsSite.uid == 'brakes'}">
        <div class="col-xs-12">
          <customerTools:calculatorsSelector calcOneId="menuPriceToCostPrice" calcTwoId="menuPriceAndCostPrice" calcThreeId="costPriceToMenuPrice" customCSSClass="centered"/>
          <customerTools:calculatorsContainer calcOneId="menuPriceToCostPrice" calcTwoId="menuPriceAndCostPrice" calcThreeId="costPriceToMenuPrice" customCSSClass="centered"/>
        </div>
      </c:when>
      <c:otherwise>
        <%-- Column left --%>
        <div class="col-xs-12 col-sm-6">
          <customerTools:calculatorFromCostToRrp formId="fromCostToRRP"/>
        </div>

        <%-- Column right --%>
        <div class="col-xs-12 col-sm-6">
          <customerTools:calculatorGrossProfit formId="grossProfit"/>
        </div>

      </c:otherwise>
    </c:choose>
  </div>

  <div class="row">
    <div class="col-xs-12">
      <customerTools:gpcDisclaimer/>
    </div>
  </div>
</div>