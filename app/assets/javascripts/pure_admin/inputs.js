var PureAdmin = PureAdmin || {};

PureAdmin.inputs = {
  initAll: function(context) {
    for (var inputType in PureAdmin.inputs) {
      inputTypeObj = PureAdmin.inputs[inputType];
      if (typeof(inputTypeObj) === 'object') {
        inputTypeObj.init();
      }
    }
  }
};

$(document).ready(function(context) {
  PureAdmin.inputs.initAll(context);
});

$(document).on('ajaxSuccess', function(context) {
  PureAdmin.inputs.initAll(context);
});
