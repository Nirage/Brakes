<%@ attribute name="itemOrder" required="true" type="java.lang.String" %>
<%@ attribute name="showPromotionClass" required="true" type="java.lang.String" %>
<%@ attribute name="productCode" required="true" type="java.lang.String" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="accordion ${showPromotionClass} js-accordionItem" data-order="${itemOrder}" data-code="${productCode}">
    <div class="accordion__heading" role="tab" id="accordionHeaderPromoDisclaimer">
        <h4 class="accordion__title flex collapsed" role="button" data-toggle="collapse" data-parent="#accordion2" data-target="#accordionCollapsePromoDisclaimer" aria-expanded="false" aria-controls="accordionHeaderPromoDisclaimer">
        <span class="accordion__title-icon font-size-base">
          <span class="bg-promo-red br1 text-white text-uppercase text-bold p1-4 plr1-2"><spring:theme code="product.promotion.offer"></spring:theme></span>
        </span><spring:theme code="productDetails.promotionalDisclaimer.heading" />
            <span class="accordion__chevron icon icon-chevron-down"></span>
        </h4>
    </div>
    <div id="accordionCollapsePromoDisclaimer" class="js-pdpAccordionCollapse accordion__collapse collapse" role="tabpanel" aria-labelledby="accordionHeaderPromoDisclaimer">
        <div class="accordion__body">
            <p><spring:theme code="productDetails.promotionalDisclaimer.text"/></p>
        </div>
    </div>
</div>