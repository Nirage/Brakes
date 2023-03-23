<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="b2c__route hide js-b2cRoute" id="b2c__router--sign-up-success">
  <%-- Title --%>
  <h2 class="b2c-signup-success__title">
    <spring:message code="b2c.pop.signup.success.title"/>
  </h2>
  <%-- Sign-up success  wrapper --%>
  <a href="/" class="btn btn-primary b2c-signup-success__cta js-b2cPopUpStartShopping">
    <spring:message code="b2c.pop.signup.success.cta"/>
  </a>
</div>