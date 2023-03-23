<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%-- Step three --%>
<div id="b2c-checkout-delivery__step-three" class="b2c-checkout-delivery__step js-b2cCheckoutDeliveryStep hide">
  <%-- Floors and steps access --%>
  <div class="col-xs-12 b2c__padding--none">
    <%-- Label --%>
    <div class="b2c-checkout-delivery__radio-button--label b2c__margin-bottom--10">
      <spring:theme code="b2c.delivery.popup.floors.restriction.label"/>
    </div>     
    <%-- Radio button | Yes --%>
    <div class="col-xs-6 b2c-checkout-delivery__radio-button--wrapper">
      <input id="floors-restrictions-yes" name="groundFloor" class="js-b2cDeliveryFormStepThree" type="radio" value="Yes">
      <label class="control-label " for="floors-restrictions-yes">
        <spring:theme code="b2c.delivery.popup.radio.button.yes"/>
      </label>
    </div>
    <%-- Radio button | No --%>
    <div class="col-xs-6 b2c-checkout-delivery__radio-button--wrapper">
      <input id="floors-restrictions-no" name="groundFloor" class="js-b2cDeliveryFormStepThree" type="radio" value="No">
      <label class="control-label " for="floors-restrictions-no">
        <spring:theme code="b2c.delivery.popup.radio.button.no"/>
      </label>
    </div>
  </div>
  <%-- Vehicle restrictions --%>
  <div class="col-xs-12 b2c__padding--none">
    <%-- Label --%>
    <div class="b2c-checkout-delivery__radio-button--label b2c__margin-top--20 b2c__margin-bottom--10">
      <spring:theme code="b2c.delivery.popup.vehicle.restriction.label"/>
    </div>     
    <%-- Radio button | Yes --%>
    <div class="col-xs-6 b2c-checkout-delivery__radio-button--wrapper">
      <input id="vehicle-restrictions-yes" name="vehicleRestriction" class="js-b2cDeliveryFormStepThree" type="radio" value="Yes">
      <label class="control-label " for="vehicle-restrictions-yes">
        <spring:theme code="b2c.delivery.popup.radio.button.yes"/>
      </label>
    </div>
    <%-- Radio button | No --%>
    <div class="col-xs-6 b2c-checkout-delivery__radio-button--wrapper">
      <input id="vehicle-restrictions-no" name="vehicleRestriction" class="js-b2cDeliveryFormStepThree" type="radio" value="No">
      <label class="control-label " for="vehicle-restrictions-no">
        <spring:theme code="b2c.delivery.popup.radio.button.no"/>
      </label>
    </div>
  </div>
  <%-- Large vehicles --%>
  <div class="col-xs-12 b2c__padding--none b2c__margin-bottom--20">
    <%-- Label --%>
    <div class="b2c-checkout-delivery__radio-button--label b2c__margin-top--20 b2c__margin-bottom--10">
      <spring:theme code="b2c.delivery.popup.large.vehicles.label"/>
    </div>     
    <%-- Radio button | Yes --%>
    <div class="col-xs-6 b2c-checkout-delivery__radio-button--wrapper">
      <input id="large-vehicles-yes" name="largeVehicleParking" class="js-b2cDeliveryFormStepThree" type="radio" value="Yes">
      <label class="control-label " for="large-vehicles-yes">
        <spring:theme code="b2c.delivery.popup.radio.button.yes"/>
      </label>
    </div>
    <%-- Radio button | No --%>
    <div class="col-xs-6 b2c-checkout-delivery__radio-button--wrapper">
      <input id="large-vehicles-no" name="largeVehicleParking" class="js-b2cDeliveryFormStepThree" type="radio" value="No">
      <label class="control-label " for="large-vehicles-no">
        <spring:theme code="b2c.delivery.popup.radio.button.no"/>
      </label>
    </div>
  </div>
</div>