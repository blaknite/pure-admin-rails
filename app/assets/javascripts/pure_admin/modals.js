var PureAdmin = PureAdmin || {};

PureAdmin.modals = {
  confirm: function (event, options) {
    event.preventDefault();

    var element = $(event.target);

    options = options || {};
    options.question = options.question || 'Are you sure?';
    options.request_method = options.request_method || 'get';
    options.href = options.href || element.closest('a').attr('href');

    if ( options.yes === undefined ) {
      var yes_button = '<a href="' + options.href + '" class="pure-button pure-button-primary"\
        rel="yes-button" data-method="' + options.request_method + '">Yes</a>';
    } else {
      var yes_button = '<a class="pure-button pure-button-primary" rel="yes-button">Yes</a>';
    }

    var time = new Date().getTime();
    var html = '\
      <div id="modal-container-' + time + '" class="modal-container">\
        <div class="modal">\
          <span class="fa fa-question-circle"></span>\
          <p>' + options.question + '</p>\
          <div class="controls">\
            ' + yes_button + '\
            <a class="pure-button" rel="no-button">No</a>\
          </div>\
        </div>\
      </div>\
    ';

    $('body').append(html);
    $('#modal-container-' + time + ' *[rel=yes-button]').on('click', function() {
      if ( options.yes !== undefined ) options.yes();
      $('#modal-container-' + time).remove();
    });
    $('#modal-container-' + time + ' *[rel=no-button]').on('click', function() {
      if ( options.no !== undefined ) options.no();
      $('#modal-container-' + time).remove();
    });

    return false;
  }
}
