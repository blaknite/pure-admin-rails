var PureAdmin = PureAdmin || {};

PureAdmin.tabs = {
  init: function() {
    $(document).on('click', '.tabbable .nav-tabs a', function(event) {
      event.preventDefault();
      var tabId = $(event.currentTarget).attr('href');
      $('.tabbable ' + tabId).show().siblings().hide();
      $(this).parent('li').addClass('active').siblings().removeClass('active');
    });
  }
};

$(document).ready(PureAdmin.tabs.init);
