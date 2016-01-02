$('document').ready(function() {
  if ( $('#main-menu .pure-menu-list').width() > $(document).width() ) {
    $('#main-menu .fade-right').show();
  }

  $('*[rel=main-menu-scroll]').on('click', function(event) {
    var menu = $('#main-menu > nav');
    var menuList = menu.find('> .pure-menu-list');

    // do not scroll if list is shorter than document
    if ( menuList.width() < $(document).width() ) return;

    // determine which scroll button was clicked
    var direction = $(event.target).closest('.fade-left, .fade-right').data('direction');

    // determine how far to scroll each click and the extremes of scrolling
    var maxOffset = menuList.width() - $(document).width();
    var minStep = $(document).width() / 3;
    var offset = maxOffset / 4;
    if ( maxOffset < minStep ) offset = maxOffset;
    if ( offset < minStep ) offset = minStep;

    if ( direction == 'left' ) {
      // we're scrolling left
      if ( menu.scrollLeft() - offset < offset / 2 ) {
        menu.animate({ scrollLeft: 0 }, 100);
      } else {
        menu.animate({ scrollLeft: menu.scrollLeft() - offset }, 100);
      }
    } else if ( direction == 'right' ) {
      // we're scrolling right
      if ( menu.scrollLeft() + offset > maxOffset - offset / 2 ) {
        menu.animate({ scrollLeft: maxOffset }, 300);
      } else {
        menu.animate({ scrollLeft: menu.scrollLeft() + offset }, 100);
      }
    }
  });

  $('#main-menu nav').on('scroll', function(event) {
    var menu = $('#main-menu nav');
    var menuList = menu.find('.pure-menu-list');
    var leftArrow = $('#main-menu .fade-left');
    var rightArrow = $('#main-menu .fade-right');

    // determine how far to scroll each click and the extremes of scrolling
    var maxOffset = menuList.width() - $(document).width();

    // toggle the navigation arrows
    rightArrow.toggle(menu.scrollLeft() < maxOffset);
    leftArrow.toggle(menu.scrollLeft() > 0);
  })
});
