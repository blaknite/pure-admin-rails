var PureAdmin = PureAdmin || {};

PureAdmin.inputs = {
  initAll: function(context) {
    PureAdmin.inputs.initColourPicker(context);
  },

  initColourPicker: function(context) {
    var colourPicker = $('input.pure-admin-colour-picker', context);
    colourPicker.minicolors({ letterCase: 'uppercase' });
  }
};

$(document).ready(function(){
  PureAdmin.inputs.initAll();
});

$(document).on('fragmentload', function(event) {
  PureAdmin.inputs.initAll(event.target);
});
