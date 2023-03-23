<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<%-- Voucher Save Money Info --%>
<div id="voucherCartInfo" class="checkout-voucher__info js-VoucherInfoSection hide">
   <button class="close js-voucherClose" aria-hidden="true"  type="button">
        <span class="icon icon-close icon--sm"></span>
    </button>
    <div class="checkout-voucher__infoSection">
        <p class="checkout-voucher__infoTitle">  <spring:theme code="text.voucher.info.saveMoney.title"/></p>
        <div class="checkout-voucher__infoContent h-space-2">            
           <spring:theme code="text.voucher.info.saveMoney.text"/>
        </div>
        <a href=<spring:theme code="text.voucher.info.saveMoney.btn.link"/> tabindex="0" class="btn btn-secondary btn--full-width">
           <spring:theme code="text.voucher.info.saveMoney.btn.text"/>
        </a>
    </div>
</div>
