var PureAdmin = PureAdmin || {};

PureAdmin.flash_messages = {
  create: function(type, message) {
    $('#flashes').prepend('<div class="flash ' + type + '">' + message + '</div>');
    $('#flashes .flash:not(.bound-close)').addClass('bound-close')
      .on('click', PureAdmin.flash_messages.remove);
  },

  remove: function(event) {
    $(event.target).closest('.flash').remove();
  }
}
