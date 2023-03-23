/**
 *
 */
package com.envoydigital.brakes.storefront.forms.validation;

import de.hybris.platform.core.model.product.ProductModel;
import de.hybris.platform.order.CartService;
import de.hybris.platform.servicelayer.config.ConfigurationService;

import java.util.Collections;
import java.util.Objects;
import java.util.regex.Matcher;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.core.services.BrakesExternalPriceService;
import com.envoydigital.brakes.core.services.BrakesProductService;
import com.envoydigital.brakes.core.services.BrakesWishlist2Service;
import com.envoydigital.brakes.core.util.BrakesCoreUtils;
import com.envoydigital.brakes.storefront.forms.QuickAddItemToFavouriteForm;



@Component("quickAddFavouriteItemValidator")
public class QuickAddFavouriteItemValidator implements Validator
{
	private static final String FAVOURITE_UID = "favouriteUid";
	private static final String PRODUCT_CODE = "productCode";
	private static final String QTY = "qty";

	@Resource(name = "configurationService")
	private ConfigurationService configurationService;

	@Resource(name = "wishlistService")
	private BrakesWishlist2Service wishlist2Service;

	@Resource(name = "productService")
	private BrakesProductService brakesProductService;

	@Resource
	private BrakesExternalPriceService externalPriceService;

	@Resource
	private CartService cartService;

	private static final Logger LOG = Logger.getLogger(QuickAddFavouriteItemValidator.class);

	@Override
	public boolean supports(final Class<?> aClass)
	{
		return QuickAddFavouriteItemValidator.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{

		final QuickAddItemToFavouriteForm quickAddFavouriteItemForm = (QuickAddItemToFavouriteForm) object;
		final String decryptedFavouriteUid = BrakesCoreUtils.decrypt(quickAddFavouriteItemForm.getFavouriteUid());

		// Favourite code should not be empty
		if (StringUtils.isEmpty(decryptedFavouriteUid))
		{
			errors.rejectValue(FAVOURITE_UID, "error.empty.favourite.uid");
		} // Checking favourite existence in DB
		else if (validateFavouriteUid(errors, decryptedFavouriteUid))
		{
			try
			{
				wishlist2Service.getWishlist(decryptedFavouriteUid);
			}
			catch (final Exception e)
			{
				// TEMP LOGS: They need be removed after fixing BRAKESP2-1401
				LOG.error("BRAKESP2-1401: wishlist2Service.getWishlist -> " + e.getMessage());
				e.printStackTrace();

				errors.rejectValue(FAVOURITE_UID, "error.favourite.not.invalid");
			}
		}

		// Product code should not be empty
		if (StringUtils.isEmpty(quickAddFavouriteItemForm.getProductCode()))
		{
			errors.rejectValue(PRODUCT_CODE, "error.empty.product.code");
		} // Checking product existence in DB
		else if (validateProductCode(errors, quickAddFavouriteItemForm.getProductCode()))
		{
			ProductModel product = null;
			try
			{
				product = brakesProductService.getProductForCode(quickAddFavouriteItemForm.getProductCode());
			}
			catch (final Exception e)
			{
				errors.rejectValue(PRODUCT_CODE, "error.product.not.invalid");

			}
			if (cartService.hasSessionCart())
			{
				externalPriceService.getPricesForCurrentUser(Collections.singletonList(brakesProductService.getMaterialCode(product)))
						.ifPresent(priceResponse -> {
							if (priceResponse == null || CollectionUtils.isEmpty(priceResponse.getPrices())
									|| Objects.isNull(priceResponse.getPrices().stream().findAny().get().getPrice()))
							{
								errors.rejectValue(PRODUCT_CODE, "error.product.price.empty");
							}
						});
			}

		}
		// qty must not null
		if (null == quickAddFavouriteItemForm.getQty())
		{
			errors.rejectValue(QTY, "basket.error.quantity.notNull");
		} //qty must be greater than '0'
		else if (quickAddFavouriteItemForm.getQty() <= 0)
		{
			errors.rejectValue(QTY, "error.min.qty");
		}
		else if (quickAddFavouriteItemForm.getQty() > 1)
		{
			errors.rejectValue(QTY, "error.max.qty");
		}


	}

	/**
	 * @param errors
	 * @param productCode
	 */
	private boolean validateProductCode(final Errors errors, final String productCode)
	{
		if (!validateProductCode(productCode))
		{
			errors.rejectValue(PRODUCT_CODE, "error.product.not.invalid");
			return false;
		}
		return true;
	}

	/* Product code must not exceed max length defined in properties file and must be numeric value */
	private boolean validateProductCode(final String productCode)
	{
		final Matcher matcher = BrakesCoreConstants.PRODUCT_CODE_REGEX.matcher(productCode);

		return productCode.length() <= configurationService.getConfiguration().getLong("brakes.product.max.char.size", 10)
				&& matcher.matches();
	}


	/**
	 * @param errors
	 * @param favouriteUid
	 */
	private boolean validateFavouriteUid(final Errors errors, final String favouriteUid)
	{
		if (!validateFavouriteUid(favouriteUid))
		{
			// TEMP LOGS: They need be removed after fixing BRAKESP2-1401
			LOG.error("BRAKESP2-1401: validateFavouriteUid-> " + favouriteUid);

			errors.rejectValue(FAVOURITE_UID, "error.favourite.not.invalid");
			return false;
		}
		return true;
	}

	private boolean validateFavouriteUid(final String favouriteUid)
	{
		final String favUid = favouriteUid.replace(" ", "");
		final Matcher matcher = BrakesCoreConstants.FAVOURITE_UID_REGEX.matcher(favUid);
		return matcher.matches();
	}


}

