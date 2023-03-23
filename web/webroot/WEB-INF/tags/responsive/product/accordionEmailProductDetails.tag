<%@ attribute name="itemOrder" required="true" type="java.lang.String" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<div class="accordion js-accordionItem" data-order="${itemOrder}">
  <div class="accordion__heading " role="tab" id="accordionHeaderEmail">
    <h4 class="accordion__title collapsed" role="button" data-toggle="collapse" data-parent="#accordion1" data-target="#accordionCollapseEmail" aria-expanded="false" aria-controls="accordionHeaderEmail"><span class="accordion__title-icon icon icon-email"></span><spring:theme code="productDetails.emailProduct.heading"/><span class="accordion__chevron icon icon-chevron-down"></span></h4>
  </div>
  <div id="accordionCollapseEmail" class="js-pdpAccordionCollapse accordion__collapse collapse" role="tabpanel" aria-labelledby="accordionHeaderEmail">
    <div class="accordion__body">
      <div class="send-product">
        <p class="send-product__desc"><spring:theme code="product.emailProduct.desc" /></p>
        <spring:url value="/p/send-productdetails" var="action"/>
        <form:form id="emailProductForm" class="site-form js-formValidation send-product__form" action="${action}" method="POST" modelAttribute="emailProductForm">
          <input id="emailProductId" name="emailProductId" type="hidden" value="${product.code}"/>
          <div class="site-form__formgroup form-group js-formGroup clearfix send-product__input">
            <label class="site-form__label hide" for="product.email" data-error-empty='<spring:theme code="error.invalid.email"/>' data-error-invalid='<spring:theme code="error.invalid.email"/>'><spring:theme code="product.emailProduct.inputLabel" /></label>
            <div class="site-form__inputgroup js-inputgroup ">
              <formElement:formInputBox
                idKey="emailProductIdAddress"
                path="emailAddress"
                mandatory="true"
                errorKey="emailProductForm_emailAddresss"
                labelKey=""
                inputCSS="form-control site__form--input js-formField"
                labelCSS="site__form--label hide"
                validationType="email"
                placeholderKey="email" />
            </div>
          </div>
          <div class="site-form__actions form-actions clearfix send-product__actions">
            <button type="submit" class="btn btn-primary btn--full-width js-submitBtn">
            <div class="btn__text-wrapper">
              <span class="icon icon-email btn__icon"></span>
              <span class="btn__text"><spring:theme code="product.emailProduct.buttonSend" /></span>
            </div>
            </button>
          </div>
        </form:form>
      </div>
    </div>
  </div>
</div>