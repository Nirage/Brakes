<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ attribute name="calcOneId" required="false" type="java.lang.String"%>
<%@ attribute name="calcTwoId" required="false" type="java.lang.String"%>
<%@ attribute name="calcThreeId" required="false" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>


<div class="tools-panel ${customCSSClass}">
  <h2 class="tools-panel__heading tools-panel__heading--align-horiz tools-panel__heading--mobile-centered"><spring:theme code="customerTools.calculatorSelector.heading" /></h2>
  <div class="row">
    <div class="col-xs-12 col-sm-4">
      <button class="btn btn-primary tools-panel__btn tools-panel__btn--selector js-formAction" data-action="switch-calculator" data-calculator-id="${calcOneId}"><spring:theme code="customerTools.calculatorSelector.option1" /></button>
    </div>
    <div class="col-xs-12 col-sm-4">
    <button class="btn btn-default custom-button--default tools-panel__btn tools-panel__btn--selector js-formAction" data-action="switch-calculator" data-calculator-id="${calcTwoId}"><spring:theme code="customerTools.calculatorSelector.option2" /></button>
    </div>
    <div class="col-xs-12 col-sm-4">
      <button class="btn btn-default custom-button--default tools-panel__btn tools-panel__btn--selector js-formAction" data-action="switch-calculator" data-calculator-id="${calcThreeId}"><spring:theme code="customerTools.calculatorSelector.option3" /></button>
    </div>
  </div>
</div>