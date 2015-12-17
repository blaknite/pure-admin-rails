$('document').ready(function() {
  $('#wrap').waypoint(function(direction) {
    if ( direction == 'down') {
      $('#back-to-top').show();
    } else {
      $('#back-to-top').hide();
    }
  }, { offset: -300 });

  $('#wrap').waypoint(function(direction) {
    if ( direction == 'down') {
      $('#wrap').addClass('no-header');
    } else {
      $('#wrap').removeClass('no-header');
    }
  }, { offset: -48 });

  $('#back-to-top').on('click', $.debounce(1000, true, function() {
    $("html, body").animate({ scrollTop: 0 }, 300);
    $('#wrap').removeClass('no-header');
  }));
});
