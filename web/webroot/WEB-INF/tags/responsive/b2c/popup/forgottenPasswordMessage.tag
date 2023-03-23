<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="b2c__route hide js-b2cRoute" id="b2c__router--forgotten-password-message">
  <%-- Title --%>
  <h2 class="b2c-forgotten-password-message__title">
    <spring:message code="b2c.pop.forgotten.password.message.title"/>
  </h2>
  <%-- Text --%>
  <div class="b2c-forgotten-password-message__form--outter">
    <div class="b2c-forgotten-password-message__form--inner">
      <spring:message code="b2c.pop.forgotten.password.message.text"/>
    </div>
  </div>
  <%-- Back to login button --%>
  <div class="col-xs-12">
    <div class="btn b2c-forgotten-password-message__cta b2c-forgotten-password-message__cta--back js-b2cForgottenPasswordMessageBtn">
      <span class="icon icon-chevron-left b2c-forgotten-password-message__cta--back-icon"></span>
      <spring:theme code="b2c.pop.forgotten.password.message.back.cta"/>
    </div>
  </div>
</div>