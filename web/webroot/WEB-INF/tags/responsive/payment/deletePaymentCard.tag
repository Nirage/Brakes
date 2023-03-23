<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="title" value="basket.page.deletebasket" />
<div id="deletePaymentCard" class="popUpBox js-deletePaymentCardSection hide">
    <div class="popUpBox__heading"><spring:theme code="mydetails.delete.card.title"/>
    <button type="button" class="icon icon-close popUpBox__close js-deletePaymentCard__close"></button></div>
    <div class="popUpBox__text">
        <p class="h-space-2"><spring:theme code="mydetails.delete.card.text1"/></p>
        <p class="h-space-2"><spring:theme code="mydetails.delete.card.phoneNo"/></p>
    </div>
  
</div>
