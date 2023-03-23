/*
 * [y] hybris Platform
 *
 * Copyright (c) 2018 SAP SE or an SAP affiliate company.  All rights reserved.
 *
 * This software is the confidential and proprietary information of SAP
 * ("Confidential Information"). You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms of the
 * license agreement you entered into with SAP.
 */
package com.envoydigital.brakes.storefront.controllers;


import com.envoydigital.brakes.core.model.components.*;
import de.hybris.platform.acceleratorcms.model.components.CMSTabParagraphContainerModel;
import de.hybris.platform.acceleratorcms.model.components.CartSuggestionComponentModel;
import de.hybris.platform.acceleratorcms.model.components.CategoryFeatureComponentModel;
import de.hybris.platform.acceleratorcms.model.components.CategoryNavigationComponentModel;
import de.hybris.platform.acceleratorcms.model.components.DynamicBannerComponentModel;
import de.hybris.platform.acceleratorcms.model.components.MiniCartComponentModel;
import de.hybris.platform.acceleratorcms.model.components.NavigationBarComponentModel;
import de.hybris.platform.acceleratorcms.model.components.ProductFeatureComponentModel;
import de.hybris.platform.acceleratorcms.model.components.ProductReferencesComponentModel;
import de.hybris.platform.acceleratorcms.model.components.PurchasedCategorySuggestionComponentModel;
import de.hybris.platform.acceleratorcms.model.components.SimpleResponsiveBannerComponentModel;
import de.hybris.platform.acceleratorcms.model.components.SubCategoryListComponentModel;
import de.hybris.platform.cms2.model.contents.components.CMSLinkComponentModel;
import de.hybris.platform.cms2lib.model.components.ProductCarouselComponentModel;

import com.envoydigital.brakes.core.model.AmplienceCMSComponentModel;
import com.envoydigital.brakes.core.model.DeliveryCalendarComponentModel;
import com.envoydigital.brakes.core.model.MyToolsTrainingModulePerformComponentModel;
import com.envoydigital.brakes.core.model.MyToolsTrainingModulesComponentModel;
import com.envoydigital.brakes.core.model.MyToolsTrainingModulesResultsComponentModel;
import com.envoydigital.brakes.core.model.PopularCategoryComponentModel;
import com.envoydigital.brakes.model.BackgroundImagedCMSComponentContainerModel;


/**
 */

public interface ControllerConstants
{
	// Constant names cannot be changed due to their usage in dependant extensions, thus nosonar

	/**
	 * Class with action name constants
	 */
	interface Actions
	{
		interface Cms // NOSONAR
		{
			String _Prefix = "/view/"; // NOSONAR
			String _Suffix = "Controller"; // NOSONAR

			/**
			 * Default CMS component controller
			 */
			String DefaultCMSComponent = _Prefix + "DefaultCMSComponentController"; // NOSONAR

