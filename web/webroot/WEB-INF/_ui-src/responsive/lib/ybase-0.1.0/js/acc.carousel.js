const carousel = {
  _autoload: [
    ['bindCarousel', $('.js-owl-carousel').length > 0],
    ['productsCarousel', $('.js-productsCarousel').length > 0]
  ],

  carouselConfig: {
    'similar-products': {
      loop: false,
      pagination: false,
      margin: 20,
      nav: true,
      navText: [
        "<span class='icon icon-chevron-left carousel-nav carousel-nav--left'></span>",
        "<span class='icon icon-chevron-right carousel-nav carousel-nav--right'></span>"
      ],
      responsive: {
        0: {
          items: 2
        },
        768: {
          items: 4
        },
        1240: {
          items: 6,
          mouseDrag: false,
          stagePadding: 0
        }
      }
    },
    'similar-products-checkout-step-one': {
      loop: false,
      pagination: false,
      margin: 20,
      nav: true,
      navText: [
        "<span class='icon icon-chevron-left carousel-nav carousel-nav--left'></span>",
        "<span class='icon icon-chevron-right carousel-nav carousel-nav--right'></span>"
      ],
      responsive: {
        0: {
          items: 2
        },
        768: {
          items: 3
        },
        1240: {
          items: 4,
          mouseDrag: false,
          stagePadding: 0
        }
      }
    },
    'similar-products-mb': {
      loop: false,
      pagination: false,
      margin: 20,
      nav: true,
      navText: [
        "<span class='icon icon-chevron-left carousel-nav carousel-nav--left'></span>",
        "<span class='icon icon-chevron-right carousel-nav carousel-nav--right'></span>"
      ],
      responsive: {
        0: {
          items: 2
        },
        768: {
          items: 3
        },
        1240: {
          items: 3,
          mouseDrag: false,
          stagePadding: 0
        }
      }
    },

    'products-carousel': {
      loop: false,
      margin: 20,
      stagePadding: 50,
      pagination: true,
      nav: true,
      navText: [
        "<span class='icon icon-chevron-left carousel-nav carousel-nav--left'></span>",
        "<span class='icon icon-chevron-right carousel-nav carousel-nav--right'></span>"
      ],
      responsive: {
        0: {
          items: 1
        },
        768: {
          items: 3
        },
        1240: {
          items: 5,
          mouseDrag: false,
          stagePadding: 0
        }
      }
    }
  },

  bindCarousel: function () {
    $('.js-owl-carousel').each(function () {
      var $c = $(this);
      $.each(ACC.carousel.carouselConfig, function (key, config) {
        if ($c.hasClass('js-owl-' + key)) {
          var $e = $(document).find('.js-owl-' + key);
          $e.owlCarousel(config);
        }
      });
    });
  },
  productsCarousel: function () {
    $('.js-productsCarousel').owlCarousel(ACC.carousel.carouselConfig['products-carousel']);
  },
  similarProductsCarousel: function () {
    $('.js-similarProductsCarousel').owlCarousel(ACC.carousel.carouselConfig['similar-products']);
  },
  similarProductsMbCarousel: function () {
    $('.js-similarProductsCarousel').owlCarousel(ACC.carousel.carouselConfig['similar-products-mb']);
  }
};

export default carousel;
