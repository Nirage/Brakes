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
<script id="a4-menus-template" type="text/x-handlebars-template">
  {{#each this}}
 	<div class="h-space-3 order-sel__sectionHeading order-sel__bordered order-sel__para js-menuSectionEntry">	
		<div class="row">
      <div class="col-xs-12 col-sm-5">
        <div class="custom-txtbox">
          <div class="site-form__formgroup form-group js-formGroup">
            <label class="order-sel__sectionHeading--label h-space-2" for=""><spring:theme code="orderSELsAndPOS.a4menus.header.code" /></label>
            <div class="site-form__inputgroup js-inputgroup">
              <input id="products[{{id}}].code" data-id="{{id}}" name="products[{{name}}].code" class="form-control site-form__input order-sel__gap order-sel__input is-optional js-productCodeMenu js-rowEntryProductCode" value="{{productVal}}" autocomplete="noautocomplete" placeholder="<spring:theme code="placeholder.text.orderSELAndPOS.productcode" />"">
            </div>	
          </div>
        </div>
      </div>
      <div class="col-sm-5 col-xs-12">
        <div class="custom-txtbox">
          <div class="site-form__formgroup form-group js-formGroup">
            <label class="order-sel__sectionHeading--label h-space-2" for="products[{{id}}].singlePrice" data-error-empty="error.empty." data-error-invalid="error.invalid.">
              <spring:theme code="orderSELsAndPOS.a4menus.header.rrp" /></label>
            <div class="site-form__inputgroup js-inputgroup ">
             <input id="products[{{id}}].singlePrice" data-id="{{id}}"  name="products[{{name}}].singlePrice" class="form-control site-form__input order-sel__input is-optional js-rrpMenu js-rowEntryRrp" value="{{rrpVal}}" autocomplete="noautocomplete" placeholder="<spring:theme code="placeholder.text.orderSELAndPOS.rrp" />"">
            </div>
          </div>
       </div>
      </div>
    </div> 
   	<input type="hidden" id="products[{{id}}].selected" name="products[{{name}}].selected"  value="false" class="js-posFieldSelectedMenu">
  </div>
  {{/each}}
</script>