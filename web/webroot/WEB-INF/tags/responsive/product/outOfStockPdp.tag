<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<c:set var="title" value="cart.quantity.popup.add.title" />
<div id="discontinuedInfo" class="discontinued__info__half  discontinued__info__noPadding js-outOfStockInfoSection hide">
   <button class="close js-outOfStockClosePdp" aria-hidden="true"  type="button">
        <span class="icon icon-close icon--sm"></span>
    </button>
    <div class="discontinued__infonoPadding">
        <p class="discontinued__sectionTitleLarge"><spring:theme code="outOfStock.info.title"/></p>
        <div class="discontinued__infoContent h-space-2">            
            <spring:theme code="outOfStock.info.content"/>
        </div>
        <a class="btn btn-secondary discontinued__btn btn--full-width js-outOfStockClosePdp">
            <spring:theme code="outOfStock.info.btn.pdp.text"/>
        </a>
    </div>
</div>