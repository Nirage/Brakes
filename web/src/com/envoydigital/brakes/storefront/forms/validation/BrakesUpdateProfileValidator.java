package com.envoydigital.brakes.storefront.forms.validation;

import de.hybris.platform.b2bacceleratorfacades.customer.exception.InvalidPasswordException;

import java.util.regex.Matcher;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.envoydigital.brakes.core.constants.BrakesCoreConstants;
import com.envoydigital.brakes.facades.user.BrakesB2BCustomerFacade;
import com.envoydigital.brakes.storefront.forms.BrakesUpdateProfileForm;


/**
 * Validator for @link BrakesUpdateProfileForm
 *
 */
@Component("brakesUpdateProfileValidator")
public class BrakesUpdateProfileValidator implements Validator
{
	@Resource(name = "b2bCustomerFacade")
	private BrakesB2BCustomerFacade brakesB2BCustomerFacade;

	@Override
	public boolean supports(final Class<?> aClass)
	{
		return BrakesUpdateProfileForm.class.equals(aClass);
	}

	@Override
	public void validate(final Object object, final Errors errors)
	{
		final BrakesUpdateProfileForm updatePasswordForm = (BrakesUpdateProfileForm) object;

		if (StringUtils.isNotBlank(updatePasswordForm.getEmail()))
		{
			validateEmail(errors, updatePasswordForm.getEmail());
		}
		else if (StringUtils.isNotBlank(updatePasswordForm.getAccountName()))
		{
			validateAccountName(errors, updatePasswordForm.getAccountName());
		}
		else
		{
			final String newPassword = updatePasswordForm.getNewPassword();

			if (StringUtils.isEmpty(newPassword))
			{
				errors.rejectValue("newPassword", "reset.pwd.invalid");
			}
			else
			{
				try
				{
					brakesB2BCustomerFacade.validatePassword(newPassword);
				}
				catch (final InvalidPasswordException ex)
				{
					errors.rejectValue("newPassword", "reset.pwd.invalid");
				}
			}
		}
	}

	/**
	 * @param accountName
	 */
	private void validateAccountName(final Errors errors, final String accountName)
	{
		if (StringUtils.length(accountName) > 35)
		{
			errors.rejectValue("accountName", "error.invalid.accountName");
		}
		if (!BrakesCoreConstants.ENGLISH_ONLY_TEXT_REGEX.matcher(accountName).matches())
		{

			errors.rejectValue("accountName", "error.invalid.accountName");
		}

	}

	protected void validateEmail(final Errors errors, final String email)
	{
		if (StringUtils.isEmpty(email))
		{
			errors.rejectValue("email", "error.empty.email");
		}
		else if (StringUtils.length(email) > 255 || !validateEmailAddress(email))
		{
			errors.rejectValue("email", "error.invalid.email");
		}
	}

	public boolean validateEmailAddress(final String email)
	{
		final Matcher matcher = BrakesCoreConstants.EMAIL_REGEX.matcher(email);
		return matcher.matches();
	}
}
