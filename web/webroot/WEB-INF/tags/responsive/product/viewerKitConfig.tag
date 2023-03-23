<script type="text/javascript">

$(function() {
  var container = document.getElementById("amp-container");
  var productName = container.getAttribute("data-product-name");
  var productPrice = container.getAttribute("data-product-price");
  var productSummary = container.getAttribute("data-product-summary");
  var amp = window.amp || {};
  var viewerSettings = {
    client: "Brakes",
    imageBasePath: "https://i1.adis.ws/",
    locale: "en-gb",
    secure: true,
    zoomInlineDoubleTap: true,
    doubleTapTime: 250,
    responsive: true,
    ecommBridge: true,
    set: window.brakesAmpSet,
    errImg: "image-not-available",
    templates: {
      thumb: "w=122&h=84&qlt=70",
      desktop: {
        main: "$pdp-desktop$",
        mainRetina: "$pdp-desktop$"
      },
      mobile: {
        main: "$pdp-mobile$",
        mainRetina: "$pdp-mobile$"
      }
    },
    product: {
      name: productName,
      description: productSummary,
      price: productPrice
    },

    errCallback: function() {
      console.log("set call failed");
    },
    navIconsMain: {
      next: "icon icon-right icon-chevron-right",
      prev: "icon icon-left icon-chevron-left"
    },
    navIconsNav: {
      next: "icon icon-right icon-chevron-right",
      prev: "icon icon-left icon-chevron-left"
    },
    ampConfigs: {
      navElementsWidthPx: 100,
      navElementsWidthPxMobile: 18,
      navElementsCount: {
        forDesktop: 5,
        forDesktopFull: 5
      },
      mainContainerCarousel: {
        height: 0.650,
        responsive: true,
        gesture: {
          enabled: true,
          fingers: 1,
          dir: "horz",
          distance: 50
        }
      },
      mainContainerZoomInline: {
        scaleStep: 0.5,
        pan: true,
        preload: true
      },
      
      smallCarousel: {
        height: 1,
        width: 1,
        loop: false,
        gesture: {
          enabled: true,
          fingers: 1,
          dir: "horz",
          distance: 50
        }
      }
    }
  };
  if(typeof window.brakesAmpSet != 'undefined'){
    var viewer = new amp.Viewer(viewerSettings);
  }
});

</script>