			/**
			 * CMS components that have specific handlers
			 */
			String PurchasedCategorySuggestionComponent = _Prefix + PurchasedCategorySuggestionComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CartSuggestionComponent = _Prefix + CartSuggestionComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CheckoutPageSuggestionComponent = _Prefix + CheckoutPageSuggestionComponentModel._TYPECODE + _Suffix; // NOSONAR
			String ProductReferencesComponent = _Prefix + ProductReferencesComponentModel._TYPECODE + _Suffix; // NOSONAR
			String ProductCarouselComponent = _Prefix + ProductCarouselComponentModel._TYPECODE + _Suffix; // NOSONAR
			String MiniCartComponent = _Prefix + MiniCartComponentModel._TYPECODE + _Suffix; // NOSONAR
			String ProductFeatureComponent = _Prefix + ProductFeatureComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CategoryFeatureComponent = _Prefix + CategoryFeatureComponentModel._TYPECODE + _Suffix; // NOSONAR
			String NavigationBarComponent = _Prefix + NavigationBarComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CMSLinkComponent = _Prefix + CMSLinkComponentModel._TYPECODE + _Suffix; // NOSONAR
			String DynamicBannerComponent = _Prefix + DynamicBannerComponentModel._TYPECODE + _Suffix; // NOSONAR
			String SubCategoryListComponent = _Prefix + SubCategoryListComponentModel._TYPECODE + _Suffix; // NOSONAR
			String SimpleResponsiveBannerComponent = _Prefix + SimpleResponsiveBannerComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CMSTabParagraphContainer = _Prefix + CMSTabParagraphContainerModel._TYPECODE + _Suffix; // NOSONAR
			String BackgroundImagedCMSComponentContainer = _Prefix + BackgroundImagedCMSComponentContainerModel._TYPECODE + _Suffix; // NOSONAR
			String DeliveryCalendarComponent = _Prefix + DeliveryCalendarComponentModel._TYPECODE + _Suffix; // NOSONAR
			String BrakesAddToFavouritesComponent = _Prefix + BrakesAddToFavouritesComponentModel._TYPECODE + _Suffix; // NOSONAR
			String FavouriteGridComponent = _Prefix + FavouriteGridComponentModel._TYPECODE + _Suffix; // NOSONAR
			String CategoryNavigationComponent = _Prefix + CategoryNavigationComponentModel._TYPECODE + _Suffix;
			String QuickAddItemToFavouriteComponent = _Prefix + QuickAddItemToFavouriteComponentModel._TYPECODE + _Suffix; // NOSONAR
			String MyToolsTrainingModulesComponent = _Prefix + MyToolsTrainingModulesComponentModel._TYPECODE + _Suffix; // NOSONAR
			String MyToolsTrainingModulePerformComponent = _Prefix + MyToolsTrainingModulePerformComponentModel._TYPECODE + _Suffix; // NOSONAR
			String MyToolsTrainingModulesResultsComponent = _Prefix + MyToolsTrainingModulesResultsComponentModel._TYPECODE
					+ _Suffix; // NOSONAR
			String ProductTileComponent = _Prefix + ProductTileComponentModel._TYPECODE + _Suffix; //NOSONAR
			String RecentPurchasedProductItemsComponent = _Prefix + RecentPurchasedProductItemsComponentModel._TYPECODE + _Suffix; //NOSONAR
			String AmplienceCMSComponent = _Prefix + AmplienceCMSComponentModel._TYPECODE + _Suffix; // NOSONAR
			String PopularCategoryComponent = _Prefix + PopularCategoryComponentModel._TYPECODE + _Suffix; // NOSONAR
			String PartyCalculatorPageComponent = _Prefix + PartyCalculatorPageComponentModel._TYPECODE + _Suffix; //NOSONAR


		}
	}

	/**
	 * Class with view name constants
	 */
	interface Views
	{
		interface Cms // NOSONAR
		{
			String ComponentPrefix = "cms/"; // NOSONAR
		}

		interface Pages
		{

			interface Account // NOSONAR
			{
				String SimpleCustomerDialogPage = "pages/customer/simpleCustomerDialogPage"; // NOSONAR
				String AccountForgottenUsernamePage = "pages/account/accountForgottenUsernamePage"; // NOSONAR
				String AccountForgotPasswordPage = "pages/account/forgotPasswordPage"; // NOSONAR
				String AccountForgotPasswordConfirmPage = "pages/account/forgotPasswordConfirmPage"; // NOSONAR
				String AccountHomePage = "pages/account/accountHomePage"; // NOSONAR
				String AccountOrderHistoryPage = "pages/account/accountOrderHistoryPage"; // NOSONAR
				String AccountOrderPage = "pages/account/accountOrderPage"; // NOSONAR
				String AccountProfilePage = "pages/account/accountProfilePage"; // NOSONAR
				String AccountProfileEditPage = "pages/account/accountProfileEditPage"; // NOSONAR
				String AccountProfileEmailEditPage = "pages/account/accountProfileEmailEditPage"; // NOSONAR
				String AccountChangePasswordPage = "pages/account/accountChangePasswordPage"; // NOSONAR
				String AccountAddressBookPage = "pages/account/accountAddressBookPage"; // NOSONAR
				String AccountEditAddressPage = "pages/account/accountEditAddressPage"; // NOSONAR
				String AccountPaymentInfoPage = "pages/account/accountPaymentInfoPage"; // NOSONAR
				String AccountRegisterPage = "pages/account/accountRegisterPage"; // NOSONAR
				String AccountMultiStepRegPage = "pages/account/accountMultiStepRegPage"; // NOSONAR
				String AccountMultiStepSFRegPage = "pages/account/accountMultiStepRegSFPage"; //NOSONAR
				String AccountMultiStepSFRegLockedPage = "pages/account/accountMultiStepSFRegLockedPage"; //NOSONAR
				String AccountCheckCustomerEligilityPage = "pages/account/accountCheckCustomerEligibilityPage"; // NOSONAR
				String LinkOrderingAccountPage = "pages/account/accountBrakesAccountLinkPage";// NOSONAR
				String RegisterConfirmationPage = "pages/account/registerConfirmationPage";// NOSONAR
				String PartyCalculatorPage = "pages/account/partyCalculaorPage";//NOSONAR
				String AccountAddCardPage = "pages/account/addCardPage";//NOSONAR
				String SSOLoginIframePage = "pages/account/ssoLoginIframePage";
			}

