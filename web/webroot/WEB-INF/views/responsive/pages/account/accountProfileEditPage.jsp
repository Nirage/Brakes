<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="payment" tagdir="/WEB-INF/tags/responsive/payment" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<div id="v-vertical-tabs" class="container mb2">
    <h1 class="no-underline mb2">My account</h1>
    <div class="row v-accordion__wrapper">
        <%-- Input Radio --%>
        <input type="radio" id="tabs-1" name="tabs-component"/>
        <input type="radio" id="tabs-2" name="tabs-component"/>
        <input type="radio" id="tabs-3" name="tabs-component"/>
        <c:if test="${isPaymentEnabled}"><input type="radio" id="tabs-4" name="tabs-component"/></c:if>
        <c:if test="${couponEnabled}"><input type="radio" id="tabs-5" name="tabs-component"/></c:if>
        <input type="radio" id="tabs-6" name="tabs-component" ${not empty accountUpdated ? 'checked' : ''}/>

        <%-- Tabs --%>
        <div class="col-sm-3 p0 v-accordion__tabs">
            <label for="tabs-1" class="v-accordion__tab"><spring:theme code="account.mydetails"/></label>
            <label for="tabs-2" class="v-accordion__tab"><spring:theme code="account.profile.updatepassword"/></label>
            <label for="tabs-3" class="v-accordion__tab"><spring:theme code="account.myAccountDocuments.title"/></label>
            <c:if test="${isPaymentEnabled}"><label for="tabs-4" class="v-accordion__tab"><spring:theme code="mydetails.payment.heading"/></label></c:if>
            <c:if test="${couponEnabled}"><label for="tabs-5" class="v-accordion__tab"><spring:theme code="account.myVouchers.title"/></label></c:if>
            <label for="tabs-6" class="v-accordion__tab"><spring:theme code="account.updateAccountName.title"/></label>
        </div>

        <%-- Accordions --%>
        <div class="col-xs-12 col-sm-9 v-accordion__outer">

            <form:form class="updateProfileForm v-accordion" action="mydetails" method="post" modelAttribute="updateProfileForm" autocomplete="off">
                <label for="tabs-1" class="v-accordion__heading">
                    <spring:theme code="account.mydetails"/>
                    <i class="icon icon-chevron"></i>
                </label>
                <div class="v-accordion__panel">
                    <input class="hidden" autocomplete="false" name="hidden" type="text">
                    <div class="v-accordion__title"><spring:theme code="account.mydetails"/></div>
                    <div class="v-accordion__content col-md-7 p0">
                        <div class="account__text-block h-space-3">
                            <span class="account__label"><spring:theme code="account.profile.fullname"/></span>  
                            <span class="account__text">${customerData.firstName}&nbsp;${customerData.lastName}</span>
                        </div>
                        <div class="account__text-block h-space-3">
                            <span class="account__label"><spring:theme code="account.profile.username"/></span>  
                            <span class="account__text">${customerData.uid}</span>
                        </div>
                        <div class="account__text-block h-space-3">
                            <span class="account__label">
                                <spring:theme code="account.profile.email"/>
                                <span
                                    class="icon icon-question site-form__icon account__label--tooltip-icon js-triggerTooltip"
                                    data-container="body"
                                    data-toggle="popover-collapsable"
                                    data-placement="top"
                                    data-content="<spring:theme code='account.tooltip.emailaddress' />"
                                    data-type="collapsable"
                                ></span>
                            </span>
                            <span class="account__text">${customerData.email}</span>
                        </div>                  
                        <a class="btn btn-secondary btn--full-width js-updateEmailBtn">
                            <spring:theme code="account.profile.updateemail.btn" />
                        </a>

                        <div class="account__update-email-box js-updateEmailBox hide">
                            <formElement:formInputBox 
                                idKey="profile.email" 
                                labelKey="account.profile.updateemail" 
                                path="email" 
                                validationType="email"
                                errorKey="forgottenUsernameForm_emailAddress"
                                inputCSS="form-control site__form--input account__email-field js-formField js-updateEmailInput" 
                                mandatory="true"
                            />
                            <ycommerce:testId code="personalDetails_savePersonalDetails_button">
                                <span class="icon icon-close account__update-email-box--close-icon js-closeEmailBoxbtn"></span>
                                <button type="submit" class="btn btn-primary btn-block account__btn account__btn--small js-submitBtn js-updateEmailSubmitBtn disabled">
                                    <spring:theme code="account.profile.save" text="Save"/>
                                </button>
                            </ycommerce:testId>
                        </div>   

                        <c:if test="${not empty customerData.secondaryEmails}">
                            <div class="account__text-block mt2">
                                <span class="account__label"><spring:theme code="account.profile.associatedemailaddress"/>
                                    <span class="icon icon-question site-form__icon account__label--tooltip-icon js-triggerTooltip " data-container="body" data-toggle="popover-collapsable" data-placement="top" data-content="<spring:theme code='account.tooltip.associtaedemailaddress' />" data-type="collapsable"></span>
                                </span>
                                <c:forEach var="email" items="${customerData.secondaryEmails}">
                                    <span class="account__text h-space-1">${email}</span>
                                </c:forEach>
                            </div>             
                        </c:if>
                    </div>
                </div>
            </form:form>

            <form:form class="updateProfileForm v-accordion" action="mydetails" method="post" modelAttribute="updateProfileForm" autocomplete="off">
                <label for="tabs-2" class="v-accordion__heading">
                    <spring:theme code="account.profile.updatepassword"/>
                    <i class="icon icon-chevron"></i>
                </label>
                <div class="v-accordion__panel">
                    <div class="v-accordion__title"><spring:theme code="account.profile.updatepassword"/></div>
                    <div class="col-md-7 p0">
                        <p><spring:theme code="reset.pwd.criteria.heading"/></p>
                        <ul class="m0">
                            <li><spring:theme code="reset.pwd.criteria.one" /></li>
                            <li><spring:theme code="reset.pwd.criteria.two" /></li>
                            <li><spring:theme code="reset.pwd.criteria.three" /></li>
                            <li><spring:theme code="reset.pwd.criteria.four" /></li>
                        </ul>
                        <div>
                            <input id="fakePassword" type="password" name="fakePassword" value="" class="sr-only">
                            <formElement:formPasswordBox idKey="currentPassword"
                                labelKey="account.profile.currentpassword" 
                                path="currentPassword" 
                                validationType="password"
                                errorKey="currentPassword"
                                inputCSS="form-control site__form--input js-formField js-accountPasswordInput"
                                labelCSS="site__form--label"
                                mandatory="true"
                            />
                            <formElement:formPasswordBox
                                idKey="newPassword"
                                labelKey="account.profile.newpassword" 
                                path="newPassword" 
                                validationType="password"
                                errorKey="newPassword"
                                inputCSS="form-control site__form--input js-formField js-accountPasswordInput"
                                labelCSS="site__form--label"
                                mandatory="true"
                            />
                            <button type="submit" class="btn btn-primary btn--full-width btn--margin-top-20 h-space-4 js-submitBtn js-updatePasswordSubmitBtn disabled">
                                <spring:theme code="account.profile.updatepassword" text="updatepassword"/>
                            </button>
                        </div>
                    </div>
                </div>
            </form:form>
            
            <div class="v-accordion">
                <label for="tabs-3" class="v-accordion__heading">
                    <spring:theme code="account.myAccountDocuments.title"/>
                    <i class="icon icon-chevron"></i>
                </label>
                <div class="v-accordion__panel">
                    <cms:pageSlot position="PlaceholderContent" var="feature">
                        <cms:component component="${feature}" />
                    </cms:pageSlot>
                </div>
            </div>

            <%-- My Payment Card --%>
            <c:if test="${isPaymentEnabled}">
                <div class="v-accordion">
                    <form:form action="mydetails" method="post" modelAttribute="paymentForm" autocomplete="off" class="js-paymentForm">
                        <c:set var="status" value="${paymentCardStatus}" />
                        <c:choose>
                            <c:when test="${status eq 'NOT_ADDED'}">
                                <c:set var="paymentCode" value="mydetails.payment.nopayment.text" />
                                <c:set var="cardIcon" value="icon-red-bank-card"/>
                                <c:set var="iconClass" value="payment-form__iconRed"/>
                                <c:set var="buttonCode" value="mydetails.payment.add.card"/>
                                <c:set var="action" value="Add payment card"/>
                            </c:when>
                            <c:when test="${status eq 'NOT_ADDED_BUT_MANDATORY'}">
                                <c:set var="paymentCode" value="mydetails.payment.no.card.use.mandatory" />
                                <c:set var="cardIcon" value="icon-red-bank-card"/>
                                <c:set var="iconClass" value="payment-form__iconRed"/>
                                <c:set var="buttonCode" value="mydetails.payment.add.card"/>
                                <c:set var="action" value="Add payment card"/>
                            </c:when>
                            <c:when test="${status eq 'EXPIRED'}">
                                <c:set var="paymentCode" value="mydetails.payment.card.expired.text" />
                                <c:set var="cardIcon" value="icon-red-bank-card"/>
                                <c:set var="iconClass" value="payment-form__iconRed"/>
                                <c:set var="buttonCode" value="mydetails.payment.update.card"/>
                                <c:set var="action" value="Update payment card"/>
                            </c:when>
                                <c:when test="${status eq 'ABOUT_TO_EXPIRE'}">
                                    <c:set var="paymentCode" value="mydetails.payment.card.nearly.expired.text" />
                                <c:set var="cardIcon" value="icon-orange-bank-card"/>
                                <c:set var="iconClass" value="payment-form__iconOrange"/>
                                <c:set var="buttonCode" value="mydetails.payment.update.card"/>
                                <c:set var="action" value="Update payment card"/>
                            </c:when>
                            <c:when test="${status eq 'ADDED'}">
                                <c:set var="paymentCode" value="mydetails.payment.card.approved.text"/>
                                <c:set var="cardIcon" value="icon-green-bank-card"/>
                                <c:set var="iconClass" value="payment-form__iconGreen"/>
                                <c:set var="buttonCode" value="mydetails.payment.update.card"/>
                                <c:set var="action" value="Update payment card"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="paymentCode" value="mydetails.payment.card.approved.text"/>
                                <c:set var="cardIcon" value="icon-green-bank-card"/>
                                <c:set var="iconClass" value="payment-form__iconGreen"/>
                                <c:set var="buttonCode" value="mydetails.payment.update.card"/>
                                <c:set var="action" value="Update payment card"/>
                            </c:otherwise>
                        </c:choose>
                        
                        <label for="tabs-4" class="v-accordion__heading">
                            <spring:theme code="mydetails.payment.heading"/>
                            <i class="icon icon-chevron"></i>
                        </label>
                        <div class="v-accordion__panel">
                            <div class="v-accordion__title"><spring:theme code="mydetails.payment.heading"/></div>
                            <div class="col-md-7 p0">
                                <div class="control-label font-size-1">
                                    <p class="h-space-1"><spring:theme code="mydetails.payment.subheading"/></p>  
                                    <p class="h-space-1"><spring:theme code="mydetails.payment.card.text"/></p>  
                                </div>
                                <div class="account__text-block h-space-2">
                                    <div class="payment-dropdown-wrapper bg-white">
                                        <c:forEach items="${b2bUnits}" var="b2bunit">
                                            <c:if test="${paymentForm.selectedAccount eq b2bunit.code}">
                                                <div class="payment-dropdown payment-dropdown-icon js-paymentDropDownActiveSection"> 
                                                    <span class="payment-dropdown__card-name js-paymentDropDownActive" data-id="${b2bunit.code}">${b2bunit.name}</span>
                                                    <span class="pull-right js-paymentCode">${b2bunit.code}</span>
                                                </div>
                                            </c:if> 
                                        </c:forEach>		
                                        <ul class="list-group js-paymentDropDownList bg-white hide">
                                            <li class="list-group-item  text-placeholder-color" data-select="default">Select Account</li>
                                            <c:forEach items="${b2bUnits}" var="b2bunit">
                                                <li class="list-group-item" value="${b2bunit.code}" data-id="${b2bunit.code}" data-name="${b2bunit.name}">${b2bunit.name}<span class="pull-right">${b2bunit.code}</span></li>
                                            </c:forEach>		
                                        </ul>
                                    </div>  
                                    <form:hidden path="addToAllAccount" idKey="addToAllAccount" class="js-addToAllAccount" />
                                </div>
                                <div class="js-paymentAccountSection">
                                    <c:if test="${not empty paymentInfoData.cardNumber}">
                                        <div class="control-label h-space-2  payment-form__labelHeading"><spring:theme code="mydetails.payment.card.details"/></div>
                                            <div class="control-label  h-space-2 "><spring:theme code="mydetails.payment.card.number"/><span class="payment-form__val js-cardNumber"> ${paymentInfoData.cardNumber}</span></div>
                                            <div class="control-label  h-space-2"><spring:theme code="mydetails.payment.card.expiry.date"/> &nbsp; <span class="js-cardExpiry">${paymentInfoData.expiryDateToShow}</span>
                                            <span class="pull-right icon payment-form__iconTrash icon-trash icon--sm js-paymentDeleteBtn"></span>
                                        </div>
                                    </c:if>
                                    <div class="account__label h-space-2  ${iconClass} payment-form__iconHolder">
                                        <span class="payment-form__icon icon ${cardIcon}"></span>
                                        <span class=" payment-form__val"> <spring:theme code="${paymentCode}"></spring:theme></span>
                                    </div>
                                    <a class="btn btn-primary btn--full-width h-space-2 js-addPaymentCardBtn" data-action="${action}">
                                       <spring:theme code="${buttonCode}" />
                                    </a>
                                </div>

                                <c:if test="${fn:length(b2bUnits) gt 1}">
                                    <a class="btn btn-secondary btn--full-width h-space-2 js-replaceAllCards">
                                        <spring:theme code="mydetails.payment.add.card.all.accounts" />
                                    </a>
                                </c:if>
                                
                                <input type="hidden" value="${showIframeErrorMessage}" class="js-showPaymetErrorPopup"/>
                                <payment:replaceAllCard/>
                                <payment:deletePaymentCard/>
                                <payment:addPaymentCardModal/>
                                <payment:paymentAccountHandlebarTemplate/>
                            </div>
                        </div>
                        <payment:paymentErrorModal/>
                    </form:form>
                </div>
            </c:if>


            <%-- My Voucher Codes --%>
            <c:if test="${couponEnabled}">
                <div class="v-accordion">
                    <label for="tabs-5" class="v-accordion__heading">
                        <spring:theme code="account.myVouchers.title"/>
                        <i class="icon icon-chevron"></i>
                    </label>
                    <div class="v-accordion__panel">
                        <div class="v-accordion__title"><spring:theme code="account.myVouchers.title"/></div>
                        <div class="col-md-7 p0">
                            <form:form action="" method="post" modelAttribute="voucherForm" autocomplete="off" class="vouchers-form js-voucherFormAjax">
                                <div class="vouchers-form__input-wrap">
                                    <div class="checkout-voucher__input-wrap"> 
                                    <input name="voucherCode" type="text" class="col-xs-6 checkout-voucher__box checkout-voucher__input js-voucherFormAjaxInput" maxlength="12" autocomplete="off"/></div>            
                                    <button id="applyVoucher" name="applyVoucher"   class="col-xs-6 checkout-voucher__box checkout-voucher__btn" type="submit" tabindex="0"><spring:theme code="text.voucher.btn.submit"/></button>
                                </div>
                                <cart:voucherSaveMoneyInfo/>
                            </form:form>
                            <button type="button" class="btn btn-link checkout-voucher__text js-voucherInfo p-0 h-topspace-1">
                                <img class="checkout-voucher__img" src="https://i1.adis.ws/i/Brakes/question-icon" alt="<spring:message code='text.voucher.label.question'/>"/><spring:message code='text.voucher.label.question'/>
                            </button>
                            <%--  Ajax call End point : /coupon/enable-coupon-account Post Data: voucherForm Return: couponData --%>
                            <%-- if empty response then show the message as per the requirement --%>
                
                            <ul class="vouchers-list h-topspace-1 js-vouchersList">
                                <c:forEach items="${vouchers}" var="voucher">
                                    <li class="vouchers-list__item voucher-item js-voucherItem ${not empty voucher.order || voucher.isExpired ? 'is-redeemed' : ''}" data-show-tc="${voucher.showTermsAndConditions}" data-tc-text="${voucher.termsAndConditions}" data-tc-moretext="${voucher.termsAndConditionsShowMore}">
                                        <c:choose>
                                            <c:when test="${voucher.discountType eq 'PERCENT'}">
                                                <c:set var="voucherValFormated" value="${voucher.voucherValue}%" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="voucherValFormated" value="${voucher.value.formattedValue}" />
                                            </c:otherwise>
                                        </c:choose>
                                        <spring:theme code="text.voucher.item.code" arguments="${voucher.couponCode}" />
                                        <spring:theme code="text.voucher.item.value" arguments="${voucherValFormated}" />
                                        <spring:theme code="text.voucher.minSpend" arguments="${voucher.minSpend.formattedValue}" />
                                        <spring:theme code="text.voucher.expires" arguments="${empty(voucher.formattedExpiryDate) ? ' ' : voucher.formattedExpiryDate}" />
                                        <c:if test="${not empty voucher.order}">
                                            <div class="voucher-item__order-code"><spring:theme code="text.voucher.orderCode" arguments="${voucher.order}" /></div>
                                        </c:if>
                                    </li>
                                </c:forEach>
                            </ul>
                            <cart:voucherCartInfo />
                        </div>
                    </div>
                    <script id="voucher-item-template" type="text/x-handlebars-template">
                        <li class="vouchers-list__item voucher-item js-voucherItem {{#if this.coupon.order }} is-redeemed {{/if}}" data-show-tc="{{this.coupon.showTermsAndConditions}}" data-tc-text="{{this.coupon.termsAndConditions}}" data-tc-moretext="{{this.coupon.termsAndConditionsShowMore}}">
                            <spring:theme code="text.voucher.item.code" arguments="${'{{this.coupon.couponCode}}'}" />
                            {{#ifCond this.coupon.discountType '==' 'PERCENT'}}
                                <spring:theme code="text.voucher.item.value" arguments="${'{{this.coupon.voucherValue}}%'}" />
                            {{else}}
                                <spring:theme code="text.voucher.item.value" arguments="${'{{this.coupon.value.formattedValue}}'}" />
                            {{/ifCond}} 

                            <spring:theme code="text.voucher.minSpend" arguments="${'{{this.coupon.minSpend.formattedValue}}'}" />
                            <spring:theme code="text.voucher.expires" arguments="${'{{this.coupon.formattedExpiryDate}}'}" />
                            {{#if this.coupon.order}}
                                <div class="voucher-item__order-code"><spring:theme code="text.voucher.orderCode" arguments="${'{{this.coupon.order}}'}" />
                                </div>
                            {{/if}}
                        </li>
                    </script>
                </div>

            </c:if>

            <%-- Update Account Name --%>
            <form:form class="updateAccountName v-accordion js-updateAccountNameContainer ${not empty accountUpdated ? 'updateAccountName--success' : ''}" action="mydetails" method="post" modelAttribute="updateProfileForm" autocomplete="off">
                <label for="tabs-6" class="v-accordion__heading">
                    <spring:theme code="account.updateAccountName.title"/>
                    <i class="icon icon-chevron"></i>
                </label>
                <div class="v-accordion__panel">
                    <div class="v-accordion__title"><spring:theme code="account.updateAccountName.title"/></div>
                    <div class="col-md-7 p0">
                            <div class="account__text-block h-space-2">
                                <div class="form-dropdown-wrapper">
                                    <div class="form-dropdown form-dropdown-icon js-accountSelectedContainer bg-white"> 
                                    <c:choose>
                                        <c:when test="${not empty accountUpdated}">
                                            <span class="form-dropdown--selected js-accountSelectedName" data-value="${accountUpdated.name}">${accountUpdated.name}</span>
                                            <span class="pull-right js-accountSelectedCode">${accountUpdated.code}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="form-dropdown--selected js-accountSelectedName" data-value="DEFAULT"><spring:theme code="account.updateAccountName.choose"/></span>
                                            <span class="pull-right js-accountSelectedCode"></span>
                                        </c:otherwise>
                                    </c:choose> 
                                    </div>
                                    <ul class="list-group js-accountListContainer bg-white hide">
                                        <c:forEach items="${assignedUnits}" var="b2bunit">
                                            <li class="list-group-item" value="${b2bunit.code}" data-id="${b2bunit.code}" data-name="${b2bunit.name}">${b2bunit.name}<span class="pull-right" data-id="${b2bunit.code}" data-name="${b2bunit.name}">${b2bunit.code}</span></li>
                                        </c:forEach>		
                                    </ul>
                                    <c:if test="${not empty accountUpdated}">
                                        <span class="text-success"><spring:theme code="account.updateAccountName.success"/></span>
                                    </c:if> 
                                </div>  
                            </div>
                            
                            <input id="selectedAccountCode" type="text" name="selectedAccountCode" value="" class="sr-only">
                            <formElement:formInputBox
                                idKey="accountName" 
                                labelKey="account.updateAccountName.inputLabel" 
                                path="accountName"
                                maxlength="35"
                                inputCSS="form-control site__form--input js-newAccountName" 
                                mandatory="true"
                                errorKey="accountName"
                            />
                            <button type="submit" class="btn btn-primary btn--full-width btn--margin-top-20 h-space-4 js-updateAccountNameSubmitButton disabled">
                                <spring:theme code="account.updateAccountName.cta" text="account.updateAccountName.cta"/>
                            </button>
                    </div>
                </div>
            </form:form>

        </div>
    </div>
</div>