import showdown from 'showdown';

const contentAuthoring = {
  _autoload: [['init', ACC.config.amplienceDomainName !== '']],
  domainName: ACC.config.amplienceDomainName,
  contentDirectory: 'content-item/',
  templateName: ACC.config.ccv2Environment === 'DEV' ? 'DEV_top_template' : 'top_template', // Main Handlebars component hosted on Amplience
  init() {
    const _this = this;
    document.body.querySelectorAll('.js-amplienceSlot').forEach((slot) => {
      $.ajax({
        url: `${_this.domainName}${_this.contentDirectory}${slot.dataset['amplienceId']}?template=${_this.templateName}`,
        dataType: 'html',
        cache: false,
        success(response) {
          $(slot).html(response);
          _this.HeroContentBanner();
          _this.slider();
          _this.convertMarkdown();
          _this.HowToComponent();
        },
        error(xhr) {
          console.warn('Error retrieving Amplience Slot', xhr);
        }
      });
    });
  },
  convertMarkdown() {
    if (showdown) {
      // replace markdown text
      $('.js-markdownText').after(function () {
        $(this).removeClass('js-markdownText');
        var converter = new showdown.Converter();
        return converter.makeHtml(this.textContent);
      });
    }
  },
  updateFeedBackStateObject(element, state) {
    var newState = state;
    for (var i = 0; i < element.length; i++) {
      var radioEle = {};
      radioEle[element[i].id] = element[i].checked;
      $.extend(newState, radioEle);
    }
    return newState;
  },
  setRadioButtonChecked(element, state) {
    for (var i = 0; i < element.length; i++) {
      element[i].checked = state[element[i].id];
    }
  },
  HeroContentBanner() {
    document.body.querySelectorAll('.amp-herobanner').forEach((herobanner) => {
      herobanner.querySelector('.amp-herobanner__content') && herobanner.classList.add('has-content');
    });
  },
  slider() {
    const ampSlider = document.body.querySelectorAll('.amp-slider[id]');
    ampSlider.forEach((slider): void => {
      $(`#${slider.id}`).owlCarousel({
        items: 1,
        loop: true,
        mouseDrag: true,
        margin: 10,
        nav: true,
        autoplay: slider.dataset['autoplay'] === 'true',
        autoplayTimeout: slider.dataset['sliderate'] * 1000,
        navText: [
          "<span class='icon icon-chevron-left carousel-nav carousel-nav--left'></span>",
          "<span class='icon icon-chevron-right carousel-nav carousel-nav--right'></span>"
        ]
      });
    });
  },
  HowToComponent() {
    var howToComponent = document.querySelector('.v-accordion__wrapper--howto');

    if (howToComponent) {
      var mq = window.matchMedia('(min-width: 768px)');
      var firstRadioButton = howToComponent.querySelector("input[id^='amp-howto-tabs']");
      var feedbackElement = howToComponent.querySelectorAll('input[name^="feedback"]');
      var localStorageKey = 'amp-howto-howToFeedback';
      var localStorageState = JSON.parse(localStorage.getItem(localStorageKey));
      var feedBackState = this.updateFeedBackStateObject(feedbackElement, {});

      firstRadioButton.checked = mq.matches;

      if (!!localStorageState) {
        $.extend(feedBackState, localStorageState);
        this.setRadioButtonChecked(feedbackElement, feedBackState);
      }

      howToComponent.addEventListener('click', (e) => {
        if (!!e.target.name && e.target.name.indexOf('feedback') !== -1) {
          feedBackState = ACC.contentAuthoring.updateFeedBackStateObject(feedbackElement, feedBackState);
          localStorage.setItem(localStorageKey, JSON.stringify(feedBackState));
        }
      });
    }
  }
};

export default contentAuthoring;
