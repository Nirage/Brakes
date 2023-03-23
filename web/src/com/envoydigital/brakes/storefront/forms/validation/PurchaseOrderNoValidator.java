package com.envoydigital.brakes.storefront.forms.validation;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.storefront.forms.PurchaseOrderForm;

import java.util.regex.Matcher;


/**
 * @author kuber.pant
 *
 */
@Component("purchaseOrderNoValidator")
public class PurchaseOrderNoValidator implements Validator
{

	@Override
	public boolean supports(final Class<?> aClass)
	{
		return PurchaseOrderForm.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final PurchaseOrderForm purchaseOrderForm = (PurchaseOrderForm) object;

		if (StringUtils.isNotEmpty(purchaseOrderForm.getPurchaseOrderNumber())
				&& StringUtils.isNotEmpty(purchaseOrderForm.getCustomerPOFormat()))
		{
			if (purchaseOrderForm.getCustomerPOFormat().matches(purchaseOrderForm.getPurchaseOrderNumber()))
			{
				errors.rejectValue("purchaseOrderNumber", "ponumber.notmatches");
			}

		}

		if(StringUtils.isNotEmpty(purchaseOrderForm.getPurchaseOrderNumber()) && !validatePONumber(purchaseOrderForm.getPurchaseOrderNumber())) {

			errors.rejectValue("purchaseOrderNumber", "ponumber.invalid");
		}
	}

	private boolean validatePONumber(final String poNumber)
	{
		final Matcher matcher = BrakesCoreConstants.PO_NUMBER_REGEX.matcher(poNumber);
		return matcher.matches();

	}
}
