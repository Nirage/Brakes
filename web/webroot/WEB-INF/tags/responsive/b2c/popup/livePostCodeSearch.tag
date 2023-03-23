<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%-- Live post code search | SCREEN --%>
<div class="b2c__route js-b2cRoute" id="b2c__router--postcode-search">
  <%-- Title --%>
  <h2 class="b2c-live-postcode-search__title">
    <spring:message code="b2c.pop.live.postcode.search.title"/>
  </h2>
  <%-- Search field --%>
  <div class="b2c-live-postcode-search__search-container--outter">
    <%-- Search icon, Input field and Label --%>
    <div class="b2c-live-postcode-search__search-container--inner">
      <span class="icon icon-search b2c-live-postcode-search__icon"></span>
      <input id="b2c-live-postcode-search__input" type="text" class="b2c-al__text-field--with-background b2c-al__text-field--rounded js-b2bLocationInput" chars="0-9a-zA-Z" data-unit="undefined" required />
      <label for="b2c-live-postcode-search__input" placeholder="<spring:message code='b2c.pop.live.postcode.search.input.placeholder'/>"></label>
    </div>
    <%-- Search results --%>
    <ul class="b2c-live-postcode-search__results hide js-b2bListOfUnits">
      <c:forEach var="item" items="${b2cUnits}">
        <li class="b2c-live-postcode-search__unit js-b2bUnit" data-name="${item.name}">
          <span class="b2c-live-postcode-search__unit-name">${item.name}</span>
          <span class="b2c-live-postcode-search__unit-cta js-selectB2bUnit" data-name="${item.name}" data-id="${item.uid}">
            <spring:message code="b2c.pop.guest.customer.b2bunit.location.cta"/>
          </span>
        </li>
      </c:forEach>
    </ul>
    <%-- No results message --%>
    <div class="b2c-live-postcode-search__no-results hide js-b2bListOfUnitsEmpty">
        <spring:message code='b2c.pop.guest.customer.b2bunit.location.unavailable'/>
    </div>
    <%-- Button wrapper --%>
    <div class="b2c__margin-top--20 b2c-live-postcode-search__buttons-wrapper">
      <%-- Sign-in button --%>
      <div class="col-xs-6">
        <button class="col-xs-6 btn b2c-live-postcode-search__button b2c-live-postcode-search__button--login js-b2cPopUpLoginBtn">
          <spring:message code="b2c.pop.guest.customer.signin.cta"/>
        </button>
      </div>
      <%-- Sign-up button --%>
      <div class="col-xs-6">  
        <button class="col-xs-6 btn b2c-live-postcode-search__button b2c-live-postcode-search__button--disabled b2c-live-postcode-search__button--sign-up" disabled>
          <spring:theme code="b2c.pop.signup.cta"/>
        </button>
      </div>
    </div>
  </div>
</div>