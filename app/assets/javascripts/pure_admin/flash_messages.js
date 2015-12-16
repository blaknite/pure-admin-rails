var PureAdmin = PureAdmin || {};

PureAdmin.flash_messages = {
  remove: function(element) {
    $(element).closest('.flash').remove();
  }
}
