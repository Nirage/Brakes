<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="b2c-checkout-delivery__navigation-wrapper">
  <%-- Progress step --%>
  <div class="b2c-checkout-delivery__navigation-step">
    <%-- Progress label | Begin --%>
    <div class="b2c-checkout-delivery__navigation-step--label">
      <spring:message code="b2c.delivery.popup.navigation.progress.step"/>
    </div>
    <%-- Progress label | End --%>

    <%-- Back | Begin --%>
    <div class="btn btn-primary b2c-checkout-delivery__navigation-step--back js-b2cCheckoutDeliveryProgressBarBack disabled">
      <span class="icon icon-chevron-left b2c-checkout-delivery__navigation-step--back-icon"></span>
    </div>
    <%-- Back | End --%>

    <%-- Add delivery address | Begin --%>
    <span class="js-b2cCheckoutDeliveryAdd hide">
      <button type="submit" value="Submit" class="btn btn-primary b2c-checkout-delivery__navigation-step--next js-bc2DeliveryAddBtn disabled">
        <spring:message code="order.quantity.popup.large.add"/>
      </button>
    </span>
    <%-- Add delivery address | End --%>

    <%-- Next | Begin --%>
    <span class="js-b2cCheckoutDeliveryNext">
      <div class="btn btn-primary b2c-checkout-delivery__navigation-step--next js-b2cCheckoutDeliveryProgressBarNext disabled">
        <spring:message code="b2c.delivery.popup.navigation.next.cta"/>
        <span class="icon icon-chevron-right b2c-checkout-delivery__navigation-step--next-icon"></span>
      </div>
    </span>
    <%-- Next | End --%>
  </div>
  <%-- Mandatory fields label | Begin --%>
  <p class="b2c-checkout-delivery__label--mandatory-fields">
    <spring:message code="b2c.delivery.popup.navigation.mandatory.fields.label"/>
  </p>
  <%-- Mandatory fields label | End --%>
</div>