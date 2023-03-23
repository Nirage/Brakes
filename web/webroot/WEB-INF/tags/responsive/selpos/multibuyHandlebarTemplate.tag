<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="selpos" tagdir="/WEB-INF/tags/responsive/selpos"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<script id="a3-a4-posters-template" type="text/x-handlebars-template">
  {{#each this}}
  <div class="h-space-3 order-sel__sectionHeading order-sel__para order-sel__bordered js-add-row-sectionParent js-multiSectionEntry col-xs-12">
 	<div class="row h-space-2">
    <div class="col-xs-12 col-sm-4">
        <div class="custom-txtbox">
          <div class="site-form__formgroup form-group js-formGroup">
            <label class="order-sel__sectionHeading--label h-space-1" for=""><spring:theme code="orderSELsAndPOS.a3a4posters.header.code" /></label>
            <div class="site-form__inputgroup js-inputgroup">
              <input id="products[{{id}}].code" data-id={{id}} name="products[{{name}}].code" class="form-control site-form__input order-sel__gap is-optional  js-productCodeMulti js-rowEntryProductCode" value="{{productVal}}" autocomplete="noautocomplete" placeholder="<spring:theme code="placeholder.text.orderSELAndPOS.productcode" />"">
            </div>	
          </div>
        </div>
      </div>		
        <div class="col-xs-12 col-sm-4">
      <div class="custom-txtbox">
        <div class="site-form__formgroup form-group"	>
          <label class="order-sel__sectionHeading--label h-space-1" ><spring:theme code="orderSELsAndPOS.a3a4posters.header.singleMultiPrice" /></label>
          <div class="control site-form__dropdown ">
           		<select id="products[{{id}}].multiPrice" data-id={{id}} name="products[{{name}}].multiPrice" class="form-control site-form__select js-multiPriceSelected js-rowEntryMultiPrice">
									<option value=""><spring:theme code="orderSELsAndPOS.input.option.select" /></option>
									<c:forEach items="${pageData.option.values}" var="option" varStatus="loopStatus">
                    {{#ifCond selectedMultiPriceVal '==' '${option}'}}
                    <option id="${loopStatus.index}" value="${option}" selected><spring:theme code="orderSELsAndPOS.option.${option}" /></option>
                    {{else}}
										<option id="${loopStatus.index}" value="${option}"><spring:theme code="orderSELsAndPOS.option.${option}" /></option>
                    {{/ifCond}}
									</c:forEach>
							</select>	
          </div>
        </div>
      </div>
    </div>
      <div class="col-sm-4 col-xs-12">
          <div class="custom-txtbox">
            <div class="site-form__formgroup form-group js-formGroup">
              <label class="order-sel__sectionHeading--label h-space-1" for="products[0].singlePrice" data-error-empty="error.empty." data-error-invalid="error.invalid.">
              <spring:theme code="orderSELsAndPOS.a3a4posters.header.rrp" /></label>
            <div class="site-form__inputgroup js-inputgroup ">
              <input id="products[{{id}}].singlePrice" data-id={{id}} name="products[{{name}}].singlePrice" class="form-control site-form__input order-sel__input is-optional  js-rowEntryRrp js-singlePriceSelected" value="{{rrpVal}}" autocomplete="noautocomplete" placeholder="<spring:theme code="placeholder.text.orderSELAndPOS.rrp" />"">
            </div>
          </div>
        </div>
    </div> 
  
  </div>
	<input  value="false" id="products[{{id}}].selected" name="products[{{name}}].selected"  class="js-posFieldSelectedMulti" type="hidden" />
</div>	
 {{/each}}
</script>