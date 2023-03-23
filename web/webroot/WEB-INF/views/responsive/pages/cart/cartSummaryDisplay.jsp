<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="quote" tagdir="/WEB-INF/tags/responsive/quote" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="checkout" tagdir="/WEB-INF/tags/responsive/checkout" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="addoncart" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/cart" %>


<c:if test="${!isb2cSite}">
  <c:url value="/cxml/requisition" context="${originalContextPath}/punchout" var="requisitionUrl"/>
  <c:url value="/"  var="cancelUrl"/>
  <c:url value="${continueUrl}" var="continueShoppingUrl" scope="session"/>
  <c:url value="/checkout/setPurchaseOrderNo" var="updatePurchaseOrderNoUrl"/>
  
  <c:url value="/checkout/placeOrder" var="placeOrderUrl"/>
  <c:url value="/cart" var="cartPageUrl" />
  
  <c:url value="/cart/validate" var="validateCheckoutUrl"/>
  <c:url value="/cart" var="cartUrl"/>
  <c:url value="/cart/checout" var="checkoutUrl"/>
  <c:choose>
  <c:when test="${not empty param['steppedCheckout']}">
    <c:url value="/cart/voucher/apply?steppedCheckout=true" var="applyVoucherUrl"/>
  </c:when>
  <c:otherwise>
     <c:url value="/cart/voucher/apply" var="applyVoucherUrl"/>
  </c:otherwise>
  </c:choose>
  <spring:theme code="ablErrorMessage" var="ablErrorMessage"/>
  <spring:theme code="deliveryDateErrorMessage" var="deliveryDateErrorMessage"/>
  
  <input type="hidden" id="cartUrl" value="${cartUrl}"/>
  <input type="hidden" id="checkoutUrl" value="${checkoutUrl}"/>
  <input type="hidden" id="ABL-ERROR_MESSAGE" value="${ablErrorMessage}"/>
  <input type="hidden" id="DELIVERY-DATE-ERROR-MESSAGE" value="${deliveryDateErrorMessage}"/>
  <c:set var="deliveryDate"  value="${cartData.formattedDeliveryDate}" />
  <c:set var="cutOffTime" value = "${currentB2BUnit.formattedCutOffTime}"/>
  <input type="hidden" class="jsDeliveryDate" value="<fmt:formatDate value="${cartData.deliveryDate}" pattern = "yyyy-MM-dd" />"/>
  <input type="hidden" class="js-cart-code" id="cartCode" value="${cartData.code}"/>

  <c:set var="cardStatus" value="${isPaymentEnabled && (paymentCardStatus eq 'EXPIRED' || paymentCardStatus eq 'NOT_ADDED_BUT_MANDATORY')}" />
  <input type="hidden" id="cardStatus" value="${cardStatus}"/>
  <input type="hidden" id="paymentCardStatus" value="${paymentCardStatus}"/>
   <%-- B2B site --%>

  <c:choose>
   <c:when test="${cartData.cutOffTimeWarning}">
    <c:set var="color" value="red" />
   </c:when>
   <c:otherwise>
    <c:set var="color" value="black" />
   </c:otherwise>
  </c:choose>
  <div class="cart-totals">
    <div class="cart-totals__inner">
      <div class="hidden-sm hidden-md hidden-lg">
        <cart:cartHeader />
      </div>
      <div class="cart-totals__header">
        <h3 class="cart-totals__header-text"><spring:theme code="basket.summary.txt"/></h3>
      </div>
      <div class="cart-totals__body">
        <c:if test="${not empty cartData.deliveryDate}" >	
          <div class="cart-totals__body-text h-space-1">
            <span class="cart-totals__body-text--bold">                   
              <spring:theme code="basket.delivery.date.txt"/>
            </span>
            <div class="pull-right">
              <a tabindex="0" href="#" class="js-accountDropdown" data-id="delivery-calendar">
                <span class="cart-totals__body-text--underline">${deliveryDate}&nbsp;</span>
                <span class="icon icon-amend cart-totals__edit-icon"></span>
              </a>
            </div>
          </div>
          <div class="h-space-1 delivery-date__deadline ${cutOffTimeWarning  ? 'highlighted' : ''}">
            <spring:theme code="basket.delivery.cutoff.txt" arguments="${color}, ${cartData.formattedOrderDeadlineDate}"/>
          </div>
        </c:if>
        <div class="cart-totals__body-text h-space-1">  
          <span class="cart-totals__body-text--bold">
            <spring:theme code="basket.summary.total.items.txt" arguments="${fn:length(cartData.entries)},${cartData.totalUnitCount}"/>
          </span>
          <span class="pull-right">    
            <spring:theme code="basket.summary.total.itemsvalue.txt" arguments="${fn:length(cartData.entries)},${cartData.totalUnitCount}"/>
          </span>
        </div>     
        <hr />
        <div class="cart-totals__body-text cart-totals__prices"> 
          <span class="icon icon-basket cart-totals__body-text--basket-icon "></span>
          <div class="cart-totals__total-price">
            <span class="cart-totals__body-text--inline-element">
              <span class="cart-totals__body-text--bold">
                <c:choose>
                  <c:when test="${isb2cSite && cartData.isVatApplicable}">
                    <spring:theme code="basket.summary.total.price.total.with.vat" />
                  </c:when>
                  <c:otherwise>
                    <spring:theme code="basket.summary.total.price.total" />
                  </c:otherwise>
                </c:choose>
                <span class="cart-totals__guide">
                   <spring:theme code="basket.summary.total.price.guide" />
                </span>
              </span>
            </span>
            <span class="pull-right cart-totals__body-text--inline-element cart-totals__body-text--bold">
              <ycommerce:testId code="cart_totalPrice_label">
                <c:choose>
                  <c:when test="${showTax}">
                    <format:price priceData="${cartData.totalPriceWithTax}"/>
                  </c:when>
                  <c:otherwise>
                    <format:price priceData="${cartData.totalPrice}"/>
                  </c:otherwise>
                </c:choose>
              </ycommerce:testId>
            </span>
          </div>
        </div>
        <div class="cart-totals__minimum-order h-space-2">
          <c:if test="${currentB2BUnit.minimumOrderValue gt 0}">
            <span class="cart-totals__body-text--font12">
              <c:choose>
                <c:when test="${cartData.totalPrice.value lt currentB2BUnit.minimumOrderValue}">
                  <span class="delivery-date__deadline highlighted">
                    <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
                  </span>
                </c:when>
                <c:otherwise>
                  <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
                </c:otherwise>
              </c:choose>
            </span>
          </c:if>
        </div> 
          <c:if test="${isb2cSite && not empty isCheckoutPage && currentB2BUnit.maximumOrderValue gt 0 &&  cartData.totalPrice.value gt currentB2BUnit.maximumOrderValue}">
            <c:set var="checkoutBtnClass" value="disabled" />
              <div class="cart-totals__maximum-order h-space-2">
               <span class="delivery-date__deadline highlighted">
                <spring:theme code="basket.summary.maximum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.maximumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
               </span>
              </div>  
          </c:if>
        <c:if test="${fn:length(cartData.entries) eq 0}">
          <c:set var="checkoutBtnClass" value="disabled" />
        </c:if>
        <c:if test="${not empty currentB2BUnit.minimumOrderValue && (cartData.totalPrice.value lt currentB2BUnit.minimumOrderValue)}">
          <c:set var="checkoutBtnClass" value="disabled" />
        </c:if>
		<%--         Payment Section Start --%>
        	<c:if test="${isPaymentEnabled}">  
            <c:choose>
              <c:when test="${paymentCardStatus eq 'EXPIRED'}">
                <c:set var="paymentMsgCode" value="checkout.payment.expiry.text1"/>
                <c:set var="iconCode" value="icon-checkout-cant-pay"/>
              </c:when>
              <c:when test="${paymentCardStatus eq 'NOT_ADDED_BUT_MANDATORY'}">
                <c:set var="paymentMsgCode" value="checkout.payment.add.card.mandatory.text1"/>
              </c:when>
              <c:otherwise>
                <c:set var="paymentMsgCode" value="checkout.payment.text1"/>
                <c:set var="iconCode" value="icon-checkout-can-pay"/>
              </c:otherwise>
            </c:choose>         
          <c:choose>
            <c:when test="${paymentCardStatus eq 'NOT_ADDED'}">
              <div class="cart-totals__body-text h-space-2">
                 <a  href="/mydetails?scrollTo=scrollToPayment"><label class="cursorPointer cart-totals__body-text cart-totals__body-text--underline"><spring:theme code="checkout.payment.add.card.details"></spring:theme></label></a>
              </div>
            </c:when>
            <c:when test="${paymentCardStatus eq 'NOT_ADDED_BUT_MANDATORY'}">
              <div class="cart-totals__body-text">
                <a href="/mydetails?scrollTo=scrollToPayment"><label class="cursorPointer cart-totals__body-text cart-totals__body-text--underline"><spring:theme code="checkout.payment.add.card.details.mandatory"></spring:theme></label></a>
              </div>
              <p class="checkout-voucher__error"><spring:theme code="${paymentMsgCode}"></spring:theme></p>
            </c:when>
            
            <c:otherwise>              
              <div class="cart-totals__body-text h-space-2">
                <p class="checkout-voucher__error"><spring:theme code="${paymentMsgCode}"></spring:theme></p>
                <p><spring:theme code="checkout.payment.card.Number"></spring:theme><span> &nbsp;${cartData.paymentInfo.cardNumber}</span><span class="pull-right"><span class="icon ${iconCode}"><span class="path1"></span><span class="path2"></span><span class="path3"></span><span class="path4"></span><span class="path5"></span><span class="path6"></span><span class="path7"></span><span class="path8"></span><span class="path9"></span><span class="path10"></span></span></span></span></p>
                <a  href="/mydetails?scrollTo=scrollToPayment"><label class="cursorPointer cart-totals__body-text cart-totals__body-text--underline"><spring:theme code="checkout.payment.update.card.details"></spring:theme></label><span class="icon icon-amend cart-totals__edit-icon"></span></a>
              </div>
            </c:otherwise>
          </c:choose>
          </c:if>
          <%--         Payment Section  End --%> 

        <c:choose>
          <c:when test="${empty isCheckoutPage && empty punchoutUser}">
            <ycommerce:testId code="checkoutButton">
              <a tabindex="0" href="${siteUid eq 'brakesfoodshop' ? '/checkout': '/checkout/step-one'}" class="btn btn-primary btn--full-width btn--continue-checkout js-continue-checkout-button ${checkoutBtnClass}">
                <spring:theme code="checkout.checkout"/>
              </a>

            </ycommerce:testId>
          </c:when>
          <c:otherwise>
            <%-- Punchout actions --%>
            <c:if test="${!empty punchoutUser}">
              <c:choose>
                <c:when test="${isInspectOperation}">
                  <div class="col-sm-5 col-md-3 col-sm-push-7 col-md-push-9">
                    <addoncart:returnButton url="${requisitionUrl}" />
                  </div>
                </c:when>
                <c:otherwise>
                  <a class="btn btn-primary btn--full-width btn-block returnButton" href="${fn:escapeXml(requisitionUrl)}">
                    <spring:theme code="punchout.custom.return.text"/>
                  </a>
                  <a class="btn btn-secondary btn--full-width btn-block cancelButton" href="${fn:escapeXml(cancelUrl)}">
                    <spring:theme code="punchout.custom.cancel.text"/>
                  </a>
                  <a class="btn btn-secondary btn--full-width btn-block btn--continue-shopping" href="${fn:escapeXml(continueShoppingUrl)}">
                    <spring:theme  code="punchout.cart.page.continue"/>
                  </a>
                </c:otherwise>
              </c:choose>
            </c:if>
            
            <c:if test="${currentB2BUnit.poRequired eq true && empty punchoutUser}">
              <input type="hidden" id="poRequired" value="${currentB2BUnit.poRequired}">
            </c:if>
            <c:if test="${empty punchoutUser}">
              <div class="flex flex-direction-column">
                <input type="hidden" class="js-PO-format" value=${currentB2BUnit.customerPOFormat}>
                <form:form id="purchaseOrderForm" name="purchaseOrderForm" action="${fn:escapeXml(updatePurchaseOrderNoUrl)}" method="post" modelAttribute="purchaseOrderForm">
                  <label for="checkout.purchaseordernumber" class="cart-totals__body-text h-space-1""> <spring:message code="checkout.purchaseordernumber"/> </label>
                  <form:input id="checkout.purchaseordernumber"  maxlength="20" path="purchaseOrderNumber" value="" class="form-control h-space-1 js-purchase-order-number text-uppercase"/>
                  <span class="error-msg site-form__errormessage js-poFormatError h-space-2 text-center hide"></span>
                  <form:hidden path="customerPOFormat" />
                  <%--  <input id="button.succeed" name="button.succeed" class="submitButtonText btn btn-primary btn-block" type="submit" tabindex="22" title="<spring:message code="button.succeed"/>" value="<spring:message code="button.succeed"/>"/> --%>
                </form:form>
                <div class="cart-totals__order-buttons">
                  <form:form id="placeOrderForm" name="placeOrderForm" action="${fn:escapeXml(placeOrderUrl)}" method="post" modelAttribute="placeOrderForm" class="js-placeOrderForm">
                    <button id="checkout.summary.placeOrder" name="checkout.summary.placeOrder" class="submitButtonText js-PlaceOrder btn btn-primary btn--full-width h-space-1 ${checkoutBtnClass}" type="submit" tabindex="0" title="<spring:message code='checkout.summary.placeOrder'/>" ${cardStatus ? 'disabled' : ''}>
                      <spring:message code="checkout.summary.placeOrder"/>
                    </button>
                  </form:form>
                  <a tabindex="0" href="${fn:escapeXml(cartPageUrl)}" class="btn btn-secondary btn--full-width h-space-1 js-continue-cart-button">
                    <spring:theme text="Continue Shopping" code="cart.page.continue"/>
                  </a>
                </div>
                <%-- Voucher form | Start --%>
                <c:set var="voucherPlaceHolder">
                  <spring:message code='text.voucher.field.input.placeholder'/>
                </c:set>
                <c:if test="${currentB2BUnit.voucherFlag}" >
                  <form:form id="voucherForm" name="voucherForm" action="${fn:escapeXml(applyVoucherUrl)}" method="post" modelAttribute="voucherForm" class="js-voucherForm vouchers-form">
                    <div class="vouchers-form__input-wrap">
                    <button type="button" class="btn btn-link vouchers-form__info-button js-saveMoneyInfOpen">
                      <span class="icon icon-info"> </span>
                    </button>
                    <div class="checkout-voucher__input-wrap">
                      <form:input id="voucherForm.voucherCode"  class="col-xs-6 checkout-voucher__box checkout-voucher__input js-voucherInput ${!empty(voucherErrorMsg) ? '' : '' }" maxlength="12" autocomplete="off" path="voucherCode" value="${empty(cartData.appliedVouchers) ? '' : cartData.appliedVouchers[0]}" placeholder="${empty(cartData.appliedVouchers) ? voucherPlaceHolder : ''}" />
                      <c:if test="${fn:length(vouchers) > 0}">
                        <span class="icon icon-chevron-down js-toggleVouchersDropdown vouchers-dropdown__toggle"></span>
                      </c:if>
                    </div>
                    <button id="applyVoucher" name="applyVoucher"   class="col-xs-6 checkout-voucher__box checkout-voucher__btn" type="submit" tabindex="0">Submit</button>
                    <c:choose>
                      <c:when test="${not empty eligibleforvoucher && eligibleforvoucher eq false}">
                        <div class="checkout-voucher__error"><spring:theme code="text.voucher.minimum.spend"/></div>
                      </c:when>
                      <c:when test="${!empty(voucherErrorMsg)}" >
                        <div class="checkout-voucher__error"><spring:theme code="${voucherErrorMsg}"/></div>
                      </c:when>
                      <c:when test="${!empty(voucherWarningMsg)}" >
                        <div class="checkout-voucher__error"><spring:theme code="${voucherWarningMsg}" arguments="${voucherMinOrderValue}"/></div>
                      </c:when>
                      <c:when test="${!empty(voucherSuccessMsg) || !empty(cartData.appliedVouchers)}" >
                        <span class="checkout-voucher__sucessText"><spring:theme code="text.voucher.apply.applied.success" arguments="${appliedCoupon.value.formattedValue}"/></span>
                      </c:when>
                    </c:choose>
                    </div>
                    <c:if test="${fn:length(vouchers) > 0}">
                      <div class="vouchers-dropdown-wrap">
                        <ul class="vouchers-dropdown h-topspace-1 js-vouchersDropdown">
                          <c:forEach items="${vouchers}" var="voucher">
                            <li class="vouchers-dropdown__item voucher-item js-vouchersDropdownItem" data-voucher-code="${voucher.couponCode}">
                            <span class="voucher-item__col-left">${voucher.couponCode}</span>
                            <span class="voucher-item__col-right">${voucher.value.formattedValue}</span></li>
                          </c:forEach>
                        </ul>
                      </div>
                    </c:if>
                  </form:form>
                  <div class="voucher-details">
                    <div class="voucher-details__col-left">
                      <button class="btn btn-link checkout-voucher__text js-voucherInfo p-0">
                        <img class="checkout-voucher__img" src="https://i1.adis.ws/i/Brakes/question-icon" alt="<spring:message code='text.voucher.label.question'/>"/><spring:message code='text.voucher.label.question'/>
                      </button>
                    </div>
                    <div class="voucher-details__col-right">
                      <c:choose>
                        <c:when test="${not empty appliedCoupon.value.formattedValue && not empty appliedCoupon.minSpend.formattedValue}">
                          <span class="voucher-details__entry  h-space-1"><spring:theme code="text.voucher.savings.withCode" arguments="${appliedCoupon.value.formattedValue}"/></span>
                          <span class="voucher-details__entry"><spring:theme code="text.voucher.minSpend.withCode" arguments="${appliedCoupon.minSpend.formattedValue}"/></span>
                        </c:when>
                        <c:otherwise>
                          <span class="voucher-details__entry h-space-1"><spring:message code="text.voucher.savings.noCode"/></span>
                          <span class="voucher-details__entry voucher-details__entry--no-value"><spring:message code="text.voucher.minSpend.noCode"/></span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                </c:if>
              </div>
            </c:if>
          </c:otherwise>
        </c:choose>
        <!-- VAT  -->
        <c:if test="${product.subjectToVAT}">
          <div class="cart-totals__vat">
            <spring:theme code="basket.summary.vat"/>
          </div>
        </c:if>
      </div>
      <c:if test="${empty isCheckoutPage}">
      <div class="visible-xs">
        <div class="quick-add__seperator"></div>
        <cart:quickOrder cssClass="quick-add--mobile"/>
      </div>
      </c:if>
    </div>
  </div>
  
  <checkout:checkoutDeliveryDateConfirmationModal/>
