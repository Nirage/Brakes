/**
 *
 */
package com.envoydigital.brakes.storefront.forms.validation;

import de.hybris.platform.basecommerce.enums.StockLevelStatus;
import de.hybris.platform.core.model.order.OrderEntryModel;
import de.hybris.platform.core.model.order.OrderModel;
import de.hybris.platform.core.model.product.ProductModel;
import de.hybris.platform.order.CartService;
import de.hybris.platform.servicelayer.config.ConfigurationService;
import de.hybris.platform.servicelayer.exceptions.UnknownIdentifierException;
import de.hybris.platform.stock.StockService;
import de.hybris.platform.store.services.BaseStoreService;
import de.hybris.platform.util.Config;

import java.util.Collections;
import java.util.Objects;
import java.util.Optional;
import java.util.regex.Matcher;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.core.json.Price.Status;
import com.envoydigital.brakes.core.json.PriceResponse;
import com.envoydigital.brakes.core.services.BrakesCustomerAccountService;
import com.envoydigital.brakes.core.services.BrakesExternalPriceService;
import com.envoydigital.brakes.core.services.BrakesProductService;
import com.envoydigital.brakes.storefront.forms.QuickOrderForm;


@Component("quickOrderValidator")
public class QuickOrderValidator implements Validator
{
	private static final String PRODUCT_CODE = "productCode";
	private static final String QTY = "qty";
	private static final Logger LOG = Logger.getLogger(QuickOrderValidator.class);

	@Resource(name = "configurationService")
	private ConfigurationService configurationService;

	@Resource(name = "cartService")
	private CartService cartService;

	@Resource(name = "productService")
	private BrakesProductService brakesProductService;

	@Resource(name = "b2bCustomerAccountService")
	private BrakesCustomerAccountService brakesCustomerAccountService;

	@Resource(name = "stockService")
	private StockService stockService;

	@Resource(name = "baseStoreService")
	private BaseStoreService baseStoreService;

	@Resource
	private BrakesExternalPriceService externalPriceService;


	@Override
	public boolean supports(final Class<?> aClass)
	{
		return QuickOrderValidator.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final boolean enableRestrictions = Config.getBoolean("enable.restrictions", false);
		final QuickOrderForm quickOrderForm = (QuickOrderForm) object;

		// Product code should not be empty
		if (StringUtils.isEmpty(quickOrderForm.getProductCode()))
		{
			errors.rejectValue(PRODUCT_CODE, "error.empty.product.code");
		} // Checking product existence in DB
		else if (validateProductCode(errors, quickOrderForm.getProductCode()))
		{
			ProductModel product = null;
			if (null != quickOrderForm.getQty() && quickOrderForm.getQty().compareTo(new Long(0L)) > 0)
			{
				try
				{
					product = brakesProductService.getProductForCode(quickOrderForm.getProductCode());

					if (null != baseStoreService.getCurrentBaseStore().getWarehouses())
					{
						final StockLevelStatus status = stockService.getProductStatus(product,
								baseStoreService.getCurrentBaseStore().getWarehouses());
						if (!StockLevelStatus.INSTOCK.equals(status))
						{
							errors.rejectValue(PRODUCT_CODE, "error.product.not.in.stock");
						}
					}

				}
				catch (final UnknownIdentifierException e)
				{
					errors.rejectValue(PRODUCT_CODE, "error.product.not.unavailable");
				}
				catch (final Exception e)
				{
					errors.rejectValue(PRODUCT_CODE, "error.product.not.invalid");
				}
			}
			if (product != null)
			{
				if (cartService.hasSessionCart())
				{
					final Optional<PriceResponse> priceResponse = externalPriceService
							.getPricesForCurrentUser(Collections.singletonList(brakesProductService.getMaterialCode(product)));
					if (priceResponse.isPresent())
					{
						if (CollectionUtils.isEmpty(priceResponse.get().getPrices())
								|| Objects.isNull(priceResponse.get().getPrices().stream().findAny().get().getPrice())
								|| Status.UNAVAILABLE.equals(priceResponse.get().getPrices().get(0).getStatus()))
						{
							errors.rejectValue(PRODUCT_CODE, "error.product.price.empty");
						}
					}
					else
					{
						errors.rejectValue(PRODUCT_CODE, "error.product.price.empty");

					}
				}
			}

		}
		// qty must not null
		if (null == quickOrderForm.getQty())
		{
			errors.rejectValue(QTY, "basket.error.quantity.notNull");
		}
		if (StringUtils.isEmpty(quickOrderForm.getOrderCode()) && quickOrderForm.getQty() <= 0)
		{
			errors.rejectValue(QTY, "error.min.qty");
		}
		else if (null != quickOrderForm.getQty() && StringUtils.isNotEmpty(quickOrderForm.getOrderCode()) && quickOrderForm.getQty() <= 0
				&& StringUtils.isNotEmpty(quickOrderForm.getProductCode())
				&& !amendOrderNullOrProductExistsInAmendOrder(quickOrderForm.getProductCode(), quickOrderForm.getOrderCode()))
		{
			errors.rejectValue(QTY, "error.min.qty");
		}else if(null == quickOrderForm.getQty()) {
			errors.rejectValue(QTY, "error.min.qty");
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

	private boolean amendOrderNullOrProductExistsInAmendOrder(final String productCode, final String orderCode)
	{
		final OrderModel amendOrder = brakesCustomerAccountService.getAmendOrderForCode(orderCode);
		boolean result;
		if (amendOrder == null)
		{
			result = true;
		}
		else
		{
			final OrderEntryModel entryModel = (OrderEntryModel) amendOrder.getEntries().stream()
					.filter(entry -> productCode.equals(entry.getProduct().getCode())).findAny().orElse(null);
			result = entryModel != null ? true : false;
		}
		return result;
	}

}

