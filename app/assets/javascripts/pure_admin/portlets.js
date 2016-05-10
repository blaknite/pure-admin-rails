var PureAdmin = PureAdmin || {};

PureAdmin.portlets = {

  loadingTimer: {},

  /*
   * Toggles the 'expanded' class for the clicked portlet if it is closable.
   * Additionally calls the loadPortlet function if the portlet is now expanded.
   * @param e (Event)
   */
  toggle: function(e) {
    e.preventDefault();
    var portlet = $(e.target).parents('.portlet');
    if (portlet.data('closable') === true) {
      portlet.toggleClass('expanded');

      if (portlet.hasClass('expanded')) {
        PureAdmin.portlets.loadPortlet(portlet);
      }
    }
  },

  /*
   * Sets the body of the given portlet to be the given newContent.
   * @param portlet (jQuery Object)
   * @param newContent (jQuery Object)
   */
  setPortletBody: function(portlet, newContent) {
    portlet.find('.portlet-body').html(newContent);
  },

  /*
   * Loads remote content to be inserted into the given portlet.
   * If a URL is given, this will be used as the endpoint. Otherwise the value of data-source will
   * be used.
   * This function sets a sentinal value to determine if the content has already been loaded.
   * If this sentinal value is present, the function will return early.
   * Similarly if no source URL can be found, the function will return early.
   * @param portlet (jQuery Object)
   * @param url (String) - optional
   */
  loadPortlet: function(portlet, url) {
    var source = (url || portlet.data('source'));

    // Return early if the contents have already been loaded or if no source can be found.
    if (portlet.data('body-loaded') || !source) { return; }

    // If this function has been called before the toggle function, the portlet will not be expanded.
    // To save duplicating that logic here, we just rely on the click handler to intercept a
    // simulated click on the title and let the toggle function call this function again.
    if (!portlet.hasClass('expanded')) {
      portlet.find('.portlet-heading').click();
      return;
    }

    PureAdmin.portlets.loading(portlet, true, source);

    $.ajax(source, {
      success: function(data, textStatus, jqXHR) {
        PureAdmin.portlets.setPortletBody(portlet, $(data));
      },
      error: function(jxXHR, textStatus, thrown) {
        PureAdmin.portlets.setPortletBody(portlet, PureAdmin.portlets.errorResponse(thrown));
      },
      complete: function(jxXHR, textStatus) {
        portlet.data('body-loaded', true);
        PureAdmin.portlets.loading(portlet, false, source);
      }
    });
  },

  /*
   * Adds a loading class to the given element if 'loading' is not false and removes it if 'loading'
   * is false.
   * @param elem (jQuery Object)
   * @param loading (Boolean)
   */
  loading: function(elem, loading, uniqueId) {
    if (loading !== false) {
      if (!PureAdmin.portlets.loadingTimer[uniqueId]) {
        PureAdmin.portlets.loadingTimer[uniqueId] = setTimeout(function() {
          // if the wait is longer than the loading timeout we show a loading animation
          elem.addClass('loading');
        }, PureAdmin.LOADING_TIMEOUT);
      }
    } else {
      clearTimeout(PureAdmin.portlets.loadingTimer[uniqueId]);
      delete PureAdmin.portlets.loadingTimer[uniqueId];
      elem.removeClass('loading');
    }
  },

  /*
   * Creates a flash message then returns a jQuery object that shows the type of error if given,
   * or a generic message.
   * @param thrown (String) - optional
   * @return (jQuery Object)
   */
  errorResponse: function(thrown) {
    PureAdmin.flash_messages.create('error', 'An error occured when loading the remote URL.');
    return $('<p class="text-error text-center"><i class="fa fa-exclamation-triangle"></i> "' +
      (thrown || 'Error') + '" loading content</p>');
  },

  /*
   * Load portlets that have a data-expand attribute
   */
  autoExpand: function() {
    $('.portlet[data-expand]').each(function() {
      PureAdmin.portlets.loadPortlet($(this));
    });
  }
};

/*
 * Intercepts clicks on the portlet title and calls the toggle function.
 */
$(document).on('click', '.portlet-heading', PureAdmin.portlets.toggle);

$(document).ready(function() {
  // Automatically open portlets that match the anchor
  var anchorValue = document.location.toString().split("#")[1];
  if (typeof anchorValue !== 'undefined' && anchorValue.length !== 0) {
    var anchorPortlet = $('.portlet.' + anchorValue);
    PureAdmin.portlets.loadPortlet(anchorPortlet);
  }

  // Automatically open portlets that have the data-expand attribute set
  PureAdmin.portlets.autoExpand();
});

$(document).ajaxSuccess(function() {
  // Automatically open portlets that have the data-expand attribute set
  PureAdmin.portlets.autoExpand();
});