</c:if>

<%-- B2C site --%>
<c:if test="${isb2cSite}">
  <c:url value="/checkout/setPurchaseOrderNo" var="updatePurchaseOrderNoUrl"/>

  <c:url value="/checkout/placeOrder" var="placeOrderUrl"/>
  <c:url value="/cart" var="cartPageUrl" />
  
  <c:url value="/cart/validate" var="validateCheckoutUrl"/>
  <c:url value="/cart" var="cartUrl"/>
  <c:url value="/cart/checout" var="checkoutUrl"/>
  <c:url value="/cart/voucher/apply" var="applyVoucherUrl"/>
  <spring:theme code="ablErrorMessage" var="ablErrorMessage"/>
  <spring:theme code="deliveryDateErrorMessage" var="deliveryDateErrorMessage"/>
  
  <input type="hidden" id="cartUrl" value="${cartUrl}"/>
  <input type="hidden" id="checkoutUrl" value="${checkoutUrl}"/>
  <input type="hidden" id="ABL-ERROR_MESSAGE" value="${ablErrorMessage}"/>
  <input type="hidden" id="DELIVERY-DATE-ERROR-MESSAGE" value="${deliveryDateErrorMessage}"/>
  <c:set var="deliveryDate"  value="${cartData.formattedDeliveryDate}" />
  <c:set var="cutOffTime" value = "${currentB2BUnit.formattedCutOffTime}"/>
  <input type="hidden" class="jsDeliveryDate" value="<fmt:formatDate value="${cartData.deliveryDate}" pattern = "yyyy-MM-dd" />"/>
    
  <c:choose>
    <c:when test="${cartData.cutOffTimeWarning}">
    <c:set var="color" value="red" />
    </c:when>
    <c:otherwise>
    <c:set var="color" value="black" />
    </c:otherwise>
  </c:choose>
  <div class="cart-totals">
    <div class="cart-totals__inner">
      <div class="hidden-sm hidden-md hidden-lg">
        <cart:cartHeader />
      </div>
      <div class="cart-totals__header">
        <h3 class="cart-totals__header-text"><spring:theme code="b2c.checkout.basket.summary.txt"/></h3>
      </div>
      <div class="cart-totals__body">
        <%-- Product information title --%>
        <div class="cart-totals__body-text h-space-1">  
          <span class="cart-totals__body-text--bold">
            <spring:theme code="b2c.checkout.basket.product.info.label"/>
          </span>
        </div>
        <div class="cart-totals__body-text h-space-1">  
          <span class="cart-totals__body-text--bold">
            <spring:theme code="b2c.checkout.basket.product.info.item.label" arguments="${fn:length(cartData.entries)},${cartData.totalUnitCount}"/>
          </span>
          <span class="pull-right">    
            <spring:theme code="basket.summary.total.itemsvalue.txt" arguments="${fn:length(cartData.entries)},${cartData.totalUnitCount}"/>
          </span>
        </div>     
        <hr />
        <%-- Delivery info --%>
        <c:if test="${not empty cartData.deliveryDate}" >	
          <%-- Delivery information title --%>
          <div class="cart-totals__body-text h-space-1">  
            <span class="cart-totals__body-text--bold">
              <spring:theme code="b2c.checkout.basket.delivery.info.label"/>
            </span>
          </div>
          <%-- Delivery address --%>
          <c:if test="${not empty user.defaultShippingAddress.formattedAddress}" >	
            <div class="cart-totals__body-text h-space-1">
              <span class="cart-totals__body-text--bold">                   
                <spring:theme code="b2c.checkout.basket.delivery.info.address.label"/>
              </span>
              <div class="b2c__margin-bottom--10">
              ${user.defaultShippingAddress.formattedAddress}
              </div>
            </div>
          </c:if>
          <div class="cart-totals__body-text h-space-1">
            <span class="cart-totals__body-text--bold">                   
              <spring:theme code="b2c.checkout.basket.delivery.info.address.date.label"/>
            </span>
            <div class="pull-right">
              <a tabindex="0" href="#" class="js-accountDropdown" data-id="delivery-calendar">
                <span class="cart-totals__body-text--underline">${deliveryDate}&nbsp;</span>
                <span class="icon icon-amend cart-totals__edit-icon"></span>
              </a>
            </div>
          </div>
          <div class="h-space-1 delivery-date__deadline ${cutOffTimeWarning  ? 'highlighted' : ''}">
            <spring:theme code="basket.delivery.cutoff.txt" arguments="${color}, ${cartData.formattedOrderDeadlineDate}"/>
          </div>
        </c:if>    
        <hr />  
        <%-- Total label --%>  
        <div class="cart-totals__body-text h-space-1">  
          <span class="cart-totals__body-text--bold">
            <spring:theme code="b2c.checkout.basket.total.charge.label"/>
          </span>
        </div>
        <%-- Delivery charge --%>
        <div class="cart-totals__body-text cart-totals__prices b2c__margin-bottom--10"> 
          <span class="icon icon-map-marker cart-totals__body-text--basket-icon "></span>
          <div class="cart-totals__total-price">
            <span class="cart-totals__body-text--inline-element">
              <span class="cart-totals__body-text--bold">
                <spring:theme code="basket.page.delivery" />
              </span>
            </span>
            <span class="pull-right cart-totals__body-text--inline-element cart-totals__body-text--bold">
              <spring:theme code="basket.page.free" />  
            </span>
          </div>
        </div>
        <%-- Total price --%>
        <div class="cart-totals__body-text cart-totals__prices"> 
          <span class="icon icon-basket cart-totals__body-text--basket-icon "></span>
          <div class="cart-totals__total-price">
            <span class="cart-totals__body-text--inline-element">
              <span class="cart-totals__body-text--bold">
                <c:choose>
                  <c:when test="${isb2cSite && cartData.isVatApplicable}">
                    <spring:theme code="basket.summary.total.price.total.with.vat" />
                  </c:when>
                  <c:otherwise>
                    <spring:theme code="basket.summary.total.price.total" />
                  </c:otherwise>
                </c:choose>
                <span class="cart-totals__guide">
                    <spring:theme code="basket.summary.total.price.guide" />
                </span>
              </span>
            </span>
            <span class="pull-right cart-totals__body-text--inline-element cart-totals__body-text--bold">
              <ycommerce:testId code="cart_totalPrice_label">
                <c:choose>
                  <c:when test="${showTax}">
                    <format:price priceData="${cartData.totalPriceWithTax}"/>
                  </c:when>
                  <c:otherwise>
                    <format:price priceData="${cartData.totalPrice}"/>
                  </c:otherwise>
                </c:choose>
              </ycommerce:testId>
            </span>
          </div>
        </div>
        <div class="cart-totals__minimum-order h-space-2">
          <c:if test="${currentB2BUnit.minimumOrderValue gt 0}">
            <span class="cart-totals__body-text--font12">
              <c:choose>
                <c:when test="${cartData.totalPrice.value lt currentB2BUnit.minimumOrderValue}">
                  <span class="delivery-date__deadline highlighted">
                    <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
                  </span>
                </c:when>
                <c:otherwise>
                  <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
                </c:otherwise>
              </c:choose>
            </span>
          </c:if>
        </div>
        <c:if test="${isb2cSite && not empty isCheckoutPage && currentB2BUnit.maximumOrderValue gt 0 &&  cartData.totalPrice.value gt currentB2BUnit.maximumOrderValue}">
          <c:set var="checkoutBtnClass" value="disabled" />
          <div class="cart-totals__maximum-order h-space-2">
            <span class="delivery-date__deadline highlighted">
              <spring:theme code="basket.summary.maximum.order.txt" arguments="${currentCurrency.symbol}"/>
              <fmt:formatNumber value="${currentB2BUnit.maximumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
            </span>
          </div>  
        </c:if>
        <c:if test="${fn:length(cartData.entries) eq 0}">
          <c:set var="checkoutBtnClass" value="disabled" />
        </c:if>
        <c:if test="${not empty currentB2BUnit.minimumOrderValue && (cartData.totalPrice.value lt currentB2BUnit.minimumOrderValue)}">
          <c:set var="checkoutBtnClass" value="disabled" />
        </c:if>
      
        <c:choose>
          <c:when test="${empty isCheckoutPage} && empty punchoutUser">
            <ycommerce:testId code="checkoutButton">
              <a tabindex="0" href="${siteUid eq 'brakesfoodshop' ? '/checkout': '/checkout/step-one'}" class="btn btn-primary btn--full-width btn--continue-checkout js-continue-checkout-button ${checkoutBtnClass}">
                <spring:theme code="checkout.checkout"/>
              </a>
            </ycommerce:testId>
          </c:when>
          <c:otherwise>
            <c:if test="${currentB2BUnit.poRequired eq true}">
              <input type="hidden" id="poRequired" value="${currentB2BUnit.poRequired}">
            </c:if>
            <input type="hidden" class="js-PO-format" value=${currentB2BUnit.customerPOFormat}>
            <div class="js-orderBtnsDesktop">
              <form:form id="placeOrderForm" name="placeOrderForm" action="${fn:escapeXml(placeOrderUrl)}" method="post" modelAttribute="placeOrderForm" class="js-placeOrderForm">	
                <button id="checkout.summary.placeOrder" name="checkout.summary.placeOrder" class="submitButtonText js-PlaceOrder btn btn-primary btn--full-width h-space-1 ${checkoutBtnClass}" type="submit" tabindex="0" title="<spring:message code='checkout.summary.placeOrder'/>" ><spring:message code="checkout.summary.placeOrder"/></button>
              </form:form> 
            </div>      
            
            <%-- Voucher form | Start --%>
            <c:if test="${currentB2BUnit.voucherFlag eq true}" >
              <form:form id="voucherForm" name="voucherForm" action="${fn:escapeXml(applyVoucherUrl)}" method="post" modelAttribute="voucherForm" class="js-voucherForm vouchers-form">
              <div class="vouchers-form__input-wrap">
                <button type="button" class="vouchers-form__info-button">
                  <span class="icon icon-info"> </span>
                </button>
                <c:choose>
                  <c:when test="${!empty(voucherErrorMsg)}">
                    <form:input id="voucherForm.voucherCode"  class="col-xs-6 checkout-voucher__box checkout-voucher__input checkout-voucher__haserror" maxlength="50" path="voucherCode" value="" placeholder="${voucherPlaceHolder}" />
                  </c:when>
                  <c:otherwise>
                    <form:input id="voucherForm.voucherCode"  class="col-xs-6 checkout-voucher__box checkout-voucher__input" maxlength="50" path="voucherCode" value="" placeholder="${voucherPlaceHolder}" />
                  </c:otherwise>
                </c:choose>                       
                <button id="applyVoucher" name="applyVoucher"   class="col-xs-6 checkout-voucher__box checkout-voucher__btn" type="submit" tabindex="0">Submit</button>
                <c:choose>
                  <c:when test="${!empty(voucherErrorMsg)}" >
                    <div class="checkout-voucher__error"><spring:theme code="${voucherErrorMsg}"/></div>
                  </c:when>
                  <c:when test="${!empty(voucherWarningMsg)}" >
                    <div class="checkout-voucher__error"><spring:theme code="${voucherWarningMsg}" arguments="${currentB2BUnit.voucherMinimumOrderValue}"/></div>
                  </c:when>
                  <c:when test="${!empty(voucherSuccessMsg) || !empty(cartData.appliedVouchers)}" >
                    <span class="checkout-voucher__sucessText"><spring:theme code="text.voucher.apply.applied.success" arguments="${appliedCoupon.value.formattedValue}"/></span>
                  </c:when>
                </c:choose>
                </div>
              </form:form>
              <div class="checkout-voucher__text js-voucherInfo">
                <img class="checkout-voucher__img" src="https://i1.adis.ws/i/Brakes/question-icon"/><spring:message code='text.voucher.label.question'/>
              </div>
              <cart:voucherCartInfo />

              <div class="js-orderBtnsMobile">
                <form:form id="placeOrderForm" name="placeOrderForm" action="${fn:escapeXml(placeOrderUrl)}" method="post" modelAttribute="placeOrderForm" class="js-placeOrderForm js-placeOrderFormMobile">	
                  <button id="checkout.summary.placeOrder" name="checkout.summary.placeOrder" class="submitButtonText js-PlaceOrder btn btn-primary btn--full-width h-space-1 ${checkoutBtnClass}" type="submit" tabindex="0" title="<spring:message code='checkout.summary.placeOrder'/>" ><spring:message code="checkout.summary.placeOrder"/></button> 				
                </form:form>    
              </div>
            </c:if>
            <%-- Voucher form | End --%>
          </c:otherwise>
        </c:choose>
        <!-- VAT  -->
        <c:if test="${product.subjectToVAT}">
          <div class="cart-totals__vat">
            <spring:theme code="basket.summary.vat"/>
          </div>
        </c:if>
      </div>
      <c:if test="${empty isCheckoutPage}">
        <div class="visible-xs">
          <div class="quick-add__seperator"></div>
            <cart:quickOrder cssClass="quick-add--mobile"/>
          </div>
        </div>
      </c:if>
  </div>
  

  <checkout:checkoutDeliveryDateConfirmationModal/>



</c:if>


<c:if test="${voucherPopUp && not empty eligVoucherCode}">
  <script>
    window.voucherPopup = true;
  </script>
  <c:set var="title" value="text.saveMoney.modal.title" />

  <components:modal id="saveMoneyModal" title="${title}" customCSSClass="cart-modal cart-modal--lg js-cartModal">
      <p class="h-space-2"><spring:theme code="text.saveMoney.modal.text" arguments="${eligVoucherCode}"/></p>
      <div class="row clearfix">
          <div class="col-xs-12cart__popup--top2">
              <button tabindex="0" type="button" class="btn btn-primary w-100"  data-dismiss="modal" aria-label="<spring:theme code="text.saveMoney.modal.button.gotIt"/>">
               <spring:theme code="text.saveMoney.modal.button.gotIt"/>
              </button>
          </div>
      </div>
  </components:modal>

</c:if>

<cart:voucherSaveMoneyInfo/>

<cart:voucherCartInfo showTC="${appliedCoupon.showTermsAndConditions}" tcText="${appliedCoupon.termsAndConditions}" tcMoreText="${appliedCoupon.termsAndConditionsShowMore}"/>