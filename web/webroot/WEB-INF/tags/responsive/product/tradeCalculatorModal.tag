<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<%@ attribute name="msgCode" required="false" type="java.lang.String" %>

<c:set var="title" value="customerTools.tradeCalculator.modal.title" />
<components:modal id="tradeCalculatorModal" title="${title}" icon="icon icon-calculator" customCSSClass="trade-calculator__modal">
    <p class="h-space-2"><spring:theme code="customerTools.tradeCalculator.modal.desc"/></p>
    <div class="clearfix">

<div class="trade-calculator h-space-2">
  <form class="trade-calculator__form js-tradeCalculatorForm h-space-2 row"  action="" method="get">
    <div class="trade-calculator__label col-xs-12 col-sm-3 m-0 p-0">
      <spring:theme code="customerTools.tradeCalculator.modal.label"/>
    </div>
    <div class="trade-calculator__container col-xs-12 col-sm-9 m-0 p-0">
      <div class="form-group trade-calculator__formgroup site-form__formgroup js-formGroup col-xs-6 col-sm-4 m-0">
        <div class="site-form__inputgroup js-inputgroup trade-calculator__inputs-group">
          <label class="hide" for="tradeCalculatorForm.qty" data-error-empty="Value required " data-error-invalid="Value invalid"></label>
          <input type="number" id="tradeCalculatorForm.qty" name="tradeCalculatorForm.qty" class="trade-calculator__input js-tradeCalculatorDiscount form-control tools-panel__form-control js-formField js-formInput" data-validation-type="marginRequired" min="0" max="100" placeholder="<spring:theme code='customerTools.tradeCalculator.inputPlaceholder'/>" value="" autocomplete="noautocomplete">
          <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
        </div>
        <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
      </div>
    <div class="trade-calculator__btn-group col-xs-4 m-0 p-0">
      <button type="submit" class="btn btn-primary btn-block trade-calculator__button js-submitBtn">
        <spring:theme code="customerTools.tradeCalculator.modal.button" />
      </button>
    </div>
    </div>
    <div>
  </div>
  </form>
</div>
  
    </div>
  <div class="modal-footer">
    <spring:theme code="customerTools.tradeCalculator.modal.footer"/>
  </div>

</components:modal>