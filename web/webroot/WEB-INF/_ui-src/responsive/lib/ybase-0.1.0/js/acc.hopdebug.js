const hopdebug = {
  _autoload: ['bindAll'],
  bindAll: function () {
    this.bindShowDebugMode();
  },
  bindShowDebugMode: function () {
    var debugModeEnabled = $('#hopDebugMode').data('hopDebugMode');

    if (!debugModeEnabled && !$('#showDebugPage').val()) {
      $('#hostedOrderPagePostForm').submit();
    }
  }
};

export default hopdebug;
