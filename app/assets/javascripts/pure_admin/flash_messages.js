var PureAdmin = PureAdmin || {};

PureAdmin.flashMessages = {
  create: function(type, message) {
    $('#flashes').prepend('<div class="flash ' + type + '">' + message + '</div>');
    $('#flashes .flash:not(.bound-close)').addClass('bound-close')
      .on('click', PureAdmin.flashMessages.destroy);
  },

  destroy: function(event) {
    $(event.target).closest('.flash').remove();
  }
};
