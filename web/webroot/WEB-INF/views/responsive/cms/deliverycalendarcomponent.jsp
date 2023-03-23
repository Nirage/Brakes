<%@ page session="false" trimDirectiveWhitespaces="true" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
<c:url value="/cart/updateDeliveryDate" var="updateDeliveryDate"/>


<fmt:formatDate pattern = "yyyy-MM-dd" value = "${deliveryCal.selectedDate}" var="selectedDateFormat1" />
<fmt:formatDate pattern = "dd MMMM yyyy" value = "${deliveryCal.selectedDate}" var="selectedDateFormat2" />

<c:set var="availableDates">[<c:forEach items="${deliveryCal.availableDates}" var="date" varStatus="varStatus">"${date}"<c:if test="${!varStatus.last}">,</c:if></c:forEach>]</c:set>

<c:set var="bankHolidaysDates">[<c:forEach items="${deliveryCal.bankHolidays}" var="date" varStatus="varStatus">"${date}"<c:if test="${!varStatus.last}">,</c:if></c:forEach>]</c:set>


<script>
  var deliveryCalendarConfig = {
    bankHolidays: ${bankHolidaysDates},
    enable: ${availableDates},
    minDate: "today",
    maxDate: "${deliveryCal.lastAvailableDate}",
    selectedDate: "${selectedDateFormat1}",
    nextAvailableDate: "${deliveryCal.firstAvailableDate}" 
  }
</script>

<div class="account-dropdown">
  <div tabindex="0" class="account-dropdown__trigger account-dropdown__trigger--delivery-calendar js-accountDropdown" data-id="delivery-calendar">
  <span class="icon icon-calendar icon-user-calendar account-dropdown__calendar-heading-icon"></span>
  <span class="hidden-xs">  <spring:theme code='deliveryCalendar.dropdownText' arguments='${selectedDateFormat2}'/> </span>
  <span class="visible-xs text-right">  <spring:theme code='deliveryCalendar.deliveryText'/> </span>

  </div>



  <div class="account-dropdown__content account-dropdown__content--deliverycalendar hide js-accountDropdownContent text-left" data-id="delivery-calendar">
    <div class="account-dropdown__calendar-top ">
      <div class="delivery-date">
        <div class="delivery-date__heading">${selectedDateFormat2}</div>
        <div class="delivery-date__description">
       <c:if test="${!isb2cSite}">
        <spring:theme code='deliveryCalendar.calendar.description' arguments='${cartId},${user.unit.uid}' />
       </c:if>
        </div>
      </div>
    </div>
      <div class="account-dropdown__calendar-middle">
        <div class="account-dropdown__calendar-heading">
          <span class="icon icon-calendar account-dropdown__calendar-heading-icon"></span>
          <span class="account-dropdown__calendar-heading-text"><spring:theme code='deliveryCalendar.calendar.heading'/></span>
        </div>
        <div class="account-dropdown__calendar">
          <div class="js-deliveryCalendar"></div>
        </div>
        <ul class="account-dropdown__calendar-legend calendar-legend">
          <li class="calendar-legend__item">
            <span class="calendar-legend__item-symbol calendar-legend__item-symbol--next-available"></span>
            <span class="calendar-legend__item-text"><spring:theme code='deliveryCalendar.calendar.nextavailable'/></span>
          </li>
          <li class="calendar-legend__item">
          <span class="calendar-legend__item-symbol calendar-legend__item-symbol--available"></span>
          <span class="calendar-legend__item-text"><spring:theme code='deliveryCalendar.calendar.available'/></span>
          </li>
          <li class="calendar-legend__item">
            <img class="calendar-legend__item-symbol calendar-legend__item-symbol--bankholiday" src="/_ui/responsive/theme-brakes/images/bank-holiday-bg.png" alt="Loading...">
            <span class="calendar-legend__item-text"><spring:theme code='deliveryCalendar.calendar.bankHoliday'/></span>
          </li>
          <li class="calendar-legend__item">
            <span class="calendar-legend__item-symbol calendar-legend__item-symbol--notavailable"></span>
            <span class="calendar-legend__item-text"><spring:theme code='deliveryCalendar.calendar.notavailable'/></span>
          </li>
        </ul>

      </div>
      <div class="account-dropdown__calendar-bottom">
        <div class="delivery-date__selected">
          <spring:theme code='deliveryCalendar.youHaveSelected' arguments='${selectedDateFormat2}'/>
        </div>
        <div class="delivery-date__deadline ${deliveryCal.orderDeadlineTwoHours  ? 'highlighted' : ''}"><spring:theme code='deliveryCalendar.orderDeadline' arguments='${deliveryCal.orderDeadline}'/></div>
        <form:form id="delCalForm" name="delCalForm" action="${updateDeliveryDate}" method="post" modelAttribute="delCalForm" class="delivery-date__form js-delCalForm">
          <form:input path="deliveryDate" value="" class="js-deliveryDate" type="hidden" />
          <button tabindex="0" type="submit" class="btn btn-primary js-deliveryCalenderSubmit text-white" title="<spring:theme code='deliveryCalendar.submit'/>"><spring:theme code='deliveryCalendar.submit'/></button>
        </form:form>
      </div>
    </div>
  </div>
</sec:authorize>

