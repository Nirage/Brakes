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
<script id="till-card-template" type="text/x-handlebars-template">
  {{#each this}}
 	<div class="h-space-3 order-sel__sectionHeading order-sel__bordered order-sel__para js-tillCardSectionEntry">
			<div class="row">
				<div class="col-xs-12 col-sm-5 js-posFieldSection">
						<div class="custom-txtbox">
							<div class="site-form__formgroup form-group js-formGroup">
								<label class="order-sel__sectionHeading--label h-space-1" for=""><spring:theme code="orderSELsAndPOS.input.productcode" /></label>
								<div class="site-form__inputgroup js-inputgroup">
									<input id="products[{{id}}].code"  data-id={{id}}  name="products[{{id}}].code" class="form-control site-form__input order-sel__gap order-sel__input is-optional js-posField js-rowEntryProductCode" value="{{productVal}}" autocomplete="noautocomplete"  placeholder="<spring:theme code="placeholder.text.orderSELAndPOS.productcode" />">
								</div>	
							</div>
						</div>
						<input name="products[{{id}}].selected" id="products[{{id}}].selected"  value="false" type="hidden" class="js-posFieldSelected"/>

					</div>
        	<div class="col-xs-12 col-sm-5 js-posFieldSection">
						<div class="custom-txtbox">
							<div class="site-form__formgroup form-group js-formGroup">
								<label class="order-sel__sectionHeading--label h-space-1" for=""><spring:theme code="orderSELsAndPOS.input.productcode" /></label>
								<div class="site-form__inputgroup js-inputgroup">
									<input id="products[{{id2}}].code"  name="products[{{id2}}].code" class="form-control site-form__input order-sel__gap order-sel__input is-optional js-posField js-rowEntryProductCode1" value="{{productVal1}}" data-id={{id}} autocomplete="noautocomplete" placeholder="<spring:theme code="placeholder.text.orderSELAndPOS.productcode" />"">
								</div>	
							</div>
						</div>
						<input name="products[{{id2}}].selected" id="products[{{id2}}].selected" value="false" type="hidden" class="js-posFieldSelected" />
					</div>
    </div>
</div>
  {{/each}}
</script>