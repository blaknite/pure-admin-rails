var PureAdmin = PureAdmin || {};

PureAdmin.mainMenu = {
  scroll: function(element) {
    var menu = element.find('> nav');
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
  },

  updateArrows: function(element) {
    var menu = element.find('nav');
    var menuList = menu.find('.pure-menu-list');
    var leftArrow = element.find('.fade-left');
    var rightArrow = element.find('.fade-right');

    // determine how far to scroll each click and the extremes of scrolling
    var maxOffset = menuList.width() - $(document).width();

    // toggle the navigation arrows
    rightArrow.toggle(menu.scrollLeft() < maxOffset);
    leftArrow.toggle(menu.scrollLeft() > 0);
  },

  openSubMenu: function(element) {
    var mainMenu = $('#main-menu');
    var subMenu = $('#sub-menu');
    var subMenuContent = element.find('> .sub-menu').clone() || '';

    mainMenu.addClass('navigating').find('.pure-menu-item').removeClass('menu-active');
    mainMenu.find('.pure-menu-link').off('click', PureAdmin.mainMenu.closeSubMenu);
    element.addClass('menu-active');
    element.find('.pure-menu-link').on('click', PureAdmin.mainMenu.closeSubMenu);
    subMenu.removeClass('hidden').find('.pure-menu').html(subMenuContent);

    PureAdmin.mainMenu.updateArrows(subMenu);
  },

  closeSubMenu: function() {
    var mainMenu = $('#main-menu');
    var subMenu = $('#sub-menu');

    subMenu.addClass('hidden').find('.pure-menu').html($('#main-menu .current > .sub-menu').clone());
    mainMenu.removeClass('navigating').find('.pure-menu-item').removeClass('menu-active');
    mainMenu.find('.pure-menu-link').off('click', PureAdmin.mainMenu.closeSubMenu);
  }
}

$('document').ready(function() {
  PureAdmin.mainMenu.updateArrows($('#main-menu'));

  $('*[rel=main-menu-scroll]').on('click', function(event) {
    PureAdmin.mainMenu.scroll($('#main-menu'));
  });

  $('*[rel=sub-menu-scroll]').on('click', function(event) {
    PureAdmin.mainMenu.scroll($('#sub-menu'));
  });

  $('#main-menu nav').on('scroll', function(event) {
    PureAdmin.mainMenu.updateArrows($('#main-menu'));
  });

  $('#sub-menu nav').on('scroll', function(event) {
    PureAdmin.mainMenu.updateArrows($('#sub-menu'));
  });

  $('#main-menu .pure-menu-link').on('click', function(event) {
    var element = $(event.target).closest('li');
    PureAdmin.mainMenu.openSubMenu(element);
  });

  $('#main').on('click', function(event) {
    PureAdmin.mainMenu.closeSubMenu();
  });
});
