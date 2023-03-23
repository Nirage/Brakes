<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ attribute name="formId" required="true" type="java.lang.String"%>

<div class="tools-panel">
  <h2 class="tools-panel__heading tools-panel__heading--align-horiz tools-panel__heading--mobile-centered"><spring:theme code="customerTools.fromCostToRrp.heading" /></h2>
  <form class="form tools-panel__form h-topspace-2 js-toolsForm js-formValidation " id="${formId}">
    <div class="form-group tools-panel__formgroup site-form__formgroup js-formGroup">
      <div class="site-form__inputgroup js-inputgroup">
        <label class="tools-panel__form-label" for="unitPrice" data-error-empty="<spring:theme code='customerTools.fromCostToRrp.unitPrice.error' />" data-error-invalid="<spring:theme code='customerTools.fromCostToRrp.unitPrice.invalid' />"><spring:theme code="customerTools.fromCostToRrp.unitPrice" /></label>
        <input type="text" class="form-control tools-panel__form-control js-formField js-formInput is-required" data-validation-type="unitPrice" data-input-type="unit-price" data-parent="${formId}" id="unitPrice" placeholder="&pound;00.00" />
        <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
      </div>
    </div>
    <div class="form-group tools-panel__formgroup site-form__formgroup js-formGroup">
      <div class="site-form__inputgroup js-inputgroup">
      <label class="tools-panel__form-label" for="marginRequired" data-error-empty="<spring:theme code='customerTools.fromCostToRrp.marginRequired.error' />" data-error-invalid="<spring:theme code='customerTools.fromCostToRrp.marginRequired.invalid' />">
      <spring:theme code="customerTools.fromCostToRrp.marginRequired" />
      </label>
      <input type="text" class="form-control tools-panel__form-control js-formField js-formInput is-required" data-validation-type="marginRequired" data-input-type="margin" data-parent="${formId}" id="marginRequired" placeholder="00%" />
      <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
      <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
      </div>
    </div>
    <div class="tools-panel__btns-group">
      <button type="button" class="btn btn-default custom-button--default tools-panel__btn js-formAction" data-action="reset" data-parent="${formId}"><spring:theme code="customerTools.button.reset"/></button>
      <button type="submit" class="btn btn-primary tools-panel__btn js-formAction js-submitBtn" data-action="calculate" data-parent="${formId}"><spring:theme code="customerTools.button.calculate"/></button>
    </div>
    <div class="tools-panel__section">
      <div class="row">
        <div class="col-xs-8"><spring:theme code="customerTools.fromCostToRrp.calculation.unitPrice"/></div>
        <div class="col-xs-4 text-right js-unitPriceCalc js-calcPrice"><spring:theme code="customerTools.fromCostToRrp.calculation.unitPrice.price"/></div>
      </div>
      <div class="row">
        <div class="col-xs-8"><spring:theme code="customerTools.fromCostToRrp.calculation.vat"/></div>
        <div class="col-xs-4 text-right js-vatTotalCalc js-calcPrice"><spring:theme code="customerTools.fromCostToRrp.calculation.vat.price"/></div>
      </div>
    </div>
    <div class="tools-panel__section clearfix">
      <div class="tools-panel__large-text">
        <span class="pull-left"><spring:theme code="customerTools.fromCostToRrp.calculation.rrpwithvat" /></span>
        <span class="pull-right js-finalCalc js-calcPrice" data-parent="${formId}"><spring:theme code="customerTools.fromCostToRrp.calculation.rrpwithvat.price" /></span>
      </div>
    </div>
  </form>
</div>