			interface Checkout // NOSONAR
			{
				String CheckoutRegisterPage = "pages/checkout/checkoutRegisterPage"; // NOSONAR
				String CheckoutConfirmationPage = "pages/checkout/checkoutConfirmationPage"; // NOSONAR
				String CheckoutLoginPage = "pages/checkout/checkoutLoginPage"; // NOSONAR
				String CheckoutPage = "pages/checkout/checkoutPage"; // NOSONAR
				String PreCheckoutPage = "pages/checkout/preCheckoutPage";
			}

			interface MultiStepCheckout // NOSONAR
			{
				String AddEditDeliveryAddressPage = "pages/checkout/multi/addEditDeliveryAddressPage"; // NOSONAR
				String ChooseDeliveryMethodPage = "pages/checkout/multi/chooseDeliveryMethodPage"; // NOSONAR
				String ChoosePickupLocationPage = "pages/checkout/multi/choosePickupLocationPage"; // NOSONAR
				String AddPaymentMethodPage = "pages/checkout/multi/addPaymentMethodPage"; // NOSONAR
				String CheckoutSummaryPage = "pages/checkout/multi/checkoutSummaryPage"; // NOSONAR
				String CheckoutPayPagePaymentPage = "pages/checkout/multi/paymentIFramePage"; // NOSONAR
				String CheckoutPayPageIFrameConfirmation = "pages/checkout/multi/paymentIFrameConfirmationPage"; // NOSONAR
				String CheckoutPayPageErrorPage = "pages/checkout/multi/paymentErrorPage"; // NOSONAR
				String HostedOrderPageErrorPage = "pages/checkout/multi/hostedOrderPageErrorPage"; // NOSONAR
				String HostedOrderPostPage = "pages/checkout/multi/hostedOrderPostPage"; // NOSONAR
				String SilentOrderPostPage = "pages/checkout/multi/silentOrderPostPage"; // NOSONAR
				String GiftWrapPage = "pages/checkout/multi/giftWrapPage"; // NOSONAR
			}

			interface Password // NOSONAR
			{
				String PasswordResetChangePage = "pages/password/passwordResetChangePage"; // NOSONAR
				String PasswordResetRequest = "pages/password/passwordResetRequestPage"; // NOSONAR
				String PasswordResetRequestConfirmation = "pages/password/passwordResetRequestConfirmationPage"; // NOSONAR
				String PasswordResetExpiryPage = "pages/password/passwordResetExpiryPage"; //NOSONAR
			}

			interface Error // NOSONAR
			{
				String ErrorNotFoundPage = "pages/error/errorNotFoundPage"; // NOSONAR
			}

			interface Cart // NOSONAR
			{
				String CartPage = "pages/cart/cartPage"; // NOSONAR
			}

			interface StoreFinder // NOSONAR
			{
				String StoreFinderSearchPage = "pages/storeFinder/storeFinderSearchPage"; // NOSONAR
				String StoreFinderDetailsPage = "pages/storeFinder/storeFinderDetailsPage"; // NOSONAR
				String StoreFinderViewMapPage = "pages/storeFinder/storeFinderViewMapPage"; // NOSONAR
			}

			interface Misc // NOSONAR
			{
				String MiscRobotsPage = "pages/misc/miscRobotsPage"; // NOSONAR
				String MiscSiteMapPage = "pages/misc/miscSiteMapPage"; // NOSONAR
				String ContactPage = "pages/misc/contactPage"; // NOSONAR
				String MiscSiteCsrfTokenPage = "pages/misc/miscSiteCsrfTokenPage"; // NOSONAR
			}

			interface Guest // NOSONAR
			{ // NOSONAR
				String GuestOrderPage = "pages/guest/guestOrderPage"; // NOSONAR
				String GuestOrderErrorPage = "pages/guest/guestOrderErrorPage"; // NOSONAR
			}

