<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ attribute name="formId" required="true" type="java.lang.String"%>

<div class="tools-panel">
  <h2 class="tools-panel__heading tools-panel__heading--align-horiz tools-panel__heading--mobile-centered"><spring:theme code="customerTools.grossProfit.heading"/></h2>
  <form class="form tools-panel__form h-topspace-2 js-toolsForm js-formValidation " id="${formId}">
    <div class="form-group tools-panel__formgroup site-form__formgroup js-formGroup">
      <div class="site-form__inputgroup js-inputgroup">
        <label class="tools-panel__form-label" for="rRPrice"><spring:theme code="customerTools.grossProfit.rrp"/></label>
        <input type="text" class="form-control tools-panel__form-control js-formField js-formInput is-required" data-validation-type="unitPrice" data-input-type="rrp" data-parent="${formId}" id="rRPrice" placeholder="&pound;00.00" />
        <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
        <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
      </div>
    </div>
    <div class="form-group tools-panel__formgroup site-form__formgroup js-formGroup">
      <div class="site-form__inputgroup js-inputgroup">
      <label class="tools-panel__form-label" for="costPriceRequired" data-error-empty="<spring:theme code='customerTools.costPrice.rrp.error'/>" data-error-invalid="<spring:theme code='customerTools.costPrice.rrp.invalid'/>"><spring:theme code="customerTools.costPrice.rrp"/></label>
      <input type="text" class="form-control tools-panel__form-control js-formField js-formInput is-required" data-validation-type="unitPrice" data-input-type="cost-price" data-parent="${formId}" id="costPriceRequired" placeholder="&pound;00.00" />
      <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
      <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
      </div>
    </div>
    <div class="tools-panel__btns-group">
      <button type="button" class="btn btn-default custom-button--default tools-panel__btn js-formAction" data-action="reset" data-parent="${formId}"><spring:theme code="customerTools.button.reset"/></button>
      <button type="submit" class="btn btn-primary tools-panel__btn js-formAction js-submitBtn" data-action="calculate" data-parent="${formId}"><spring:theme code="customerTools.button.calculate"/></button>
    </div>
    <div class="tools-panel__section">
      <div class="row">
        <div class="col-xs-8"><spring:theme code="customerTools.grossProfit.calculation.rrpwithoutvat"/></div>
        <div class="col-xs-4 text-right js-rrpExVat js-calcPrice"><spring:theme code="customerTools.grossProfit.calculation.rrpwithoutvat.price"/></div>
      </div>
      <div class="row">
        <div class="col-xs-8"><spring:theme code="customerTools.grossProfit.calculation.grossProfitWithoutVat"/></div>
        <div class="col-xs-4 text-right js-grossProfitExVat js-calcPrice"><spring:theme code="customerTools.grossProfit.calculation.grossProfitWithoutVat.price"/></div>
      </div>
    </div>
    <div class="tools-panel__section clearfix">
      <div class="tools-panel__large-text">
        <span class="pull-left"><spring:theme code="customerTools.grossProfit.calculation.grossProfit"/></span>
        <span class="pull-right js-finalRrpCalc js-calcPercentage" data-parent="${formId}"><spring:theme code="customerTools.grossProfit.calculation.grossProfit.value"/></span>
      </div>
    </div>
  </form>
</div>