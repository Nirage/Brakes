<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script id="payment-account-template" type="text/x-handlebars-template">
 {{#if b2BCardStatus}}
    {{#switch b2BCardStatus}} 
    
     {{#case 'NOT_ADDED_BUT_MANDATORY'}} 
            {{var 'paymentCode' 'mydetails.payment.no.card.use.mandatory'}}
            {{var 'cardIcon' 'icon-red-bank-card'}}
            {{var  'iconClass' 'payment-form__iconRed'}}
            {{var 'buttonCode' 'mydetails.payment.add.card'}}
            {{var 'action' 'Add payment card'}}
        {{/case}} 
        {{#case 'NOT_ADDED'}} 
            {{var 'paymentCode' 'mydetails.payment.nopayment.text'}}
            {{var 'cardIcon' 'icon-red-bank-card'}}
            {{var  'iconClass' 'payment-form__iconRed'}}
            {{var 'buttonCode' 'mydetails.payment.add.card'}}
            {{var 'action' 'Add payment card'}}
        {{/case}} 
        {{#case 'EXPIRED'}}
            {{var 'paymentCode' 'expired'}}
            {{var 'cardIcon' 'icon-red-bank-card'}}
            {{var  'iconClass' 'payment-form__iconRed'}}
            {{var 'buttonCode' 'mydetails.payment.update.card'}}
            {{var 'action' 'update payment card'}}
        {{/case}} 
        {{#case 'ABOUT_TO_EXPIRE'}}
            {{var 'paymentCode' 'mydetails.payment.card.nearly.expired.text'}}
            {{var 'cardIcon' 'icon-orange-bank-card'}}
            {{var  'iconClass' 'payment-form__iconOrange'}}
            {{var 'buttonCode' 'mydetails.payment.update.card'}}
            {{var 'action' 'update payment card'}}
        {{/case}}
        {{#case 'ADDED'}}
            {{var 'paymentCode' 'mydetails.payment.card.approved.text'}}
            {{var 'cardIcon' 'icon-green-bank-card'}}
            {{var  'iconClass' 'payment-form__iconGreen'}}
            {{var 'buttonCode' 'mydetails.payment.update.card'}}
            {{var 'action' 'update payment card'}}
        {{/case}} 
        {{#case 'APPROVED'}}
            {{var 'paymentCode' 'mydetails.payment.card.approved.text'}}
            {{var 'cardIcon' 'icon-green-bank-card'}}
            {{var  'iconClass' 'payment-form__iconGreen'}}
            {{var 'buttonCode' 'mydetails.payment.update.card'}}
            {{var 'action' 'update payment card'}}
        {{/case}} 
        {{#default}}
            {{var 'paymentCode' 'mydetails.payment.card.approved.text'}}
            {{var 'cardIcon' 'icon-green-bank-card'}}
            {{var  'iconClass' 'payment-form__iconGreen'}}
            {{var 'buttonCode' 'mydetails.payment.update.card'}}
            {{var 'action' 'update payment card'}}
            {{/default}}
    {{/switch}}
    {{/if}}
  
              
    {{#if paymentInfo.cardNumber}}
        <div class="control-label h-space-2  payment-form__labelHeading"><spring:theme code="mydetails.payment.card.details"/></div>
            <div class="control-label  h-space-2 "><spring:theme code="mydetails.payment.card.number"/><span class="payment-form__val js-cardNumber"> {{paymentInfo.cardNumber}}</span></div>
            <div class="control-label  h-space-2"><spring:theme code="mydetails.payment.card.expiry.date"/> &nbsp; <span class="js-cardExpiry">{{paymentInfo.expiryDateToShow}}</span>
            <span class="pull-right icon payment-form__iconTrash icon-trash icon--sm js-paymentDeleteBtn"></span>
        </div>
    {{/if}}
    {{#if b2BCardStatus}}
        <div class="account__label h-space-2  {{iconClass}} payment-form__iconHolder">
        <span class="payment-form__icon icon {{cardIcon}}"></span>
        {{#switch b2BCardStatus}} 
            {{#case 'NOT_ADDED_BUT_MANDATORY'}} 
            <div class="account__label h-space-2  payment-form__iconRed payment-form__iconHolder">
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.no.card.use.mandatory"/></span>
            </div>
            {{/case}} 
            {{#case 'NOT_ADDED'}} 
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.nopayment.text"/></span>
            {{/case}} 
            {{#case 'EXPIRED'}}
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.card.expired.text"/></span>

            {{/case}} 
            {{#case 'ABOUT_TO_EXPIRE'}}
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.card.nearly.expired.text"/></span>
            {{/case}}
            {{#case 'ADDED'}}
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.card.approved.text"/></span>

            {{/case}} 
            {{#case 'APPROVED'}}
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.card.approved.text"/></span>
            {{/case}} 
            {{#default}}
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.card.approved.text"/></span>

            {{/default}}
        {{/switch}}
        </div>
    {{else}}
            <div class="account__label h-space-2  payment-form__iconRed payment-form__iconHolder">
                <span class="payment-form__icon icon icon-red-bank-card"></span>
                <span class="payment-form__val"> <spring:theme code="mydetails.payment.nopayment.text"/></span>
            </div>
    {{/if}}  
    {{#if b2BCardStatus}} 
        {{#switch b2BCardStatus}} 
            {{#case 'NOT_ADDED_BUT_MANDATORY'}} 
            <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="Add payment card">
                    <spring:theme code="mydetails.payment.add.card"/>
                </a>
            {{/case}} 
            {{#case 'NOT_ADDED'}} 
                <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="Add payment card">
                    <spring:theme code="mydetails.payment.add.card"/>
                </a>  
            {{/case}} 
            {{#case 'EXPIRED'}}
                <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="Update payment cards">
                    <spring:theme code="mydetails.payment.update.card"/>
                </a>
            {{/case}} 
            {{#case 'ABOUT_TO_EXPIRE'}}
                <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="Update payment cards">
                        <spring:theme code="mydetails.payment.update.card"/>
                </a> 
            {{/case}}
            {{#case 'ADDED'}}
                <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="Update payment cards">
                    <spring:theme code="mydetails.payment.update.card"/>
                </a>
            {{/case}} 
            {{#case 'APPROVED'}}
                <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="Update payment cards">
                    <spring:theme code="mydetails.payment.update.card"/>
                </a> 
            {{/case}} 
            {{#default}}
                <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="Update payment cards">
                    <spring:theme code="mydetails.payment.add.card"/>
                </a>
            {{/default}}
        {{/switch}}
    {{/if}}    

</script>
                    