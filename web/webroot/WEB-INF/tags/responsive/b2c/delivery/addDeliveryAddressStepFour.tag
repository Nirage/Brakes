<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div id="b2c-checkout-delivery__step-four" class="b2c-checkout-delivery__step js-b2cCheckoutDeliveryStep hide">
  <%-- Distance--%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--30">
    <p class="b2c-checkout-delivery__slide-label b2c__margin-bottom--20">
      <spring:theme code="b2c.delivery.popup.slider.range.label"/>
      <span class="b2c-checkout-delivery__slide-distance js-checkoutDeliveryRangeSliderValue"></span>
    </p>
    <input 
      type="range" 
      id="distanceFromCarParking" 
      name="distanceFromCarParking"
      min="0" 
      max="100" 
      value="15" 
      step="5" 
      class="b2c-checkout-delivery__slider js-checkoutDeliveryRangeSlider"
    >
  </div>
  <%-- Door passcode --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20">
    <%-- Label --%>
    <p class="b2c-checkout-delivery__passcode-label">
      <spring:theme code="b2c.delivery.popup.passcode.label"/>
    </p>
    <%-- Passcode input --%>
    <input 
      id="b2cDeliveryPassCode" 
      name="communalDoorCode" 
      type="text" 
      class="b2c-al__text-field--optional js-adaptiveInputOptional" 
      value="" 
      autocomplete="noautocomplete"
      maxlength="10"
    >
    <%-- Placeholder --%>
    <label 
      class="b2c-al__label--optional js-adaptiveLabelOptional" 
      for="b2cDeliveryPassCode" 
      placeholder="Code (optional)">
    </label>
  </div>
  <%-- Terms and conditions --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--10">
    <label class="b2c-checkout-delivery__checkbox-container">
      <spring:theme code="b2c.delivery.popup.termsConditions"/>
      <input class="b2c-checkout-delivery__checkbox-field js-bc2DeliveryLegalCheckbox" type="checkbox">
      <span class="b2c-checkout-delivery__checkbox-label"></span>
    </label>
  </div>
  <%-- Privacy and policy --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20">
    <label class="b2c-checkout-delivery__checkbox-container">
      <spring:theme code="b2c.delivery.popup.privacyPolicy"/>
      <input class="b2c-checkout-delivery__checkbox-field js-bc2DeliveryLegalCheckbox" type="checkbox">
      <span class="b2c-checkout-delivery__checkbox-label"></span>
    </label>
  </div>
</div>