<%@ attribute name="itemOrder" required="true" type="java.lang.String" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="accordion js-accordionItem" data-order="${itemOrder}">
  <div class="accordion__heading " role="tab" id="accordionHeaderEmail">
   <h4 class="accordion__title collapsed" role="button"data-toggle="modal" data-target="#tradeCalculatorModal"> 
     <span class="icon icon-calculator btn__icon"></span>
     <spring:theme code="customerTools.tradeCalculator.button"/>
     <span class="accordion__chevron icon icon-chevron-down"></span>
   </h4>
  </div>
</div>

