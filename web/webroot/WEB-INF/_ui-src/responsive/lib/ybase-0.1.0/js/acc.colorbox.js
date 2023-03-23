const colorbox = {
  _autoload: [['init', $('#colorbox').length]],
  config: {
    maxWidth: '100%',
    opacity: 0.7,
    width: 'auto',
    transition: 'none',
    close: '<span class="glyphicon glyphicon-remove"></span>',
    title: '<div class="headline"><span class="headline-text">{title}</span></div>',
    onComplete: function () {
      $.colorbox.resize();
      ACC.common.refreshScreenReaderBuffer();
    },
    onClosed: function () {
      ACC.common.refreshScreenReaderBuffer();
    }
  },
  init: function () {
    //Makes Color Box Responsive
    var cboxOptions = {
      width: '95%',
      height: '95%',
      maxWidth: '960px',
      maxHeight: '960px'
    };

    $('.cbox-link').colorbox(cboxOptions);

    $(window).resize(function () {
      if (!$('#colorbox').hasClass('variantSelectMobile')) {
        $.colorbox.resize({
          width: window.innerWidth > parseInt(cboxOptions.maxWidth) ? cboxOptions.maxWidth : cboxOptions.width,
          height: window.innerHeight > parseInt(cboxOptions.maxHeight) ? cboxOptions.maxHeight : cboxOptions.height
        });
      }
    });
  },
  open: function (title, config) {
    var configObj = $.extend({}, ACC.colorbox.config, config);
    configObj.title = configObj.title.replace(/{title}/g, title);
    return $.colorbox(configObj);
  },
  resize: function () {
    $.colorbox.resize();
  },
  close: function () {
    $.colorbox.close();
  }
};

export default colorbox;
