var PureAdmin = PureAdmin || {};

PureAdmin.modals = {
  show: function (event) {
    event.preventDefault();

    var element = $(event.target).closest('*[modal]');
    var modalType = element.attr('modal');

    if ( PureAdmin.modals['_' + modalType] !== undefined ) {
      PureAdmin.modals['_' + modalType](element);
    } else {
      PureAdmin.flash('alert', modalType + ' is not a valid modal type.');
    }

    return false;
  },

  _ajax: function (element) {
    var icon = element.data('modal-icon') || 'fa-info-circle';
    var url = element.data('modal-url') || element.attr('href');
    var requestMethod = element.data('modal-request-method') || 'get';
    var requestData = element.data('modal-request-data') || {};

    if ( url === undefined ) {
      PureAdmin.flashMessages.create('alert', 'You need to pass a URL to AJAX modals.');
      return false;
    }

    var html = '<span class="fa ' + icon + '"></span>';

    var modal = PureAdmin.modals._create('ajax', html);

    $.ajax({
      url:  url,
      type: requestMethod,
      data: requestData,
      timeout: 40000,
      success: function(response) {
        modal.find('.modal').append('<div class="modal-body">' + response + '</div>').show();
        modal.find('.modal-background').on('click', function(event) { PureAdmin.modals._destroy(modal) });
      },
      error: function(response) {
        PureAdmin.modals._destroy(modal);
        PureAdmin.flashMessages.create('error', 'An error occured when loading the remote URL.');
      }
    });

    return false;
  },

  _alert: function (element) {
    var icon = element.data('modal-icon') || 'fa-exclamation-circle';
    var text = element.data('modal-text') || 'Oh no!';

    var yesCallbackFunction = PureAdmin.modals._getCallbackFunction(element.data('modal-yes-callback'));

    var yesCallback = function() {
      if ( yesCallbackFunction !== undefined ) yesCallbackFunction(element);
      PureAdmin.modals._destroy(modal);
    }

    var html = '\
      <span class="fa ' + icon + '"></span>\
      <div class="modal-body">\
        <p>' + text + '</p>\
      </div>\
      <div class="modal-controls">\
        <a class="pure-button pure-button-primary" modal-button="yes">OK</a>\
      </div>\
    ';

    var modal = PureAdmin.modals._create('alert', html);

    modal.find('*[modal-button=yes]').on('click', yesCallback);

    return false;
  },

  _confirm: function (element) {
    var icon = element.data('modal-icon') || 'fa-question-circle';
    var text = element.data('modal-text') || 'Are you sure?';
    var url = element.data('modal-url') || element.attr('href');
    var requestMethod = element.data('modal-request-method') || 'get';

    var yesCallbackFunction = PureAdmin.modals._getCallbackFunction(element.data('modal-yes-callback'));
    var noCallbackFunction = PureAdmin.modals._getCallbackFunction(element.data('modal-no-callback'));

    var yesCallback = function() {
      if ( yesCallbackFunction !== undefined ) yesCallbackFunction(element);      }
      PureAdmin.modals._destroy(modal);
    }

    var noCallback = function() {
      if ( noCallbackFunction !== undefined ) noCallbackFunction(element);
      PureAdmin.modals._destroy(modal);
    }

    if ( yesCallbackFunction === undefined ) {
      var yesButton = '<a href="' + url + '" class="pure-button pure-button-primary"\
        modal-button="yes" data-method="' + requestMethod + '">Yes</a>';
    } else {
      var yesButton = '<a class="pure-button pure-button-primary" modal-button="yes">Yes</a>';
    }

    var html = '\
      <span class="fa ' + icon + '"></span>\
      <div class="modal-body">\
        <p>' + text + '</p>\
      </div>\
      <div class="modal-controls">\
        <a class="pure-button" modal-button="no">No</a>\
        ' + yesButton + '\
      </div>\
    ';

    var modal = PureAdmin.modals._create('confirm', html);

    modal.find('*[modal-button=yes]').on('click', yesCallback);
    modal.find('*[modal-button=no], .modal-background').on('click', noCallback);

    return false;
  },

  _html: function (element) {
    var icon = element.data('modal-icon') || 'fa-info-circle';
    var innerHtml = element.data('modal-html') || '';

    if ( url === undefined ) {
      PureAdmin.flashMessages.create('alert', 'You need to pass a URL to AJAX modals.');
      return false;
    }

    var html = '\
      <span class="fa ' + icon + '"></span>\
      ' + element.data('modal-html') + '\
    ';

    var modal = PureAdmin.modals._create('html', html);

    modal.find('.modal-background').on('click', function(event) { PureAdmin.modals._destroy(modal) });

    return false;
  },

  _create: function(type, innerHtml) {
    var timestamp = new Date().getTime();
    var html = '\
      <div id="modal-container-' + timestamp + '" class="modal-container">\
        <div class="modal-background"></div>\
        <div class="modal-loading"></div>\
        <div class="modal ' + type + '">\
          ' + innerHtml + '\
        </div>\
      </div>\
    ';

    $('body').addClass('no-scroll').append(html);

    var modal = $('#modal-container-' + timestamp);

    // if the wait is longer than the loading timeout we show a loading gif
    setTimeout(function() { modal.find('.modal-loading').css('opacity', 1) }, PureAdmin.LOADING_TIMEOUT);

    return modal;
  },

  _destroy: function(modal) {
    modal.remove();
    $('body').removeClass('no-scroll');
  },

  _getCallbackFunction: function(callbackString) {
    if ( callbackString === undefined ) return undefined;

    var objects = callbackString.split('.');

    var getObject = function(objects, object) {
      object = object || window;
      object = object[objects.shift()]

      if ( object === undefined ) return undefined;

      return ( objects.length > 0 ) ? getObject(objects, object) : object;
    }

    return getObject(objects);
  }
};

$('document').ready(function() {
  $('*[modal]:not(.bound-modal)').addClass('bound-modal').on('click', PureAdmin.modals.show);
});
