<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ attribute name="calcId" required="true" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>

<%@ attribute name="isActive" required="true" type="java.lang.Boolean"%>

<div class="customer-tools__calculator js-calculator ${isActive ? 'is-active' : '' } ${customCSSClass}" data-id="${calcId}">
  <div class="tools-panel">
    <h2 class="tools-panel__heading"><spring:theme code="customerTools.${calcId}.heading"/></h2>
    <div class="tools-panel__main">
      <form id="${calcId}" class="form tools-panel__form js-toolsForm js-formValidation">
        <%-- Column left --%>
        <div class="customer-tools__calculator-left col-xs-6 col-sm-4">
          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="menuPrice" 
            htmlType="text"
            mandatory="true"
            inputType="plate-cost"
            validationType="unitPrice"
            showPlaceholder="true" />

          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="accompanientCost1" 
            htmlType="text"
            mandatory="false"
            inputType="accompaniment-cost"
            validationType="unitPrice"
            showPlaceholder="true" />
          <div class="js-accompanimentsList">
          </div>

          <div class="form-group tools-panel__formgroup site-form__formgroup">
            <div class="site-form__inputgroup ">
              <label class="tools-panel__form-label tools-panel__form-label--add-cost">     
                <spring:theme code="customerTools.costPriceToMenuPrice.addRemoveaccompanients.label"/>
              </label>
              <div class="form-control tools-panel__form-control tools-panel__form-control--add-cost">
                <span class="js-formAction js-formAction icon icon-minus" data-action="remove-cost" data-parent="${calcId}"></span> 
                <span class="js-formAction icon icon-plus" data-action="add-cost" data-parent="${calcId}"></span>
              </div>
            </div>
          </div>
          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="marginRequired" 
            htmlType="text"
            mandatory="true"
            inputType="margin"
            validationType="marginRequired"
            showPlaceholder="true" />
        
        </div>

        <%-- Column center --%>
        <div class="customer-tools__calculator-center col-xs-4 hidden-xs p-0">
         <div class="icon icon-calculator1 customer-tools__icon customer-tools__icon--large"></div>
          <button type="submit" class="btn btn-primary tools-panel__btn js-formAction js-submitBtn hidden-xs" data-action="calculate" data-parent="${calcId}">
            <spring:theme code="customerTools.button.calculate" />
          </button>
        </div>

        <%-- Column right --%>
        <div class="customer-tools__calculator-right col-xs-6 col-sm-4">
          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="totalPriceFood" 
            htmlType="text"
            readonly="true"
            inputType="total-price-food"
            validationType="unitPrice"
            showPlaceholder="true" />

          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="menuPriceExVat" 
            htmlType="text"
            readonly="true"
            inputType="menu-price-ex-vat"
            validationType="unitPrice"
            showPlaceholder="true" />

          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="grossProfitExtVat" 
            htmlType="text"
            readonly="true"
            inputType="gross-profit-ex-vat"
            validationType="unitPrice"
            showPlaceholder="true" />

          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="vat" 
            htmlType="text"
            readonly="true"
            inputType="vat-only"
            validationType="unitPrice"
            showPlaceholder="true" />
        </div>
        <div class="customer-tools__calculator-bottom">
          <button type="submit" class="btn btn-primary btn--centered tools-panel__btn js-formAction js-submitBtn visible-xs" data-action="calculate" data-parent="${calcId}">
            <spring:theme code="customerTools.button.calculate" />
          </button>
          <div class="customer-tools__seperator"></div>
          <div class="customer-tools__results">
            <span class="tools-panel__large-text">
              <spring:theme code="customerTools.${calcId}.menuPriceIncVat" />
              <span class="js-finalCalc js-calcPrice" data-parent="${calcId}"><spring:theme code="customerTools.${calcId}.menuPriceIncVat.price" /></span>
            </span>
          </div>
          <button type="button" class="btn btn-default custom-button--default tools-panel__btn js-formAction" data-action="reset" data-parent="${calcId}">
            <spring:theme code="customerTools.button.reset" />
          </button>
        </div>
      </form>
    
    </div>
  </div>
</div>

<script id="accompaniment-cost-template" type="text/x-handlebars-template">
  <div class="form-group tools-panel__formgroup site-form__formgroup js-formGroup">
    <div class="site-form__inputgroup js-inputgroup">
      <label class="tools-panel__form-label" for="costPriceToMenuPriceaccompanientCost{{counter}}" data-error-empty="<spring:theme code='error.empty.costPriceToMenuPrice.accompanientCost'/>" data-error-invalid="<spring:theme code='error.invalid.costPriceToMenuPrice.accompanientCost'/>">
        <spring:theme code="customerTools.costPriceToMenuPrice.accompanientCost.label" arguments="${'{{counter}}'}"/>
        </label>

      <input type="text" id="costPriceToMenuPriceaccompanientCost{{counter}}" class="form-control tools-panel__form-control js-formField js-formInput" tabindex="" data-validation-type="unitPrice" data-input-type="accompaniment-cost" data-parent="costPriceToMenuPrice" placeholder="<spring:theme code='placeholder.text.costPriceToMenuPrice.accompanientCost' />">

      <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
      </div>
  </div>
</script>