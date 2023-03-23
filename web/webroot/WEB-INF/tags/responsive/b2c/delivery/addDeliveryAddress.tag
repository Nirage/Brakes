<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="delivery" tagdir="/WEB-INF/tags/responsive/b2c/delivery"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%-- Overlay wrapper --%>
<div class="b2c-checkout-delivery__popup--overlay js-b2cDeliveryPopUpOverlay">
  <%-- Overlay inner --%>
  <div id="b2c__delivery-root" class="b2c-checkout-delivery__popup js-b2cDeliveryRoot">
    <%-- Title | Begin --%>
    <div class="b2c-checkout-delivery__title">
      <spring:message code="b2c.delivery.popup.title"/>
    </div>
    <%-- Title | End --%>

    <%-- Progress bar | Begin --%>
    <div class="b2c-checkout-delivery__progress-bar">
      <div class="b2c-checkout-delivery__progress-bar--inner js-b2cCheckoutDeliveryProgress"></div>
    </div>
    <%-- Progress bar | End --%>
    
    <%-- Add delivery address form | Begin --%>
    <form:form id="brakesGuestCheckoutForm" name="brakesB2cRegisterForm" action="/b2c-register/checkout-update-details" method="post" modelAttribute="brakesB2cRegisterForm" class="">
      <%-- Steps | Begin --%>
      <div class="b2c-checkout-delivery__steps">
        <%-- Step one --%>
        <delivery:addDeliveryAddressStepOne/>
        <%-- Step two --%>
        <delivery:addDeliveryAddressStepTwo/>
        <%-- Step three --%>
        <delivery:addDeliveryAddressStepThree/>
        <%-- Step four --%>
        <delivery:addDeliveryAddressStepFour/>
      </div>
      <%-- Steps | End --%>

      <%-- Bottom navigation | Begin --%>
      <delivery:addDeliveryAddressBottomNavigation/>
      <%-- Bottom navigation | End --%>   
    </form:form>
    <%-- Add delivery address form | End --%>
  </div>
</div>