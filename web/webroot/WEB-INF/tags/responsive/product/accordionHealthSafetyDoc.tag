<%@ attribute name="itemOrder" required="true" type="java.lang.String" %>
<%@ attribute name="product" required="true" type="java.lang.Object" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${product.guidanceSheet || product.safetyDataSheet}" >						
  <div class="accordion js-accordionItem" data-order="${itemOrder}">
    <div class="accordion__heading " role="tab" id="accordionHeadingSafetyDoc">
      <h4 class="accordion__title collapsed" role="button" data-toggle="collapse" data-parent="#accordion1" data-target="#accordionCollapseSafetyDoc" aria-expanded="false" aria-controls="accordionHeadingSafetyDoc">
     <spring:theme code="productDetails.healthSafty.heading" />
      <span class="accordion__chevron icon icon-chevron-down"></span>
      </h4>
    </div>
		<div id="accordionCollapseSafetyDoc" class="js-pdpAccordionCollapse accordion__collapse collapse" role="tabpanel" aria-labelledby="accordionHeadingSafetyDoc">
			<div class="accordion__body">
        <div class="row">
          <c:if test="${product.guidanceSheet}">
            <div class="col-xs-12 col-sm-6">
              <h5 class="accordion__section-heading"><spring:theme code="productDetails.productGuidanceSheet.heading" /></h5>
              <a href="<spring:theme code='productDetails.productGuidanceSheet.link' arguments='${product.code}' />" target="_blank" class="btn btn-primary btn--has-icon">
                <div class="btn__text-wrapper">
                  <span class="btn__icon icon icon-download"></span>
                  <span class="btn__text"><spring:theme code="productDetails.productGuidanceSheet.download" /></span>
                </div>
              </a>
            </div>
          </c:if>
          <c:if test="${product.safetyDataSheet}">
            <div class="col-xs-12 col-sm-6">
              <h5 class="accordion__section-heading"><spring:theme code="productDetails.safetyDataSheet.heading" /></h5>
              <a href="<spring:theme code='productDetails.safetyDataSheet.link' arguments='${product.code}' />" target="_blank" class="btn btn-primary btn--has-icon">
                <div class="btn__text-wrapper">
                <span class="btn__icon icon icon-download"></span>
                <span class="btn__text"><spring:theme code="productDetails.safetyDataSheet.download" /></span>
                </div>
              </a>
            </div>
          </c:if>
          </div>
      </div>
    </div>
  </div>
</c:if>