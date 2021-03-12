(function ($) {
  $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click(() => {
    if (location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') && location.hostname === this.hostname) {
      let target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');

      if (target.length) {
        $('html, body').animate({scrollTop: target.offset().top - 56}, 1000, 'easeInOutExpo');
        return false;
      }
    }
  });

  $('.js-scroll-trigger').click(() => $('.navbar-collapse').collapse('hide'));
  $('body').scrollspy({target: '#main-nav', offset: 56});
})(jQuery);
