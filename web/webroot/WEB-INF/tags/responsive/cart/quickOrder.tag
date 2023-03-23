<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ attribute name="cssClass" required="false" type="java.lang.String"%>

<c:choose>
  <c:when test="${not empty param['steppedCheckout']}">
    <c:url value="${contextPath}/cart/quickOrder?steppedCheckout=true" var="quickOrderUrl"/>
  </c:when>
  <c:otherwise>
     <c:url value="${contextPath}/cart/quickOrder" var="quickOrderUrl"/>
  </c:otherwise>
</c:choose>

<div class="quick-add ${cssClass}">
  <form:form method="post" id="" class="quick-add__form js-quickAddForm" data-large-qty="${cartLargeQuantity}" data-max-qty="${cartMaximumQuantity}" modelAttribute="quickOrderForm" action="${quickOrderUrl}">
    <input type="hidden" class="js-quickAddChangeQuantity" name="changeQuantity" value="" />
    <div class="quick-add__header"><spring:theme code="quickOrderForm.header" /></div>

    <div class="quick-add__inputs-group">

      <input type="text" id="quickOrderForm.productCode" name="productCode" class="quick-add__input quick-add__input--large js-quickAddInput js-quickAddProductCode" maxlength="10" data-validation-type="product-code" placeholder="<spring:theme code='placeholder.text.productCode' />" value="${quickOrderForm.productCode}" autocomplete="noautocomplete"/>

      <input type="text" id="quickOrderForm.qty" name="qty" class="quick-add__input quick-add__input--small js-quickAddInput js-quickAddQty is-required" data-validation-type="qty" maxlength="4" placeholder="<spring:theme code='placeholder.text.qty' />" value="${quickOrderForm.qty}" autocomplete="noautocomplete" />

                 <input type="hidden" name="isCheckoutPage"
                    value="${not empty isCheckoutPage ? true : false}"/>       

    </div>
    <div class="quick-add__btn-group">
      <button tabindex="0" type="submit" disabled="disabled" class="btn btn-primary btn-block quick-add__button js-submitBtn js-quickAddSubmitButton">
        <spring:theme code="quickOrderForm.submit" />
      </button>
    </div>

    <div class="quick-add__errors-section">
      <div class="quick-add__error error js-quickAddError hide" data-error-type="product-code">
       <spring:theme code="quickadd.productcode.error" />
      </div>

      <div class="quick-add__error error js-quickAddError hide" data-error-type="product-code-empty">
        <spring:theme code="quickadd.productcode.error.required" />
      </div>

      <div class="quick-add__error error js-quickAddError hide" data-error-type="qty">
        <spring:theme code="quickadd.qty.error"/>
      </div>

      <div class="quick-add__error error js-quickAddError hide" data-error-type="qty-empty">
        <spring:theme code="quickadd.qty.error.required"/>
      </div>

      <c:if test="${isProductAlreadyExistInCart }">
        <div class="quick-add__error"><spring:theme code="error.basket.product.existingInCart" /></div>
      </c:if>

      <c:if test="${isQtyMaxLimitExceeded}">
        <script>
        var quickAddQtyExceeds = true;
        </script>

      </c:if>
    </div>

    <form:errors path="productCode"  cssClass="quick-add__error js-quickAddBackendError"/>
    <form:errors path="qty" cssClass="quick-add__error js-quickAddBackendError"/>
  </form:form>
</div>