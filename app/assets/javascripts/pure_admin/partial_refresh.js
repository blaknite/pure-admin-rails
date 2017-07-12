var PureAdmin = PureAdmin || {};

PureAdmin.partial_refresh = {
  loadingTimer: {},

  init: function() {
    var matchElem = '.js-partial-refresh';
    // Only initialise once, multiple times caused loading issues
    if (window.partial_refresh_init == true)
      return;

    /*
    * When the ajaxSend event is triggered on matchElem, show the loading indicator.
    */
    $(document).on('ajax:beforeSend', matchElem, function(e, data) {
      var target = $(e.currentTarget);
      var uniqueId = Math.floor((Math.random() * 1000) + 1);

      target.data('pure-admin-unique-id', uniqueId);
      loading(parentWrapper(target), true, uniqueId);
      e.stopPropagation();
    });

    /*
    * When the ajaxSuccess event is triggered on matchElem, replace the contents.
    */
    $(document).on('ajax:success', matchElem, function(e, data) {
      var target = $(e.currentTarget);
      var uniqueId = target.data('pure-admin-unique-id');
      var wrapper = parentWrapper(target);

      // Data will be undefined if we are using Rails 5.1 since UJS dropped
      // jQuery, so we get the data from the Event
      wrapper.html(data || e.detail[2].response);
      loading(wrapper, false, uniqueId);
      e.stopPropagation();
    });

    /*
    * When the ajaxError event is triggered on matchElem, show a flash message.
    */
    $(document).on('ajax:error', matchElem, function(e, xhr, status, thrown) {
      var target = $(e.currentTarget);

      PureAdmin.flashMessages.create('error', thrown || 'Error');
      loading(parentWrapper(target), false, target.data('pure-admin-unique-id'));
      e.stopPropagation();
    });

    /*
    * Return the appropriate parent of the target element.
    * If the element has a data-parent attribute, return the matching jQuery object.
    * Otherwise, return the portlet or main-content div elements, whichever comes first.
    * @param (jQuery Object) target
    * @return (jQuery Object) the appropriate parent
    */
    function parentWrapper(target) {
      if (target.data('parent')) {
        return $(target.data('parent'));
      } else {
        return target.parents('.portlet-body, #main-content').first();
      }
    }

    /*
    * Adds a loading class to the given element if 'loading' is not false and removes it if 'loading'
    * is false.
    * @param elem (jQuery Object)
    * @param loadingStatus (Boolean)
    */
    function loading(elem, loadingStatus, uniqueId) {
      if (loadingStatus !== false) {
        PureAdmin.partial_refresh.loadingTimer[uniqueId] = setTimeout(function() {
          // if the wait is longer than the loading timeout we show a loading animation
          elem.addClass('loading');
        }, PureAdmin.LOADING_TIMEOUT);
      } else {
        clearTimeout(PureAdmin.partial_refresh.loadingTimer[uniqueId]);
        delete PureAdmin.partial_refresh.loadingTimer[uniqueId];
        elem.removeClass('loading');
      }
    }
    window.partial_refresh_init = true;
  }
};

// Init via Turbolinks load if that exists
if (typeof(Turbolinks) == 'undefined') {
  $(document).ready(PureAdmin.partial_refresh.init);
} else {
  $(document).on('turbolinks:load', PureAdmin.partial_refresh.init);
}
