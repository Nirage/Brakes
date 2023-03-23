<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<spring:theme var="promoComplexMsgPart2" code="promo.complex.popup.msg.part2"/>

<components:modal id="promoComplexInfoModal" title="<div class='js-complexPromoTitleDest hide'></div>" customCSSClass="cart-modal cart-modal--lg cart-modal--promo js-cartModal">
    <c:choose>
        <c:when test="${not empty promoComplexMsgPart2 && fn:length(promoComplexMsgPart2) gt 0}">
            <p><spring:theme code="promo.complex.popup.msg.part1"/><span class="js-promoComplexMsgEllipses">...</span><p>
            <div class="js-promoComplexMsgMore cart-modal__read"><spring:theme code="promo.complex.popup.readMore" /></div>
            <div class="js-promoComplexMsgPart2 hide">
                ${promoComplexMsgPart2}
            </div>
            <div class="js-promoComplexMsgLess hide cart-modal__read"><spring:theme code="promo.complex.popup.readLess" /></div>
        </c:when>
        <c:otherwise>
            <spring:theme code="promo.complex.popup.msg.part1"/>
        </c:otherwise>
    </c:choose>
</components:modal>