const quiz = {
  _autoload: ['init', ['initQuizResults', $('#jsQuizResultsContainer').length]],
  RESULTS_FORM_CLASS: '.js-trainingModulesResultsForm',
  RESULTS_STARTDATE: '.js-resultsStartDate',
  RESULTS_ENDDATE: '.js-resultsEndDate',
  init: function () {
    this.bindOnQuizAction();
    this.setCounter();
  },
  initQuizResults: function () {
    this.bindFilterResults();
  },
  endpoints: {
    perform: '/my-country-choice/training-module-perform',
    submit: '/my-country-choice/training-module-submit',
    filterResults: '/my-country-choice/training-modules-results'
  },
  quizCounter: {
    current: 0,
    total: 0
  },

  bindFilterResults: function () {
    $('.js-resetResults').on('click', function () {
      ACC.global.checkLoginStatus(ACC.quiz.onResetResulsClick);
    });

    $(ACC.quiz.RESULTS_FORM_CLASS).on('submit', function (e) {
      e.preventDefault();
      ACC.global.checkLoginStatus(ACC.quiz.onTrainingModuleFormSubmit, $(this));
    });
  },

  onResetResulsClick: function () {
    $(ACC.quiz.RESULTS_STARTDATE).val('').parents('.js-formGroup').removeClass('is-valid');
    $(ACC.quiz.RESULTS_ENDDATE).val('').parents('.js-formGroup').removeClass('is-valid');
    $(ACC.quiz.RESULTS_FORM_CLASS).submit();
  },

  onTrainingModuleFormSubmit: function ($form) {
    var endpoint = ACC.quiz.endpoints.filterResults;
    var startDate = $form.find(ACC.quiz.RESULTS_STARTDATE).val();
    var endDate = $form.find(ACC.quiz.RESULTS_ENDDATE).val();
    var hasError = $form.find('.has-error').length;
    if (hasError) {
      return false;
    }
    $.ajax({
      type: 'POST',
      url: endpoint,
      data: {
        startDate: startDate,
        endDate: endDate
      },
      success: function (response) {
        ACC.global.renderHandlebarsTemplate(response.results, 'jsQuizResultsContainer', 'quiz-results-template');
      },
      error: function () {
        console.warn('Error retrieving results');
      }
    });
  },

  setCounter: function () {
    if (window.quizCounter) {
      this.quizCounter = window.quizCounter;
    }
  },
  bindOnQuizAction: function () {
    $(document).on('click', '.js-quizBtn', function () {
      ACC.global.checkLoginStatus(ACC.quiz.handleQuizAction, $(this));
    });
  },

  handleQuizAction: function ($button) {
    var endpoint = ACC.quiz.endpoints.perform;
    var $form = $('.js-quizForm');
    var answerId = ACC.quiz.getAnswerValue($form, '.js-quizAnswer');
    var actionType = $button.data('action-type');
    var actionName = actionType;
    if ((actionType == 'nextQuestion' || actionType == 'submit') && typeof answerId == 'undefined') {
      return false;
    }
    if (actionType == 'submit') {
      actionName = 'nextQuestion';
    }

    $.ajax({
      type: 'POST',
      url: endpoint,
      data: {
        action: actionName,
        answer: answerId
      },
      success: function (response) {
        if (actionType == 'submit') {
          // Reset HTML
          ACC.global.renderHandlebarsTemplate({}, 'jsQuizQuestionContainer', 'quiz-question-template');
          $('.js-quizForm').submit();
        } else {
          ACC.global.renderHandlebarsTemplate(response, 'jsQuizQuestionContainer', 'quiz-question-template');
          ACC.quiz.updateCounter(actionType);
          ACC.quiz.updateProgressBar();
        }
      },
      error: function () {
        console.warn('Error retrieving quiz questions');
      }
    });
  },

  getAnswerValue: function ($form, inputClass) {
    var val = $form.find(inputClass + ':checked').val();
    return val;
  },
  updateCounter: function (actionType) {
    if (actionType == 'prevQuestion') {
      this.quizCounter.current -= 1;
    }
    if (actionType == 'nextQuestion') {
      this.quizCounter.current += 1;
    }
    $('.js-quizCurrentQuestionCount').html(this.quizCounter.current);
  },
  updateProgressBar: function () {
    var $current = $('.js-progressBarCurrent');
    var $done = $('.js-progressBarDone');
    var step = 100 / this.quizCounter.total;
    var current = step * this.quizCounter.current;
    var done = current - step;
    $current.css('width', current + '%');
    $done.css('width', done + '%');
  }
};

export default quiz;
