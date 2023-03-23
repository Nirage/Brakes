<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ attribute name="showTC" required="false" type="java.lang.Boolean"%>
<%@ attribute name="tcText" required="false" type="java.lang.String"%>
<%@ attribute name="tcMoreText" required="false" type="java.lang.String"%>
<%-- Voucher Info --%>
<div id="voucherSaveMoney" class="checkout-voucher__info hide js-voucherSaveMoneyInfo">
   <button class="close js-voucherSaveMoneyInfoClose" aria-hidden="true"  type="button">
        <span class="icon icon-close icon--sm"></span>
    </button>

    <div class="checkout-voucher__infoSection">
        <p class="checkout-voucher__infoTitle"><spring:theme code="text.voucher.info.title"/></p>
        <div class="checkout-voucher__infoContent h-space-2 js-voucherContent ${not empty tcMoreText ? 'has-tc' : ''}">            
            <div class="js-voucherTC word-wrap">
            <c:choose>
                <c:when test="${showTC && not empty tcText}">
                    ${tcText}
                </c:when>
                <c:otherwise>
                    <spring:theme code="text.voucher.info.content"/>
                </c:otherwise>
            </c:choose>
            </div>

            <div class="checkout-voucher__tc-wrap hide js-voucherTCMoreWrap ${showTC && not empty tcMoreText ? 'js-hasMoreTc' : ''}">
                <button type="button" class="btn btn-link js-voucherToggleTC checkout-voucher__btn checkout-voucher__btn--show-more">
                    <spring:theme code="text.voucher.info.btn.showMore"/>
                </button>
                
                <div class="checkout-voucher__tc word-wrap">
                    <div class="js-voucherTCMore">${tcMoreText} </div>
                    <button type="button" class="btn btn-link js-voucherToggleTC checkout-voucher__btn checkout-voucher__btn--show-less">
                        <spring:theme code="text.voucher.info.btn.showLess"/>
                    </button>
                </div>
            </div>
        </div>
        <a href=<spring:theme code="text.voucher.info.learnmore.link"/> tabindex="0" class="btn btn-secondary btn--full-width js-VoucherLearnMore">
            <spring:theme code="text.voucher.info.btn.text"/>
        </a>
    </div>
</div>

