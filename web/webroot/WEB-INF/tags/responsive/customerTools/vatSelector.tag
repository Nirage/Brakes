<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ attribute name="isCentered" required="false" type="java.lang.Boolean"%>

<div class="tools-panel h-topspace-2 ${isCentered ? 'centered' : ''}">
  <div class="row">
    <div class="col-xs-12 ${isCentered ? '' : 'col-sm-6'}">
      <h2 class="tools-panel__heading tools-panel__heading--align-horiz tools-panel__heading--mobile-centered"><spring:theme code="customerTools.vatSelector.heading" /></h2>
    </div>
    <div class="col-xs-12 ${isCentered ? '' : 'col-sm-6'} h-topspace-2">
    <div class="tools-panel__btns-group ${isCentered ? "centered" : ''}">
      <button type="button" class="btn btn-secondary tools-panel__btn js-formAction " data-action="vat-rate" data-value="<spring:theme code='customerTools.vatSelector.option1.value'/>"><spring:theme code="customerTools.vatSelector.option1.text"/></button>
      <button type="button" class="btn btn-primary tools-panel__btn js-formAction js-btnVatRateDefault" data-action="vat-rate" data-value="<spring:theme code='customerTools.vatSelector.option2.value'/>"><spring:theme code='customerTools.vatSelector.option2.text'/></button>
      </div>
    </div>
  </div>
</div>