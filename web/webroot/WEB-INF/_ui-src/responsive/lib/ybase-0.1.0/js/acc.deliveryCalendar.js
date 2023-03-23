import 'flatpickr';

const deliveryCalendar = {
  _autoload: [['init', ACC.config.authenticated]],
  CAL_FORM_CLASS: '.js-delCalForm',
  init: function () {
    // if user is logged in init Flatpickr calendar
    // https://flatpickr.js.org/
    if (typeof window.deliveryCalendarConfig != 'undefined') {
      ACC.deliveryCalendar.setConfig(window.deliveryCalendarConfig);

      $('.js-deliveryCalendar').flatpickr(ACC.deliveryCalendar.config);
      ACC.deliveryCalendar.bindDateConfirmationSubmit();
      ACC.deliveryCalendar.onDeliveryConfirmationClose();
      ACC.deliveryCalendar.bindOnFormSubmit();
    }
  },
  $dateConfirmationModal: $('#dateConfirmationModal'),
  config: {},
  setConfig: function (deliveryCalendar) {
    var calendarConfig = {
      inline: true,
      mode: 'single',
      showMonths: 1,
      dateFormat: 'Y-m-d',
      ariaDateFormat: 'Y-m-d',
      enable: deliveryCalendar.enable,
      minDate: deliveryCalendar.minDate,
      maxDate: deliveryCalendar.maxDate,
      onDayCreate: function (dObj, dStr, fp, dayElem) {
        var formatedDate = ACC.deliveryCalendar.formatDate(dayElem.dateObj);

        if (deliveryCalendar.bankHolidays.indexOf(formatedDate) !== -1) {
          dayElem.className += ' date-bankholiday';
        }
        if (deliveryCalendar.nextAvailableDate == formatedDate) {
          dayElem.className += ' date-nextavailable';
        }
        if (deliveryCalendar.selectedDate == formatedDate) {
          dayElem.className += ' date-selected';
        }
      },
      onChange: function (selectedDates, dateStr, instance) {
        var selectedElem = instance.selectedDateElem;
        if (selectedElem.classList.contains('date-bankholiday')) {
          ACC.deliveryCalendar.displayDateConfirmationModal(dateStr);
        } else {
          ACC.deliveryCalendar.updateHiddenInput('.js-deliveryDate', dateStr);
          ACC.deliveryCalendar.fixCalendarSelectedDates();
        }
      },
      onMonthChange: function () {
        ACC.deliveryCalendar.fixCalendarSelectedDates();
      }
    };
    this.config = calendarConfig;
  },

  fixCalendarSelectedDates: function () {
    // suggested use of flatpickr.clear() is non-functional
    // traverse the dom tree
    $('.flatpickr-day.date-selected:not(.date-next-available)').each(function (key, dayItem) {
      var dayDate = $(dayItem).attr('aria-label');
      if (dayDate !== $('.js-deliveryDate').val()) {
        // remove the selected label class from date not selected by clicking
        $(dayItem).removeClass('date-selected');
      }
    });
  },

  bindDateConfirmationSubmit: function () {
    $('.js-dateConfirmationForm').on('submit', function (e) {
      e.preventDefault();
      var dateStr = $('.js-dateConfirmation').val();
      ACC.deliveryCalendar.updateHiddenInput('.js-deliveryDate', dateStr);

      $(ACC.deliveryCalendar.CAL_FORM_CLASS).submit();
    });
  },

  bindOnFormSubmit: function () {
    $(ACC.deliveryCalendar.CAL_FORM_CLASS).on('submit', ACC.deliveryCalendar.onDeliveryCalFormSubmit);
  },

  onDeliveryCalFormSubmit: function (e) {
    e.preventDefault();
    ACC.global.toggleSpinner(true);
    ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $(this));
  },

  onDeliveryConfirmationClose: function () {
    ACC.deliveryCalendar.$dateConfirmationModal.on('hide.bs.modal', function () {
      $('.flatpickr-day').removeClass('selected');
    });
  },
  displayDateConfirmationModal: function (selectedDate) {
    $('.js-dateConfirmation').val(selectedDate);
    ACC.deliveryCalendar.$dateConfirmationModal.modal('show');
  },

  updateHiddenInput: function (selector, value) {
    $(selector).val(value);
    if ($('.js-deliveryDate').val() == '') {
      $('.js-deliveryCalenderSubmit').attr('disabled', 'disabled');
    } else {
      $('.js-deliveryCalenderSubmit').removeAttr('disabled');
    }
  },

  formatDate: function (dateObj) {
    var dd = dateObj.getDate();
    var mm = dateObj.getMonth() + 1; //January is 0!
    var yyyy = dateObj.getFullYear();
    if (dd < 10) {
      dd = '0' + dd;
    }
    if (mm < 10) {
      mm = '0' + mm;
    }

    return yyyy + '-' + mm + '-' + dd;
  }
};

export default deliveryCalendar;
