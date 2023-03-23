<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>

<template:page pageTitle="${pageTitle}">

    <%-- TODO - Move to a proper javascript file

         it should be included in the following components:

         - checkoutAmendmentThankOOSMessage.jsp
         - checkoutCancellationThankOOSMessage.jsp
         - checkoutConfirmationThankOOSMessage.jsp
    --%>

    <script>
        const checkStatusCommon = (checkStatusFn, clearIntervalsFn) => {
            const xhr = new XMLHttpRequest();
            const orderNumber = document.body.querySelector('.checkout-success').dataset['order'];
            xhr.open("GET", '/orders/' + orderNumber + '/status');
            xhr.send();
            xhr.onload = function(e) {
                if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
                    const response = xhr.responseText;
                    let url = '/my-account/order/' + orderNumber;
                    if (checkStatusFn(response)) {
                        console.log(response, "Redirecting....");
                        clearIntervalsFn();
                        window.location.href = url;
                    }
                }
            }
        };
        const timeOutFn = (clearIntervalsFn) => {
            const orderNumber = document.body.querySelector('.checkout-success').dataset['order'];
            let url = '/my-account/order/' + orderNumber + '?timeout=true';
            console.log("Redirecting due to timeout....");
            clearIntervalsFn();
            window.location.href = url;
        };
    </script>

    <cms:pageSlot position="SideContent" var="feature" class="accountPageSideContent" element="div">
        <cms:component component="${feature}" element="div" class="accountPageSideContent-component"/>
    </cms:pageSlot>
    <cms:pageSlot position="TopContent" var="feature" element="div" class="accountPageTopContent">
        <cms:component component="${feature}" element="div" class="accountPageTopContent-component"/>
    </cms:pageSlot>
    <div class="account-section">
        <cms:pageSlot position="BodyContent" var="feature" element="div" class="account-section-content checkout__confirmation__content">
            <cms:component component="${feature}" element="div" class="checkout__confirmation__content--component"/>
        </cms:pageSlot>
    </div>
    <cms:pageSlot position="BottomContent" var="feature" element="div" class="accountPageBottomContent">
        <cms:component component="${feature}" element="div" class="accountPageBottomContent-component"/>
    </cms:pageSlot>
</template:page>