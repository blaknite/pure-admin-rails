var PureAdmin = PureAdmin || {};

PureAdmin.header = {
  ready: function() {
    $('#wrap').waypoint(function(direction) {
      $('#back-to-top').toggle(direction === 'down');
    }, { offset: -300 });

    $('#wrap').waypoint(function(direction) {
      $('#wrap').toggleClass('no-header', direction === 'down');
    }, { offset: -48 });

    $('#back-to-top').on('click', $.debounce(1000, true, function() {
      $("html, body").animate({ scrollTop: 0 }, 300);
      $('#wrap').removeClass('no-header');
    }));
  }
};

$(document).ready(PureAdmin.header.ready)
$(document).on('turbolinks:load', PureAdmin.header.ready)
