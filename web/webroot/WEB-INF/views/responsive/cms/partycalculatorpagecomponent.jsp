<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="formId" value="partyCalculatorForm" />
<script>
window.partyCalculator = {
  meatandPoultry: {
    name: '<spring:theme code="customerTools.partyCalculator.meatandPoultry" />'
  },
  fishandSeafood: {
    name: '<spring:theme code="customerTools.partyCalculator.fishandSeafood" />'
  },
  vegetarian: {
    name: '<spring:theme code="customerTools.partyCalculator.vegetarian" />'
  },
  desserts: {
    name: '<spring:theme code="customerTools.partyCalculator.desserts" />'
  },
  extras: {
    name: '<spring:theme code="customerTools.partyCalculator.extras" />'
  }
}
</script>

      <div class="site-header site-header--align-left">
        <h1 class="site-header__text site-header--align-left site-header__text--underline site-header__text--underline-left"><spring:theme code="customerTools.partyCalculator.heading"/></h1>
        <p class="site-header__subtext"><spring:theme code="customerTools.partyCalculator.desc"/></p>
      </div>

      <div class="tools-panel centered js-partCalculator">
        <h2 class="tools-panel__heading"><spring:theme code="customerTools.partyCalculator.selectEvent"/></h2>
        <div class="row">
          <div class="col-xs-12">
            <form id="${formId}" class="js-formValidation js-partCalculatorForm tools-panel__form tools-panel__form--party-calculator h-topspace-2">
            <div class="row">
              <div class="col-xs-12 col-sm-5">
              <div class="control site-form__dropdown js-subSelectWrapper">
                <label for="typeOfEvent" data-error-empty="<spring:theme code='error.empty.businesstypeOfEvent' />">
                  <select id="typeOfEvent" name="typeOfEvent" class="form-control site-form__select js-formField js-formSelect js-typeOfEvent is-required" data-validation-type="select" >
                    <option value="">---Select---</option>
                    <c:forEach items="${eventTypes}" var="events">
                      <option value="${events.code}">${events.name}</option>
                    </c:forEach>
                  </select>
                    <span class="icon icon-error site-form__errorsideicon js-error-icon"></span>
                    <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
                </label>
                <span class="icon icon-caret-up error-msg js-errorMsg hide site-form__errormessage"></span>
              </div>
              </div>
              <div class="col-xs-12 col-sm-3">
              <div class="form-group tools-panel__formgroup site-form__formgroup js-formGroup">
                <div class="site-form__inputgroup js-inputgroup">
                  <label class="hide" for="noOfGuests" data-error-empty="" data-error-invalid=""></label>
                  <input type="text" class="form-control tools-panel__form-control tools-panel__form-control--full-width  tools-panel__input-field js-formField js-formInput js-noOfGuests is-required" data-validation-type="numeric"  data-parent="${formId}" id="noOfGuests" placeholder="<spring:theme code="customerTools.partyCalculator.noOfGuests.placeholder" />" />
                  <span class="icon icon-error site-form__errorsideicon  js-error-icon"></span>
                  <span class="icon icon-tick site-form__validsideicon js-valid-icon"></span>
                </div>
              </div>
              </div>
              <div class="col-xs-6 col-sm-2">
                <button type="submit" class="btn btn-primary tools-panel__btn tools-panel__btn--full-width js-formAction js-submitBtn" data-action="calculate" data-parent="${formId}"><spring:theme code="customerTools.button.calculate"/></button>
              </div>
              <div class="col-xs-6 col-sm-2">
                <button type="button" class="btn btn-default custom-button--default tools-panel__btn--full-width tools-panel__btn js-formAction" data-action="reset" data-parent="${formId}"><spring:theme code="customerTools.button.reset"/></button>
              </div>
              </div>
            </form>
          </div>
        </div>
        </div>

        <div id="jsPartyCalculatorTable" class="js-formRenderedHtml"></div>
            <div class="row">
            <div class="col-xs-12">
              <div class="tools-panel__disclaimer">
              <spring:theme code="customerTools.disclaimer"/>
              </div>
              </div>
              </div>
                </div>
            </div>


        <script id="party-calculator-template" type="text/x-handlebars-template">
           <div class="tools-panel centered">
           <h2 class="tools-panel__heading "><spring:theme code="customerTools.partyCalculator.tableTitle"/></h2>
             <div class="row">
               <div class="col-xs-12">
                 <table class="tools-panel__table">
                   <thead class="tools-panel__table-head">
                     <tr>
                       <th class="tools-panel__table-col tools-panel__table-col--1"><spring:theme code="customerTools.partyCalculator.table.th1" /></th>
                       <th class="tools-panel__table-col tools-panel__table-col--2"><spring:theme code="customerTools.partyCalculator.table.th2" /></th>
                       <th class="tools-panel__table-col tools-panel__table-col--3"><spring:theme code="customerTools.partyCalculator.table.th3" /></th>
                     </tr>
                   </thead>
                   <tbody class="tools-panel__table-body">
                   {{#with bites}}
                   {{#each this}}
                     <tr class="tools-panel__table-row">
                       <td class="tools-panel__table-col tools-panel__table-col--1">{{name}}</td>
                       <td class="tools-panel__table-col tools-panel__table-col--2">{{perPerson}}</td>
                       <td class="tools-panel__table-col tools-panel__table-col--3">{{perBites}}</td>
                     </tr>
                   {{/each}}
                   {{/with}}
                     <tr class="tools-panel__table-footer">
                       <td class="tools-panel__table-col tools-panel__table-col--1"><spring:theme code="customerTools.partyCalculator.table.total"/></td>
                       <td class="tools-panel__table-col tools-panel__table-col--2">{{totals.perPerson}}</td>
                       <td class="tools-panel__table-col tools-panel__table-col--3">{{totals.perBites}}</td>
                     </tr>
                   </tbody>
                 </table>
               </div>
             </div>
           </div>
         </script>