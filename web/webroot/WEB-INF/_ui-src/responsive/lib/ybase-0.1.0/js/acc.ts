import breakpoints from './acc.breakpoints';
import stickyASM from './acc.stickyasm';
import contentAuthoring from './acc.contentauthoring';
import navigation from './acc.navigation';
import global from './acc.global';
import register from './acc.register';
import common from './acc.common';
import forgottenpassword from './acc.forgottenpassword';
import cms from './acc.cms';
import footer from './acc.footer';
import minicart from './acc.minicart';
import stickyMiniCart from './acc.sticky-minicart';
import hopdebug from './acc.hopdebug';
import colorbox from './acc.colorbox';
import gtmDataLayer from './acc.gtm-datalayer';
import paginationsort from './acc.paginationsort';
import order from './acc.order';
import orderfilter from './acc.orderfilter';
import product from './acc.product';
import productDetail from './acc.productDetail';
import termsandconditions from './acc.termsandconditions';
import track from './acc.track';
import consent from './acc.consent';
import coookienotification from './acc.cookienotification';
import validation from './acc.validation';
import carousel from './acc.carousel';
import cart from './acc.cart';
import cartitem from './acc.cartitem';
import cartactions from './acc.cartactions';
import checkout from './acc.checkout';
import csvimport from './acc.csv-import';
import plp from './acc.plp';
import plptile from './acc.plp-tile';
import categoryBox from './acc.category-box';
import productprice from './acc.productprice';
import ratingstars from './acc.ratingstars';
import password from './acc.password';
import accountdropdown from './acc.accountdropdown';
import postcodeLookup from './acc.postcodelookup';
import wishlist from './acc.wishlist';
import quickAdd from './acc.quickadd';
import deliveryCalendar from './acc.deliveryCalendar';
import customerTools from './acc.customerTools';
import salesLocal from './acc.sales-local';
import quiz from './acc.quiz';
import nectar from './acc.nectar';
import promo from './acc.promo';
import promoPage from './acc.promoPage';
import sel from './acc.selPos';
import sideNav from './acc.sideNav';
import vouchers from './acc.vouchers';
import sanitizer from './acc.sanitizer';
import dwellChat from './acc.dwell-chat';
import monetate from './acc.monetate';
import b2bPayment from './acc.b2bPayment';
import b2bPaymentDropDown from './acc.b2bPaymentDropDown';
import b2cPopup from './acc.b2c-popup';
import b2cAdaptiveLabel from './acc.b2c-adaptive-label';
import b2cPopupLiveSearch from './acc.b2c-popup-live-search';
import b2cSignUp from './acc.b2c-signup';
import b2cSignUpSuccess from './acc.b2c-signup-success';
import b2cLogIn from './acc.b2c-login';
import b2cForgottenPassword from './acc.b2c-forgotten-password';
import b2cForgottenPasswordMessage from './acc.b2c-forgotten-password-message';
import b2cDeliveryPopup from './acc.b2c-delivery-popup';
import _autoload from './_autoload';

export default function Acc() {
  const ACC = window.ACC as Window;

  Object.assign(ACC, {
    breakpoints,
    stickyASM,
    contentAuthoring,
    navigation,
    global,
    register,
    common,
    forgottenpassword,
    cms,
    footer,
    minicart,
    stickyMiniCart,
    hopdebug,
    colorbox,
    gtmDataLayer,
    paginationsort,
    order,
    orderfilter,
    product,
    productDetail,
    termsandconditions,
    track,
    consent,
    coookienotification,
    validation,
    carousel,
    cart,
    cartitem,
    cartactions,
    checkout,
    csvimport,
    plp,
    plptile,
    categoryBox,
    productprice,
    ratingstars,
    password,
    accountdropdown,
    postcodeLookup,
    wishlist,
    quickAdd,
    deliveryCalendar,
    customerTools,
    salesLocal,
    quiz,
    nectar,
    promo,
    promoPage,
    sel,
    sideNav,
    vouchers,
    sanitizer,
    dwellChat,
    monetate,
    b2bPayment,
    b2bPaymentDropDown,
    b2cPopup,
    b2cAdaptiveLabel,
    b2cPopupLiveSearch,
    b2cSignUp,
    b2cSignUpSuccess,
    b2cLogIn,
    b2cForgottenPassword,
    b2cForgottenPasswordMessage,
    b2cDeliveryPopup
  });
}
