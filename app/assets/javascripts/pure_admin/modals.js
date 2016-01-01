var PureAdmin = PureAdmin || {};

PureAdmin.modals = {
  show: function (event) {
    event.preventDefault();

    var element = $(event.target).closest('*[modal]');
    var modal_type = element.attr('modal');

    switch ( modal_type ) {
      case 'alert':
        PureAdmin.modals._alert(element);
        break;

      case 'confirm':
        PureAdmin.modals._confirm(element);
        break;

      case 'ajax':
        PureAdmin.modals._ajax(element);
        break;

      default:
        PureAdmin.flash_messages.create('alert', modal_type + ' is not a valid modal type.');
        break;
    }

    return false;
  },

  _alert: function (element) {
    var text = element.data('modal-text') || 'Oh no!';
    var ok_callback = element.data('modal-ok-callback');

    var time = new Date().getTime();
    var html = '\
      <div id="modal-container-' + time + '" class="modal-container">\
        <div class="modal-background"></div>\
        <div class="modal alert">\
          <span class="fa fa-exclamation-circle"></span>\
          <div class="modal-body">\
            <p>' + text + '</p>\
          </div>\
          <div class="modal-controls">\
            <a class="pure-button pure-button-primary" rel="ok-button">OK</a>\
          </div>\
        </div>\
      </div>\
    ';

    $('body').addClass('no-scroll').append(html);

    $('#modal-container-' + time + ' *[rel=ok-button]').on('click', function() {
      if ( ok_callback !== undefined ) ok_callback();
      $('#modal-container-' + time).remove();
      $('body').removeClass('no-scroll');
    });
    $('#modal-container-' + time + ' .modal-background').on('click', function(event) {
      $('#modal-container-' + time).remove();
      $('body').removeClass('no-scroll');
    });

    return false;
  },

  _confirm: function (element) {
    var text = element.data('modal-text') || 'Are you sure?';
    var url = element.data('modal-url') || element.closest('a').attr('href');
    var request_method = element.data('modal-request-method') || 'get';
    var yes_callback = element.data('modal-yes-callback');
    var no_callback = element.data('modal-no-callback');

    if ( yes_callback === undefined ) {
      var yes_button = '<a href="' + url + '" class="pure-button pure-button-primary"\
        rel="yes-button" data-method="' + request_method + '">Yes</a>';
    } else {
      var yes_button = '<a class="pure-button pure-button-primary" rel="yes-button">Yes</a>';
    }

    var time = new Date().getTime();
    var html = '\
      <div id="modal-container-' + time + '" class="modal-container">\
        <div class="modal-background"></div>\
        <div class="modal confirm">\
          <span class="fa fa-question-circle"></span>\
          <div class="modal-body">\
            <p>' + text + '</p>\
          </div>\
          <div class="modal-controls">\
            <a class="pure-button" rel="no-button">No</a>\
            ' + yes_button + '\
          </div>\
        </div>\
      </div>\
    ';

    $('body').addClass('no-scroll').append(html);

    $('#modal-container-' + time + ' *[rel=yes-button]').on('click', function() {
      if ( yes_callback !== undefined ) yes_callback();
      $('#modal-container-' + time).remove();
      $('body').removeClass('no-scroll');
    });
    $('#modal-container-' + time + ' *[rel=no-button]').on('click', function() {
      if ( no_callback !== undefined ) no_callback();
      $('#modal-container-' + time).remove();
      $('body').removeClass('no-scroll');
    });
    $('#modal-container-' + time + ' .modal-background').on('click', function(event) {
      if ( no_callback !== undefined ) no_callback();
      $('#modal-container-' + time).remove();
      $('body').removeClass('no-scroll');
    });

    return false;
  },

  _ajax: function (element) {
    var text = element.data('modal-text') || 'Are you sure?';
    var url = element.data('modal-url') || element.closest('a').attr('href');
    var request_method = element.data('modal-request-method') || 'get';
    var request_data = element.data('modal-request-data') || {};

    if ( url === undefined ) {
      PureAdmin.flash_messages.create('alert', 'You need to pass a URL to AJAX modals.');
      return false;
    }

    var time = new Date().getTime();
    var html = '\
      <div id="modal-container-' + time + '" class="modal-container">\
        <div class="modal-background"></div>\
        <div class="modal-loading"></div>\
        <div class="modal ajax hidden">\
          <span class="fa fa-info-circle"></span>\
        </div>\
      </div>\
    ';

    $('body').addClass('no-scroll').append(html);

    setTimeout(function() {
      // if the wait is longer than the loading timeout we show a loading gif
      $('#modal-container-' + time + ' .modal-loading').css('opacity', 1);
    }, PureAdmin.LOADING_TIMEOUT);

    $.ajax({
      url:  url,
      type: request_method,
      data: request_data,
      timeout: 40000,
      success: function(response) {
        $('#modal-container-' + time + ' .modal-loading').remove();
        $('#modal-container-' + time + ' .modal').append('<div class="modal-body">' + response + '</div>')
          .removeClass('hidden');

        $('#modal-container-' + time + ' .modal-background').on('click', function(event) {
          $('#modal-container-' + time).remove();
          $('body').removeClass('no-scroll');
        });
      },
      error: function(response) {
        $('body').removeClass('no-scroll');
        $('#modal-container-' + time).remove();
        PureAdmin.flash_messages.create('error', 'An error occured when loading the remote URL.');
      }
    });

    return false;
  }
}

$('document').ready(function() {
  $('*[modal]').on('click', PureAdmin.modals.show);
});
