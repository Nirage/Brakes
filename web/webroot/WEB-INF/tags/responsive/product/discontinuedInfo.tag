<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<c:set var="title" value="cart.quantity.popup.add.title" />
<div id="discontinuedInfo" class="discontinued__info js-discontinuedInfoSection hide">
   <button class="close js-discontinuedClose" aria-hidden="true"  type="button">
        <span class="icon icon-close icon--sm"></span>
    </button>
    <div class="discontinued__infoSection">
        <p class="discontinued__infoTitle"><spring:theme code="discontinued.info.title"/></p>
        <div class="discontinued__infoContent h-space-2">            
            <spring:theme code="discontinued.info.content"/>
        </div>
        <c:if test="${product.alternatives}">
            <div class="mb1 text-center"><spring:theme code="discontinued.check.alternatives"/></div>
            <a class="btn btn-primary discontinued__btn btn--full-width js-discontinuedSimilarBtn">
                <spring:theme code="discontinued.info.btn.text"/> 
            </a>
        </c:if>
        
    </div>
</div>