<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="title" value="deliveryCalendar.modal.dateConfirmation.title" />
<components:modal id="dateConfirmationModal" title="${title}" customCSSClass="cart-modal">
  <form class="js-dateConfirmationForm">
  <input type="hidden" class="js-dateConfirmation" value="" />
    <p class="h-space-2"><spring:theme code="deliveryCalendar.modal.dateConfirmation.text"/></p>
    <div class="clearfix">
        <button tabindex="0" class="btn btn-secondary cart-modal__btn-left" data-dismiss="modal" aria-label="Close">
          <spring:theme code="deliveryCalendar.modal.dateConfirmation.button.cancel"/>
        </button>
        <button tabindex="0" type="submit" class="btn btn-primary cart-modal__btn-right ">
          <spring:theme code="deliveryCalendar.modal.dateConfirmation.button.proceed"/>
        </button>
    </div>
    </form>
</components:modal>