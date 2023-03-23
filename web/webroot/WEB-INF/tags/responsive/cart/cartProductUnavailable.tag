<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="title" value="basket.productunavailable.title" />
<components:modal id="cartProductUnavailableGenericModal" title="${title}" customCSSClass="cart-modal">
    <div class="clearfix">
        <p class="h-space-2 js-modalMessage"><spring:theme code="basket.productunavailable.abl"/></p>
        <c:if test="${not empty validationData}">
                    <p class="h-space-2 js-modalMessage">
                       <spring:theme code="basket.productid.unvailable"/>
                       <c:forEach items="${validationData}" var="cartModificationData" varStatus="loop">
                          ${cartModificationData.entry.product.code}
                          <c:if test="${!loop.last}">,</c:if>
                       </c:forEach>
                   </p>
        </c:if>
        <button type="button" class="btn btn-primary cart-modal__btn-center" data-dismiss="modal" aria-label="Close"><spring:theme code="basket.productunavailable.button"/></button> 
    </div>
</components:modal>

<c:set var="title" value="basket.productunavailable.title" />
<components:modal id="cartProductUnavailableModal" title="${title}" customCSSClass="cart-modal">
    <div class="clearfix">
        <p class="h-space-2"><spring:theme code="basket.productunavailable"/></p>
         <c:if test="${not empty validationData}">
            <p class="h-space-2 js-modalMessage">
               <spring:theme code="basket.productid.unvailable"/>
               <c:forEach items="${validationData}" var="cartModificationData" varStatus="loop">
                  ${cartModificationData.entry.product.code}
                  <c:if test="${!loop.last}">,</c:if>
               </c:forEach>
           </p>
          </c:if>
        <button type="button" class="btn btn-primary cart-modal__btn-center" data-dismiss="modal" aria-label="Close"><spring:theme code="basket.productunavailable.button"/></button> 
    </div>
</components:modal>