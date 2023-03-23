<%@ attribute name="itemOrder" required="true" type="java.lang.String" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="accordion js-accordionItem" data-order="${itemOrder}">
    <div class="accordion__heading " role="tab" id="accordionHeaderDisclaimer">
      <h4 class="accordion__title collapsed" role="button" data-toggle="collapse" data-parent="#accordion2" data-target="#accordionCollapseDisclaimer" aria-expanded="false" aria-controls="accordionHeaderDisclaimer"><spring:theme code="productDetails.productDisclaimer.heading" />
      <span class="accordion__chevron icon icon-chevron-down"></span></h4>
    </div>
    <div id="accordionCollapseDisclaimer" class="js-pdpAccordionCollapse accordion__collapse collapse" role="tabpanel" aria-labelledby="accordionHeaderDisclaimer">
      <div class="accordion__body">
        <p><spring:theme code="productDetails.productDisclaimer.text"/></p>
      </div>
    </div>
  </div>