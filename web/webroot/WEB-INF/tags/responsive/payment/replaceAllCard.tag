<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="title" value="basket.page.deletebasket" />
<div id="replaceAllCard" class="popUpBox js-replaceAllCardSection hide">
    <div class="popUpBox__heading"><spring:theme code="mydetails.replace.all.card.title"/>
    <button type="button" tabindex="0" title="<spring:theme code="mydetails.payment.error.close"/>" class="icon icon-close popUpBox__close js-removeAllCard__close"></button></div>
    <div class="popUpBox__text">
        <p class="h-space-2"><spring:theme code="mydetails.replace.all.card.text1"/></p>
        <p class="h-space-2"><spring:theme code="mydetails.replace.all.card.text2"/></p>
        <p class="h-space-2"><spring:theme code="mydetails.replace.all.card.text3"/></p>
    </div>
    <button tabindex="1" title="<spring:theme code="mydetails.replace.all.card.button.text"></spring:theme>" class="btn btn-primary btn--full-width js-paymentSubmit">
        <spring:theme code="mydetails.replace.all.card.button.text"/>
    </button>     
</div>
