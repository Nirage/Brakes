/**
 *
 */
package com.envoydigital.brakes.storefront.forms.validation;

import de.hybris.platform.util.Config;

import java.util.regex.Matcher;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.storefront.forms.LinkBrakesOrderingAccountForm;

/**
 * @author maheshroyal
 *
 */
@Component("brakesLinkAccountFormValidator")
public class BrakesLinkAccountFormValidator implements Validator
{

	private static final Integer ACCNT_THRESHOLD = Config.getInt("trading.account.numbers.threshold", 5);

	@Override
	public boolean supports(final Class<?> aClass)
	{

		return LinkBrakesOrderingAccountForm.class.equals(aClass);
	}


	@Override
	public void validate(final Object object, final Errors errors)
	{
		final LinkBrakesOrderingAccountForm form = (LinkBrakesOrderingAccountForm) object;
		if (StringUtils.isEmpty(form.getFirstName()))
		{
			errors.rejectValue("firstName", "error.empty.firstName");
		}
		if (StringUtils.isEmpty(form.getLastName()))
		{
			errors.rejectValue("firstName", "error.empty.lastName");
		}
		if (StringUtils.isEmpty(form.getPostCode()))
		{
			errors.rejectValue("postCode", "error.empty.postCode");
		}
		else if (StringUtils.isNotEmpty(form.getPostCode()) && !validatePostcode(form.getPostCode()))
		{
			errors.rejectValue("postCode", "error.invalid.postCode");
		}
		if (CollectionUtils.isEmpty(form.getAccountNumbers()))
		{
			errors.rejectValue("accountNumber", "error.empty.accountNumber");
		}
		else if (form.getAccountNumbers().size() > 1 && form.getAccountNumbers().size() > ACCNT_THRESHOLD)
		{
			errors.rejectValue("accountNumber", "error.invalid.accountNumber");
		}
		if (StringUtils.isEmpty(form.getTradingName()))
		{
			errors.rejectValue("tradingName", "error.empty.tradingName");
		}
		if (StringUtils.isEmpty(form.getEmail()))
		{
			errors.rejectValue("email", "error.empty.email");
		}
		else if (StringUtils.isNotEmpty(form.getEmail()) && !validateEmailAddress(form.getEmail()))
		{
			errors.rejectValue("email", "error.invalid.email");
		}

	}


	private boolean validatePostcode(final String postCode)
	{
		final Matcher matcher = BrakesCoreConstants.POSTCODE_REGEX.matcher(postCode);
		return matcher.matches();
	}

	public boolean validateEmailAddress(final String email)
	{
		final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
		return matcher.matches();
	}

}