			interface Product // NOSONAR
			{
				String WriteReview = "pages/product/writeReview"; // NOSONAR
				String OrderForm = "pages/product/productOrderFormPage"; // NOSONAR
			}

			interface QuickOrder // NOSONAR
			{
				String QuickOrderPage = "pages/quickOrder/quickOrderPage"; // NOSONAR
			}

			interface CSV // NOSONAR
			{
				String ImportCSVSavedCartPage = "pages/csv/importCSVSavedCartPage"; // NOSONAR
			}
		}

		interface Fragments
		{
			interface Cart // NOSONAR
			{
				String AddToCartPopup = "fragments/cart/addToCartPopup"; // NOSONAR
				String MiniCartPanel = "fragments/cart/miniCartPanel"; // NOSONAR
				String MiniCartDetails = "fragments/cart/miniCartDetails"; // NOSONAR
				String MiniCartErrorPanel = "fragments/cart/miniCartErrorPanel"; // NOSONAR
				String CartPopup = "fragments/cart/cartPopup"; // NOSONAR
				String ExpandGridInCart = "fragments/cart/expandGridInCart"; // NOSONAR
			}

			interface Favourites // NOSONAR
			{
				String AddToFavouritesPopup = "fragments/favourites/addToFavouritesPopup"; // NOSONAR
				String EditFavouritePopup = "fragments/favourites/editFavouritePopup"; // NOSONAR
				String RenameFavouritesPopup = "fragments/favourites/renameFavouritesPopup";
				String CreateFavouritePopup = "fragments/favourites/createFavouritePopup"; //NOSONAR
			}

			interface Account // NOSONAR
			{
				String CountryAddressForm = "fragments/address/countryAddressForm"; // NOSONAR
				String SavedCartRestorePopup = "fragments/account/savedCartRestorePopup"; // NOSONAR
			}

			interface Checkout // NOSONAR
			{
				String TermsAndConditionsPopup = "fragments/checkout/termsAndConditionsPopup"; // NOSONAR
				String BillingAddressForm = "fragments/checkout/billingAddressForm"; // NOSONAR
				String ReadOnlyExpandedOrderForm = "fragments/checkout/readOnlyExpandedOrderForm"; // NOSONAR
			}

			interface Password // NOSONAR
			{
				String PasswordResetRequestPopup = "fragments/password/passwordResetRequestPopup"; // NOSONAR
				String ForgotPasswordValidationMessage = "fragments/password/forgotPasswordValidationMessage"; // NOSONAR
			}

			interface Product // NOSONAR
			{
				String FutureStockPopup = "fragments/product/futureStockPopup"; // NOSONAR
				String QuickViewPopup = "fragments/product/quickViewPopup"; // NOSONAR
				String ZoomImagesPopup = "fragments/product/zoomImagesPopup"; // NOSONAR
				String ReviewsTab = "fragments/product/reviewsTab"; // NOSONAR
				String StorePickupSearchResults = "fragments/product/storePickupSearchResults"; // NOSONAR
			}

			interface B2cPopup // NOSONAR
			{
				String RegisterCheckoutPopup = "fragments/registercheckout/registerCheckoutPopup"; // NOSONAR
				String B2cCheckoutDetailsPopup = "fragments/registercheckout/b2cCheckoutDetailsPopup"; //NOSoNAR
			}
		}
	}

	interface WishlistAction
	{
		String MOVE_UP = "moveUp";
		String MOVE_TOP = "moveToTop";
		String MOVE_DOWN = "moveDown";
		String MOVE_BOTTOM = "moveToBottom";

	}

	static final String REGEX_PATTREN_WISHLIST_NAME = "^((?!#).)*$";

	interface QuizAction
	{
		String NEXT_QUESTION = "nextQuestion";
		String PREV_QUESTION = "prevQuestion";
	}

	interface RecentPurchasedProducts
	{
		int PAGE_NUMBER_FIRST_PAGE = 1;
		int MAX_COUNT_PRODUCTS_UNLIMITED = -1;
		int WEEKS_IN_PAST_NO_LIMIT = -1;
		int DEFAULT_WEEKS_IN_PAST = 4;

	}

	interface Cookies
	{
		String LAST_TOUCH_COOKIE = "last_touch";
		String ACQUISITION_KEYWORD_COOKIE = "acquisition_keyword";
	}
}
