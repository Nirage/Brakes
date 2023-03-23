<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ attribute name="calcId" required="true" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>

<%@ attribute name="isActive" required="true" type="java.lang.Boolean"%>

<div class="customer-tools__calculator js-calculator ${isActive ? 'is-active' : '' } ${customCSSClass}" data-id="${calcId}">
  <div class="tools-panel">
    <h2 class="tools-panel__heading tools-panel__heading--align-horiz tools-panel__heading--mobile-centered"><spring:theme code="customerTools.${calcId}.heading"/></h2>
    <div class="tools-panel__main">
      <form id="${calcId}" class="form tools-panel__form js-toolsForm js-formValidation">
        <%-- Column left --%>
        <div class="customer-tools__calculator-left col-xs-6 col-sm-4">
          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="menuPrice" 
            htmlType="text"
            mandatory="true"
            inputType="menu-price"
            validationType="unitPrice"
            showPlaceholder="true" />
    
          <formElement:calculatorInputField 
            formId="${calcId}"
            idKey="costPriceExVat" 
            htmlType="text"
            mandatory="true"
            inputType="cost-price-ex-vat"
            validationType="unitPrice"
            showPlaceholder="true" />
        </div>
        <%-- Column center --%>
        <div class="customer-tools__calculator-center col-xs-4 hidden-xs p-0">
          <div class="icon icon-calculator1 customer-tools__icon customer-tools__icon--large"></div>
        </div>
        <%-- Column right --%>
        <div class="customer-tools__calculator-right col-xs-6 col-sm-4">
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
        </div>

        <div class="customer-tools__calculator-bottom">
          <button type="submit" class="btn btn-primary tools-panel__btn js-formAction js-submitBtn" data-action="calculate" data-parent="${calcId}">
            <spring:theme code="customerTools.button.calculate" />
          </button>
          <div class="customer-tools__seperator"></div>
            <div class="customer-tools__results">
              <span class="tools-panel__large-text">
                <spring:theme code="customerTools.${calcId}.calcText" />
                <span class="js-finalCalc js-calcPercentage" data-parent="${calcId}"><spring:theme code="customerTools.${calcId}.calcVal" /></span>
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