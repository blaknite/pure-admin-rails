(function() {
  var loadingTimer;

  var matchElem = '.pagination, .js-partial-refresh';

  $(document).on('ajax:beforeSend', matchElem, function(e, data) {
    loading(parentWrapper($(e.currentTarget)), true);
    e.stopPropagation();
  });

  $(document).on('ajax:success', matchElem, function(e, data) {
    var wrapper = parentWrapper($(e.currentTarget));
    wrapper.html(data);
    loading(wrapper, false);
    e.stopPropagation();
  });

  $(document).on('ajax:error', matchElem, function(e, xhr, status, thrown) {
    PureAdmin.flashMessages.create('error', thrown || 'Error');
    loading(parentWrapper($(e.currentTarget)), false);
    e.stopPropagation();
  });

  /*
   * Return the appropriate parent of the target element.
   * If the target element is within a portlet, return the portlet. If not, return the main-content
   * div.
   * @param (jQuery Object) target
   * @return (jQuery Object) the appropriate parent
   */
   function parentWrapper(target) {
    return target.parents('.portlet-body, #main-content').first();
   }

  /*
   * Adds a loading class to the given element if 'loading' is not false and removes it if 'loading'
   * is false.
   * @param elem (jQuery Object)
   * @param loadingStatus (Boolean)
   */
  function loading(elem, loadingStatus) {
    if (loadingStatus !== false) {
      loadingTimer = setTimeout(function() {
        // if the wait is longer than the loading timeout we show a loading animation
        elem.addClass('loading');
      }, PureAdmin.LOADING_TIMEOUT);
    } else {
      clearTimeout(loadingTimer);
      elem.removeClass('loading');
    }
  }
})();
