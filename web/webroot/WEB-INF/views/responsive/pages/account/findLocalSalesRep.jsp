<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:url value="/localSalesRepResults/?postCode=" var="salesRepUrl" />
<div class="container">
  <div class="col-xs-12 h-space-3">
    <div class="sales-local ">
      <h1 class="sales-local__title"><spring:theme code="findLocalSales.title"/></h1>
      <div class="sales-local__text"><spring:theme code="findLocalSales.heading.discription"/></div>
        <ul class="sales-local__list">
          <li><spring:theme code="findLocalSales.discrition1"/></li>
          <li><spring:theme code="findLocalSales.discrition2"/></li>
          <li><spring:theme code="findLocalSales.discrition3"/></li>
          <li><spring:theme code="findLocalSales.discrition4"/></li>
          <li><spring:theme code="findLocalSales.discrition5"/></li>
        </ul>
      </div>
      <div class="sales-local__section-header">
        <spring:theme code="findLocalSales.postcodeform.heading"/>
      </div>
      <input type="hidden" value=${salesRepUrl} class="js-postcode-search-url"/>
      <form:form action="${salesRepUrl}" method="get" id="sales-local-form">
        <div class="input-group sales-local__input-group h-space-2">
          <input type="text" name="postCode" class="form-control site-search__input js-postcode-value" placeholder="<spring:theme code="salesRep.postcode.placeholder"/>" />
          <span class="input-group-btn site-search__submit">
            <button tabindex="0" type="submit" value="search" class="btn btn-link site-search__submit-btn site-search__submit-minbtn js-post-code-search">
            <span class="glyphicon glyphicon-search"></span></button>
          </span>
        </div>
        <span class="error-msg site-form__errormessage js-sales-postcode-err h-space-2 hide"><spring:theme code="salesRep.postCode.invalid"/></span>
        <span class="error-msg site-form__errormessage js-sales-postcode-no-results h-space-2 hide"><spring:theme code="salesRep.postcode.noResults"/></span>
      </form:form>
      <div class="clearfix" id="sales-local-data">
        
      </div> 
      <div class="js_spinner spinning-div">
          <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
      </div> 
    </div>
  </div>
</div>
<script id="sales-local-postcode-template" type="text/x-handlebars-template">
{{#each response}}
  <div class="sales-local__data">
    {{#if repName}}
      <div class="sales-local__name">{{repName}}</div>
    {{/if}}
    <div class="sales-local__info h-space-2"><spring:theme code="salesRep.results.data" arguments="{{phoneNumber}},{{email}}"/></div>
  </div>
{{/each}}
</script>