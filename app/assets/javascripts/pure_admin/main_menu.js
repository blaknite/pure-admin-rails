$('document').ready(function() {
  if ( $('#main-menu .pure-menu-list').width() > $(document).width() ) {
    $('#main-menu .fade-right').show();
  }

  $('*[rel=main-menu-scroll]').on('click', function(event) {
    var element = $(event.target);

    var menu_list = element.closest('.pure-menu').find('.pure-menu-list');
    var left_arrow = element.closest('.pure-menu').find('.fade-left');
    var right_arrow = element.closest('.pure-menu').find('.fade-right');

    // do not scroll if list is shorter than document
    if ( menu_list.width() < $(document).width() ) return;

    // determine which scroll button was clicked
    var direction = $(event.target).closest('.fade-left, .fade-right').data('direction');

    // determine how far to scroll each click and the extremes of scrolling
    var total_offset = menu_list.width() - $(document).width();
    var min_offset = $(document).width() / 3;
    var offset = total_offset / 4;
    if ( total_offset < min_offset ) offset = total_offset;
    if ( offset < min_offset ) offset = min_offset;

    // how far we have already scrolled is stored on the list
    var current_offset = parseInt(menu_list.attr('data-offset'));
    if ( isNaN(current_offset) ) current_offset = 0;

    if ( direction == 'left' ) {
      // we're scrolling left
      if ( current_offset + offset > -offset ) {
        menu_list.attr('data-offset', 0).css('left', '0px');
      } else {
        menu_list.attr('data-offset', current_offset + offset).css('left', current_offset + offset + 'px');
      }

      left_arrow.toggle(current_offset + offset <= -offset);
      right_arrow.show();
    } else if ( direction == 'right' ) {
      // we're scrolling right
      if ( current_offset - offset < -total_offset + offset ) {
        menu_list.attr('data-offset', -total_offset).css('left', '-' + total_offset + 'px');
      } else {
        menu_list.attr('data-offset', current_offset - offset).css('left', current_offset - offset + 'px');
      }

      right_arrow.toggle(current_offset - offset >= -total_offset + offset);
      left_arrow.show();
    }
  });
});
