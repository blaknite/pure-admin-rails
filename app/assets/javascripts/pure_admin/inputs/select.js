if (!PureAdmin) {
  console.error('You must load the PureAdmin JavaScript first before loading this JavaScript.');
}

PureAdmin.inputs.select = {
  init: function(context) {
    $('.pure-admin-select').select2({
      theme: 'pure-admin',
      templateResult: PureAdmin.inputs.select.formatResult,
      templateSelection: PureAdmin.inputs.select.formatResult,

      escapeMarkup: function(markup) {
        return markup;
      },
    });
  },

  formatResult: function(result) {
    return result.name || result.text || '<span class="text-muted">(blank)</span>';
  }
};
